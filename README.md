<div align="center">
  <img src="https://github.com/user-attachments/assets/257205c8-4b35-4223-8609-e08265d403bf" alt="danbo" width="100%" />
</div>

</br>
<div align="center">
  
  **A Minimal NixOS cloud image for the [kyun.host](https://kyun.host) danbo vps!**
  
</div>

<div align="center">
  
  [![NixOS Flake](https://img.shields.io/badge/NixOS-Flake-blue?logo=nixos&logoColor=white)](https://github.com/Mo0nbase/nix-danbo)
  [![Latest Release](https://img.shields.io/github/v/release/Mo0nbase/nix-danbo?label=Latest%20Release&style=flat-square)](https://github.com/Mo0nbase/nix-danbo/releases)
  [![Downloads](https://img.shields.io/github/downloads/Mo0nbase/nix-danbo/total?style=flat-square)](https://github.com/Mo0nbase/nix-danbo/releases)
  
</div>

<div align="center">
  <a href="https://trocador.app/anonpay?ticker_to=xmr&network_to=Mainnet&address=86sk661f7XTNFCTmjtYWL8FL6mxdmVZneC1dF5Ct9YtmBq1C4DS7ZNPDvwfuPXw9vhG4SNpEU9LJC8LpVTe3qN8mCxwXVC5&ref=sqKNYGZbRl&direct=True&name=Mo0nbase&description=nix-danbo+%F0%9F%A4%8D+monero">
    <img src="https://img.shields.io/badge/Donate-Monero-ff6600?logo=monero&logoColor=white&style=for-the-badge" alt="Donate Monero"/>
  </a>
</div>

## Quick Start

### 1. Get the Image URL

Go to [Releases](https://github.com/Mo0nbase/nixos-danbo/releases) and copy the link for the latest `.qcow2` image.

### 2. Deploy on Kyun.host

Paste the image URL into the kyun.host dashboard custom qick start section on the danbo dashboard.

### 3. Reboot After First Boot

Once the instance boots up, SSH in and reboot!

```bash
ssh root@your-server-ip
reboot
```

### 4. Add to Your NixOS Flake

Copy the configuration template to your NixOS flake and deploy:

```bash
# In your NixOS config repository
mkdir -p hosts/kyun
cd hosts/kyun

curl -O https://raw.githubusercontent.com/Mo0nbase/nixos-danbo/main/template/danbo.nix
curl -O https://raw.githubusercontent.com/Mo0nbase/nixos-danbo/main/template/hardware.nix
```

Add to your `flake.nix` and deploy to your server.

**See [template/README.md](template/README.md) for detailed configuration guide.**

---

## Overview

nixos-danbo is a minimal, production-ready NixOS cloud image for kyun.host VPS hosting. It uses cloud-init for automatic configuration of networking, SSH keys, and system settings on first boot.

### What's Included

- NixOS 25.05
- Essential packages: vim, wget, curl, git, htop, tmux
- SSH server, QEMU guest agent, cloud-init
- Static networking via systemd-networkd

## Building from Source

```bash
git clone https://github.com/Mo0nbase/nixos-danbo.git
cd nixos-danbo
nix build
# Output: result/nixos.qcow2
```

See [CONTRIBUTING.md](CONTRIBUTING.md) for development details.

## Documentation

- [User Configuration Guide](template/README.md) - Manage your system with NixOS
- [Contributing Guide](CONTRIBUTING.md) - Development workflow

## Support

- 🐛 [Report Issues](https://github.com/Mo0nbase/nixos-danbo/issues)
- 📚 [Kyun.host Docs](https://kyun.host/docs)

## License

MIT
