# NixOS Configuration Template for Kyun.host

This template provides a minimal NixOS host configuration for managing your kyun.host server after the initial cloud-init bootstrap.

**Assumption**: You already have a NixOS flake for managing your systems. This template gives you the host-specific configuration to add to your flake.

## Quick Start

1. **After deploying the nixos-danbo image to kyun.host**, SSH into your server
2. **Add this template to your existing NixOS flake**:

```bash
# In your existing NixOS config repo (local machine or server)
mkdir -p hosts/kyun
cd hosts/kyun

# Download the template files
curl -O https://raw.githubusercontent.com/Mo0nbase/nixos-danbo/main/template/danbo.nix
curl -O https://raw.githubusercontent.com/Mo0nbase/nixos-danbo/main/template/hardware.nix
```

3. **Add the host to your flake.nix**:

```nix
nixosConfigurations.kyun = nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  modules = [
    ./hosts/kyun/danbo.nix
  ];
};
```

4. **Customize** `danbo.nix` with your needs
5. **Deploy** your configuration:

```bash
# From your local machine
nixos-rebuild switch --flake .#kyun --target-host root@your-server

# Or on the server itself (if you cloned your flake there)
sudo nixos-rebuild switch --flake /etc/nixos#kyun
```

## What's Included

### `danbo.nix`
- Minimal system configuration
- Firewall setup (SSH enabled by default)
- Package list (vim, wget, curl, git, htop, tmux)
- Commented examples for common tasks

### `hardware.nix`
- Hardware configuration matching kyun.host/QEMU environment
- Bootloader setup (GRUB on /dev/sda)
- Virtio kernel modules
- Serial console support
- systemd-networkd (used by cloud-init)

## Important Notes

### Cloud-Init vs. NixOS Management

The base image uses **cloud-init** for initial bootstrap:
- Sets hostname, static IPs, gateway, DNS
- Creates initial user with SSH keys
- Runs on first boot only

After bootstrap, **you manage the system with NixOS**:
- Networking configuration can be overridden in `danbo.nix`
- Add users, packages, services as needed
- Cloud-init becomes inactive after first boot

### Don't Conflict with Base Image

These settings are **already configured** in the base image, keep them:
- `boot.loader.grub.device = "/dev/sda"`
- `boot.kernelParams = [ "console=ttyS0,115200" "net.ifnames=0" ]`
- `networking.useNetworkd = true`
- `services.qemuGuest.enable = true`
- `system.stateVersion = "25.05"`

### Networking

Cloud-init configures your network on first boot. You can:

**Option 1**: Leave it as-is (recommended)
- Cloud-init manages networking
- No changes needed

**Option 2**: Override in NixOS (see kyuns documentation, network settings are at /dev/sr1)
```nix
networking.interfaces.eth0 = {
  ipv4.addresses = [{ address = "x.x.x.x"; prefixLength = 24; }];
  ipv6.addresses = [{ address = "xxxx::1"; prefixLength = 48; }];
};
networking.defaultGateway = "x.x.x.1";
networking.defaultGateway6 = { address = "xxxx::1"; interface = "eth0"; };
networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];
```

## Common Tasks

### Add Packages
```nix
environment.systemPackages = with pkgs; [
  vim
  git
  docker
  # your packages here
];
```

### Enable Services
```nix
services.tailscale.enable = true;
services.docker.enable = true;
services.postgresql.enable = true;
```

### Add Users
```nix
users.users.alice = {
  isNormalUser = true;
  extraGroups = [ "wheel" "docker" ];
  openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAA... alice@laptop"
  ];
};
```

### Open Firewall Ports
```nix
networking.firewall.allowedTCPPorts = [ 22 80 443 ];
networking.firewall.allowedUDPPorts = [ 51820 ]; # wireguard
```

## Deployment Workflow

### Local Development
```bash
# Edit configuration locally
# Deploy to server
nixos-rebuild switch --flake .#kyun --target-host root@your-server.com
```

### On Server
```bash
# Edit configuration
sudo vim /etc/nixos/hosts/kyun/danbo.nix

# Apply changes
sudo nixos-rebuild switch --flake /etc/nixos#kyun

# Test before switching
sudo nixos-rebuild test --flake /etc/nixos#kyun
```

## Troubleshooting

### Check current configuration
```bash
nixos-rebuild list-generations
```

### Rollback to previous generation
```bash
sudo nixos-rebuild switch --rollback
```

### View system logs
```bash
journalctl -xe
```

### Validate flake
```bash
nix flake check /etc/nixos
```

## Resources

- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [NixOS Search](https://search.nixos.org/)
- [nixos-danbo Image Builder](https://github.com/Mo0nbase/nixos-danbo)
