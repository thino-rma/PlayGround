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

void show_usage_exit(const char * const arg0, int exit_code) {
    char* p = strrchr(arg0, '/');
    if (p == NULL) { p = (char *)arg0; } else { p++; }

    printf("Description:\n"
           "    %s - tiny logging program.\n"
           , p);
    printf("Usage:\n");
    printf("    %s -h|--help\n"
           "    command | %s -f LOGFILE [OPTIONS ...]\n"
           , p, p);
    printf("Options:\n"
           "    -h|--help       Show usage and exit.\n"
           "    -f LOGFILE      Log file path [mandatory]\n"
           "    -p PIDFILE      PID file path\n");
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
    ctx.fpath = NULL; ctx.ppath = NULL;

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
            if (++i < argc) {
                if (ctx.fpath == NULL) { ctx.fpath = *(argv+i); }
                else { --i; msg ="appeared twice."; break; } 
            } else { --i; msg = "requires log filename."; break; }
        } else if (strcmp(*(argv+i), "-p") == 0) {
            if (++i < argc) {
                if (ctx.ppath == NULL) { ctx.ppath = *(argv+i); }
                else { --i; msg ="appeared twice."; break; }
            } else { --i; msg = "requires pid filename."; break; }
        } else { msg = "is unknown parameter."; break; }
    }
    if (msg != NULL) {
        fprintf(stderr, "Invalid argument : '%s' %s\n", *(argv+i), msg);
        show_usage_exit(*argv, 1);
    }
    if (ctx.fpath == NULL) {
        fprintf(stderr, "Invalid argument : '-f' required.\n");
        show_usage_exit(*argv, 1);
    }
    return ctx;
}

void err_msg(const int exit_code, const char * const func_name,
        const int error_no) {
    fprintf(stderr, ERR_FORMAT, exit_code, func_name,
            error_no, strerror(error_no));
}

void err_exit(const int exit_code, const char * const func_name,
        const int error_no) {
    err_msg(exit_code, func_name, error_no); exit(exit_code);
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
    int fd_flag = 0;       /* file descriptor flag */
    char *line = NULL;     /* line for log         */
    char pid[64];          /* pid for pid file     */
    FILE *s_in = stdin;    /* stream_in            */
    FILE *s_out = NULL;    /* stream_out           */
    FILE *p_out = NULL;    /* stream_out for pid   */
    int rc = 0;            /* return code          */
    int es = 1;            /* exit status          */
    int poll_rc = 0;       /* poll return code     */
    struct pollfd fds[1];  /* for poll()           */
    struct context ctx;    /* context              */

    ctx = parse_args(argc, argv);

    line = malloc_str(BUFSIZ);
    if (line == NULL)
        err_exit(11, "malloc_str()", errno);

    /* make stdin non-blocking */
    fd_flag = fcntl(fileno(stdin), F_GETFL);
    if (fd_flag == -1)
        err_exit(11, "fcntl(stdin, F_GETFL)", errno);
    fd_flag = fcntl(fileno(stdin), F_SETFL, fd_flag | O_NONBLOCK);
    if (fd_flag == -1)
        err_exit(11, "fcntl(stdin, F_SETFL, ...)", errno);

    /* prepare signal handler */
    struct sigaction sa;
    sa.sa_handler = handler_signal;
    sa.sa_flags = 0;
    rc = sigemptyset(&sa.sa_mask);
    sigaddset(&sa.sa_mask, SIGUSR1);
    rc = sigaction(SIGUSR1, &sa, NULL);

    /* initialize polling target infomations */ 
    fds[0].fd      = fileno(s_in);
    fds[0].events  = POLLIN;
    fds[0].revents = 0;

    /* need_to_end_section from here.: s_out */
    s_out = fopen(ctx.fpath, "a");
    if (s_out == NULL)
        err_exit(12, "logpath fopen()", errno);

    /* create pid file */
    if (ctx.ppath != NULL) {
        p_out = fopen(ctx.ppath, "w");
        if (p_out == NULL) {
            es = 13; err_msg(es, "pidpath fopen()", errno);
            goto end;
        }
        sprintf(pid, "%d\n", getpid());
        if (fputs(pid, p_out) == EOF) {
            es = 13; err_msg(es, "pidpath fputs()", errno);
            goto end;
        }
        fflush(p_out); fclose(p_out);
    }

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
            printf("[DEBUG] SIGUSR1 reopening\n");
            rc = fclose(s_out);
            if (rc == EOF) {
                es = 23; err_msg(es, "fclose()", errno);
                goto end;
            }
            s_out = fopen(ctx.fpath, "a");
            if (s_out == NULL) {
                es = 24; err_msg(es, "fopen()", errno);
                goto end;
            }
            if (rc != 0) { es = rc; goto end; }
            flag_signal = 0;    /* clear flag after reopen. */
        }
        if (poll_rc > 0 && fds[0].revents | POLLIN) {
            if (fgets(line, BUFSIZ, s_in) == NULL) {
                /* Ctrl-D cause errno = 11          *
                 * Resource temporarily unavailable */
                if (feof(s_in)) break;
                es = 31; err_msg(es, "fgets()", errno); goto end;
            } else {
                if (fputs(line, s_out) == EOF) {
                    es = 32; err_msg(es, "fputs()", errno); goto end;
                }
                fflush(s_out);
            }
        }
        sigprocmask(SIG_UNBLOCK, &sa.sa_mask, NULL); /* UNBLOCK signal */
    }
    es = 0;

end:
    if (s_out != NULL) { fflush(s_out); fclose(s_out); }
    if (ctx.ppath != NULL) { unlink(ctx.ppath); }
    return es;
}



