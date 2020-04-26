/*
 * small logger program.
 *
 * compile:
 *     gcc -g -Wall -pedantic -O0 -o mylogger logger.c
 */

#include <errno.h>
#include <limits.h>
#include <poll.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#define CONST_YmdHMS_LEN (16)
#define DEFAULT_LINE_MINLEN (64)
#define DEFAULT_LINE_MAXLEN (4096)
#define TRUE (1)
#define FALSE (0)

char *ERROR_FORMAT = "[%d] Error: %s(%d) %s\n";

struct context {
    char *fpath;      /* log file path */
    size_t line_maxlen;  /* line max length */
    time_t interval;     /* rotate interval in seconds */
    time_t delay;        /* rotate delay in seconds */
    int dry_run;      /* dry run : 0 false, 1 true */
    struct timespec current_time;
    struct timespec rotate_time;
    char *newpath;    /* strlen(fpath) + CONST_YmdHMS_LEN - 1 */
};

void show_usage(const char * const arg0) {
    printf("Description:\n");
    printf("============\n");
    printf("    This is a logging program, reads from stdin, writes to logfile.\n");
    printf("    If interval > 0, rotate log when new input arrived.\n");
    printf("    This program uses fgets().\n");
    printf("\n");
    printf("Usage:\n");
    printf("======\n");
    printf("    %s -h|--help\n", arg0);
    printf("    %s --dry-run -f FILE [-l length] [-i interval] [-d delay]\n", arg0);
    printf("    command | %s [--dry-run] -f FILE [-l length] [-i interval] [-d delay]\n", arg0);
    printf("\n");
    printf("Caution:\n");
    printf("========\n");
    printf("    If specified value is out of range, it will be rounded.\n");
    printf("    Use '--dry-run' to check how the arguments were parsed.\n");
    printf("\n");
    printf("Options:\n");
    printf("========\n");
    printf("    -h|--help    show usage and exit.\n");
    printf("    --dry-run    show parsed arguments and exit.\n");
    printf("    -f FILE      log file name\n");
    printf("    -l length    line size in bytes (integer)\n");
    printf("                 this must includes terminating null character.\n");
    printf("                 default is %d.\n", DEFAULT_LINE_MAXLEN);
    printf("                   (min, max)=(%d, %d)\n", DEFAULT_LINE_MINLEN, INT_MAX);
    printf("    -i interval  log rotate interval in seconds.\n");
    printf("                 rotation occures when new input arrives.\n");
    printf("                 default is 0.\n");
    printf("                   (min, max)=(%d, %d)\n", 0, INT_MAX);
    printf("                       0 : no rotation\n");
    printf("                      60 : minutely.\n");
    printf("                    3600 : hourly.\n");
    printf("                   86400 : daily.\n");
    printf("    -d delay     log rotate delay in seconds.\n");
    printf("                 ignored when interval is 0.\n");
    printf("                   (min, max)=(%d, %d)\n", INT_MIN, INT_MAX);
    fflush(stdout);
}

struct context parse_args(int argc, char **argv) {
    int i = 0; long v = 0;
    char **endptr = NULL; char *msg = NULL;
    
    struct context ctx;
    ctx.fpath = NULL;
    ctx.line_maxlen = DEFAULT_LINE_MAXLEN;
    ctx.interval = 0; /* 0 means no rotation.  */
    ctx.delay = 0;    /* 0 means no delay. */
    ctx.dry_run = 0;  /* 0 false */
    ctx.newpath = NULL;
    
    if (argc == 0) { return ctx; }
# ifdef DEBUG
    printf("[DEBUG] parse_args: argc=%d\n", argc);
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
                ctx.fpath = *(argv+i);
            } else { --i; msg = "requires filename."; break; }
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
        } else {
            msg = "is unknown parameter."; break;
        }
    }
    if (ctx.fpath == NULL) {
        fprintf(stderr, "Invalid argument : '-f' required.\n");
        show_usage(*argv); exit(1);
    }
    if (msg != NULL) {
        fprintf(stderr, "Invalid argument : '%s' %s\n", *(argv+i), msg);
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
    int rc;
    if (*s_out != NULL) {
        rc = fclose(*s_out);
        if (rc == EOF) { err_msg(23, "fclose", errno); return 23; }
        *s_out = NULL;
# ifdef DEBUG
        printf("[DEBUG] rotate_log: fclose()\n");
# endif

        rc = rename(from, to);
        if (rc == -1) {
            err_msg(24, "rename", errno);
            fprintf(stderr, "oldpath=%s\n", from);
            fprintf(stderr, "newpath=%s\n", to);
            return 24;
        }
# ifdef DEBUG
        printf("[DEBUG] rotate_log: rename() %s -> %s\n", from, to);
# endif

        *s_out = fopen(from, "a");
        if (*s_out == NULL) { 
            err_msg(25, "fopen", errno);
            fprintf(stderr, "filename=%s\n", from);
            exit(25);
        }
# ifdef DEBUG
        printf("[DEBUG] rotate_log: open() %s\n", from);
# endif
    }
    return 0;
}

