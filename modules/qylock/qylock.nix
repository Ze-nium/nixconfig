{ lib, config, pkgs, ... }:
{
  options = {
    services.displayManager.sddm.qylock = {
      theme = lib.mkOption {
        description = "An option that describes which qylock theme to use. A derivation will be built based on the option";
        type = lib.types.enum [
          "clockwork"
          "dog-samurai"
          "enfield"
          "field"
          "forest"
          "Genshin"
          "girl-coffee"
          "girl-pillow"
          "last-of-us"
          "man-bicycle"
          "material-you"
          "minecraft"
          "nier-automata"
          "ninesols"
          "ninja_gaiden"
          "nothing"
          "osu"
          "osumania"
          "pixel-coffee"
          "pixel-cyberpunk"
          "pixel-dusk-city"
          "pixel-emerald"
          "pixel-hollowknight"
          "pixel-munchlax"
          "pixel-night-city"
          "pixel-rainyroom"
          "pixel-sakura"
          "pixel-skyscrapers"
          "pixel-waterfall"
          "R1999_1"
          "R1999_2"
          "star-rail"
          "sword"
          "terraria"
          "windows_7"
          "winter"
          "women-umbrella"
          "wuwa"
        ];
        default = "pixel-dusk-city";
      };
      clockwork.theme = lib.mkOption {
        type = lib.types.enum [ "neo-orbital" "orbital" "tape" ];
        default = "neo-orbital";
      };
    };
  };
}
