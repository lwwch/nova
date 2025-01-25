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
    set --global _prompt_git_status (echo (set_color brred)"" $branch)
  else
    set --global _prompt_git_status (echo (set_color brgreen)"" $branch)
  end
end

function _prompt_status --on-event fish_postexec
  set --local last_status $pipestatus
  for code in $last_status
    if test $code -eq 0
      set --global _prompt_status (echo (set_color brblue)""$last_status)
    else
      set --global _prompt_status (echo (set_color brred)""$last_status)
    end
  end
end

function _prompt_timing --on-event fish_postexec
  set --local sec (math --scale=3 $CMD_DURATION/1000 % 60)
  set --local min (math --scale=0 $CMD_DURATION/60000 % 60)
  set --local hour (math --scale=0 $CMD_DURATION/3600000)

  set --local out
  test $hour -gt 0 && set --local --append out $hour"h"
  test $min -gt 0 && set --local --append out $min"m"
  set --local --append out $sec"s"

  set --global _prompt_timing $out
end

function fish_prompt --description "Fish/Myles"
  echo -e (set_color --dim)(pwd) $_prompt_git_status $_prompt_status $_prompt_timing
  echo -e (set_color normal) "-> "
end

function fish_right_prompt --description "Fish/Myles-Right"
  echo -e (set_color brblack) (command date "+%Y-%m-%d %H:%M:%S %Z")
end
