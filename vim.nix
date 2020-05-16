{ pkgs, ... }:

let
  customPlugins.vim-better-whitespace = pkgs.vimUtils.buildVimPlugin {
    name = "vim-better-whitespace";
    src = pkgs.fetchFromGitHub {
      owner = "ntpeters";
      repo = "vim-better-whitespace";
      rev = "984c8da518799a6bfb8214e1acdcfd10f5f1eed7";
      sha256 = "10l01a8xaivz6n01x6hzfx7gd0igd0wcf9ril0sllqzbq7yx2bbk";
    };
  };
  customPlugins.vim-quick-tex = pkgs.vimUtils.buildVimPlugin {
    name = "vim-quick-tex";
    src = pkgs.fetchFromGitHub {
      owner = "brennier";
      repo = "quicktex";
      rev = "f10c77e01df9be647bc2cf3f430ec1506c08f730"; # "984c8da518799a6bfb8214e1acdcfd10f5f1eed7";
      sha256 = "0wxnvqs3j8j8xncpjqmvjvnr2lkivxxxvka02lv9bm1gs7lzym25"; # "10l01a8xaivz6n01x6hzfx7gd0igd0wcf9ril0sllqzbq7yx2bbk"; gotten by nix-prefetch-url --unpack https://github.com/brennier/quicktex/archive/f10c77e01df9be647bc2cf3f430ec1506c08f730.tar.gz
    };
  };

in {
   users.users.darclaw.packages = [
    (pkgs.vim_configurable.customize {
      name = "nvim";
      vimrcConfig.vam.knownPlugins = pkgs.vimPlugins // customPlugins;
      vimrcConfig.vam.pluginDictionaries = [ 
        { names = ["vim-better-whitespace" "vim-quick-tex" "deoplete-nvim" "rainbow" "vim-nix" "vimtex" "vim-grammarous"]; } ];
      vimrcConfig.customRC = ''
set shell=/bin/sh

set nu
set tabstop=3 shiftwidth=3 smartindent
set expandtab
set guicursor=
"set clipboard=unnamedplus
set undodir=$HOME/.config/nvim/undo
set undofile
set scrolloff=8
set timeoutlen=10 ttimeoutlen=0

set backspace=indent,eol,start

" set nocompatible
set showmode
"set tw=80
set smartcase
set smarttab
set smartindent
set autoindent
set softtabstop=3
"set incsearch
set mouse=a
"set history=1000
set clipboard=unnamedplus

"set completeopt=menuone,menu,longest

set wildignore+=*\\tmp\\*,*.swp,*.swo,*.zip,.git,.cabal-sandbox
"set wildmode=longest,list,full
"set wildmenu
"set completeopt+=longest

" set t_Co=256
 

      " Normal guibg=NONE ctermbg=NONE

" execute pathogen#infect()
syntax on
filetype plugin indent on

" au BufWritePost *.latex exec "AsyncRun pdflatex %"

" let g:deoplete#enable_at_startup = 1

let g:quicktex_tex = {
    \' '   : "\<ESC>:call search('<+.*+>')\<CR>\"_c/+>/e\<CR>",
    \'m'   : '\( <+++> \) <++>',
    \'prf' : "\\begin{proof}\<CR><+++>\<CR>\\end{proof}",
    \'align' : "\\begin{align*}\<CR><+++>\<CR>\\end{align*}",
    \'sl' : '\',
\}

let g:quicktex_latex = {
    \' '   : "\<ESC>:call search('<+.*+>')\<CR>\"_c/+>/e\<CR>",
    \'m'   : '\( <+++> \) <++>',
    \'prf' : "\\begin{proof}\<CR><+++>\<CR>\\end{proof}",
    \'align' : "\\begin{align*}\<CR><+++>\<CR>\\end{align*}",
    \'sl' : '\',
\}

let g:quicktex_math = {
    \' '    : "\<ESC>:call search('<+.*+>')\<CR>\"_c/+>/e\<CR>",
    \'real'   : '\mathcal{R} ',
    \'eq'   : '= ',
    \'set'  : '\{ <+++> \} <++>',
    \'fr' : '\frac{<+++>}{<++>} <++>',
    \'st'   : ': ',
    \'bn'   : '\mathbb{N} ',
    \'nrt' : '\sqrt[<+++>]{<++>} <++>',
    \'sqrt' : '\sqrt{<+++>} <++>',
    \'sl' : '\',
 \}

let g:rainbow_active = 1
 '';
    }) ];
}
