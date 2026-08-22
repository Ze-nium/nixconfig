{ config, pkgs, lib, ... }:
{
  security.pam.loginlimits = [
    { domain = "*"; type = "-"; item = "memlock"; value = "unlimited"; }
    { domain = "@kvm"; type = "hard"; item = "memlock"; value = "unlimited"; }
  ];
  systemd.tmpfiles.rules = [
  "f /dev/shm/looking-glass 0660 kian kvm -"
  ];
}
