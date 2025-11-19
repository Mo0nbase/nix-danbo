{
  pkgs,
  ...
}:

{
  imports = [
    ./hardware.nix
  ];

  # Networking - cloud-init handles initial setup, you can customize here
  # Cloud-init sets: hostname, static IPs, gateway, nameservers
  # Override if needed after bootstrap:
  # networking.hostName = "my-server";
  # networking.interfaces.eth0.ipv4.addresses = [{ address = "x.x.x.x"; prefixLength = 24; }];

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
