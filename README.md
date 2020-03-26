# Dotfiles

Configuration files to make nixos work.

### Cheatsheet

#### Configure

Edit `/etc/nixos/configuration.nix` and then:

```bash
nixos-rebuild switch
```

#### Install

```bash
nix-env -f '<nixpkgs>' -iA xorg.xproto
```