void update_rotate_time(struct context *ctx) {
    while (ctx->rotate_time.tv_sec <= ctx->current_time.tv_sec) {
        ctx->rotate_time.tv_sec += ctx->interval;
    }
    strcpy(ctx->newpath, ctx->fpath);
    strftime(ctx->newpath + strlen(ctx->fpath), CONST_YmdHMS_LEN,
             ".%Y%m%d%H%M%S", localtime(&ctx->rotate_time.tv_sec));
# ifdef DEBUG
    printf("[DEBUG] update_rotate_time: current_time.tv_sec=%ld\n",
           ctx->current_time.tv_sec);
    printf("[DEBUG] update_rotate_time: rotate_time.tv_sec =%ld\n",
           ctx->rotate_time.tv_sec);
    printf("[DEBUG] update_rotate_time: newpath            =%s\n",
           ctx->newpath);
# endif
}

void prepare_rotation(struct context *ctx) {
    int rc = 0;            /* return code     */
    struct tm tmp_tm;

    rc = timespec_get(&ctx->current_time, TIME_UTC);
    if (rc == 0) { err_exit(13, "timespec_get", errno); }

    /* calculate rotate time */
    ctx->rotate_time = ctx->current_time;
    ctx->rotate_time.tv_nsec = 0;
    tmp_tm = *localtime(&ctx->rotate_time.tv_sec);

    tmp_tm.tm_sec = ctx->delay;
    if (ctx->interval >= 60) { tmp_tm.tm_min = 0; }
    if (ctx->interval >= 60 * 60) { tmp_tm.tm_hour = 0; }
    if (ctx->interval >= 24 * 60 * 60) { tmp_tm.tm_mday -= 1; }
    tmp_tm.tm_sec += ctx->interval;
    ctx->rotate_time.tv_sec = mktime(&tmp_tm);
    if (ctx->rotate_time.tv_sec < 0) { err_exit(14, "mktime", errno); }

    /* calculate nearest future rotation time. */
    while (ctx->rotate_time.tv_sec > ctx->current_time.tv_sec) {
        ctx->rotate_time.tv_sec -= ctx->interval;
    }
    update_rotate_time(ctx);
}

void exit_if_dry_run(const struct context *ctx) {
    if (ctx->dry_run) {
        printf("== dry run result ==\n");
        printf("parsed arguments   : -f %s -l %ld -i %ld -d %ld --dry-run\n",
                ctx->fpath, ctx->line_maxlen, ctx->interval, ctx->delay);
        printf("logfile path       : %s\n", ctx->fpath);
        printf("next rotation file : %s\n", ctx->newpath); 
        fflush(stdout);
        exit(0);
    }
}

