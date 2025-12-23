style:
  stylua --verify .

check:
  luacheck --quiet .

format: style check
