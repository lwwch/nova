#define _DEFAULT_SOURCE

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdarg.h>
#include <string.h>

#define LIMIT (1024)
#define SHORT_LIMIT (64)
#define NONE (-1)
#define WHITE (231)
#define RED (9)
#define BLUE (12)
#define GREEN (2)
#define CYAN (6)
#define MAGENTA (5)

typedef struct {
  char buffer[LIMIT];
  int offset;
} Prompt;

void format_prompt(Prompt* p, int color, const char* fmt, ...) {
  if (color != -1) {
    p->offset += snprintf(p->buffer + p->offset, LIMIT - p->offset, "\\[\x1b[38;5;%dm\\]", color); }
  va_list args;
  va_start(args, fmt);
  p->offset += vsnprintf(p->buffer + p->offset, LIMIT - p->offset, fmt, args);
  va_end(args);
  p->offset += snprintf(p->buffer + p->offset, LIMIT - p->offset, "\\[\x1b[0m\\]");
}

void display_prompt(Prompt* p) {
  fprintf(stdout, "%s\n", p->buffer);
}
  
int main(int argc, char* argv[]) {
  Prompt p;
  p.offset = 0;
  memset(p.buffer, 0x00, sizeof(p.buffer));

  if (argc != 2) {
    format_prompt(&p, NONE, "ERROR (args)\n");
    display_prompt(&p);
    return 1;
  }

  int rc = atoi(argv[1]);
  format_prompt(&p, rc == 0 ? NONE : RED, "(%3d) ", rc);

  char login[SHORT_LIMIT];
  memset(login, 0x00, sizeof(login));
  getlogin_r(login,  sizeof(login));
  format_prompt(&p, BLUE, "%s ", login);

  format_prompt(&p, WHITE, "at ");
  char hostname[SHORT_LIMIT];
  memset(hostname, 0x00, sizeof(hostname));
  gethostname(hostname, sizeof(hostname));
  format_prompt(&p, GREEN, "%s ", hostname);

  format_prompt(&p, WHITE, "wd ");
  char working[SHORT_LIMIT];
  memset(working, 0x00, sizeof(working));
  getcwd(working, sizeof(working));
  format_prompt(&p, CYAN, "%s ", working);

  format_prompt(&p, WHITE, "> ");
  display_prompt(&p);
  return 0;
}
