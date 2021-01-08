###### enable bash completion in interactive shells
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

alias usage='du -sk * | sort -n | perl -ne '\''($s,$f)=split(m{\t});for (qw(K M G)) {if($s<1024) {printf("%.1f",$s);print "$_\t$f"; last};$s=$s/1024}'\'
alias ls="ls --color"
#
###### Powerline
#if [ -f /usr/share/powerline/bindings/bash/powerline.sh ]; then
#    source /usr/share/powerline/bindings/bash/powerline.sh
#fi
#
# Linux Lite Custom Terminal
#LLVER=$(awk '{print}' /etc/llver)
#echo -e "Welcome to $LLVER ${USER}"
#echo " "
#date "+%A %d %B %Y, %T"
#free -m | awk 'NR==2{printf "Memory Usage: %s/%sMB (%.2f%%)\n", $3,$2,$3*100/$2 }'
#df -h | awk '$NF=="/"{printf "Disk Usage: %d/%dGB (%s)\n", $3,$2,$5}'
#echo "Support - https://www.linuxliteos.com/forums/ (Right click, Open Link)"
#echo " "


############################# CUSTOM ALIAS ########################
alias pleas_update="sudo apt update"
alias pleas_upgrade="sudo apt upgrade"
alias ll="ls -alZ"
#alias vim="vim -S ~/.vimrc"
#alias v="vim -S ~/.vimrc"
#alias df="df -Th"
alias ls="ls --size --human-readable --color"
[ -f ~/.fzf.bash ] && source ~/.fzf.bash


############################ CUSTOM PS1 [ BASH PROMPTS ] ##########

PS1="\e[36;32m\@:[$(tput sgr0)\]\W]⚡|~ "                #------------------------------------ best PROMPTS


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
