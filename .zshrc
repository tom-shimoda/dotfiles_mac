########################
# Locale
########################
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

ZSH_DISABLE_COMPFIX=true

########################
# zsh起動時にtmuxも自動起動
########################
[[ -z "$TMUX" && ! -z "$PS1" && -t 0 ]] && { tmux a || tmux new-session; exit }

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
# .zshrcの分割 (分割ファイルは~/.zsh/*.zsh)
# 参考元: https://original-game.com/how-to-manage-zshrc-separately/
########################
ZSH_DIR="${HOME}/.zsh"
# .zshがディレクトリで、読み取り、実行、が可能なとき
if [ -d $ZSH_DIR ] && [ -r $ZSH_DIR ] && [ -x $ZSH_DIR ]; then
    # zshディレクトリより下にある、.zshファイルの分、繰り返す
    for file in ${ZSH_DIR}/**/*.zsh; do
        # 読み取り可能ならば実行する
        [ -r $file ] && source $file
    done
fi

########################
# alias
########################
alias ll='ls -alFh'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias here='open .'
alias py='python3'
alias python='python3'
alias gitg='git log --graph --oneline --decorate=full --date=short --format="%C(yellow)%h%C(reset) %C(magenta)[%ad]%C(reset)%C(auto)%d%C(reset) %s %C(cyan)@%an%C(reset)" $args'
alias sail='[ -f sail  ] && sh sail || sh vendor/bin/sail'
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
# function convVideoToGif {
#     # input: mov,mp4等
#     # -vf scale: <横幅pixel : -1 (-1でアス比を保つ)>
#     # -r: フレームレート
#     ffmpeg -i $1 -vf scale=800:-1 -r 30 output.gif
# }
function convVideoToGif {
    local input="$1" # $1 = 入力ファイル
    local width="${2:-800}" # $2 = 横幅 (省略時 800)
    local framerate="${3:-30}" # $3 = フレームレート (省略時 30)
    if [ -z "$input" ]; then
        echo "Usage: convVideoToGif <inputfile> [width] [framerate]"
        return 1
    fi

    ffmpeg -i "$input" -vf "scale=${width}:-1" -r "$framerate" output.gif
}
function heic_to_png {
    input="$1"
    # 拡張子を除いたファイル名を取得（パスなし）
    filename_without_ext="${input%.*}"
    # ImageMagickによる変換
    magick "$input" "${filename_without_ext}.png"
}
function heic_to_png_all() {
    # カレントディレクトリの HEIC を全部処理
    setopt local_options null_glob no_case_glob  # *.heic 無い時の安全 & 大文字拡張子対応
    for file in *.heic; do
        [[ -f $file ]] || continue
        print -P "%F{green}▶︎ 変換中:%f $file"
        heic_to_png "$file"
    done
    print -P "%F{magenta}✓ すべて完了%f"
}
function heic_to_jpg {
    input="$1"
    # 拡張子を除いたファイル名を取得（パスなし）
    filename_without_ext="${input%.*}"
    # ImageMagickによる変換
    magick "$input" "${filename_without_ext}.jpg"
}
function heic_to_jpg_all() {
    # カレントディレクトリの HEIC を全部処理
    setopt local_options null_glob no_case_glob

    for file in *.heic; do
        [[ -f $file ]] || continue
        print -P "%F{green}▶︎ 変換中:%f $file"
        heic_to_jpg "$file"
    done

    print -P "%F{magenta}✓ すべて完了%f"
}
function png_to_jpg() {
    input="$1"

    # 拡張子を除いたファイル名を取得
    filename_without_ext="${input%.*}"

    # ImageMagickによる変換
    magick "$input" "${filename_without_ext}.jpg"
}
function png_to_jpg_all() {
    # カレントディレクトリの PNG を全部処理
    setopt local_options null_glob no_case_glob

    for file in *.png; do
        [[ -f $file ]] || continue
        print -P "%F{green}▶︎ 変換中:%f $file"
        png_to_jpg "$file"
    done

    print -P "%F{magenta}✓ すべて完了%f"
}
# 第2引数に1~99でクオリティを指定 (数値が大きいほど高品質、容量大)
function sizedown_jpg {
    input="$1"
    # 拡張子を除いたファイル名を取得（パスなし）
    filename_without_ext="${input%.*}"
    # ImageMagickによる変換
    magick "$input" -quality $2 "${filename_without_ext}.jpg"
}
# mkdir -p && touch (途中のフォルダがなければ生成)
tp() {
  mkdir -p "$(dirname "$1")" && touch "$1"
}

########################
# PATH
########################
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"
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
# 履歴設定（tmux全paneで共有）
########################
HISTFILE=$HOME/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt SHARE_HISTORY       # 全paneでリアルタイム共有
setopt HIST_IGNORE_DUPS    # 連続重複コマンドを保存しない
setopt HIST_REDUCE_BLANKS  # 余分なスペースを除去して保存


########################
# Added by Zinit's installer (Zinitインストールで自動追加されたもの)
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
ZINIT[COMPINIT_OPTS]=-u

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
### 補完（24時間ごとにのみフル再生成、それ以外はキャッシュ使用）
autoload -Uz compinit
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
    compinit
else
    compinit -C
fi
zinit cdreplay -q
zstyle ':completion:*:default' menu select=1 # 補完候補を一覧表示したとき、Tabや矢印で選択できるようにする
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' # 小文字でも大文字ディレクトリ、ファイルを補完できるようにする

########################
# fzf
########################
# export FZF_CTRL_T_COMMAND='rg --files --hidden --follow --glob "!.git/*"' # --followはシンボリックを含める
export FZF_CTRL_T_COMMAND='rg --files --hidden --glob "!.git/*"'
export FZF_CTRL_T_OPTS='--preview "bat --color=always --style=header,grid --line-range :100 {}"'

########################
# Powerlevel10kにより自動生成
########################
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Created by `pipx` on 2024-04-10 08:57:15
export PATH="$PATH:/Users/owner/.local/bin"
