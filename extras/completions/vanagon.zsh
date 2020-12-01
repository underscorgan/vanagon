_vanagon()
{
  local line commands template_arg_commands 

  commands="build build_host_info build_requirements inspect list render sign ship help"
  template_arg_commands=("build")

  # arguments function provides potential completions to zsh 
  # -C flag inspects completion state and gives context specific completions
  # specs are of the form n:message:action 
  # two colons means the message argument is optional 
  # if the message contains a space, nothing will be pritned
  # first normal argument = position after the end of the options
  _arguments -C \
    "1: :(${commands})" \
    "*::arg:->args" 
  
  # if ((template_arg_commands[(Ie)$line[1]])); then <- what is the Ie there?
  # prevents "invalid subscript"
  if ((template_arg_commands[(Ie)$line[1]])); then
    _vanagon_template_sub_projects
    _vanagon_template_sub_platforms
  fi
}

_vanagon_template_sub_projects()
{
  # how is it checking vanagon_avil_templates if it hasn't been defined yet?
  if [[ -z "$_vanagon_avail_templates" ]] ; then
    _vanagon_avail_templates=$(vanagon list -r 2>/dev/null)
  fi

  _arguments "1: :(${_vanagon_avail_templates})"
}

_vanagon_template_sub_platforms()
{
  if [[ -z "$_vanagon_avail_platforms" ]] ; then
    _vanagon_avail_platforms=$(vanagon list -l 2>/dev/null)
  fi

  _arguments "2: :(${_vanagon_avail_platforms})"
}

# compdef registeres the completion function: compdef <function-name> <program>
compdef _vanagon vanagon
