# 🧮 Proxmox + Nix Homelab Bootstrap Guide

This document defines the full provisioning sequence for a fresh Proxmox + Nix environment, from installation to fully configured infrastructure.

---

## 🧬 Pre-flight Setup

```bash
nix fmt && git add -A
rm -rf .terraform/ .terraform.lock.hcl result
nix-collect-garbage -d
NIXPKGS_ALLOW_UNFREE=1 nix flake check --impure
nix build .#mktar --out-link "./result/tar"
NIXPKGS_ALLOW_UNFREE=1 colmena build --impure
```

---

## 🖥️ Proxmox Installation (Manual Steps)

1. Install Proxmox VE normally.
2. After first login, run the **Post-Install Script** manually:

   ```bash
   bash -c "$(curl -fsSL https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/tools/pve/post-pve-install.sh)"
   ```

   > ⚠️ Run this **only** inside the Proxmox Shell (not over SSH).

---

## 🔑 SSH Setup

```bash
rm -rf ~/.ssh/known_hosts
nix run .#pve-authorize-ssh-pk
reboot pve
```

---

## 💿 ZFS Pool & Dataset Setup

```bash
nix run .#zfs-create-pool -- tank

nix run .#zfs-create-dataset -- tank jellyfin-data y 210
nix run .#zfs-create-dataset -- tank sabnzbd-data y 210
```

---

## 📦 CIFS Automounts

```bash
nix run .#create-cifs-automount -- movies mediarr y 210
nix run .#create-cifs-automount -- shows mediarr y 210
nix run .#create-cifs-automount -- music mediarr y 210

reboot pve
```

---

## ⚙️ iGPU Bootstrap

```bash
nix run .#igpu-host-bootstrap
reboot pve
```

---

## 🌎 Terraform Cloud Sync (Manual Step)

1. Reset Terraform Cloud state as needed.
2. Then apply:

   ```bash
   NIXPKGS_ALLOW_UNFREE=1 nix run .#proxmox-apply --impure
   reboot pve
   ```

---

## 🥉 LXC Patching

After containers are provisioned:

1. Remove CTs from the Tailscale Admin Console UI (**manual cleanup**).
2. Run:

   ```bash
   nix run .#tailscale-lxc-patch
   nix run .#igpu-lxc-patch
   reboot pve
   ```

---

## 🔐 Secrets Sync

```bash
nix run .#copy-sops-pk
```

---

## 🚀 Final Provisioning

Now provision all hosts declaratively:

```bash
NIXPKGS_ALLOW_UNFREE=1 colmena apply --on <host> --impure
```

---

## ✅ Summary

| Phase               | Description                                | Mode         |
| ------------------- | ------------------------------------------ | ------------ |
| **Proxmox Install** | Base installation + community post-install | 🧟 Manual    |
| **SSH Auth**        | Authorize local public key                 | 🔄 Automated |
| **ZFS Setup**       | Create pools & datasets                    | 🔄 Automated |
| **CIFS Mounts**     | Configure systemd automounts               | 🔄 Automated |
| **iGPU Bootstrap**  | Enable host GPU passthrough                | 🔄 Automated |
| **Terraform Reset** | Cloud state refresh                        | 🧟 Manual    |
| **LXC Patching**    | Add tun/dri mounts for CTs                 | 🔄 Automated |
| **SOPS Sync**       | Copy encryption keys                       | 🔄 Automated |
| **Colmena Apply**   | Final host provisioning                    | 🔄 Automated |

---

### 💬 Notes

* Manual steps are only required where **interactive approval or UI** is necessary (PVE post-install, Terraform reset, Tailscale cleanup).
* Everything else is reproducible via `nix run` or `colmena apply`.
* Keep this file versioned — it serves as the authoritative bootstrap logbook.

---
