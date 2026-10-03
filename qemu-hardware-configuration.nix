{ config, pkgs, lib, ... }:
{
  security.pam.loginLimits = [
    { domain = "*"; type = "-"; item = "memlock"; value = "unlimited"; }
    { domain = "@kvm"; type = "hard"; item = "memlock"; value = "unlimited"; }
  ];
  systemd.tmpfiles.rules = [
    "f /dev/shm/looking-glass 0660 kian kvm -"
  ];

  services.udev.extraRules = ''
    KERNEL=="/dev/kvmfr0", MODE="0660", GROUP="kvm"
  '';

  virtualisation.libvirtd = {
    qemu = {
      verbatimConfig = ''
        cgroup_device_acl = [
          "/dev/null", "/dev/full", "/dev/zero",
          "/dev/random", "/dev/urandom",
          "/dev/ptmx", "/dev/kvm",
          "/dev/kvmfr0"
        ]
      '';
    };
  };
}
