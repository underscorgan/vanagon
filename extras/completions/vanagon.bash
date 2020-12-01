#!/usr/bin/env bash

_vanagon()
{
  local cur prev commands template_arg_commands 

  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"

  commands="build build_host_info build_requirements inspect list render sign ship help"
  template_arg_commands="build"

  if [[ $cur == -* ]] ; then
    COMPREPLY=()
  elif [[ $template_arg_commands =~ (^| )$prev($| ) ]] ; then
    if [[ -z "$_vanagon_avail_templates" ]] ; then
      _vanagon_avail_templates=$(vanagon list 2>/dev/null)
    fi
    COMPREPLY=( $(compgen -W "${_vanagon_avail_templates}" -- "${cur}") )
  elif [[ $1 == $prev ]] ; then
    # only show top level commands we are at root
    COMPREPLY=( $(compgen -W "${commands}" -- "${cur}") )
  fi
}
complete -F _vanagon vanagon
