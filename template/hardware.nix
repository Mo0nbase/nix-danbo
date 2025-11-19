{
  config,
  lib,
  modulesPath,
  ...
}:

{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    (modulesPath + "/profiles/minimal.nix")
  ];

  # Nix settings - required for flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Bootloader - matches cloud-init image
  boot.loader.grub = {
    enable = true;
    device = lib.mkForce "/dev/sda";
  };

  # Kernel parameters - keep these for cloud compatibility
  boot.kernelParams = [
    "console=ttyS0,115200"
    "net.ifnames=0"
  ];

  # Essential virtio modules for kyun.host
  boot.initrd.availableKernelModules = [
    "virtio_pci"
    "virtio_scsi"
    "virtio_blk"
    "virtio_net"
    "scsi_mod"
    "sd_mod"
    "sr_mod" # Required for cloud-init CD-ROM at /dev/sr1
  ];

  # Root filesystem - autoResize important for cloud images
  fileSystems."/" = {
    device = lib.mkDefault "/dev/disk/by-label/nixos";
    fsType = "ext4";
    autoResize = true;
  };

  # Cloud-init support - CRITICAL: must stay enabled
  services.cloud-init.enable = true;
  services.cloud-init.network.enable = true;

  # SSH - minimal secure config
  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = "prohibit-password";
  services.openssh.settings.PasswordAuthentication = false;

  # Security - allow sudo for cloud-init created users
  security.sudo.wheelNeedsPassword = lib.mkDefault false;
  security.sudo.execWheelOnly = lib.mkDefault false;

  # Networking - use systemd-networkd (matches cloud-init image)
  networking.useDHCP = false;
  networking.useNetworkd = true;
  systemd.network.enable = true;

  # QEMU guest agent
  services.qemuGuest.enable = true;
}
