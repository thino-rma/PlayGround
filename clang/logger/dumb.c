/*
 * small logger program.
 *
 * compile:
 *     gcc -Wall -O2 -o dumb dumb.c
 */

#include <errno.h>
#include <fcntl.h>
#include <poll.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define TRUE (1)     // #define FALSE (0)

const char *ERR_FORMAT  = "[%d] Error: %s [%d] %s\n"; /* Error message */

struct context {
    char   *fpath;       /* log file path */
    char   *ppath;       /* pid file path */
};

void show_usage_exit(const char * const p, int exit_code) {
    printf("Description:\n"
           "    %s - tiny logging program.\n"
           , p);
    printf("Usage:\n");
    printf("    %s -h|--help\n"
           "    command | %s [-f LOGFILE] [-p PIDFILE]\n"
           , p, p);
    printf("Options:\n"
           "    -h|--help       Show usage and exit.\n"
           "    -f LOGFILE      Log file path. default: %s.log\n"
           "    -p PIDFILE      PID file path. default: %s.pid\n"
           , p, p);
    printf("Signals:\n"
           "    SIGUSR1         Causes to immediately reopen the log.\n");
    printf("Example:\n"
           "    reopen on signal SIGUSR1\n"
           "        $ command | %s -f a.log -p %s.pid > err.log 2>&1 &\n"
           "        $ mv test.log test.log.`date +'%%Y%%m%%d%%H%%M%%S'`\n"
           "        $ kill -SIGUSR1 `cat %s.pid`\n"
           , p, p, p);
    printf("\n"); fflush(stdout); exit(exit_code);
}

char *malloc_str(const size_t size) {
    char *buf = NULL;
    buf = (char *)malloc(size);
    if (buf != NULL) { *(buf + size - 1) = '\0'; } // for safety
    return buf;
}

void dbg_msg(const int exit_code, const char * const msg,
        const int value) {
    fprintf(stderr, "[%d] Debug: %s %d\n", exit_code, msg, value);
}

void perr_msg(const int exit_code, const char * const msg,
        const int revents) {
    fprintf(stderr, ERR_FORMAT, exit_code, msg,
            revents, "");
}

void err_msg(const int exit_code, const char * const msg,
        const int error_no) {
    fprintf(stderr, ERR_FORMAT, exit_code, msg,
            error_no, strerror(error_no));
}

void err_exit(const int exit_code, const char * const msg,
        const int error_no) {
    err_msg(exit_code, msg, error_no); exit(exit_code);
}

struct context parse_args(int argc, char **argv) {
    int i = 0; char *msg = NULL; struct context ctx;
    char* p = strrchr(*argv, '/');
    if (p == NULL) { p = (char *)argv; } else { p++; }

    if (argc == 0) return ctx;
    for (i = 1; i < argc; i++)
        if ( strcmp(*(argv+i), "-h") == 0 ||
             strcmp(*(argv+i), "--help") == 0 )
             show_usage_exit(*argv, 0);
    for (i = 1; i < argc; i++) {
        if ( strcmp(*(argv+i), "-h") == 0 || 
             strcmp(*(argv+i), "--help") == 0)  
            ; /* already been dieled with. */
        else if (strcmp(*(argv+i), "-f") == 0) {
            if (++i < argc) { ctx.fpath = *(argv+i); }
            else { --i; msg = "requires log file path."; break; }
        } else if (strcmp(*(argv+i), "-p") == 0) {
            if (++i < argc) { ctx.ppath = *(argv+i); }
            else { --i; msg = "requires pid file path."; break; }
        } else { msg = "is unknown parameter."; break; }
    }
    if (msg != NULL) {
        fprintf(stderr, "Invalid argument : '%s' %s\n", *(argv+i), msg);
        show_usage_exit(p, 1);
    }
    if (ctx.fpath == NULL) {
        ctx.fpath = malloc_str(strlen(p) + 4);
        if (ctx.fpath == NULL)
            err_exit(11, "fpath = malloc_str()", errno);
        sprintf(ctx.fpath, "%s.log", p);
    }
    if (ctx.ppath == NULL) {
        ctx.ppath = malloc_str(strlen(p) + 4);
        if (ctx.ppath == NULL)
            err_exit(11, "ppath = malloc_str()", errno);
        sprintf(ctx.fpath, "%s.pid", p);
    }

    return ctx;
}

volatile int flag_signal = 0;
void handler_signal(int signum) {
    flag_signal = signum;
}

