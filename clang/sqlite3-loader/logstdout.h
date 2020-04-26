#ifndef _LOGSTDOUT_H_
#define _LOGSTDOUT_H_

#ifdef LOGSTDOUT
/* output is enabled. */
#define LOG_ERROR(...) printf("%s.%d [ERROR] ", __FILE__, __LINE__);\
                       printf(__VA_ARGS__)
#define LOG_INFO(...)  printf("%s.%d [INFO] ", __FILE__, __LINE__);\
                       printf(__VA_ARGS__)
#define LOG_DEBUG(...) printf("%s.%d [DEBUG] ", __FILE__, __LINE__);\
                       printf(__VA_ARGS__)
#define LOG_DEBUG_IF(status, ...) if (status) {\
                           printf("%s.%d [DEBUG] ", __FILE__, __LINE__);\
                           printf(__VA_ARGS__);\
                       }
#define __LOG_CLOCK_INIT       clock_t __start_clock = 0, __delta_clock = 0;
#define __LOG_CLOCK_START      __start_clock = clock();
#define __LOG_CLOCK_END        __delta_clock = clock() - __start_clock;
#define LOG_DEBUG_CLOCK(...) printf("%s.%d [DEBUG] ", __FILE__, __LINE__);\
 printf("spent %4.2f sec. ", __delta_clock / (double)CLOCKS_PER_SEC);\
                               printf(__VA_ARGS__)
#else
/* output is disabled. */
#define LOG_ERROR(...)       /* LOG_ERROR()    */
#define LOG_INFO(...)        /* LOG_INFO()     */
#define LOG_DEBUG(...)       /* LOG_DEBUG()    */
#define LOG_DEBUG_IF(...)    /* LOG_DEBUG_IF() */
#define __LOG_CLOCK_INIT     /* __LOG_CLOCK_INIT  */
#define __LOG_CLOCK_START    /* __LOG_CLOCK_START */
#define __LOG_CLOCK_END      /* __LOG_CLOCK_END   */
#define LOG_DEBUG_CLOCK(...) /* LOG_DEBUG_CLOCK() */
#endif

#endif

