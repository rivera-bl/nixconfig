-- o  = global
-- wo = local to window
-- bo = local to buffer

-- -- indentline
-- vim.opt.list = true
-- vim.opt.listchars:append("eol:↴")

-- cmp
vim.o.pumheight = 20 -- ammount of results

vim.g.loaded_netrw = 0
vim.g.loaded_netrwPlugin = 0

-- roote
vim.cmd("let g:rooter_patterns = ['.git']")
vim.cmd("let g:rooter_silent_chdir = 1")

-- vim-fugitive :GBrowse
vim.cmd([[ command! -nargs=1 Browse silent exec '!wsl-open "<args>"' ]])

-- copilot
vim.cmd[[imap <silent><script><expr> <C-Space> copilot#Accept("\<CR>")]]
vim.keymap.set('i', '<M-.>', '<Plug>(copilot-next)')
vim.g.copilot_no_tab_map = true
vim.g.copilot_assume_mapped = true
vim.g.copilot_filetypes = {
	["*"] = false,
	["lua"] = true,
	["rust"] = true,
	["go"] = true,
	["python"] = true,
	["sh"] = true,
  ["terraform"] = true,
  ["yaml"] = true,
  ["nix"] = true
}

vim.cmd('syntax on')
vim.cmd('filetype plugin on')
vim.cmd('set nofoldenable')
vim.cmd('set noswapfile')
vim.cmd('set autochdir')

vim.g.shell         = 'zsh'
vim.o.clipboard     = 'unnamedplus'
vim.o.mouse         = 'a'
vim.o.wildmode      = 'longest:full,full'     -- shell autocompletion
vim.o.hidden        = true
vim.o.termguicolors = true
vim.wo.signcolumn   = "number"

-- the two bellow highlight the current line number
vim.wo.number       = true 		      -- shows linenumbers
vim.wo.rnu          = true 	        -- shows linenumbers and relative

vim.o.scrolloff     = 15
vim.o.showmode      = false
vim.o.ruler         = false
vim.wo.cursorline   = true

vim.o.splitright    = true
vim.o.splitbelow    = true
vim.o.gdefault      = true		      -- by default match every ocurrence in a line

vim.o.autoread      = true          -- reload if file has been changed outside of ivm
vim.bo.smartindent  = true
vim.wo.breakindent  = true          -- continue indenting on next line
vim.wo.linebreak    = true          -- break a line by word not by character
vim.opt.expandtab   = true          -- converts tabs to spaces
vim.opt.tabstop     = 2             -- insert 2 spaces for a tab
vim.opt.shiftwidth  = 2             -- number of space characters for tabs
vim.opt.softtabstop = -1            -- treat tabs as tabs and not spaces when editing

-- Hides tilde chars on endofbuffer
vim.cmd("set fillchars=fold:\\ ,vert:\\│,eob:\\ ,msgsep:‾")

-- Set versplit separator to the same color of the background
vim.cmd("hi VertSplit guifg=#1d2225 guibg=#1d2225")

vim.cmd('hi CursorLine guibg=#252e33')

-- Maintain same size of splits when resizing the window
-- Not so useful when resizing a vim window with 2 splits in tmux with 2 vertical panes
-- vim.cmd('autocmd VimResized * wincmd =')

-- Shows cursorline only in focused window
vim.cmd([[
  augroup CursorLine
      au!
      au VimEnter * setlocal cursorline
      au WinEnter * setlocal cursorline
      au BufWinEnter * setlocal cursorline
      au WinLeave * setlocal nocursorline
  augroup END
]])

-----------------------
--- BUFSURF
-----------------------
vim.g['BufSurfIgnore'] = 'NetrwTreeListing,NetrwTreeListing[-]'

-----------------------
--- LAZYGIT
-----------------------
vim.g['lazygit_floating_window_scaling_factor'] = 1.0

-----------------------
--- NETRW
-----------------------
vim.g["netrw_preview"]       = 1
vim.g["netrw_liststyle"]     = 3
vim.g["netrw_banner"]        = 0
vim.g["netrw_winsize"]       = 15

-----------------------
--- TERRAFORM
-----------------------
vim.g["terraform_fmt_on_save"]  = 0
vim.g["terraform_align"]        = 1

-----------------------
--- ZEAVIM
-----------------------
vim.g["zv_get_docset_by"] = "['ext', 'file', 'ft']"
vim.g["_file_types"] = [[{
            \   'tf'                : 'terraform',
            \   'pkr.hcl'           : 'packer',
            \   'yml'               : 'kubernetes,ansible',
            \   'yaml'              : 'kubernetes,ansible',
            \   'tex'               : 'latex',
            \   'Vagrantfile'       : 'vagrant'
            \ }]]

-----------------------
--- MARKDOWN
-----------------------
vim.g["m_markdown_folding_disabled"] = 1

-----------------------
--- VIMUX
-----------------------
vim.g["VimuxHeight"]      = "20"
vim.g["VimuxOrientation"] = "v"
vim.g["VimuxUseNearest"]  = 1
vim.g["VimuxCloseOnExit"] = 0

-- TODO move to other file
-- yanks to tmux buffer
-- taken from https://github.com/roxma/vim-tmux-clipboard
vim.cmd([[
func! s:TmuxBufferName()
    let l:list = systemlist('tmux list-buffers -F"#{buffer_name}"')
    if len(l:list)==0
        return ""
    else
        return l:list[0]
    endif
endfunc

func! s:TmuxBuffer()
    return system('tmux show-buffer')
endfunc

func! s:Enable()

    if $TMUX=='' 
        " not in tmux session
        return
    endif

    let s:lastbname=""

    " if support TextYankPost
    if exists('##TextYankPost')==1
        " @"
        augroup vimtmuxclipboard
            autocmd!
            autocmd FocusLost * call s:update_from_tmux()
            autocmd	FocusGained   * call s:update_from_tmux()
            autocmd TextYankPost * silent! call system('tmux loadb -',join(v:event["regcontents"],"\n"))
        augroup END
        let @" = s:TmuxBuffer()
    else
        " vim doesn't support TextYankPost event
        " This is a workaround for vim
        augroup vimtmuxclipboard
            autocmd!
            autocmd FocusLost     *  silent! call system('tmux loadb -',@")
            autocmd	FocusGained   *  let @" = s:TmuxBuffer()
        augroup END
        let @" = s:TmuxBuffer()
    endif

endfunc

func! s:update_from_tmux()
    let buffer_name = s:TmuxBufferName()
    if s:lastbname != buffer_name
        let @" = s:TmuxBuffer()
    endif
    let s:lastbname=s:TmuxBufferName()
endfunc

call s:Enable()
]])
