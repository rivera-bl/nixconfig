-- MAIN
vim.g.mapleader = ","
vim.api.nvim_set_keymap('n', '<leader>m', ':w<CR>', {noremap = true}) -- Write
vim.api.nvim_set_keymap('n', '<leader>q', ':lua CloseTree()<CR>', {noremap = true}) -- Quit window
vim.api.nvim_set_keymap('n', '<leader>Q', ':qa<CR>', {noremap = true}) -- Quit all windows
vim.api.nvim_set_keymap('n', '<leader>s', ':! ~/code/personal/system/home/zsh/scripts/launch_fzf<CR><CR>', {noremap = true, silent = true})

-----------------------------
-- UTILS
-----------------------------

-- Close NvimTree if only 2 windows are open
function CloseTree()
  local buffers = vim.fn.getbufinfo({bufloaded = true})
  local buffer_filetypes = {}

  for _, buffer in ipairs(buffers) do
      local filetype = vim.fn.getbufvar(buffer.bufnr, "&filetype")
      table.insert(buffer_filetypes, filetype)
  end

  if #vim.api.nvim_list_wins() == 2 and vim.tbl_contains(buffer_filetypes, "NvimTree") then
        vim.api.nvim_command('NvimTreeClose | q')
    else
      vim.api.nvim_command('q')
    end
end

-- build nixos and home-manager configs
function SysBuild()
  local current_path = vim.fn.expand("%:p")
  local system_path = os.getenv('HOME') .. '/code/personal/system'
  local nprofile = "/nix/var/nix/profiles/system"

  if string.match(current_path, system_path) then
    local filepath = string.gsub(current_path, system_path, "")
    if string.match(filepath, '/home') then
      vim.api.nvim_command(':w | !home-manager switch --impure --flake ' .. system_path .. '/.')
      local hgen = vim.fn.system('home-manager generations | head -n 1 | awk \'{print $5}\'')
      Bmsg = "home." .. hgen
    else
      vim.api.nvim_command(':w | !sudo nixos-rebuild switch --flake ' .. system_path .. "/\\# | true")
      local ngen = vim.fn.system('sudo nix-env --list-generations -p ' .. nprofile .. ' | tail -n 1 | awk -F " " \'{print $1}\'')
      Bmsg = "nixos." .. ngen
    end
    vim.fn.system('git add -u && git commit -m "' .. Bmsg .. '"')
    ReloadConfig()
  end
end
vim.api.nvim_set_keymap('n', '<leader>x', ":lua SysBuild()<CR><CR>", { noremap = true })

-- run file in tmux pane
function FileBuild()
  local filetype = vim.bo.filetype
  function Run(cmd)
    -- resize if nvim is zoomed
    vim.fn.system("tmux if-shell -F '#{window_zoomed_flag}' 'resize-pane -Z'")
    vim.api.nvim_command(':w | !tmux send-keys -t right \'' .. cmd .. '\' C-m')
  end

  if filetype == 'terraform' then
    Run('terraform apply')
  elseif filetype == 'yaml' then
    if vim.fn.system('grep -q -m 10 "apiVersion:" ' .. vim.fn.expand("%:p")) then
      Run('kubectl apply -f ' .. vim.fn.expand("%:p"))
    end
  -- run last history command
  elseif filetype == 'nix' then
    vim.api.nvim_command('@:')
  else
    Run(filetype .. ' ' .. vim.fn.expand("%:p"))
  end
end
vim.api.nvim_set_keymap('n', '<leader>r', ":lua FileBuild()<CR><CR>", { noremap = true })

-----------------------------
-- SPLITS
-----------------------------

