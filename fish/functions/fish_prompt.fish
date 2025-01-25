# adapted from _hydro_
# https://github.com/jorgebucaran/hydro/blob/main/conf.d/hydro.fish

function _prompt_working --on-variable PWD
  set --global git_root (command git --no-optional-locks rev-parse --show-toplevel 2>/dev/null)
  if test $status -ne 0
    set --global --erase git_root
  end
  # set --global git_base (string replace --all --regex -- "^.*/" "" "$git_root")
end

function _prompt_git_status --on-event fish_prompt
  if not set -q git_root
    set --global _prompt_git_status (echo -e (set_color --dim)"")
    return
  end


  set --local branch (
    command git symbolic-ref --short HEAD 2> /dev/null ||
    command git describe --tags --exact-match HEAD 2> /dev/null ||
    command git rev-parse --short HEAD 2> /dev/null
  )

  command git diff --quiet
  if test $status -eq 1
    set --global _prompt_git_status (echo (set_color --bold red)"" $branch)
  else
    set --global _prompt_git_status (echo (set_color --bold green)"" $branch)
  end
end

function fish_prompt --description "Fish/Myles"
  echo -e (set_color --dim)(pwd) $_prompt_git_status
  echo -e (set_color normal) "-> "
end
