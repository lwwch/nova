#include <stdio.h>
#include <unistd.h>
#include <string.h>

typedef struct {
  char buffer[LIMIT];
  int offset;
} Prompt;

