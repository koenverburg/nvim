-- Colorscheme for lualine

local nightcoder = {
  bright = {
    pinkish = "#FB467B",
  },
  wayfinder = {
    red = "#8b0000",
    red1 = "#7d0000",
    red2 = "#6f0000",
    red3 = "#610000",
    red4 = "#530000",
    red5 = "#460000",
    red6 = "#380000",
    red7 = "#2a0000",
    red8 = "#1c0000",
    red9 = "#0e0000",
  },
  red = {
    shade1 = "#feffff",
    shade2 = "#f8d3d2",
    shade3 = "#f2a8a5",
    shade4 = "#ed7d79",
    shade5 = "#e5524c",
    shade6 = "#df271f",
    shade7 = "#b21f19",
    shade8 = "#851713",
    shade9 = "#590f0c",
  },
  orange = {
    shade1 = "#fff9f2",
    shade2 = "#fee3c1",
    shade3 = "#ffd099",
    shade4 = "#ffb966",
    shade5 = "#ffa233",
    shade6 = "#ff8b00",
    shade7 = "#cc6f00",
  },
}

local crimson = {
  text = "#FEFDFD",
  backgroundDark = "#ff6363",
  backgroundLight = "#733434",
  -- background = rgba 0,0,0,0.75,
  string = "#EBB99D",
  comment = "#895E60",
  variable = "#C88E8E",
  variable2 = "#FFE4E4",
  variable3 = "#E97598",
  number = "#FDA97A",
  atom = "#FDA97A",
  keyword = "#EB6F6F",
  property = "#D15510",
  definition = "#C88E8E",
  meta = "#FFE4E4",
  operator = "#EB6F6F",
  attribute = "#C88E8E",
  tag = "#EB6F6F",
}

local custom = {
  pinkish = "#FB467B",
  red5 = "#e5524c",
}

-- local colors = {
--   -- bg = "NONE",
--   -- bg = "#171717",
--   bg = nightcoder.wayfinder.red6,
--   -- bg = custom.pinkish, --"#171717",
--   fg = "#D0D0D0",
-- }

local colors = {
  bg = "#171717",
  fg = "#D0D0D0",
  gray = "#373737",
}

return {
  normal = {
    a = { fg = colors.fg, bg = colors.bg, gui = "bold" },
    b = { fg = colors.fg, bg = colors.bg },
    c = { fg = colors.fg, bg = colors.bg },
  },
  insert = { a = { fg = colors.fg, bg = colors.bg, gui = "bold" } },
  visual = { a = { fg = colors.fg, bg = colors.bg, gui = "bold" } },
  command = { a = { fg = colors.fg, bg = colors.bg, gui = "bold" } },
  replace = { a = { fg = colors.fg, bg = colors.bg, gui = "bold" } },
  inactive = {
    a = { fg = colors.gray, bg = colors.bg },
    b = { fg = colors.gray, bg = colors.bg },
    c = { fg = colors.gray, bg = colors.bg },
  },
}
