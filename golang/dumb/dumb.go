package main

import (
    "bufio"
    "io"
    "fmt"
    "flag"
    "os"
    "path/filepath"
    "os/signal"
    "syscall"
)

type Context struct {
    logpath string  // LOGPATH
    pidpath string  // PIDPATH
}

func parse_args() Context {
    var pname string   // program name
    var logpath string // LOGPATH
    var pidpath string // PIDPATH

    _, pname = filepath.Split(os.Args[0])
    flag.Usage = func() {
        fmt.Fprintf(os.Stderr, "usage: " + pname + " [-h] [-f LOGPATH] [-p PIDPATH]\n")
        fmt.Fprintf(os.Stderr, "\n")
        fmt.Fprintf(os.Stderr, pname + " - tiny logging program.\n")
        fmt.Fprintf(os.Stderr, "\n")
        fmt.Fprintf(os.Stderr, "  Signal SIGUSR1 cause to reopen the logfile.\n")
        fmt.Fprintf(os.Stderr, "  Permission of the newly created files is 640 ('rw-r----').\n")
        fmt.Fprintf(os.Stderr, "\n")
        fmt.Fprintf(os.Stderr, "optional arguments:\n")
        fmt.Fprintf(os.Stderr, "  -h, --help  show this help message and exit\n")
        fmt.Fprintf(os.Stderr, "  -f LOGPATH  Log file path\n")
        fmt.Fprintf(os.Stderr, "  -p PIDPATH  PID file path\n")
        fmt.Fprintf(os.Stderr, "\n")
        fmt.Fprintf(os.Stderr, "simple usage: standard output will be stored into test.log\n")
        fmt.Fprintf(os.Stderr, "  command | dumb -f test.log\n")
        fmt.Fprintf(os.Stderr, "\n")
        fmt.Fprintf(os.Stderr, "log rotatation:\n")
        fmt.Fprintf(os.Stderr, "  command | dumb -f test.log -p test.pid\n")
        fmt.Fprintf(os.Stderr, "  mv test.log{,.`date +'%%Y%%m%%d%%H%%M%%S'`}\n")
        fmt.Fprintf(os.Stderr, "  kill -SIGUSR1 `cat test.pid`\n")
        fmt.Fprintf(os.Stderr, "\n")
        fmt.Fprintf(os.Stderr, "setting setgid permission to the log directory:\n")
        fmt.Fprintf(os.Stderr, "  mkdir /var/log/test\n")
        fmt.Fprintf(os.Stderr, "  chown root:zabbix /var/log/test\n")
        fmt.Fprintf(os.Stderr, "  command | dumb -f /var/log/test/test.log -p /var/run/test.pid\n")
        fmt.Fprintf(os.Stderr, "  mv /var/log/test/test.log{,.`date +'%%Y%%m%%d%%H%%M%%S'`}\n")
        fmt.Fprintf(os.Stderr, "  kill -SIGUSR1 `cat /var/run/test.pid`\n")
        fmt.Fprintf(os.Stderr, "\n")
        fmt.Fprintf(os.Stderr, "automated log rotation:\n")
        fmt.Fprintf(os.Stderr, "  use cron or logrotate.\n")
    }
    flag.StringVar(&logpath, "f", pname + ".log", "Log file path")
    flag.StringVar(&pidpath, "p", pname + ".pid", "PID file path")
    flag.Parse()
    return Context{logpath, pidpath}
}

func err_exit(exit_code int, func_name string, err error) {
    fmt.Fprintf(os.Stderr, "[%d] Error: %s\n", exit_code, func_name)
    fmt.Fprintf(os.Stderr, "err.Error() = %s\n", err.Error())
    os.Exit(exit_code)
}

func main() {
    ctx := parse_args()

    // create PIDFILE
    pidfile, err := os.OpenFile(ctx.pidpath, os.O_WRONLY|os.O_CREATE, 0640)
    if err != nil { err_exit(11, "os.OpenFile(PIDFILE)", err) }

    fmt.Fprintf(pidfile, "%d\n", os.Getpid())
    err = pidfile.Close()
    if err != nil { err_exit(12, "os.Close(PIDFILE)", err) }
    defer func() {
        // remove PIDFILE
        _, err := os.Stat(ctx.pidpath);
        if os.IsNotExist(err) { return }
        err = os.Remove(ctx.pidpath)
        if err != nil { err_exit(13, "os.Remove(PIDFILE)", err) }
    }()

    // prepare signal channel
    sigs := make(chan os.Signal)
    signal.Notify(sigs, syscall.SIGUSR1)

    // prepare read channel
    ch := make(chan []byte)
    go func(ch chan []byte) {
        buf := make([]byte, 4096)
        in := bufio.NewReader(os.Stdin)
        for {
            // read from stdin
            n, err := in.Read(buf)
            if n > 0 { ch <- buf[:n] }
            if err == io.EOF { break }
        }
        close(ch)
    }(ch)

    // open LOGFILE
    logfile, err := os.OpenFile(ctx.logpath, os.O_WRONLY|os.O_CREATE|os.O_APPEND, 0640)
    if err != nil { err_exit(21, "os.OpenFile(LOGFILE)", err) }
loop:
    for {
        select {
        case buf, ok := <-ch:
            if ! ok { break loop }
            // write to LOGFILE
            _, err = logfile.Write(buf)
            if err != nil { err_exit(22, "logfile.Write(buf)", err) }
        case _ = <-sigs:
            // reopen LOGFILE
            err = logfile.Close()
            if err != nil { err_exit(23, "logfile.Close()", err) }
            logfile, err = os.OpenFile(ctx.logpath, os.O_WRONLY|os.O_CREATE|os.O_APPEND, 0640)
            if err != nil { err_exit(24, "os.OpenFile(LOGFILE)", err) }
        }
    }
    // close LOGFILE
    err = logfile.Close()
    if err != nil { err_exit(25, "logfile.Close()", err) }
}
