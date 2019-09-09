#define _DEFAULT_SOURCE
#define _XOPEN_SOURCE 500

#include <stdarg.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <git2.h>

#define LIMIT (1024)
#define SHORT_LIMIT (1024)
#define NONE (-1)
#define WHITE (231)
#define RED (9)
#define BLUE (12)
#define YELLOW (11)
#define GREEN (2)
#define CYAN (6)
#define MAGENTA (5)

typedef struct {
  bool is_dirty;
  const char* branch;
} GitInfo;

typedef struct {
  char buffer[LIMIT];
  int offset;
} Prompt;

bool get_git_info(GitInfo* info) {
  git_buf root = {0};
  git_repository* repo;
  git_reference* head;
  git_status_list* status;

  if (git_repository_discover(&root, ".", 0, NULL) != 0) {
    return false;
  }

  if (git_repository_open(&repo, root.ptr) != 0) {
    git_buf_free(&root);
    return false;
  }
  git_buf_free(&root);

  if (git_repository_head(&head, repo) != 0) {
    return false;
  }
  info->branch = strdup(git_reference_shorthand(head));
  git_reference_free(head);

  git_status_options opts;
  memset(&opts, 0x00, sizeof(opts));
  opts.version = 1;
  opts.show = GIT_STATUS_SHOW_INDEX_AND_WORKDIR;
  opts.flags = GIT_STATUS_OPT_INCLUDE_UNTRACKED;

  if (git_status_list_new(&status, repo, &opts) != 0) {
    return false;
  }

  size_t dirty_entries = git_status_list_entrycount(status);
  info->is_dirty = dirty_entries != 0;

  git_status_list_free(status);
  git_repository_free(repo);
  return true;
}

void modify_for_home_relative(const char* user, const char* working) {
  if (strncmp(working, "/home/", 6) != 0) {
    return;
  }
  const size_t user_len = strlen(user);
  if (strncmp(working + 6, user, user_len) != 0) {
    return;
  }

  const char sep = working[6 + user_len];
  if (sep != 0 && sep != '/') {
    return;
  }

  const char* src = strdup(working);
  char* out = (char*)working;
  out[0] = '~';
  strcpy(out + 1, src + 6 + user_len);
  free((void*)src);
}

void format_prompt(Prompt* p, int color, const char* fmt, ...) {
  if (color != -1) {
    p->offset += snprintf(p->buffer + p->offset, LIMIT - p->offset,
                          "\\[\x1b[38;5;%dm\\]", color);
  }
  va_list args;
  va_start(args, fmt);
  p->offset += vsnprintf(p->buffer + p->offset, LIMIT - p->offset, fmt, args);
  va_end(args);
  p->offset +=
      snprintf(p->buffer + p->offset, LIMIT - p->offset, "\\[\x1b[0m\\]");
}

void display_prompt(Prompt* p) { fprintf(stdout, "%s\n", p->buffer); }

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

  const char* conda_env = getenv("CONDA_DEFAULT_ENV");
  if (conda_env != NULL) {
    format_prompt(&p, NONE, "[py: ");
    format_prompt(&p, GREEN, "%s", conda_env);
    format_prompt(&p, NONE, "] ");
  }

  char login[SHORT_LIMIT];
  memset(login, 0x00, sizeof(login));
  getlogin_r(login, sizeof(login));
  format_prompt(&p, BLUE, "%s ", login);

  format_prompt(&p, WHITE, "at ");
  char hostname[SHORT_LIMIT];
  memset(hostname, 0x00, sizeof(hostname));
  gethostname(hostname, sizeof(hostname));
  format_prompt(&p, YELLOW, "%s ", hostname);

  format_prompt(&p, WHITE, "in ");
  char working[SHORT_LIMIT];
  memset(working, 0x00, sizeof(working));
  if (getcwd(working, sizeof(working)) != 0) {
    modify_for_home_relative(login, working);
    format_prompt(&p, CYAN, "%s ", working);
  }

  git_libgit2_init();
  GitInfo ginfo;
  memset(&ginfo, 0x00, sizeof(ginfo));
  if (get_git_info(&ginfo)) {
    format_prompt(&p, NONE, "(git: ");
    format_prompt(&p, ginfo.is_dirty ? RED : GREEN, "%s", ginfo.branch);
    format_prompt(&p, NONE, ") ");
  }
  if (ginfo.branch != NULL) {
    free((void*)ginfo.branch);
  }
  git_libgit2_shutdown();

  format_prompt(&p, WHITE, "> ");
  display_prompt(&p);
  return 0;
}
