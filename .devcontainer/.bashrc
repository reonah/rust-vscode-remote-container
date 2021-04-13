# aws completion
complete -C aws_completer aws

#git completion
if [ -f /root/git-completion.bash -a -f /root/git-prompt.sh ]; then
  source /root/git-completion.bash
  GIT_PS1_SHOWDIRTYSTATE=1
  source /root/git-prompt.sh
  PS1='[\u@\h \W$(__git_ps1 " (%s)")]\$ '
fi

# \w カレントディレクトリ（フルパス）
# \e カラー変更： 32m green, 34m blue, 37m white
export PS1='\[\e[01;33m\]\w \[\e[01;36m\]$(__git_ps1 " (%s)") \[\e[01;37m\]\$ '

# rain_completion
if [ -f /root/rain_completion.sh ]; then
  source /root/rain_completion.sh
fi

#alias
alias rm='rm -i'
alias la='ls -a'
alias ll='ls -l'
alias c='clear'
alias mkdir='mkdir -p'

alias d='docker'
alias dc='docker container'
alias dcc='docker rm -f $(docker ps -q -a)'
alias di='docker image'
alias ds='docker system'
