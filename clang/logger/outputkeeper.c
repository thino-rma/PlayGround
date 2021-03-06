/*
 * small logger program.
 *
 * compile:
 *     gcc -g -Wall -pedantic -O0 -o outputkeeper outputkeeper.c
 *     gcc -DDEBUG -Wall -pedantic -O0 -o outputkeeper outputkeeper.c
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

#define CONST_EXT_DT_FORMAT_LEN (16)
#define CONST_DT_FORMAT_LEN (20)
#define DEFAULT_LINE_MINLEN (64)
#define DEFAULT_LINE_MAXLEN (4096)
#define TRUE (1)
#define FALSE (0)

const char *ERROR_FORMAT  = "[%d] Error: %s [%d] %s\n";  /* Error message             */
const char *DT_FORMAT     = "%Y-%m-%d %H:%M:%S";         /* header of log line        */
const char *EXT_DT_FORMAT = ".%Y%m%d%H%M%S";             /* extention of log filename */

struct context {
    char   *fpath;       /* log file path */
    char   *ppath;       /* pid file path */
    int    pid_fd;       /* pid file descriptor */
    size_t line_maxlen;  /* line max length */
    time_t interval;     /* rotate interval in seconds */
    time_t delay;        /* rotate delay in seconds */
    int    dry_run;      /* dry run : 0 false, 1 true */
    struct timespec current_time;
    struct timespec rotate_time;
    char   *sigpath;     /* strlen(fpath) + 2 - 1 */
    char   *newpath;     /* strlen(fpath) + CONST_EXT_DT_FORMAT_LEN - 1 */
};

