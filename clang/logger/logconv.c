/*
 * log converter program. for log generated logger
 *
 * compile:
 *     gcc -g -Wall -pedantic -O0 -o logconv logconv.c
 */

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <time.h>

void show_usage(char *arg0) {
    printf("Description:\n");
    printf("    This is a logfile converter program, reads from stdin, writes to stdout.\n");
    printf("      $ cat logfile | logconv\n");
    printf("Usage:\n");
    printf("    %s -h|--help\n", arg0);
    printf("    cat logile | %s\n", arg0);
}

void parse_args(int argc, char **argv) {
    int i = 0;
    if (argc == 0) { return; }
# ifdef DEBUG
    printf("DEBUG: argc=%d\n", argc); /* for debug. */
    for (i = 0; i < argc; i++) { printf("DEBUG: argv[%d]=%s\n", i, *(argv+i)); }
# endif
    for (i = 1; i < argc; i++) {
        if ( strcmp(*(argv+i), "-h") == 0 || 
             strcmp(*(argv+i), "--help") == 0 ) {
             show_usage(*argv); exit(0);
        }
    }
    return;
}

int main(int argc, char **argv)
{
    char *line = NULL;     /* line for log */
    char *p = "";          /* pointer      */
    time_t sec;
    long nsec;
    struct timespec ct;    /* current_time */
    char YmdHMS[20]; 
    const int maxlen = 4096;
    const int tabpos = 18;
    
    parse_args(argc, argv);
    
    timespec_get(&ct, TIME_UTC);
    
    line = (char *)malloc(maxlen);
    p = fgets(line, maxlen, stdin);
    while (p != NULL) {
#ifdef DEBUG
        printf("p='%s'\n", p);
        printf("line='%s'\n", line);
        printf("line[0]='%c'\n", *line);
        printf("line[18]='%c'\n", *(line+tabpos));
#endif
        if (strlen(line) >= tabpos && *line == '@' && *(line + tabpos) == '\t') {
            /* sscanf(line, "@%8ld.%8ld\t", &sec, &nsec); not match */
            sscanf(line, "@%8lx.%8lx\t", &sec, &nsec);
            ct.tv_sec = sec; ct.tv_nsec = 0;
            strftime(YmdHMS, sizeof(YmdHMS), "%Y-%m-%d %H:%M:%S", localtime(&ct.tv_sec));
            /*
            printf("%s.%09ld%s", YmdHMS, nsec, line+tabpos);
            */
            printf("%s.%09ld", YmdHMS, nsec);
            line += tabpos;
        }
        printf("%s", line);
        if (p != NULL && *(line + strlen(line) - 1) != '\n') {
            p = fgets(line, maxlen, stdin);
            printf("%s", line);
            while (p != NULL && *(line + strlen(line) - 1) != '\n') {
                p = fgets(line, maxlen, stdin);
                printf("%s", line);
            }
        }
        p = fgets(line, maxlen, stdin);
    }
    return 0;
}

