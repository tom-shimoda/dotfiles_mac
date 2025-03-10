########################
# zsh起動時にtmuxも自動起動
########################
[[ -z "$TMUX" && ! -z "$PS1" ]] && tmux a

# paneのタイトル部分のリロード用 (.tmux-pane-border追加時に追加)
function precmd() {
  if [ ! -z $TMUX ]; then
    tmux refresh-client -S
  fi
}

########################
# Powerlevel10kにより自動生成
########################
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

########################
# alias
########################
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ll='ls -alFh'
alias here='open .'
alias py='python3'
alias python='python3'
alias gitg='git log --graph --oneline --decorate=full --date=short --format="%C(yellow)%h%C(reset) %C(magenta)[%ad]%C(reset)%C(auto)%d%C(reset) %s %C(cyan)@%an%C(reset)" $args'
alias zengit='zengit .'

# 48463=IPA CyberLab 400G (Tokyo) がアクセス不可になったためCO
# サーバー一覧は`speedtest -L`で表示できる。詳しくは`speedtest -h`で。
# alias speedtest='speedtest -s 48463'

# フォルダサイズを取得
function sz(){
    if [ $# -eq 0 ]; then
        ## 方法1
        # setopt local no_nomatch  # マッチしない場合にエラーを無視
        # du -shx . .[^.]* *

        ## 方法2
        # du -shx . $(find . -mindepth 1 -maxdepth 1 -name '.*' ! -name '.' ! -name '..') *

        ## 方法3
        # *(D): zsh の拡張グロブ。D オプションは隠しファイル（. で始まるファイル）も対象に含めます。
        du -shx . *(D)
    else
        du -shx $1
    fi
}

function youtubeDL_Movie() {
    # yt-dlpはpipxでインストールした
    yt-dlp $1 -i -f bestvideo+bestaudio/best -o "~/Documents/YouTube/Movie/%(title)s - %(channel)s.%(ext)s" --add-metadata --embed-thumbnail --merge-output-format mp4 -N 10
}
function compVideo1280 {
    ffmpeg -i $1 -c:a libopus -c:v libx265 -crf 31 -r 29.97 -tag:v hvc1 -vf scale=1280:720 output.mp4
}
function compVideoFull {
    ffmpeg -i $1 -c:a libopus -c:v libx265 -crf 31 -r 29.97 -tag:v hvc1 output.mp4
}
function extractMusicFromVideo {
    ffmpeg -i $1 -vn -acodec mp3 ${1%.*}.mp3
}
function mp3_to_wav {
    ffmpeg -i $1 -vn -ac 2 -ar 44100 -acodec pcm_s16le -f wav ${1%.*}.wav
}

########################
# PATH
########################
# Blender
export PATH="$PATH:/Applications/Blender.app/Contents/MacOS/"
# ggrepをgrepとして使いたい (ggrepは`brew install grep`でインストールできる)
# gnu系をデフォルト名で使いたい場合はbrew info grep等で何をPATHに追加すればいいか教えてくれる
export PATH="/opt/homebrew/opt/grep/libexec/gnubin:$PATH"
# Zengit
export PATH="$PATH:/Applications/zengit.app/Contents/MacOS/"


########################
# cd移動時に自動でllする
########################
chpwd() {
    if [[ $(pwd) != $HOME ]]; then
        ll
    fi
}

# cdを省略
setopt auto_cd

########################
# nvmインストール時に自動で追加されたもの
########################
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

########################
# pyenv (https://www.imamura.biz/blog/32400)
########################
# あまりpythonのバージョンを切り替える必要がなくなったのでCO
# brewでpythonを直インストールする形に変更した
# eval "$(pyenv init --path)"

########################
# Added by Zinit's installer
########################
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk

########################
# Load Plugins
########################
### Load pure theme
# zinit ice pick"async.zsh" src"pure.zsh" # with zsh-async library that is bundled with it.
# zinit light sindresorhus/pure
# zstyle :prompt:pure:git:stash show yes # turn on git stash status

zinit ice wait'!0'; zinit load zsh-users/zsh-syntax-highlighting # 実行可能なコマンドに色付け
zinit ice wait'!0'; zinit load zsh-users/zsh-completions # 補完
zinit ice wait'!0'; zinit load chrissicool/zsh-256color # 256色使えるようにする
zinit ice wait'!0'; zinit load zsh-users/zsh-autosuggestions # 過去の入力履歴を検索しサジェストを表示
zinit ice depth=1; zinit light romkatv/powerlevel10k # theme編集ソフト
zinit ice wait'!0'; zinit light Aloxaf/fzf-tab # 補完選択メニューをfzfに置き換え

########################
# autoload
########################
### 補完
autoload -Uz compinit && compinit
zstyle ':completion:*:default' menu select=1 # 補完候補を一覧表示したとき、Tabや矢印で選択できるようにする
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' # 小文字でも大文字ディレクトリ、ファイルを補完できるようにする

########################
# bookmarks
#
# 登録方法:
# ~/.bookmarksへ移動し、"ln -s 登録/したい/フォルダ/パス/ @登録したい名前"
# 使い方:
# goto @<tab> であらかじめ登録したものを選ぶだけ
########################
if [ -d "$HOME/.bookmarks" ]; then
    export CDPATH=".:$HOME/.bookmarks:/"
    alias goto="cd -P"
fi

########################
# fzf
########################
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# export FZF_CTRL_T_COMMAND='rg --files --hidden --follow --glob "!.git/*"' # --followはシンボリックを含める
export FZF_CTRL_T_COMMAND='rg --files --hidden --glob "!.git/*"'
export FZF_CTRL_T_OPTS='--preview "bat  --color=always --style=header,grid --line-range :100 {}"'

########################
# Powerlevel10kにより自動生成
########################
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


# Created by `pipx` on 2024-04-10 08:57:15
export PATH="$PATH:/Users/owner/.local/bin"
