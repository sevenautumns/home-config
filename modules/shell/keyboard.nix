{ pkgs, config, ... }: {
  home.keyboard = {
    layout = "de";
    model = "pc105";
    options = [ "caps:ctrl_modifier" ];
  };
}
