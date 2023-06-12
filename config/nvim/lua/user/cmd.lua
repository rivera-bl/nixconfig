function AutoSave()
  local result = vim.fn.system('git rev-parse --is-inside-work-tree')
  if result == "true\n" then
    vim.cmd("silent! write")
  end
end
vim.cmd("autocmd InsertLeave,BufLeave * lua AutoSave()")

-- Save the 'wd path' to clipboard
vim.cmd("command! Dcp redir @+ | echo expand('%:p:h') | redir END")
-- Change to directory of current file
vim.cmd("command! Dcd cd %:p:h")

-- nrh
vim.cmd("command! Nrh !home-manager switch --impure --flake ~/code/personal/system/.")
-- nrs
vim.cmd("command! Nrs !sudo nixos-rebuild switch --flake ~/code/personal/system/")

-- Auto source when saving
vim.cmd('autocmd BufWritePost tmux.conf silent !tmux source %')
vim.cmd('autocmd BufWritePost .Xresources silent !xrdb %')
vim.cmd('autocmd BufWritePost .zshrc,.zshenv,.zsyntax,.zprompt,.zalias silent !source ~/.config/zsh/.zshrc')

-- terminal no number
vim.cmd("autocmd TermOpen * setlocal nonumber norelativenumber")

-- Disables automatic commenting on newline:
vim.cmd('autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o')

-- For some reason treesitter is not recognizing .nix files
vim.cmd('autocmd FileType nix TSBufEnable highlight')

-- Calcurse notes with markdown
vim.cmd('autocmd BufRead,BufNewFile /tmp/calcurse* set filetype=markdown')
vim.cmd('autocmd BufRead,BufNewFile ~/.calcurse/notes/* set filetype=markdown')

-- cursorline only in Insert Mode
vim.cmd('autocmd InsertLeave,InsertEnter * set cul!')

-- Startify Unmap q key and others
vim.cmd([[autocmd User Startified for key in ['q','s','t','v'] | silent execute 'nunmap <buffer>' key | endfor]])

-- Upload to Tech bookstack
vim.cmd([[
command! Bsup silent !~/system/home/zsh/scripts/bookstack_update '%:p:h' '%:t'
]])

-- Source tmux config after saving
vim.cmd('autocmd BufWritePost tmux.conf silent !tmux source %')

-- Autoformat nix code with alejandra
-- wget https://github.com/kamadorueda/alejandra/releases/download/1.5.0/alejandra-x86_64-unknown-linux-musl
vim.cmd('autocmd BufWritePost *.nix silent !alejandra %:p')

-- Jenkisfile syntax highlight as groovy files
vim.cmd('au BufNewFile,BufRead Jenkinsfile setf groovy')

-- flake.lock syntax highlight as json files
vim.cmd('au BufNewFile,BufRead flake.lock setf json')

-- Markdown format options
-- t: auto-wrap based on tw, a: format paragraph, w: trailing white space continues paragraph
vim.cmd('au filetype markdown setlocal fo=wnt')
-- vim.cmd('command MarkdownParagraphFormat g/\\S $/norm A ') -- add 2nd whitespace to break line on paragraph

-- Create .pdf out of current .md file
vim.cmd('autocmd BufWritePost ~/dev/jekyll/codeblog/_posts/*.md silent !mkdir -p /tmp/blog-preview && pandoc %:p -o /tmp/blog-preview/tmp.pdf &')

-- commentary.vim # for .nix files
vim.cmd('autocmd FileType nix setlocal commentstring=#\\ %s')
