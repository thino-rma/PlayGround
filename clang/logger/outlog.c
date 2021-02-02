/*
 * small logger program.
 *
 * compile:
 *     gcc -g -Wall -pedantic -O0 -o outlog outlog.c
 *     gcc -DDEBUG -Wall -pedantic -O0 -o outlog outlog.c
 */

#include <errno.h>
#include <fcntl.h>
#include <limits.h>
#include <poll.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <time.h>
#include <unistd.h>

#define DEFAULT_LINE_MINLEN (64)
#define DEFAULT_LINE_MAXLEN (4096)
#define TRUE (1)
#define FALSE (0)

const char *ERROR_FORMAT  = "[%d] Error: %s [%d] %s\n";  /* Error message             */

struct context {
    char   *fpath;       /* log file path */
    char   *ppath;       /* pid file path */
    int    pid_fd;       /* pid file descriptor */
    size_t line_maxlen;  /* line max length */
    char   *sigpath;     /* strlen(fpath) + 2 - 1 */
};

void show_usage(const char * const arg0) {
    char* p = strrchr(arg0, '/');
    if (p == NULL) { p = (char *)arg0; } else { p++; }

    printf("Description:\n"
           "    %s - logging program, reads from stdin, writes to logfile.\n"
           , p);
    printf("Usage:\n");
    printf("    %s -h|--help\n"
           "    command | %s -f LOGFILE [OPTIONS ...]\n"
           , p, p);
    printf("Options:\n"
           "    -h|--help       Show usage and exit.\n"
           "    -f LOGFILE      Log file path [mandatory]\n"
           "    -p PIDFILE      PID file path\n");
    printf("    -l LENGTH       Line length in bytes (integer)\n"
           "                    This must includes terminating null character.\n"
           "                    Default is %d.\n"
           "                      (min, max)=(%d, %d)\n"
           , DEFAULT_LINE_MAXLEN, DEFAULT_LINE_MINLEN, INT_MAX);
    printf("    -m METADATA     Specify metadata. this is not used in program.\n"
           "                    This can be useful to find the process.\n");
    printf("Signals:\n"
           "    SIGUSR1         Causes to immediately rotate the log.\n"
           "                    If \"-f a.log\" then rotated file name will be \"a.log.1\".\n"
           "                    You can periodically send signal using crond.\n");
    printf("    SIGUSR2         Causes to immediately reopen the log.\n"
           "                    This can be useful in logrotate.\n");
    printf("Example:\n"
           "    rotate on signal SIGUSR1\n"
           "        $ command | %s -f a.log -p ol.pid -m XYZ\n"
           "        $ kill -SIGUSR1 `cat ol.pid` && mv a.log.1 a.log.`date +'%%Y%%m%%d%%H%%M%%S'`\n"
           "    reopen on signal SIGUSR2\n"
           "        $ command | %s -f a.log -p ol.pid\n"
           "        /path/to/a.log {\n"
           "            weekly\n"
           "            rotate 5\n"
           "            missingok\n"
           "            postrotate\n"
           "                /usr/bin/kill -SIGUSR2 `cat /path/to/ol.pid`\n"
           "            endscript\n"
           "            compress\n"
           "        }\n"
           , p, p);
    printf("\n");
    fflush(stdout);
}

struct context parse_args(int argc, char **argv) {
    int i = 0; long v = 0;
    char **endptr = NULL; char *msg = NULL;

    struct context ctx;
    ctx.fpath = NULL;
    ctx.ppath = NULL;
    ctx.pid_fd = -1;
    ctx.line_maxlen = DEFAULT_LINE_MAXLEN;
    ctx.sigpath = NULL;

# ifdef DEBUG
    printf("[DEBUG] parse_args: argc=%d\n", argc);
# endif
    if (argc == 0) { return ctx; }
# ifdef DEBUG
    for (i = 0; i < argc; i++) {
        printf("[DEBUG] parse_args: argv[%d]=%s\n", i, *(argv+i));
    }
# endif
    for (i = 1; i < argc; i++) {
        if ( strcmp(*(argv+i), "-h") == 0 || 
             strcmp(*(argv+i), "--help") == 0 ) {
             show_usage(*argv); exit(0);
        }
    }
    for (i = 1; i < argc; i++) {
        if ( strcmp(*(argv+i), "-h") == 0 || 
             strcmp(*(argv+i), "--help") == 0) { 
            /* already been dieled with. */
        } else if (strcmp(*(argv+i), "-f") == 0) {
            if (++i < argc) {
                if (ctx.fpath == NULL) { 
                    ctx.fpath = *(argv+i);
                } else {
                    --i; msg ="appeared twice."; break;
                } 
            } else { --i; msg = "requires log filename."; break; }
        } else if (strcmp(*(argv+i), "-p") == 0) {
            if (++i < argc) {
                if (ctx.ppath == NULL) {
                    ctx.ppath = *(argv+i);
                } else {
                    --i; msg ="appeared twice."; break;
                }
            } else { --i; msg = "requires pid filename."; break; }
        } else if (strcmp(*(argv+i), "-l") == 0) {
            if (++i < argc) {
                v = strtol(*(argv+i), endptr, 10);
                if ( v < DEFAULT_LINE_MINLEN ) { v = DEFAULT_LINE_MINLEN; }
                else if ( INT_MAX < v ) { v = INT_MAX; }
                ctx.line_maxlen = (int)v;
            } else { --i; msg = "requires line max length."; break; }
        } else if (strcmp(*(argv+i), "-m") == 0) {
            if (++i < argc) {
                /* do nothing. */
            } else { --i; msg = "requires metadata."; break; }
        } else {
            msg = "is unknown parameter."; break;
        }
    }
    if (msg != NULL) {
        fprintf(stderr, "Invalid argument : '%s' %s\n", *(argv+i), msg);
        show_usage(*argv); exit(1);
    }
    if (ctx.fpath == NULL) {
        fprintf(stderr, "Invalid argument : '-f' required.\n");
        show_usage(*argv); exit(1);
    }
    return ctx;
}