int main(int argc, char **argv) {
    char *buf = NULL;             /* buffer                */
    int fd_in = fileno(stdin);    /* file descripter stdin */
    int fd_log = -1;              /* file descripter log   */
    int fd_pid = -1;              /* file descripter pid   */
    ssize_t cnt_read = 0;         /* read count            */
    ssize_t cnt_wrote = 0;        /* wrote count           */
    ssize_t cnt_written = 0;      /* written count         */
    int rc = 0;                   /* return code           */
    int es = 1;                   /* exit status           */
    int poll_rc = 0;              /* poll return code      */
    struct pollfd fds[1];         /* for poll()            */
    struct context ctx;           /* context               */

    ctx = parse_args(argc, argv);

    buf = malloc_str(BUFSIZ);
    if (buf == NULL)
        err_exit(11, "buf = malloc_str()", errno);

    /* prepare signal handler */
    struct sigaction sa;
    sa.sa_handler = handler_signal;
    sa.sa_flags = 0;
    rc = sigemptyset(&sa.sa_mask);
    sigaddset(&sa.sa_mask, SIGUSR1);
    rc = sigaction(SIGUSR1, &sa, NULL);

    /* initialize polling target infomations */ 
    fds[0].fd      = fd_in;
    fds[0].events  = POLLIN;
    fds[0].revents = 0;

    /* need_to_end_section from here.: fd_log */
    fd_log = open(ctx.fpath, O_WRONLY|O_APPEND|O_CREAT, 0640);
    if (fd_log < 0)
        err_exit(12, "open(LOGFILE)", errno);  // open error.

    /* create pid file */
    fd_pid = open(ctx.ppath, O_WRONLY|O_CREAT|O_TRUNC, 0640);
    if (fd_pid < 0) {
        es = 13; err_msg(es, "open(PIDFILE)", errno);
        goto end;  // open error.
    }
    cnt_wrote = sprintf(buf, "%d\n", getpid());
    if (write(fd_pid, buf, cnt_wrote) == EOF) {
        es = 13; err_msg(es, "write(PIDFILE, pid)", errno);
        goto end;  // write error.
    }
    fsync(fd_pid); close(fd_pid);

    dbg_msg(13, "BUFSIZ =", BUFSIZ);
    while(TRUE) {
        poll_rc = poll(fds, 1, -1);
        dbg_msg(21, "poll_rc =", poll_rc);
        if (poll_rc < 0 && errno != EINTR) {
            es = 21; err_msg(es, "poll()", errno);
            goto end;  // poll error.
        }

        sigprocmask(SIG_BLOCK, &sa.sa_mask, NULL); /* BLOCK signal*/
        dbg_msg(22, "flag_signal =", flag_signal);
        if (flag_signal == SIGUSR1) { /* reopen by signal */
            rc = close(fd_log);
            if (rc < 0) {
                es = 23; err_msg(es, "close(LOGFILE)", errno);
                goto end;  // close error.
            }
            fd_log = open(ctx.fpath, O_WRONLY|O_APPEND|O_CREAT, 0640);
            if (fd_log < 0) {
                es = 24; err_msg(es, "open(LOGFILE)", errno);
                goto end;  // open error.
            }
            flag_signal = 0;    /* clear flag after reopen. */
        }
        if (poll_rc > 0) {
            dbg_msg(31, "fds[0].revents =", fds[0].revents);
            dbg_msg(31, "POLLIN =", fds[0].revents & POLLIN);
            dbg_msg(31, "POLLPRI =", fds[0].revents & POLLPRI);
            dbg_msg(31, "POLLERR =", fds[0].revents & POLLERR);
            dbg_msg(31, "POLLHUP =", fds[0].revents & POLLHUP);
            dbg_msg(31, "POLLNVAL =", fds[0].revents & POLLNVAL);

            if (fds[0].revents & POLLIN) {
                cnt_read = read(fd_in, buf, BUFSIZ);
                dbg_msg(31, "cnt_read =", cnt_read);
                if (cnt_read < 0) {
                    es = 31; err_msg(es, "read(STDIN)", errno);
                    goto end;  // read error.
                }
                cnt_written = 0;
                while (cnt_written < cnt_read) {
                    cnt_wrote = write(fd_log,
                                      buf + cnt_written,
                                      cnt_read - cnt_written);
                    dbg_msg(31, "cnt_wrote =", cnt_wrote);
                    if (cnt_wrote < 0) {
                        es = 31; err_msg(es, "write(LOGFILE)", errno);
                        goto end;  // write error
                    }
                    cnt_written += cnt_wrote;
                    dbg_msg(31, "cnt_written =", cnt_written);
                }
                fsync(fd_log);
            } else {
                if (fds[0].revents & POLLHUP) {
                    break;  // stdin is closed. normal exit.
                }
                if (fds[0].revents & (POLLERR | POLLNVAL)) {
                    es = 31;
                    perr_msg(es, "poll() fds[0].revents error",
                            fds[0].revents);
                    goto end;  // error.
                }
                es = 31;
                perr_msg(es, "poll() fds[0].revents unknown",
                        fds[0].revents);
                goto end;  // unknown.
            }
        }
        sigprocmask(SIG_UNBLOCK, &sa.sa_mask, NULL); /* UNBLOCK signal */
    }
    es = 0;

end:
    close(fd_log);
    unlink(ctx.ppath);
    return es;
}

