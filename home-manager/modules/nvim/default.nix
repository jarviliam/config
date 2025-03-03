{
  config,
  flakePath,
  ...
}:
{
  xdg.configFile.nvim = {
    source = config.lib.file.mkOutOfStoreSymlink "${flakePath}/home-manager/modules/nvim/config";
  };
}
