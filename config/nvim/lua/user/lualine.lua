local status_ok, _ = pcall(require, "lualine")
if not status_ok then
  return
end

require('lualine').setup {
  options = {
    theme = 'ayu_mirage'
  },
  sections = {
    lualine_c = {
      {
        'filename',
        path = 3,                -- 0: Just the filename
                                 -- 1: Relative path
                                 -- 2: Absolute path
                                 -- 3: Absolute path, with tilde as the home directory
        shorting_target = 40,    -- Shortens path to leave 40 spaces in the window
                                 -- for other components. (terrible name, any suggestions?)
      }
    }
  }
}
