-- apparently cant use M = {} and return M cause hm turn this into a single file
-- adds new commands but not removes commands commented
-- TODO fix bugs out other plugins like vim-tmux-navigator
function _G.ReloadConfig()
  for name,_ in pairs(package.loaded) do
    if name:match('^cnull') then
      package.loaded[name] = nil
    end
  end

  dofile(vim.env.MYVIMRC)
end
-- fix not taking <leader> in keymap
vim.api.nvim_set_keymap('n', ',vs', '<Cmd>lua ReloadConfig()<CR>', { silent = true, noremap = true })
vim.cmd('command! ReloadConfig lua ReloadConfig()')
