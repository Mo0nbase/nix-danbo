{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  # Import hardware configuration for QEMU/KVM
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  # Minimal Nix settings
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Debug kernel parameters - keep for troubleshooting boot issues
  boot.kernelParams = [
    "console=ttyS0,115200"
    "net.ifnames=0"
    "earlyprintk=serial,ttyS0,115200"
    "debug"
    "loglevel=7"
    "initcall_debug"
    "boot.shell_on_fail"
  ];

  # Cloud-init support - minimal configuration
  services.cloud-init.enable = true;
  services.cloud-init.network.enable = true;

  # SSH - minimal secure config
  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = "prohibit-password";
  services.openssh.settings.PasswordAuthentication = false;

  # Networking - let cloud-init handle it
  networking.useDHCP = false;
  networking.useNetworkd = false;
  systemd.network.enable = lib.mkForce false;

  # Minimal firewall
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 22 ];

  # QEMU guest agent
  services.qemuGuest.enable = true;

  # System state version
  system.stateVersion = "24.11";
}
