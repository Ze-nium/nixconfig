{ config, pkgs, lib, ... }:
let 
  themeName = config.services.displayManager.sddm.qylock.theme; 
  clockworkTheme = config.services.displayManager.sddm.qylock.clockwork.theme;
in
# Consider turning the qylock folder into a NAR file for cleaner configuration. 
# Or better yet, pull the file from qylock in GitHub
pkgs.stdenv.mkDerivation {
  name = "qylockTheme";
  src = if themeName == "clockwork"
        then /. + "/home/kian/qylock/themes/clockwork/${clockworkTheme}"
        else /. + "/home/kian/qylock/themes/${themeName}";
  themeName = config.services.displayManager.sddm.qylock.theme;
  installPhase = ''
    mkdir -p $out/share/sddm/themes/${themeName}
    cp -r . $out/share/sddm/themes/${themeName}
  '';
}


