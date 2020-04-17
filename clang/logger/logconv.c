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
    printf("      $ cat logfile | TZ=Asia/Tokyo logconv\n");
    printf("Usage:\n");
    printf("    %s -h|--help\n", arg0);
    printf("    cat logile | %s\n", arg0);
}

void parse_args(int argc, char **argv) {
    int i = 0;
    if (argc == 0) { return; }
# ifdef DEBUG
    printf("[DEBUG] argc=%d\n", argc); /* for debug. */
    for (i = 0; i < argc; i++) { printf("[DEBUG] argv[%d]=%s\n", i, *(argv+i)); }
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
    long unsigned sec;
    long unsigned nsec;
    struct timespec ct;    /* current_time */
    char YmdHMS[20]; 
    const int tabpos = 18;
    int maxlen = 4096;
    int pos;

    if (maxlen < tabpos) { maxlen += tabpos; } // for safety

    parse_args(argc, argv);

    timespec_get(&ct, TIME_UTC);

    line = (char *)malloc(maxlen);
    if (line != NULL) { *(line+strlen(line)-1) = '\0'; } // for safety

    while (! feof(stdin)) {
        pos = 0;
        while (pos == 0 || (pos < tabpos && *(line+pos-1) != '\n')) {
            p = fgets(line + pos, maxlen - pos, stdin);
            if (p == NULL) { break; }
            pos = strlen(line);
#ifdef DEBUG
            printf("[DEBUG] pos=%d\n", pos);
            if (*(line+pos-1) == '\0') { 
                printf("[DEBUG] *(line+pos-1) = '\\0'\n");
            } else if (*(line+pos-1) == '\n') { 
                printf("[DEBUG] *(line+pos-1) = '\\n'\n");
            } else {
                printf("[DEBUG] *(line+pos-1) = '%c'\n", *(line+pos-1));
            }
#endif
        }
#ifdef DEBUG
        if (p!= NULL) {
            // printf("[DEBUG] p='%s'\n", p);
            // printf("[DEBUG] line='%s'\n", line);
            if (strlen(line) >= tabpos && *line == '@' && *(line + tabpos) == '\t') {
                printf("[DEBUG] header line[0]='@', line[%d]='\\t'\n", tabpos);
            }
        }
#endif
        if(p != NULL) {
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
                printf("%s", line + tabpos);
            } else {
                printf("%s", line);
            }
        }
        while (p != NULL && *(line + strlen(line) - 1) != '\n') {
            p = fgets(line, maxlen, stdin);
            printf("%s", line);
        }
    }
    return 0;
}

