package main

import (
	"bufio"
	"flag"
	"fmt"
	"io"
	"os"
	"os/signal"
	"path/filepath"
	"syscall"
)

type Context struct {
	logpath string // LOGPATH
	pidpath string // PIDPATH
}

func parse_args() Context {
	var pname string // program name
	ctx := Context{"", ""}

	_, pname = filepath.Split(os.Args[0])
	flag.Usage = func() {
		fmt.Fprintf(os.Stderr, "usage: "+pname+" [-h] [-f LOGPATH] [-p PIDPATH]\n")
		fmt.Fprintf(os.Stderr, "\n")
		fmt.Fprintf(os.Stderr, pname+" - tiny logging program.\n")
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
	}
	flag.StringVar(&ctx.logpath, "f", pname+".log", "Log file path")
	flag.StringVar(&ctx.pidpath, "p", pname+".pid", "PID file path")
	flag.Parse()
	return ctx
}

// func dbg_msg(exit_code int, msg string) {
//     fmt.Fprintf(os.Stderr, "[%d] Debug: %s\n", exit_code, msg)
// }

func err_msg(exit_code int, msg string, err error) {
	fmt.Fprintf(os.Stderr, "[%d] Error: %s\n", exit_code, msg)
	fmt.Fprintf(os.Stderr, "err.Error() = %s\n", err.Error())
}
func err_exit(exit_code int, func_name string, err error) {
	err_msg(exit_code, func_name, err)
	os.Exit(exit_code)
}

func loop(ctx Context, logfile *os.File) int {
	var err error
	ec := 31 // section select loop
	// dbg_msg(ec, "section select loop")
	// dbg_msg(ec, "prepare signal channel")
	sigs := make(chan os.Signal)
	signal.Notify(sigs, syscall.SIGUSR1, syscall.SIGTERM, syscall.SIGINT)

	// dbg_msg(ec, "prepare read channel")
	ch := make(chan []byte)
	go func() {
		buf := make([]byte, 4096)
		in := bufio.NewReader(os.Stdin)
		n := 0
		for {
			// dbg_msg(ec, "read from stdin")
			// dbg_msg(ec, "in.Read(buf)...")
			n, err = in.Read(buf)
			// dbg_msg(ec, fmt.Sprintf("in.Read(buf) returned %d", n))
			if n > 0 {
				ch <- buf[:n]
			}
			if err == io.EOF {
				break
			}
		}
		close(ch)
	}()

loop:
	// dbg_msg(ec, "loop")
	for {
		select {
		case buf, ok := <-ch:
			if !ok {
				ec = 0
				break loop
			}
			// dbg_msg(ec, "write to LOGFILE")
			// dbg_msg(ec, "logfile.Write(buf)...")
			_, err := logfile.Write(buf)
			// n, err := logfile.Write(buf)
			// dbg_msg(ec, fmt.Sprintf("logfile.Write(buf) returned %d", n))
			if err != nil {
				err_msg(ec, "logfile.Write(buf)", err)
				break loop
			}
		case signal := <-sigs:
			switch signal {
			case syscall.SIGUSR1:
				// dbg_msg(ec, "reopen LOGFILE")
				// dbg_msg(ec, "os.Close(LOGFILE)...")
				err = logfile.Close()
				if err != nil {
					err_msg(ec, "logfile.Close()", err)
					break loop
				}
				// dbg_msg(ec, "os.Open(LOGFILE)...")
				flag := os.O_WRONLY | os.O_CREATE | os.O_APPEND
				logfile, err = os.OpenFile(ctx.logpath, flag, 0640)
				if err != nil {
					err_msg(ec, "os.OpenFile(LOGFILE)", err)
					break loop
				}
			case syscall.SIGINT:
				// dbg_msg(ec, "signal SIGINT...")
				ec = 128 + 2 // SIGINT=2
				break loop
			case syscall.SIGTERM:
				// dbg_msg(ec, "signal SIGTERM...")
				ec = 128 + 15 // SIGTERM=15
				break loop
			}
		}
	}
	return ec
}

func do_work(ctx Context) int {
	var err error
	ec := 21
	// dbg_msg(ec, "section create PIDFILE")
	// dbg_msg(ec, "os.OpenFile(PIDFILE)...")
	flag := os.O_WRONLY | os.O_CREATE
	pidfile, err := os.OpenFile(ctx.pidpath, flag, 0640)
	if err != nil {
		err_exit(ec, "os.OpenFile(PIDFILE)", err)
		return ec
	}

	// dbg_msg(ec, "fmt.Fprintf(pidfile, PID)...")
	fmt.Fprintf(pidfile, "%d\n", os.Getpid())
	// dbg_msg(ec, "pidfile.Close()...")
	err = pidfile.Close()
	if err != nil {
		err_msg(ec, "os.Close(PIDFILE)", err)
		return ec
	}
	defer func() {
		// dbg_msg(99, "remove PIDFILE")
		// dbg_msg(99, "os.Stat(ctx.pidpath)...")
		_, err = os.Stat(ctx.pidpath)
		if !os.IsNotExist(err) {
			// dbg_msg(99, "os.Remove(ctx.pidpath)...")
			// # Remove() may return error : "file does not exist"
			// # Ignore the error because the situation can't be improved.
			_ = os.Remove(ctx.pidpath)
			// err = os.Remove(ctx.pidpath)
			// if err != nil {
			//     err_msg(99, "defer os.Remove(PIDFILE)", err)
			// }
		}
	}()

	ec = 22
	// dbg_msg(ec, "section open LOGFILE")
	// dbg_msg(ec, "os.OpenFile(LOGFILE)...")
	flag = os.O_WRONLY | os.O_CREATE | os.O_APPEND
	logfile, err := os.OpenFile(ctx.logpath, flag, 0640)
	if err != nil {
		err_msg(ec, "os.OpenFile(LOGFILE)", err)
		return ec
	}

	// ec = 23
	// dbg_msg(ec, "section loop")
	// dbg_msg(ec, "loop(ctx, logfile)...")
	ec = loop(ctx, logfile)
	// dbg_msg(ec, fmt.Sprintf("loop(ctx, logfile) returned %d", ec))

	// ec = 24
	// dbg_msg(ec, "section close LOGFILE")
	// # Close() sometimes return error : "file already closed"
	// # Ignore the error because the situation can't be improved.
	_ = logfile.Close()
	// err = logfile.Close()
	// if err != nil {
	//     err_msg(ec, "logfile.Close()", err)
	// }
	return ec
}

func main() {
	// dbg_msg(11, "parse_args)...")
	ctx := parse_args()
	// dbg_msg(11, "do_work(ctx)...")
	ec := do_work(ctx)
	// dbg_msg(11, fmt.Sprintf("do_work(ctx) returned %d", ec))
	os.Exit(ec)
}
