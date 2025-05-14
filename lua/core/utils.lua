local utils = {}
function utils.dim(text)
  if text == "" then
    return
  end
  return "%#Comment#" .. text .. "%#KVClear#"
end

function utils.get_icon_by_filetype(name)
  local ok, icons = pcall(require, "nvim-web-devicons")

  if not ok then
    return ""
  end

  local icon, color = icons.get_icon_by_filetype(name)
  if not icon then
    return ""
  end

  return "%#" .. color .. "#" .. icon .. "%#Normal#", color
end

function utils.get_icon(name)
  local ok, icons = pcall(require, "nvim-web-devicons")

  if not ok then
    return ""
  end

  local icon, _ = icons.get_icon(name)
  if not icon then
    return ""
  end

  return icon
end

function utils.loadable(name)
  local ok, module = pcall(require, name)

  if not ok then
    vim.notify("Failed to load " .. name)
    return
  end
  return module
end

function utils.capitalize(s)
  return s:sub(1, 1):upper() .. s:sub(2)
end

function utils.capitalize_wrap(s)
  return "[" .. s:sub(1, 1):upper() .. "]" .. s:sub(2)
end

function utils.capitalize_every_word(s)
  return (s:gsub("(%w[%w]*)", function(match)
    return utils.capitalize_wrap(match)
  end))
end

function utils.contains(table, element)
  for _, value in pairs(table) do
    if value == element then
      return true
    end
  end
  return false
end

function utils.isEmpty(v)
  return v == nil or v == ''
end

function utils.isNotEmpty(v)
  return v ~= nil or v ~= ''
end

return utils
