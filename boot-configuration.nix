{config, pkgs, lib, ...}:
{
  # Bootloader.
  boot.loader.systemd-boot.enable = false;
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    useOSProber = true;
    extraEntries = ''
      submenu "NixOS Extras" {
        menuentry "Boot with GPU Passthrough" {
          search --set=drive1 --fs-uuid CED3-7B41
            linux ($drive1)//kernels/dadq563gcxdn44731bnr5fz0k6rz9v5j-linux-6.18.44-bzImage init=/nix/store/fdyhiil8np9m313920qfrvkhsxs98qx7-nixos-system-nixos-26.05.7675.02e08985a27c/init quiet splash ids=10de:28e1 amd_iommu=on root=fstab loglevel=4 lsm=landlock,yama,bpf
            initrd ($drive1)//kernels/g7igvqmkg92g7kvk2wg7q2crnwa6q65c-initrd-linux-6.18.44-initrd
        }
      }
    '';
  };
  boot.kernelParams = [
    "quiet"
    "splash"
  ];
  boot.kernel.sysctl = {
    "vm.image_size" = 0;
  };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.extraModulePackages = [ config.boot.kernelPackages.kvmfr ];
  boot.initrd.kernelModules = [ 
    "kvmfr" 
    "vfio-pci" 
    "vfio"
    "vfio_iommu_type1"
  ];
  boot.extraModprobeConfig = ''
    options vfio-pci ids=10de:28e1
    softdep drm pre: vfio-pci
    options kvmfr static_size_mb=256
  '';

  services.udev.packages = lib.singleton (pkgs.writeTextFile
    {
      name = "kvmfr";
      text = ''
        SUBSYSTEM=="kvmfr", GROUP="kvm", MODE="0600", TAG+="uaccess"
      '';
      destination = "/etc/udev/rules.d/70-kvmfr.rules";
    }
  );
}
