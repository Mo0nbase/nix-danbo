{
  modulesPath,
  ...
}:

{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  # Bootloader - matches cloud-init image
  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
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
  ];

  # Root filesystem
  fileSystems."/" = {
    device = "/dev/sda1";
    fsType = "ext4";
  };

  # Networking - use systemd-networkd (matches cloud-init image)
  networking.useDHCP = false;
  networking.useNetworkd = true;
  systemd.network.enable = true;

  # QEMU guest agent
  services.qemuGuest.enable = true;
}
