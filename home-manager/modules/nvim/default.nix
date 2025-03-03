{
  config,
  ...
}:
{
  xdg.configFile.nvim = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.setup/home-manager/modules/nvim/config";
  };
}