void err_msg(const int exit_code, const char * const func_name, const int error_no) {
    fprintf(stderr, ERROR_FORMAT, exit_code, func_name, error_no, strerror(error_no));
} 
void err_exit(const int exit_code, const char * const func_name, const int error_no) {
    err_msg(exit_code, func_name, error_no);
    exit(exit_code);
}

char *malloc_str(const size_t size) {
    char *buf = NULL;
    buf = (char *)malloc(size);
    if (buf != NULL) { *(buf + size - 1) = '\0'; } // for safety
    return buf;
}

int rotate_log(FILE **s_out, const char *from, const char *to) {
    int rc;  /* return code  */
    int es;  /* error status */
    if (*s_out != NULL) {
# ifdef DEBUG
        printf("[DEBUG] rotate_log: fclose()");
# endif
        rc = fclose(*s_out);
# ifdef DEBUG
        printf("... %d\n", rc);
# endif
        if (rc == EOF) { es = 23; err_msg(es, "rotate_log: fclose()", errno); return es; }
        *s_out = NULL;

# ifdef DEBUG
        printf("[DEBUG] rotate_log: rename() %s -> %s", from, to);
# endif
        rc = rename(from, to);
# ifdef DEBUG
        printf("... %d\n", rc);
# endif
        if (rc == -1) {
            es = 24; err_msg(es, "rotate_log: rename()", errno);
            fprintf(stderr, "from=%s\n", from);
            fprintf(stderr, "to  =%s\n", to);
            return es;
        }

# ifdef DEBUG
        printf("[DEBUG] rotate_log: fopen() %s", from);
# endif
        *s_out = fopen(from, "a");
        if (*s_out == NULL) {
# ifdef DEBUG
            printf("... NULL\n");
# endif
            es = 25; err_msg(es, "rotate_log: fopen()", errno);
            fprintf(stderr, "filename=%s\n", from);
            return es;
        }
# ifdef DEBUG
        printf("... NOT NULL\n");
# endif
    }
    return 0;
}

int reopen_log(FILE **s_out, const char *from) {
    int rc;  /* return code  */
    int es;  /* error status */
    if (*s_out != NULL) {
# ifdef DEBUG
        printf("[DEBUG] reopen_log: fclose()");
# endif
        rc = fclose(*s_out);
# ifdef DEBUG
        printf("... %d\n", rc);
# endif
        if (rc == EOF) { es = 23; err_msg(es, "reopen_log: fclose()", errno); return es; }
        *s_out = NULL;

# ifdef DEBUG
        printf("[DEBUG] rotate_log: fopen() %s", from);
# endif
        *s_out = fopen(from, "a");
        if (*s_out == NULL) {
# ifdef DEBUG
            printf("... NULL\n");
# endif
            es = 25; err_msg(es, "rotate_log: fopen()", errno);
            fprintf(stderr, "filename=%s\n", from);
            return es;
        }
# ifdef DEBUG
        printf("... NOT NULL\n");
# endif
    }
    return 0;
}

volatile int flag_signal = 0;
void handler_signal(int signum)
{
# ifdef DEBUG
    printf("[DEBUG] handler_signal() called.\n");
# endif
    flag_signal = signum;
}

