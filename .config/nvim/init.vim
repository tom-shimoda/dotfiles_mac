if &compatible
    set nocompatible
endif

" ----- dein.vim -----

" dein.vimインストール時に指定したディレクトリをセット
let s:dein_dir = expand('~/.cache/dein')

" dein.vimの実体があるディレクトリをセット
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

" dein.vimが存在していない場合はgithubからclone
if &runtimepath !~# '/dein.vim'
    if !isdirectory(s:dein_repo_dir)
        execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
    endif
    execute 'set runtimepath+=' . fnamemodify(s:dein_repo_dir, ':p')
endif

if dein#load_state(s:dein_dir)
    call dein#begin(s:dein_dir)

    " dein.toml, dein_layz.tomlファイルのディレクトリをセット
    let s:toml_dir = expand('~/.config/nvim')

    " 起動時に読み込むプラグイン群
    call dein#load_toml(s:toml_dir . '/dein.toml', {'lazy': 0})

    " 遅延読み込みしたいプラグイン群
    call dein#load_toml(s:toml_dir . '/dein_lazy.toml', {'lazy': 1})

    " --- plugins
    call dein#add('luochen1990/rainbow')

    call dein#end()
    call dein#save_state()
endif

filetype plugin indent on
syntax enable

" If you want to install not installed plugins on startup.
if dein#check_install()
    call dein#install()
endif

" アンインストール時に使う(:call dein#recache_runtimepath())
call map(dein#check_clean(), "delete(v:val, 'rf')")

" ----- dein.vim END -----

"swpファイル出力無効
set noswapfile
"バックアップファイル出力無効
set nobackup
"undoファイル出力無効
set noundofile
"1行の最大文字数ボーダーライン表示
set colorcolumn=120
"更新時間
set updatetime=300

" ポップアップ半透明設定
set termguicolors
"set pumblend=10
"set winblend=10

"検索時大文字小文字を区別しない
set ignorecase
"検索文字列に大文字が含まれる場合は区別する
set smartcase
"行数表示
set number
"画面端で行を折り返さない
set nowrap
"マウスを有効化
set mouse=a

" --- Tab settings
"タブ文字数
set tabstop=4
"改行時や、'>>, <<' インデント増減時のスペース文字数
set shiftwidth=4
"タブをスペースで埋める
set expandtab
"シフトしたときに、shiftwidthの値の倍数になるようにスペースを挿入する
set shiftround
"保存せずにバッファを切り替える際の警告を出さない
set hidden
"折り畳みは手動で行う
"set foldmethod=manual

"補完時に表示されるプレビューウィンドウを消す
set completeopt=menuone

" カーソル行をハイライト
set cursorline

" 不可視文字を可視化
set listchars=eol:↩,tab:»-,trail:_
set list

" 改行時の自動コメント化をしない
autocmd BufNewFile,BufRead * setlocal formatoptions-=c
autocmd BufNewFile,BufRead * setlocal formatoptions-=r
autocmd BufNewFile,BufRead * setlocal formatoptions-=o

"pythonパス設定
"let g:python_host_prog = $HOME . '/.pyenv/versions/neovim2/bin/python'
let g:python3_host_prog = '/usr/bin/python3'

"vimrcの再読込
nnoremap <Space>g :source ~/.config/nvim/init.vim<CR>
"space割り当て解除 (誤爆を防ぐため)
nnoremap <Space> <Nop>
"tmuxで利用するので無効化
nnoremap <C-q> <Nop>
"3行飛び上下移動
noremap <S-j> jjj
noremap <S-k> jjj
noremap <C-j> kkk
noremap <C-k> kkk
"行頭文字に移動
noremap <Space>h ^
"行末移動
noremap <Space>l $
"カーソル下のシンボルをリネーム
nnoremap <Space>r *N:%s//

"行番号移動
nnoremap <Space><Enter> G
"カーソル下のシンボルをコピー
nnoremap <Space>y wbvey
"カーソル下のシンボルをカット
nnoremap <Space>c wbvec
"行の連結
noremap <Space>j gJ
"前回のカーソル位置に戻る
nnoremap <Space>b <C-o>zz
"前回のカーソル位置に進む
nnoremap <Space>n <C-i>zz
"現在のバッファを閉じる
nnoremap <leader>x :bp<cr>:bd #<cr>
"ハイライト切替
nnoremap <F1> :noh<cr>
"現在のファイルをエクスプローラーで開く
nnoremap <F12> :!open .<cr>
"システムクリップボードにコピー
noremap <C-c> "*yy
"ウィンドウフォーカスの移動
nnoremap <C-h> <C-w>W
nnoremap <C-l> <C-w>w
"v0.6.0より'Y'が'y$'に変更されたため再マッピング
nnoremap Y yy

" --- rainbow
let g:rainbow_active = 1
autocmd VimEnter * RainbowToggle

" コメント中の特定の単語を強調表示する
augroup HilightsForce
    autocmd!
    autocmd WinEnter,BufRead,BufNew,Syntax * :silent! call matchadd('Todo', '\(TODO\|NOTE\|INFO\|XXX\|TEMP\):')
    autocmd WinEnter,BufRead,BufNew,Syntax * highlight Todo guibg=Red guifg=White
augroup END

" .h <-> .cpp
nnoremap <Space>t :call ToggleBetweenHeaderAndSource()<cr>
function! ToggleBetweenHeaderAndSource() abort
    " let l:gitPath = system("git rev-parse --show-toplevel")
    " echo gitPath

    let l:ext = expand("%:e")
    if ext == "cpp"
        let l:filename = expand("%:r") . ".h"
        execute 'find ' . filename
    elseif ext == "h"
        let l:filename = expand("%:r") . ".cpp"
        execute 'find ' . filename
    endif
endfunction

" encode utf-8 lf
function! ToUtf8() abort
    execute 'e ++enc=shift-jis'
    execute 'set fenc=utf-8'
    silent write
endfunction
command! ToUtf8 :call ToUtf8()
function! ToLf() abort
    execute 'e ++ff=unix'
    execute '%s///g'
    silent write
endfunction
command! ToLf :call ToLf()
function! ToUtf8Lf() abort
    call ToUtf8()
    call ToLf()
endfunction
command! ToUtf8Lf :call ToUtf8Lf()

" スムーズなスクロール (参考: https://zenn.dev/matsui54/articles/2021-03-17-smooth-scroll)
let s:stop_time = 10

function! s:down(timer) abort
  execute "normal! 3\<C-e>3j"
endfunction

function! s:up(timer) abort
  execute "normal! 3\<C-y>3k"
endfunction

function! s:smooth_scroll(fn) abort
  let working_timer = get(s:, 'smooth_scroll_timer', 0)
  if !empty(timer_info(working_timer))
    call timer_stop(working_timer)
  endif
  if (a:fn ==# 'down' && line('$') == line('w$')) ||
        \ (a:fn ==# 'up' && line('w0') == 1)
    return
  endif
  let s:smooth_scroll_timer = timer_start(s:stop_time, function('s:' . a:fn), {'repeat' : &scroll/3})
endfunction

nnoremap <silent> <C-u> <cmd>call <SID>smooth_scroll('up')<CR>
nnoremap <silent> <C-d> <cmd>call <SID>smooth_scroll('down')<CR>
vnoremap <silent> <C-u> <cmd>call <SID>smooth_scroll('up')<CR>
vnoremap <silent> <C-d> <cmd>call <SID>smooth_scroll('down')<CR>

" yank内容をクリップボードへ
set clipboard=unnamed
