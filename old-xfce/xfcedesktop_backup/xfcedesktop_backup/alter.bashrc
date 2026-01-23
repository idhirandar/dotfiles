###### enable bash completion in interactive shells
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
#
alias usage='du -sk * | sort -n | perl -ne '\''($s,$f)=split(m{\t});for (qw(K M G)) {if($s<1024) {printf("%.1f",$s);print "$_\t$f"; last};$s=$s/1024}'\'
alias ls="ls --color"
#
############################# CUSTOM ALIAS ########################
alias v="vim"
alias pleas_update="sudo apt update"
alias pleas_upgrade="sudo apt upgrade"
alias ll="ls -alZ"
#alias vim="vim -S ~/.vimrc"
#alias v="vim -S ~/.vimrc"
alias df="df -Th"
alias ls="ls --size --human-readable --color"
[ -f ~/.fzf.bash ] && source ~/.fzf.bash


############################ CUSTOM PS1 [ BASH PROMPTS ] ##########

#PS1="\e[36;32m\@:[$(tput sgr0)\]\W]👽️|~ "                #------------------------------------ best PROMPTS

#PS1="\e[36;32m\@:[$(tput sgr0)\]"

#PS1="\e[0;32m[\W]\$ \e[m "

#PS1='\[\033[35;1m\]\u\[\033[0m\]@\[\033[31;1m\]\h \[\033[32;1m\]$PWD\[\033[0m\] [\[\033[35m\]****\W\[\033[0m\]]\[\033[31m\]\$\[\033[0m\] '
PS1='[\[\033[36m\]\W\[\033[0m\]]\[\033[32m\]:>>\[\033[0m\] '

#PS1="\e[36;36m\@: [\W] [$(tput sgr0)\]⚡]~ "             #------------------------------------ PROMPTS with 2 block
#PS1="\e[30;48;5;32m \h \e[0;38;5;82m \@ \e[82m:~ "       #------------------------------------ blue+green

#======================================================#
##          this alias for bakup dotfiles             ##
#======================================================#
alias config='/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'

#=============================================================================================================
#if [ "`id -u`" -eq 0 ]; then
#PS1="\[\033[m\]|\[\033[1;35m\]\t\[\033[m\]|\[\e[1;31m\]\u\[\e[1;36m\]\[\033[m\]@\[\e[1;36m\]\h\[\033[m\]:\[\e[0m\]\[\e[1;32m\][\W]> \[\e[0m\]"
#    else
#PS1="\[\033[m\]|\[\033[1;35m\]\t\[\033[m\]|\[\e[1m\]\u\[\e[1;36m\]\[\033[m\]@\[\e[1;36m\]\h\[\033[m\]:\[\e[0m\]\[\e[1;32m\][\W]> \[\e[0m\]"
#fi
##i======================================================= multi color PROMPTS

#for i in {16..21} {21..16} ; do echo -en "\e[48;5;${i}m \e[0m" ; done ; echo #======color bar on PROMPTS start 
#echo -e "\e[40;38;5;82m Hello \e[30;48;5;82m World \e[0m"                     # ===== Hello World when PROMPTS start
#PS1="\e[30;48;5;82m \h \e[0;38;5;82m \@ \e[82m:~ "                             # ======== green thinkpad with time
#PS1='\e[033;01;32m \h \e[033;01;32m \@'                                 #------green thinkpad without background
#PS1="\e[30;48;5;32m \h \e[0;38;5;82m \@ \e[82m:~ "                      #------------blue+green thinkpad
##45m is a nice color

#PS1="\e[30;48;5;45m \w \e[0;38;5;071m \@ \e[071m🎅 \#:~ "

source /etc/profile.d/bash_completion.sh
export TERM="xterm-256color" # This sets up colors properly
