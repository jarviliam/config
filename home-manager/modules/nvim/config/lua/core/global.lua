_G.__as_global_callbacks = __as_global_callbacks or {}
_G.as = {
  _store = __as_global_callbacks,
}

function _G.reload(name, children)
  children = children or false
  package.loaded[name] = nil
  if children then
    for pkg_name, _ in pairs(package.loaded) do
      if vim.startswith(pkg_name, name) then
        package.loaded[pkg_name] = nil
      end
    end
  end
  return require(name)
end