-- Navigation
vim.api.nvim_set_keymap('n', '<C-j>', '<C-w>j', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<C-k>', '<C-w>k', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<C-h>', '<C-w>h', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<C-l>', '<C-w>l', {noremap = true, silent = true})

-- Relocate
vim.api.nvim_set_keymap('n', '<leader>ww', '<C-W>=', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>wf', '<C-W>|', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>wv', '<C-W>v', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>ws', '<C-W>s', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>wh', ':wincmd H<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>wl', ':wincmd L<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>wj', ':wincmd J<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>wk', ':wincmd K<CR>', {noremap = true, silent = true})

-- Jumplist
-- Add j,k motion movements to the jumplist
vim.cmd([[:nnoremap <silent> k :<C-U>execute 'normal!' (v:count > 1 ? "m'" . v:count : '') . 'k'<CR>]])
vim.cmd([[:nnoremap <silent> j :<C-U>execute 'normal!' (v:count > 1 ? "m'" . v:count : '') . 'j'<CR>]])

-----------------------------
-- BUFFERS
-----------------------------

-- using ton/vim-bufsurf to navigate consistently between buffers
vim.api.nvim_set_keymap('n', '<leader>a'    , ':BufSurfBack<CR>'                                  , {noremap = true, silent = true}) -- Go to previous buffer history
vim.api.nvim_set_keymap('n', '<leader>d'    , ':BufSurfForward<CR>'                               , {noremap = true, silent = true}) -- Go to next buffer history
vim.api.nvim_set_keymap('n', '<leader>c'    , ':bn|bw #<CR>'                                      , {noremap = true, silent = true}) -- Delete current buffer
vim.api.nvim_set_keymap('n', '<leader><S-c>', ":let var=expand('%:p') | %bw | exec 'edit' var<CR>", {noremap = true, silent = true}) -- Delete all opened buffers but current

-----------------------------
-- COMMAND MODE
-----------------------------

vim.api.nvim_set_keymap('c', '<C-j>', '<down>'    , {noremap = true})
vim.api.nvim_set_keymap('c', '<C-k>', '<up>'      , {noremap = true})
vim.api.nvim_set_keymap('c', '<C-h>', '<left>'    , {noremap = true})
vim.api.nvim_set_keymap('c', '<C-l>', '<right>'   , {noremap = true})
vim.api.nvim_set_keymap('c', '<C-b>', '<C-left>'  , {noremap = true})
vim.api.nvim_set_keymap('c', '<C-e>', '<C-right>' , {noremap = true})
vim.api.nvim_set_keymap('c', '<C-n>', '<C-f>'     , {noremap = true})

-----------------------------
-- TELESCOPE
-----------------------------

project_files = function()
  local opts = {
    prompt_title = vim.fn.expand("%:p:h"),
    cwd = vim.fn.expand("%:p:h"),
    hidden = true
  } -- define here if you want to define something
  require"telescope.builtin".find_files(opts)
end
search_code = function()
  require("telescope.builtin").find_files({
    prompt_title = "<code>",
    cwd = "~/code",
    hidden = true
  })
end
search_git = function()
  require("telescope.builtin").git_files({
    cwd = vim.fn.expand("%:p:h"),
    prompt_title = "<git>",
    hidden = true
  })
end
search_grep = function()
  require('telescope.builtin').live_grep(require('telescope.themes').get_ivy{
    prompt_title = "Grep",
    hidden = true
  })
end

vim.api.nvim_set_keymap('n', '<leader>b',  ':Buffers<CR>'           , {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>f',  ':Files %:p:h<CR>'             , {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>g',  ':GitFiles<CR>'          , {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>,d', ':Files ~/code<CR>'     , {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>,r', ':History:<CR>'     , {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>z',  ':cd `git rev-parse --show-toplevel` | Rg<CR>'    , {noremap = true})

-----------------------------
-- SPELL CHECKING
-----------------------------

-- ,¿¿ - C-N - <TAB>
-- Set spell
vim.cmd('nnoremap <leader>¿¿ :setlocal spell!<CR>') -- toggle spellcheck
vim.cmd('nnoremap <leader>¿s :setlocal spell <bar> setlocal spelllang=es<CR>')
vim.cmd('nnoremap <leader>¿n :setlocal spell <bar> setlocal spelllang=en<CR>')
-- Bind only when spell is set on
vim.cmd('nnoremap <expr> <TAB> ( &spell ) ? "1z=" : "<TAB>"') -- accept first suggestion
vim.cmd('nnoremap <expr> <CR>  ( &spell ) ? "zg"  : "<CR>"')  -- add to dictionary
vim.cmd('nnoremap <expr> <C-N> ( &spell ) ? "]S"  : "<C-N>"') -- next word
vim.cmd('nnoremap <expr> <C-P> ( &spell ) ? "[S"  : "<C-P>"') -- previous word

-----------------------------
-- K8
-----------------------------

vim.api.nvim_set_keymap('n', '<leader>ka', ":silent !tmux send-keys -t right 'kubectl apply -f %' Enter<CR>", {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>kd', ":silent !tmux send-keys -t right 'kubectl delete -f %' Enter<CR>", {noremap = true})

-----------------------------
-- MISC
-----------------------------

-- open file on current buffer dir
vim.api.nvim_set_keymap('n', '<leader>e', ':e <C-R>=expand("%:p:h") . "/"<CR>', {noremap = true})

-- exec shell visual selection
-- tmux send-keys -t right Enter && tmux run-shell -t right ls
vim.cmd([[vnoremap <C-s> y$:! <C-r>0<Home><right>]])

-- Open Lazygit
vim.api.nvim_set_keymap('n', '<leader>4', [[:cd %:p:h | LazyGit<CR>]], {noremap = true})
-- vim.api.nvim_set_keymap('n', '<leader>4', [[:cd %:p:h | !tmux display-popup -h 100\% -w 100\% lazygit -p $(git rev-parse --show-toplevel) <CR><CR>]], {noremap = true})

-- Toggle netrw
vim.api.nvim_set_keymap('n', '<leader>n', ':cd `git rev-parse --show-toplevel` | NvimTreeCollapse | NvimTreeFindFileToggle<CR>', {noremap = true, silent = true})

-- Don't enter Insert mode before inserting multiple lines
-- Commenting because it messes up indentation
-- vim.api.nvim_set_keymap('n',   'o', 'o<esc>i', {noremap = true})
-- vim.api.nvim_set_keymap('n',   'O', 'O<esc>i', {noremap = true})

-- Clear the search Highlight with ESC
vim.api.nvim_set_keymap('n',   '<esc>'    , ':noh<return><esc>', {noremap = true, silent = true})

-- Replace every word of the last search
vim.api.nvim_set_keymap('n', '<leader>R', ':%s//', {})

-- Don't yank the string to the unnamed register when using 'c' or 'C' in normal or visual mode
vim.cmd([[noremap c "_c]])
vim.cmd([[noremap C "_C]])
