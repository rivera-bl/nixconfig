-- so nvim doesnt break on first start up before PackerInstall
local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
  return
end

local actions = require('telescope.actions')

telescope.setup{
  defaults = {
    initial_mode = "insert",
    file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
    grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
    qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,
    file_ignore_patterns = {
      "Session.vim",
      "NetrwTreeListing",
      ".zcompdump*",
      ".backup*",
      "tmux/plugins",
      "nvim/snippets",
      ".git/"
    },
    -- Developer configurations: Not meant for general override
    buffer_previewer_maker = require'telescope.previewers'.buffer_previewer_maker,
    mappings = {
      i = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-l>"] = actions.select_default + actions.center,
        [",q"] = actions.close
      },
      n = {
        ["l"] = actions.select_default + actions.center,
        ["v"] = actions.select_vertical,
        ["h"] = actions.select_horizontal,
        ["t"] = actions.select_tab,
        ["u"] = actions.move_to_top,
        ["d"] = actions.move_to_bottom,
        [",q"] = actions.close
      },
    }
  },
  pickers = {
    buffers = {
      mappings = {
        i = {
          ["<C-d>"] = "delete_buffer",
        },
        n = {
          ["<C-d>"] = "delete_buffer",
        }
      }
    },
    find_files = {
      find_command = { "rg", "--ignore", "-L", "--hidden", "--files"}
    }
  },
  extensions = {
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = false, -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                       -- the default case_mode is "smart_case"
    }
  }
}
telescope.load_extension('fzf')

-- local M = {}
-- M.project_files = function()
--   local opts = {
--     prompt_title = vim.fn.expand("%:p:h"),
--     cwd = vim.fn.expand("%:p:h"),
--     hidden = true
--   } -- define here if you want to define something
--   require"telescope.builtin".find_files(opts)
-- end
-- M.search_dev = function()
--   require("telescope.builtin").find_files({
--     prompt_title = "<Dev Folder>",
--     cwd = "~/dev",
--     hidden = true
--   })
-- end
-- M.search_config = function()
--   require("telescope.builtin").find_files({
--     prompt_title = "<Dotfiles>",
--     cwd = "~/.config",
--     hidden = true
--   })
-- end
-- M.search_git = function()
--   require("telescope.builtin").git_files({
--     prompt_title = "<Git>",
--     hidden = true
--   })
-- end
-- M.search_vim = function()
--   require("telescope.builtin").find_files({
--     prompt_title = "<Vim>",
--     cwd = "~/editor",
--     hidden = true
--   })
-- end
--  M.search_nixpkgs = function()
--   require("telescope.builtin").find_files({
--     prompt_title = "<nixpkgs>",
--     cwd = "~/dev/nix/nixpkgs",
--     hidden = true
--   })
-- end
--  M.search_grep = function()
--   require('telescope.builtin').live_grep(require('telescope.themes').get_ivy{
--     prompt_title = "Grep",
--     hidden = true
--   })
-- end

-- return M