int main(int argc, char **argv)
{
    char *line = NULL;     /* line for log     */
    char *p = NULL;        /* pointer          */
    FILE *s_in = stdin;    /* stream_in        */
    FILE *s_out = NULL;    /* stream_out       */
    int rc = 0;            /* return code      */
    int es = 1;            /* exit status      */
    int poll_rc = 0;       /* poll return code */
    struct pollfd fds[1];  /* for poll()       */
    struct context ctx;    /* context          */

    ctx = parse_args(argc, argv);

    line = malloc_str(ctx.line_maxlen);
    if (line == NULL) { err_exit(11, "main: line = malloc()", errno); }

    ctx.sigpath = malloc_str(strlen(ctx.fpath) + 2 - 1);
    if (ctx.sigpath == NULL) { err_exit(11, "main: ctx.sigpath = malloc()", errno); }
    strcpy(ctx.sigpath, ctx.fpath);
    strcpy(ctx.sigpath + strlen(ctx.fpath), ".1");

    /* create pid file */
    if (ctx.ppath != NULL) {
        ctx.pid_fd = open(ctx.ppath, O_RDWR|O_CREAT, 0640);
        if (ctx.pid_fd < 0) {
            es = 12; err_exit(es, "main: ctx.pid_fd = open()", errno);
            goto end;
        }
        if (lockf(ctx.pid_fd, F_TLOCK, 0) < 0) {
            es = 12; err_exit(es, "main: lockf()", errno);
            goto end;
        }
        char str[256];
        sprintf(str, "%d\n", getpid());
        rc = write(ctx.pid_fd, str, strlen(str));
        if (rc == -1) {
            es = 21; err_msg(es, "main: write()", rc);
            goto end;
        }
        fsync(ctx.pid_fd);
# ifdef DEBUG
        printf("[DEBUG] main: created pid file.\n");
# endif
    }

    /* prepare signal handler */
    struct sigaction sa;
    sa.sa_handler = handler_signal;
    sa.sa_flags = 0;
    rc = sigemptyset(&sa.sa_mask);
    sigaddset(&sa.sa_mask, SIGUSR1);
    sigaddset(&sa.sa_mask, SIGUSR2);
    rc = sigaction(SIGUSR1, &sa, NULL);
    rc = sigaction(SIGUSR2, &sa, NULL);

    /* need_to_end_section from here.: s_out */
    s_out = fopen(ctx.fpath, "a");  /* append mode. */
    if (s_out == NULL) {
        es = 21; err_msg(es, "main: s_out = fopen()", errno);
        fprintf(stderr, "filename=%s\n", ctx.fpath);
        goto end;
    }

    fds[0].fd      = fileno(s_in);
    fds[0].events  = POLLIN;
    fds[0].revents = 0;

    while(! feof(stdin)) {
        while (TRUE) { /* polling block        */
# ifdef DEBUG
            printf("[DEBUG] main: polling... \n");
# endif

            poll_rc = poll(fds, 1, -1);

            if (flag_signal == SIGUSR1) { /* rotation by signal */
# ifdef DEBUG
                printf("[DEBUG] main: rotation by SIGUSR1... poll_rc=%d\n", poll_rc);
# endif
                rc = rotate_log(&s_out, ctx.fpath, ctx.sigpath);
                if (rc != 0) { es = rc; goto end; }
                flag_signal = 0;    /* clear flag after rotation. */
            } else if (flag_signal == SIGUSR2) { /* reopen by signal */
# ifdef DEBUG
                printf("[DEBUG] main: reopen by SIGUSR2... poll_rc=%d\n", poll_rc);
# endif
                rc = reopen_log(&s_out, ctx.fpath);
                if (rc != 0) { es = rc; goto end; }
                flag_signal = 0;    /* clear flag after reopen. */
            }

            if (poll_rc > 0) { break; }
        }

        sigprocmask(SIG_BLOCK, &sa.sa_mask, NULL); /* BLOCK signal SIGUSR1/2 */

        while (TRUE) {
# ifdef DEBUG
            printf("[DEBUG] main: fgets()...\n");
# endif
            p = fgets(line, ctx.line_maxlen, s_in);
            if (p == NULL && ferror(s_in) == 0) { break; }
            if (p == NULL ) { es = 31; err_msg(es, "main: fgets()", errno); goto end; }
# ifdef DEBUG
            fputs(line, stdout);
# endif
            rc = fputs(line, s_out);
            if (rc == EOF) { es = 32; err_msg(es, "main: fputs()", errno); goto end; }

            if (*(line + strlen(line) - 1) == '\n') { break; }
        }
        fflush(s_out);
        sigprocmask(SIG_UNBLOCK, &sa.sa_mask, NULL); /* UNBLOCK signal SIGUSR1/2 */
    }
    es = 0;

end:
    if (s_out != NULL) { fclose(s_out); }
    if (ctx.pid_fd != -1) {
        lockf(ctx.pid_fd, F_ULOCK, 0);
        close(ctx.pid_fd);
    }
    if (ctx.ppath != NULL) { unlink(ctx.ppath); }
# ifdef DEBUG
    printf("[DEBUG] main: return(%d)\n", es);
# endif
    return es;
}