int main(int argc, char **argv)
{
    char *line = NULL;     /* line for log     */
    char *p = NULL;        /* pointer          */
    FILE *s_in = stdin;    /* stream_in        */
    FILE *s_out = NULL;    /* stream_out       */
    int rc = 0;            /* return code      */
    int es = 1;            /* exit status      */
    int cnt = 0;           /* count            */
    int poll_rc = 0;       /* poll return code */
    struct pollfd fds[1];  /* for poll()       */
    struct context ctx;    /* context          */
    struct tm tm;          /* local time       */

    ctx = parse_args(argc, argv);

    line = malloc_str(ctx.line_maxlen);
    if (line == NULL) { err_exit(11, "malloc", errno); }

    if (ctx.interval > 0) {
        ctx.newpath = malloc_str(strlen(ctx.fpath) + CONST_YmdHMS_LEN - 1);
        if (ctx.newpath == NULL) { err_exit(12, "malloc", errno); }

        prepare_rotation(&ctx);
    }

    exit_if_dry_run(&ctx);

    /* need_to_end_section from here.: s_out */
    s_out = fopen(ctx.fpath, "a");
    if (s_out == NULL) { 
        err_msg(19, "fopen", errno);
        fprintf(stderr, "filename=%s\n", ctx.fpath);
        exit(19);
    }

    fds[0].fd      = fileno(s_in);
    fds[0].events  = POLLIN;
    fds[0].revents = 0;

    while(! feof(stdin)) {
        cnt = 0;
        while (TRUE) {
# ifdef DEBUG
            printf("[DEBUG] main: polling... cnt=%d\n", cnt);
# endif
            poll_rc = poll(fds, 1, 166);
            if (poll_rc == -1) { err_msg(21, "poll", errno); es = 21; goto end; }

            if (ctx.interval > 0) {
                cnt++;
# ifdef DEBUG
                printf("[DEBUG] main: rotating... rc=%d, cnt=%d\n", rc, cnt);
# endif
                if (poll_rc > 0 || cnt > 5) {
                    rc = timespec_get(&ctx.current_time, TIME_UTC);
                    if (rc == 0) { err_exit(22, "timespec_get", errno); }
                    if (ctx.rotate_time.tv_sec <= ctx.current_time.tv_sec) {
                        rc = rotate_log(&s_out, ctx.fpath, ctx.newpath);
                        if (rc != 0) { es = rc; goto end; }
                        update_rotate_time(&ctx);
                    }
                    cnt = 0;
                }
            }

            if (poll_rc > 0) { break; }
        }
# ifdef DEBUG
        printf("[DEBUG] main: fgets... cnt=%d\n", cnt);
# endif
        p = fgets(line, ctx.line_maxlen, s_in);
        if (p == NULL && ferror(s_in)) { err_msg(31, "fgets", errno); es = 31; goto end; }
        if (p != NULL) {
            rc = timespec_get(&ctx.current_time, TIME_UTC);
            if (rc == 0) { err_msg(32, "timespec_get", errno); es = 32; goto end; }
            tm = *localtime(&ctx.current_time.tv_sec);
            rc = fprintf(s_out, "%04d-%02d-%02d %02d:%02d:%02d.%09ld %s",
                         tm.tm_year + 1900, tm.tm_mon + 1, tm.tm_mday,
                         tm.tm_hour, tm.tm_min, tm.tm_sec,
                         ctx.current_time.tv_nsec, line);

            /* fprintf(s_out, "@%ld.%ld:", ct.tv_sec, ct.tv_nsec); */
            /* tv_sec is second, in Hexadecimal 0 - ffffffff */
            /* tv_nsec is nanosecond, 0 - 999999999, in Hexadecimal 0 - 3b9ac9ff */
            /*
             rc = fprintf(s_out, "@%08lx.%08lx\t%s",
                         ctx.current_time.tv_sec,
                         ctx.current_time.tv_nsec,
                         line);
             */
            if (rc < 0) { err_msg(33, "fprintf", errno); es = 33; goto end; }

# ifdef DEBUG
            printf("%04d-%02d-%02d %02d:%02d:%02d.%09ld %s",
                   tm.tm_year + 1900, tm.tm_mon + 1, tm.tm_mday,
                   tm.tm_hour, tm.tm_min, tm.tm_sec,
                   ctx.current_time.tv_nsec, line);
            /*
            printf("@%08lx.%08lx\t%s",
                    ctx.current_time.tv_sec,
                    ctx.current_time.tv_nsec,
                    line);
             */
# endif
            /* discard the remaining data in stream */
            while (p != NULL && *(line + strlen(line) - 1) != '\n') {
                p = fgets(line, ctx.line_maxlen, s_in);
                if (p == NULL && ferror(s_in)) { err_msg(34, "fgets", errno); es = 34; goto end; }
                if (p != NULL) {
                    rc = fputs(line, s_out);
                    if (rc == EOF) { err_msg(35, "fputs", errno); es = 35; goto end; }
# ifdef DEBUG
                    printf("%s", line);
# endif
                }
            }
            rc = fflush(s_out);
            if (rc == EOF) { err_msg(36, "fflush", errno); es = 36; goto end; }
        }
    }
    es = 0;

end:
    if (s_out !=NULL) { fclose(s_out); }
# ifdef DEBUG
    printf("[DEBUG] main: return(%d)\n", es);
# endif
    return es;
}



