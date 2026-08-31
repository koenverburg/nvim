style:
  stylua --verify .

check:
  luacheck --quiet .

format: style check

version:
   stylua --version


setup:
  brew install stylua

install:
  nvim --headless -u init.lua "+Lazy! sync" +qa
