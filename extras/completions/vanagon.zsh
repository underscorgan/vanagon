_vanagon()
{
    # current shell word in zsh is "$1"
  local line commands template_arg_commands 

  commands="build build_host_info build_requirements completion inspect list render sign ship help"
  template_arg_commands=("build" "build_host_info" "build_requirements" "inspect"  "render")

  # arguments function provides potential completions to zsh 
  # -C flag inspects completion state and gives context specific completions
  # specs are of the form n:message:action 
  # two colons means the message argument is optional 
  # if the message contains a space, nothing will be pritned
  _arguments -C \
    "1: :(${commands})" \
    "*::arg:->args" 
  
  # (Ie)prevents "invalid subscript"
  if ((template_arg_commands[(Ie)$line[1]])); then
    _vanagon_template_sub_projects
    _vanagon_template_sub_platforms
  fi
}

_vanagon_template_sub_projects()
{
  if [[ -z "$_vanagon_avail_projects" ]] ; then
    # 2>/dev/null redirects errors to /dev/null
    _vanagon_avail_projects=$(vanagon list -r | sed 1d 2>/dev/null)
  fi

  _arguments "1: :(${_vanagon_avail_projects})"
}

_vanagon_template_sub_platforms()
{
  # num determiens the value of the nth normal argument.
  # This ensures that the nth normal argument will repeatedly be 
  # complted with platform names.
  num=$((${#line[@]}-1))
  if [[ -z "$_vanagon_avail_platforms" && $num -gt 1 ]] ; then
    _vanagon_avail_platforms=$(vanagon list -l | sed 1d 2>/dev/null)
  fi
  
  _arguments "$num: :(${_vanagon_avail_platforms})"
}

# compdef registeres the completion function: compdef <function-name> <program>
compdef _vanagon vanagon
