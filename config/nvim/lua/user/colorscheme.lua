local status_ok, colorbuddy = pcall(require, "colorbuddy")
if not status_ok then
	return
end

local Color, colors, Group, groups, styles = colorbuddy.setup()

-- for some reason this block of colors is hardcoded inside the colorbuddy plugin
-- pinned the commit for the plugin is any case
Color.new("gray0", "#1d2225") -- background
Color.new("gray1", "#1d2225") -- background of the line numbers column
Color.new("gray2", "#373b41")
Color.new("gray3", "#969896") -- line numbers,comments
Color.new("gray4", "#b4b7b4")
Color.new("gray5", "#c5c8c6")
Color.new("gray6", "#e0e0e0")
Color.new("gray7", "#ffffff")

Color.new('white',     '#f2e5bc')
Color.new('red',       '#cc6666') --function
Color.new('pink',      '#fef601')
Color.new('green',     '#99cc99')
Color.new('yellow',    '#f8fe7a')
Color.new('background','#f8fe7a')
Color.new('blue',      '#81a2be')
Color.new('aqua',      '#8ec07c')
Color.new('cyan',      '#8abeb7')
Color.new('purple',    '#8e6fbd')
Color.new('violet',    '#b294bb')
Color.new('orange',    '#de935f')
Color.new('brown',     '#a3685a')

Color.new('seagreen',  '#698b69')
Color.new('turquoise', '#698b69')

-- not working?
Group.new('Function'        , colors.red      , colors.background , styles.italic)
Group.new('luaFunctionCall' ,  groups.Function   , groups.Function, groups.Function)

colorbuddy.colorscheme('')
