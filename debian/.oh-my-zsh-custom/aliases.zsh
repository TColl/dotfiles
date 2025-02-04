ZSHRCFILE="$HOME/.zshrc"
ZSHALIASES="$ZSHCUSTOM/aliases.zsh"
ZSHFUNCTIONS="$ZSHCUSTOM/functions.zsh"

# meta
alias ezalias='nano $ZSHALIASES && source $ZSHALIASES && echo aliases updated'
alias ezfunc='nano $ZSHFUNCTIONS && source $ZSHFUNCTIONS && echo zshfunctions updated'
alias ezshrc='nano $ZSHRCFILE && source $ZSHRCFILE && echo zshrc updated'

# git
alias gpup='git pull --prune'
alias gcm='git commit -m'
alias gcam='git commit -am'
alias nvgcam='git commit --no-verify -am'
alias gpuo='git push -u origin'
alias gsm="git switch main"
alias gsc='git switch -c'
alias gsd="git switch dev"
alias gst='git switch test'
alias gsdpup='gsd && gpup'
alias gs-="git switch -"
alias grbm='git rebase --committer-date-is-author-date main'
alias grbt='gsm && gpup && gbD test && gst && gpup && grbm && gp --force-with-lease'

# docker
alias rmdockerimages='docker image rm -f $(docker images -q | cut -d " " -f1) || echo "nothing to delete"'

# terragrunt
alias tg='terragrunt'
alias tgra='terragrunt run-all'

# sudo
alias pls='please'
alias plz='please'
