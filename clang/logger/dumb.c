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

struct context parse_args(int argc, char **argv) {
    int i = 0; char *msg = NULL; struct context ctx;
    char* p = strrchr(*argv, '/');
    if (p == NULL) { p = (char *)argv; } else { p++; }

    // TODO use p
    ctx.fpath = "dumb.log"; ctx.ppath = "dumb.pid";

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
    return ctx;
}

void dbg_msg(const int exit_code, const char * const msg) {
    fprintf(stderr, "[%d] Debug: %s\n", exit_code, msg);
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

char *malloc_str(const size_t size) {
    char *buf = NULL;
    buf = (char *)malloc(size);
    if (buf != NULL) { *(buf + size - 1) = '\0'; } // for safety
    return buf;
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
        err_exit(11, "malloc_str()", errno);

    /* make stdin non-blocking */
    // fd_flag = fcntl(fileno(stdin), F_GETFL);
    // if (fd_flag == -1)
    //     err_exit(11, "fcntl(stdin, F_GETFL)", errno);
    // fd_flag = fcntl(fileno(stdin), F_SETFL, fd_flag | O_NONBLOCK);
    // if (fd_flag == -1)
    //     err_exit(11, "fcntl(stdin, F_SETFL, ...)", errno);

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
        err_exit(12, "open(LOGFILE)", errno);

    /* create pid file */
    fd_pid = open(ctx.ppath, O_WRONLY|O_CREAT|O_TRUNC, 0640);
    if (fd_pid < 0) {
        es = 13; err_msg(es, "open(PIDFILE)", errno);
        goto end;
    }
    cnt_wrote = sprintf(buf, "%d\n", getpid());
    if (write(fd_pid, buf, cnt_wrote) == EOF) {
        es = 13; err_msg(es, "write(PIDFILE, pid)", errno);
        goto end;
    }
    fsync(fd_pid); close(fd_pid);

    while(TRUE) {
        // printf("[DEBUG] poll()...\n"); 
        poll_rc = poll(fds, 1, -1);
        // printf("[DEBUG] poll_rc = %d\n", poll_rc);
        if (poll_rc < 0 && errno != EINTR) {
            es = 21; err_msg(es, "poll()", errno);
            goto end;
        }

        sigprocmask(SIG_BLOCK, &sa.sa_mask, NULL); /* BLOCK signal*/
        if (flag_signal == SIGUSR1) { /* reopen by signal */
            // printf("[DEBUG] SIGUSR1 reopening\n");
            rc = close(fd_log);
            if (rc < 0) {
                es = 23; err_msg(es, "close(LOGFILE)", errno);
                goto end;
            }
            fd_log = open(ctx.fpath, O_WRONLY|O_APPEND|O_CREAT, 0640);
            if (fd_log < 0) {
                es = 24; err_msg(es, "open(LOGFILE)", errno);
                goto end;
            }
            flag_signal = 0;    /* clear flag after reopen. */
        }
        if (poll_rc > 0 && fds[0].revents | POLLIN) {
            cnt_read = read(fd_in, buf, BUFSIZ);
            if (cnt_read <= 0) {
                if (cnt_read == 0) {
                    es = 0; goto end;
                }
                if (fcntl(fd_log, F_GETFD) == -1 && errno == EBADF) {
                    es = 0; goto end;
                }
                if (cnt_read < 0) {
                    es = 31; err_msg(es, "read(STDIN)", errno);
                    goto end;
                }
            } else {
                cnt_written = 0;
                while (cnt_written < cnt_read) {
                    cnt_wrote = write(fd_log, buf + cnt_written, cnt_read - cnt_written);
                    if (cnt_wrote < 0) {
                        es = 31; err_msg(es, "write(LOGFILE)", errno);
                        goto end;
                    }
                    cnt_written += cnt_wrote;
                }
                fsync(fd_log);
            }

            // if (fgets(line, BUFSIZ, s_in) == NULL) {
            //     /* Ctrl-D cause errno = 11          *
            //      * Resource temporarily unavailable */
            //     if (feof(s_in)) break;
            //     es = 31; err_msg(es, "fgets()", errno); goto end;
            // } else {
            //     if (fputs(line, s_out) == EOF) {
            //         es = 32; err_msg(es, "fputs()", errno); goto end;
            //     }
            //     fflush(s_out);
            // }
        }
        sigprocmask(SIG_UNBLOCK, &sa.sa_mask, NULL); /* UNBLOCK signal */
    }
    es = 0;

end:
    close(fd_log);
    unlink(ctx.ppath);
    return es;
}