void show_usage(const char * const arg0) {
    char* p = strrchr(arg0, '/');
    if (p == NULL) { p = (char *)arg0; } else { p++; }

    printf("Description:\n"
           "    %s - logging program, reads from stdin, writes to logfile.\n"
           "    If INTERVAL > 0, log file will be saved as another name (time based).\n"
           "    Even if INTERVAL = 0, you can send SIGUSR1 to cause log rotation.\n"
           , p);
    printf("Usage:\n");
    printf("    %s -h|--help\n"
           "    %s --dry-run -f LOGFILE [OPTIONS ...]\n"
           "    command | %s -f LOGFILE [OPTIONS ...]\n"
           , p, p, p);
    printf("Caution:\n"
           "    If specified value is out of range, it will be rounded.\n"
           "    Use '--dry-run' to check how the arguments were parsed.\n");
    printf("Options:\n"
           "    -h|--help       Show usage and exit.\n"
           "    --dry-run       Parse arguments, show next rotation path and exit.\n"
           "    -f LOGFILE      Log file path [mandatory]\n"
           "    -p PIDFILE      PID file path\n");
    printf("    -l LENGTH       Line length in bytes (integer)\n"
           "                    This must includes terminating null character.\n"
           "                    Default is %d.\n"
           "                      (min, max)=(%d, %d)\n"
           , DEFAULT_LINE_MAXLEN, DEFAULT_LINE_MINLEN, INT_MAX);
    printf("    -i INTERVAL     Log rotation interval in seconds.\n"
           "                    Default is 0 (means no rotation).\n"
           "                      (min, max)=(%d, %d)\n"
           "                    If \"-f a.log\" then rotated file name will be\n"
           "                    \"a.log.YYYYmmddHHMMSS\".\n"
           , 5, INT_MAX);
    printf("                    If negative will be treated as 0.\n"
           "                    If 1-4 will be treated as 5.\n");
    printf("                                     0 : no rotation\n"
           "                                   1-4 : treated as 5\n"
           "                            60 (=1min) : minutely.\n"
           "                          3600 (=1hr)  : hourly.\n"
           "                         86400 (=1day) : daily.\n"
           "                        604800 (=7day) : daily.\n");
    printf("    -d DELAY        Log rotate delay in seconds.\n"
           "                    Ignored when DELAY is 0.\n"
           "                      (min, max)=(%d, %d)\n"
           , INT_MIN, INT_MAX);
    printf("                         86400 (=1day), 172800 (=2day),  259200 (=3day)\n"
           "                        345600 (=4day), 432000 (=5day),  518400 (=6day)\n");
    printf("    -m METADATA     Specify metadata. this is not used in program.\n"
           "                    This can be useful to find the process.\n");
    printf("Signals:\n"
           "    SIGUSR1         Causes to immediately rotate the log.\n"
           "                    If \"-f a.log\" then rotated file name will be \"a.log.1\".\n"
           "                    You can periodically send signal using crond.\n");
    printf("Example:\n"
           "    no roatation\n" 
           "        $ command | %s -f a.log\n"
           "    roatate daily at 02:00\n" 
           "        $ command | %s -f a.log -i 86400 -d 7200\n"
           "    rotate weekly at 22:00\n"
           "        $ command | %s -f a.log -i 604800 -d -7200\n"
           "    rotate on signal SIGUSR1\n"
           "        $ command | %s -f a.log -p ok.pid -m XYZ\n"
           "        $ kill -SIGUSR1 `cat ok.pid`\n"
           "        $ [ -f a.log.1 ] && mv a.log.1 a.log.`date +'%%Y%%m%%d%%H%%M%%S'`\n"
           , p, p, p, p);
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
    ctx.interval = 0; /* 0 means no rotation.  */
    ctx.delay = 0;    /* 0 means no delay. */
    ctx.dry_run = 0;  /* 0 false */
    ctx.newpath = NULL;

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
        } else if (strcmp(*(argv+i), "--dry-run") == 0) {
            ctx.dry_run = 1; /* 1 true */
        }
    }
    for (i = 1; i < argc; i++) {
        if ( strcmp(*(argv+i), "-h") == 0 || 
             strcmp(*(argv+i), "--help") == 0 ||
             strcmp(*(argv+i), "--dry-run") == 0) {
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
        } else if (strcmp(*(argv+i), "-i") == 0) {
            if (++i < argc) {
                v = strtol(*(argv+i), endptr, 10);
                if ( v < 0 ) { v = 0; }
                else if ( v < 5 ) { v = 5; }
                else if ( INT_MAX < v ) { v = INT_MAX; }
                ctx.interval = (int)v;
            } else { --i; msg = "requires interval in seconds."; break; }
        } else if (strcmp(*(argv+i), "-d") == 0) {
            if (++i < argc) {
                v = strtol(*(argv+i), endptr, 10);
                if ( v < INT_MIN ) { v = INT_MIN; }
                else if ( INT_MAX < v ) { v = INT_MAX; }
                ctx.delay = (int)v;
            } else { --i; msg = "requires delay in seconds."; break; }
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
            fprintf(stderr, "oldpath=%s\n", from);
            fprintf(stderr, "newpath=%s\n", to);
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

void update_rotate_time(struct context *ctx) {
    while (ctx->rotate_time.tv_sec <= ctx->current_time.tv_sec) {
        ctx->rotate_time.tv_sec += ctx->interval;
    }
    strcpy(ctx->newpath, ctx->fpath);
    strftime(ctx->newpath + strlen(ctx->fpath), CONST_EXT_DT_FORMAT_LEN,
             EXT_DT_FORMAT, localtime(&ctx->rotate_time.tv_sec));
# ifdef DEBUG
    printf("[DEBUG] update_rotate_time: current_time.tv_sec=%ld\n",
           ctx->current_time.tv_sec);
    printf("[DEBUG] update_rotate_time: rotate_time.tv_sec =%ld\n",
           ctx->rotate_time.tv_sec);
    printf("[DEBUG] update_rotate_time: newpath            =%s\n",
           ctx->newpath);
# endif
}

/* no DEBUGs */
void prepare_rotation(struct context *ctx) {
    int rc = 0;            /* return code */
    struct tm tmp_tm       /* temporary time */;

    rc = timespec_get(&ctx->current_time, TIME_UTC);
    if (rc == 0) { err_exit(12, "prepare_rotation: timespec_get()", errno); }

    /* calculate time to rotate */
    ctx->rotate_time = ctx->current_time;
    ctx->rotate_time.tv_nsec = 0;  /* reset nanosec to 0 */
    tmp_tm = *localtime(&ctx->rotate_time.tv_sec);

    tmp_tm.tm_sec = ctx->delay;
    if (ctx->interval >= 60) { tmp_tm.tm_min = 0; }
    if (ctx->interval >= 60 * 60) { tmp_tm.tm_hour = 0; }
    // if (ctx->interval >= 24 * 60 * 60) { tmp_tm.tm_mday -= 1; }
    tmp_tm.tm_sec += ctx->interval;
    ctx->rotate_time.tv_sec = mktime(&tmp_tm);
    if (ctx->rotate_time.tv_sec < 0) { err_exit(12, "prepare_rotation: mktime()", errno); }

    /* calculate nearest future rotation time. */
    while (ctx->rotate_time.tv_sec > ctx->current_time.tv_sec) {
        ctx->rotate_time.tv_sec -= ctx->interval;
    }
    update_rotate_time(ctx);
}

/* no DEBUGs */
void exit_if_dry_run(const struct context *ctx) {
    if (ctx->dry_run) {
        printf("=== dry run result ===\n");
        printf("parsed arguments\n");
        printf(" --dry-run\n");
        printf(" -f %s\n", ctx->fpath);
        printf(" -p %s\n", ctx->ppath);
        printf(" -l %ld\n", ctx->line_maxlen);
        printf(" -i %ld\n", ctx->interval);
        printf(" -d %ld\n", ctx->delay);
        printf("logfile path          : %s\n", ctx->fpath);
        printf("next rotation path    : %s\n", ctx->newpath); 
        printf("SIGUSR1 rotation path : %s\n", ctx->sigpath); 
        fflush(stdout);
        exit(0);
    }
}

volatile int flag_sigusr1 = 0;
void handler_sigusr1(int signum)
{
# ifdef DEBUG
    printf("[DEBUG] handler_siusr1() called.\n");
# endif
    flag_sigusr1 = 1;
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

#ifdef HEADER_DT    
    char buffer[20];       /* yyyy-mm-dd HH:MM:SS  */
                           /* 12345678901234567890 */
    time_t timer;          /* current time for log header */
#endif

    ctx = parse_args(argc, argv);

    line = malloc_str(ctx.line_maxlen);
    if (line == NULL) { err_exit(11, "main: line = malloc()", errno); }

    ctx.sigpath = malloc_str(strlen(ctx.fpath) + 2 - 1);
    if (ctx.sigpath == NULL) { err_exit(11, "main: ctx.sigpath = malloc()", errno); }
    strcpy(ctx.sigpath, ctx.fpath);
    strcpy(ctx.sigpath + strlen(ctx.fpath), ".1");

    if (ctx.interval > 0) {
        ctx.newpath = malloc_str(strlen(ctx.fpath) + CONST_EXT_DT_FORMAT_LEN - 1);
        if (ctx.newpath == NULL) { err_exit(11, "main: ctx.newpath = malloc()", errno); }

        prepare_rotation(&ctx);
    }

    exit_if_dry_run(&ctx);

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
    sigset_t set;
    sigemptyset(&set);
    sigaddset(&set, SIGUSR1);

    struct sigaction sa;
    sa.sa_handler = handler_sigusr1;
    sa.sa_flags = 0;
    rc = sigemptyset(&sa.sa_mask);
    if (rc == -1) {
        es = 21; err_msg(es, "main: sigemptyset()", rc);
        goto end;
    }
    rc = sigaction(SIGUSR1, &sa, NULL);
    if (rc == -1) {
        es = 21; err_msg(es, "main: sigaction()", rc);
        goto end;
    }

    /* need_to_end_section from here.: s_out */
    s_out = fopen(ctx.fpath, "a");  /* append mode. */
    if (s_out == NULL) {
        es = 21; err_msg(es, "main: s_out = fopen()", errno);
        fprintf(stderr, "filename=%s\n", ctx.fpath);
        goto end;
    }

    /* from here,
       "es = NN; err_mst(es, ...); goto end;"
       to exit in order to close().            */
    fds[0].fd      = fileno(s_in);
    fds[0].events  = POLLIN;
    fds[0].revents = 0;

    while(! feof(stdin)) {
        while (TRUE) { /* polling block        */
# ifdef DEBUG
            printf("[DEBUG] main: polling... \n");
# endif

# ifdef MASK_POLL
            // sigprocmask(SIG_BLOCK, &set, NULL);
            poll_rc = poll(fds, 1, 333);
            // sigprocmask(SIG_UNBLOCK, &set, NULL);
            // if (poll_rc == -1) {  /* error occured. */
            //     es = 22; err_msg(es, "main: poll()", errno);
            //     fprintf(stderr, "revents=%d\n", fds[0].revents);
            //     goto end;
            // }
# else
            poll_rc = poll(fds, 1, 333);
# endif

            if (flag_sigusr1 == 1) { /* rotation by signal */
# ifdef DEBUG
                printf("[DEBUG] main: rotation by SIGUSR1... poll_rc=%d\n", poll_rc);
# endif
                rc = rotate_log(&s_out, ctx.fpath, ctx.sigpath);
                if (rc != 0) { es = rc; goto end; }
                flag_sigusr1 = 0;    /* clear flag after rotation. */
            }

            if (ctx.interval > 0) {
                rc = timespec_get(&ctx.current_time, TIME_UTC);
                if (rc == 0) {
                    es = 23; err_msg(es, "main: timespec_get()", errno);
                    goto end;
                }
                if (ctx.rotate_time.tv_sec <= ctx.current_time.tv_sec) {
# ifdef DEBUG
                    printf("[DEBUG] main: rotating... poll_rc=%d\n", poll_rc);
# endif
                    rc = rotate_log(&s_out, ctx.fpath, ctx.newpath);
                    if (rc != 0) { es = rc; goto end; }
                    update_rotate_time(&ctx);
                }
            }

            if (poll_rc > 0) { break; }
        }

# ifdef DEBUG
        printf("[DEBUG] main: fgets()...\n");
# endif

        sigprocmask(SIG_BLOCK, &set, NULL); /* BLOCK signal SIGUSR1 from here */
        p = fgets(line, ctx.line_maxlen, s_in);
        if (p == NULL && ferror(s_in) == 0) {
            es = 0;  /* normal end */
            goto end;
        }
        if (p == NULL) {
            es = 31; err_msg(es, "main: fgets() 1st", errno);
            goto end;
        }
        if (p != NULL) {
            rc = timespec_get(&ctx.current_time, TIME_UTC);
            if (rc == 0) {
                es = 31; err_msg(es, "main: timespec_get()", errno);
                goto end;
            }

# ifdef HEADER_DT
            /* tv_sec  is second,                    *
             *         in Hexadecimal 0 - ffffffff   */
            /* tv_nsec is nanosecond, 0 - 999999999, * 
             *         in Hexadecimal 0 - 3b9ac9ff   */
            /*
# ifdef DEBUG
            fprintf(stdout, "@%08lx.%08lx\t",
                    ctx.current_time.tv_sec,
                    ctx.current_time.tv_nsec);
# endif
            rc = fprintf(s_out, "@%08lx.%08lx\t",
                         ctx.current_time.tv_sec,
                         ctx.current_time.tv_nsec);
            if (rc < 0) {
                es = 31; err_msg(es, "main: fprintf", errno);
                goto end;
            }
             */

            timer = time(NULL);  /* for header of log line */ 
            strftime(buffer, CONST_DT_FORMAT_LEN, DT_FORMAT,
                     localtime(&timer));
# ifdef DEBUG
            fprintf(stdout, "%s\t", buffer);
# endif
            rc = fprintf(s_out, "%s\t", buffer);
            if (rc < 0) {
                es = 31; err_msg(es, "main: fprintf", errno);
                goto end;
            }
# endif

# ifdef DEBUG
            fputs(line, stdout);
# endif
            rc = fputs(line, s_out);
            if (rc == EOF) {
                es = 32; err_msg(es, "main: fputs() 1st", errno);
                goto end;
            }
            if (p != NULL && *(line + strlen(line) - 1) != '\n') {
# ifdef DEBUG
                printf("\n");
# endif
                rc = fputs("\n", s_out);
                if (rc == EOF) {
                    es = 32; err_msg(es, "main: fputs() 2nd", errno);
                    goto end;
                }
            }
# ifdef DEBUG
            fflush(stdout);
# endif
            rc = fflush(s_out);
            if (rc == EOF) {
                es = 32; err_msg(es, "main: fflush()", errno);
                goto end;
            }

            /* discard the remaining data in stream */
            while (p != NULL && *(line + strlen(line) - 1) != '\n') {
                p = fgets(line, ctx.line_maxlen, s_in);
                if (p == NULL && ferror(s_in) == 0) {
                    es = 0;  /* normal end */
                    goto end;
                }
                if (p == NULL) {
                    es = 31; err_msg(es, "main: fgets() 2nd", errno);
                    goto end;
                }
            }
        }
        sigprocmask(SIG_UNBLOCK, &set, NULL); /* UNBLOCK signal SIGUSR1 */
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



