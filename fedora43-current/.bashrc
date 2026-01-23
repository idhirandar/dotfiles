# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc
############################################################
alias paplilabs-ssh='ssh -o "ProxyCommand=ssh -i ~/Documents/obsidian-knowledgevault/04-Files-Backup/ssh-key-bakcup/paplilabs-sshkey/id_rsa -W %h:%p jumpuser@103.104.73.225" -i ~/Documents/obsidian-knowledgevault/04-Files-Backup/ssh-key-bakcup/paplilabs-sshkey/id_rsa devops@172.25.250.225'
############################################################

#gemini() {
#    cd ~/gemini-cli-container || return 1
#
#    # If no arguments → interactive chat (-it)
#    if [ $# -eq 0 ]; then
#        podman run -it --rm \
#          -v "$PWD":/app:Z \
#          -v "$HOME/.gemini:/root/.gemini:Z" \
#          -v "$PWD/settings.json:/app/settings.json:Z" \
#          -e GEMINI_DISABLE_UPDATE_CHECK=1 \
#          -e GEMINI_DISABLE_KEYTAR=1 \
#          -w /app \
#          --security-opt label=disable \
#          localhost/gemini-cli:latest
#    else
#        # If arguments → one-shot with --
#        podman run --rm \
#          -v "$PWD":/app:Z \
#          -v "$HOME/.gemini:/root/.gemini:Z" \
#          -v "$PWD/settings.json:/app/settings.json:Z" \
#          -e GEMINI_DISABLE_UPDATE_CHECK=1 \
#          -e GEMINI_DISABLE_KEYTAR=1 \
#          -w /app \
#          --security-opt label=disable \
#          localhost/gemini-cli:latest -- "$@"
#    fi
#}

######################################################################################## below i the acctual working command 
# podman run -it --rm   --userns=keep-id   -v "$PWD:/app:z"   -v "$HOME/.gemini:/home/gemini/.gemini:z"   -e GEMINI_DISABLE_UPDATE_CHECK=1   -e GEMINI_API_KEY="$(cat "$PWD/api-key")"   gemini-cli
# ##########################################################

gemini() {
  # Must have api-key in current folder
  [[ -f "$PWD/api-key" ]] || { echo "Error: api-key not found in $(pwd)"; return 1; }

  local image="localhost/gemini-cli:latest"
  local cmd=(podman run --rm)
  [[ -t 1 ]] && cmd+=(-it)  # interactive only if terminal

  "${cmd[@]}" \
    --userns=keep-id \
    -v "$PWD:/app:z" \
    -v "$HOME/.gemini:/home/gemini/.gemini:z" \
    -e GEMINI_DISABLE_UPDATE_CHECK=1 \
    -e GEMINI_API_KEY="$(cat "$PWD/api-key")" \
    -w /app \
    "$image" ${@:+-- "$@"}  # pass args only if any
}
############################################################

alias debtest='
  podman stop debian-test >/dev/null 2>&1 || true;
  podman rm debian-test >/dev/null 2>&1 || true;
  podman run -d --name debian-test --replace --systemd=always -p 2222:22 debian-test-ssh &&
  echo "✅ Debian 13 test container started!" &&
  echo "   SSH in with: ssh tester@localhost -p 2222   (password: tester)" ||
  echo "❌ Failed to start container – check podman images/logs"
'
