#!/usr/bin/env bash

_vanagon()
{
  local cur prev commands template_arg_commands 
    # -- signifies end of command, necessary here?

  # COMREPLY is an array variable used to store completions  
  # the completion mechanism uses this variable to display its contents as completions
  COMPREPLY=()
  # COMP_WORDS is an array of all the words typed after the name of the program 
  # COMP_CWORD is an index of the COMP_WORDS array pointing to the word the curernt cursor is at
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"

  commands="build build_host_info build_requirements inspect list render sign ship help"
  template_arg_commands="build"
  
  # compgen generates completions filtered based on what has been typed by the user
  # what is happening here?(^| )$prev($| )

  if [[ $template_arg_commands =~ (^| )$prev($| ) ]] ; then
    if [[ -z "$_vanagon_avail_templates_projects" ]] ; then
      _vanagon_avail_templates_projects=$(vanagon list -r | sed 1d 2>/dev/null)
      COMPREPLY=( $(compgen -W "${_vanagon_avail_templates_projects}" -- "${cur}") )
    fi
  fi 
  # there has to be a better way to do this 
  if [[ ${#COMP_WORDS[@]} -gt 3 && ${COMP_WORDS[1]} == "build" && "$(vanagon list -r)" == *"$PREV"* ]] ; then 
    _vanagon_avail_templates_platforms=$(vanagon list -l | sed 1d 2>/dev/null)
    COMPREPLY=( $(compgen -W "${_vanagon_avail_templates_platforms}" -- "${cur}") )
  fi
  if [[ $1 == $prev ]] ; then
    # only show top level commands we are at root
    COMPREPLY=( $(compgen -W "${commands}" -- "${cur}") )
  fi
}

# complete with a function `_vanagon` for the commmand `vanagon`
complete -F _vanagon vanagon