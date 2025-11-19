{
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware.nix
  ];

  # Networking - cloud-init handles initial setup, you can customize here
  # Cloud-init sets: hostname, static IPs, gateway, nameservers
  # Override hostname after bootstrap:
  networking.hostName = "danbo"; # change this to your preferred hostname

  # Override static network configuration if needed:
  # networking.interfaces.eth0.ipv4.addresses = [{ address = "x.x.x.x"; prefixLength = 24; }];
  # networking.interfaces.eth0.ipv6.addresses = [{ address = "xxxx::1"; prefixLength = 48; }];
  # networking.defaultGateway = "x.x.x.1";
  # networking.defaultGateway6 = { address = "xxxx::1"; interface = "eth0"; };
  # networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];

  # Firewall - add your required ports
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ]; # SSH - add more as needed
  };

  # Time zone
  time.timeZone = "UTC";

  # Locale
  i18n.defaultLocale = "en_US.UTF-8";

  # Users - cloud-init creates initial user, you can add more
  # Override root SSH keys (cloud-init sets these initially):
  # users.users.root.openssh.authorizedKeys.keys = [
  #   "ssh-ed25519 AAAA... your-key-name"
  # ];

  # Add additional users:
  # users.users.myuser = {
  #   isNormalUser = true;
  #   extraGroups = [ "wheel" ];
  #   openssh.authorizedKeys.keys = [ "ssh-ed25519 ..." ];
  # };

  # Packages - add what you need
  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    git
    htop
    tmux
    # tailscale
  ];

  # Services
  # services.tailscale.enable = true;

  # Allow unfree packages if needed
  # nixpkgs.config.allowUnfree = true;

  # IMPORTANT: Keep this matching your base image version
  system.stateVersion = "25.05";
}
