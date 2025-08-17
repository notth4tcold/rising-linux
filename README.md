# Ricing Linux - Guia Completo

&#x20;&#x20;

Este repositório contém um guia completo para configurar um ambiente Linux minimalista e estético, com **Sway**, **Wayland**, gerenciadores de janelas, temas GTK, áudio e muito mais.

---

## Estrutura do Repositório

| Arquivo / Pasta | Descrição                                              |
| --------------- | ------------------------------------------------------ |
| `.config/`      | Exemplo de configuração pessoal dos utilitários e apps |
| `backup.sh`     | Script automatizado de backup                          |

---

## SWAY (Tiling Window Manager)

### Instalação

```bash
sudo pacman -S sway
```

**Inclui:**

- `sway` → compositor/gerenciador de janelas
- `swaybg` → plano de fundo
- `swaylock` → bloqueio de sessão
- `swayidle` → gerenciamento de suspensão
- `swaymsg` → enviar comandos para Sway

### Configurações

- Global: `/etc/sway/config`
- Usuário: `~/.config/sway/config`

Copiar config para usuário:

```bash
mkdir -p ~/.config/sway
cp /etc/sway/config ~/.config/sway/config
```

Recarregar config:

```bash
swaymsg reload
```

> Mod key pode ser alterado para `Mod1` (Alt).

---

## WOFI (Launcher de Apps)

### Instalação

```bash
sudo pacman -S wofi
```

### Configurações

- `~/.config/wofi/config`
- `~/.config/wofi/style.css`

Executar:

```bash
wofi --show drun
```

---

## LY (Login Manager)

### Instalação

```bash
yay -S ly
```

- Binário: `/usr/bin/ly`
- Config: `/etc/ly/config.ini`

### Ativar no boot

```bash
sudo systemctl enable ly.service
sudo systemctl start ly.service
```

Desativar outros (ex: GDM):

```bash
sudo systemctl disable gdm.service
```

---

## GRUB (Bootloader)

### Instalação

```bash
sudo pacman -S grub efibootmgr os-prober
```

- Binários: `/usr/bin/grub-install`, `/usr/bin/grub-mkconfig`
- Config: `/etc/default/grub`, `/boot/grub/`

### Instalar GRUB (UEFI)

```bash
sudo grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
```

### Gerar configuração

```bash
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

### Detectar Windows

```bash
sudo nano /etc/default/grub
# GRUB_DISABLE_OS_PROBER=false
sudo os-prober
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

### Configurar Windows manualmente

```bash
sudo mkdir -p /mnt/windows-efi
sudo mount /dev/nvme0n1p1 /mnt/windows-efi
ls /mnt/windows-efi/EFI/Microsoft/Boot/bootmgfw.efi
sudo nano /etc/grub.d/40_custom
```

```text
menuentry "Windows 11" {
    insmod part_gpt
    insmod fat
    set root='hd0,gpt1'
    chainloader /EFI/Microsoft/Boot/bootmgfw.efi
}
```

```bash
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

---

## Network Manager (Wi-Fi/Ethernet)

### Instalação

```bash
sudo pacman -S networkmanager network-manager-applet
```

### Ativar e iniciar serviço

```bash
sudo systemctl enable --now NetworkManager
sudo systemctl start NetworkManager
```

### Conectar na rede

```bash
nmcli dev wifi list
nmcli dev wifi connect NOMEDAREDE password "SENHA"
nmcli connection modify NOMEDAREDE connection.autoconnect yes
```

Desativar systemd-networkd (opcional):

```bash
sudo systemctl disable --now systemd-networkd.service
sudo systemctl mask systemd-networkd.service
```

---

## PIPEWIRE (Áudio/Multimídia)

### Instalação

```bash
sudo pacman -S pipewire pipewire-alsa pipewire-pulse pipewire-jack pipewire-media-session
sudo pacman -S pavucontrol
```

### Serviços do usuário

```bash
systemctl --user enable pipewire pipewire-pulse pipewire-media-session
systemctl --user start pipewire pipewire-pulse pipewire-media-session
```

### Configurações

- Globais: `/etc/pipewire/`
- Usuário: `~/.config/pipewire/`

---

## KITTY (Terminal)

### Instalação

```bash
sudo pacman -S kitty
```

Configuração: `~/.config/kitty/kitty.conf`

---

## NEMO (File Manager)

### Instalação

```bash
sudo pacman -S nemo nemo-fileroller gvfs gvfs-smb ntfs-3g
```

Montar automaticamente Windows:

```bash
sudo nano /etc/fstab
/dev/nvme0n1p3 /mnt/windows ntfs-3g defaults,uid=1000,gid=1000 0 0
```

---

## GTK (Temas)

```bash
yay themix-full-git
sudo pacman -S dconf-editor dconf
```

- Abrir themix, criar tema e exportar para `~/.theme`
- Alterar tema com `dconf-editor`

---

## WAYBAR (Barra de Status)

```bash
sudo pacman -S waybar
```

- Config global: `/etc/xdg/waybar/`
- Config usuário: `~/.config/waybar/` (`config`, `style.css`)

---

## EWW (Widgets)

```bash
yay -S eww-git
```

- Binário: `/usr/bin/eww`
- Config: `~/.config/eww/`

---

## Configurações Gerais

### Wi-Fi

```bash
sudo systemctl enable --now iwd
iwctl
device list
station wlan0 scan
station wlan0 get-networks
station wlan0 connect NOMEDAREDE
exit
```

### Timezone

```bash
sudo timedatectl set-timezone America/Sao_Paulo
```

### Language / Locale

```bash
sudo nano /etc/locale.conf
LANG=en_US.UTF-8
sudo nano /etc/locale.gen
# descomente en_US.UTF-8 UTF-8
sudo locale-gen
export LANG=en_US.UTF-8
```

### Driver NVIDIA (Wayland)

```bash
sudo pacman -S nvidia nvidia-utils nvidia-settings nvidia-dkms
sudo nano /etc/modprobe.d/nvidia.conf
# adicionar: options nvidia-drm modeset=1
sudo mkinitcpio -P
reboot
```

Validar:

```bash
lsmod | grep nvidia
nvidia-smi
```

---

## Backup

### Backup automático:

```bash
chmod +x backup.sh
./backup.sh
```

Processo:

- Copia de arquivos de configurações (Eww, Kitty, Sway, Waybar, Wofi)

---

💡 **Dicas finais:**

- Use `systemctl status` para verificar serviços
- Faça backup de `/etc/sway/` e `/etc/default/grub`
- Aproveite o ambiente minimalista e personalizável do Sway + Wayland

---

Faça sua instalação com segurança, estilo e eficiência. Bom ricing!
