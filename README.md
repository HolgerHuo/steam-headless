# Steam Headless

Containerized gaming server with labwc desktop and Sunshine for streaming.

## Features

- Sunshine server with Moonlight-compatible desktop streaming
- Steam Client configured for Linux gaming and Proton
- labwc Wayland desktop with Waybar, fuzzel launcher, PCManFM file manager, and foot terminal
- PipeWire audio with Pulse compatibility
- AMD and Intel GPU support
- Controller support through Sunshine virtual input devices
- Root access inside the container
- Arch Linux base image

## Notes

### Additional Software

Put startup scripts in `~/init.d` with a `.sh` suffix to run them when the container starts.

### Storage Paths

Persist anything important under the home directory or another bind mount. Files outside persistent mounts can be lost when the container is recreated or updated.

### Games Library

Mount your games library at `/mnt/games` and add that path in Steam.

### Network Mode

The example Compose file uses host networking. This avoids common discovery and port-forwarding issues with Sunshine and Steam Remote Play.

## Docker Compose

These instructions assume Docker Compose is installed. Depending on your Docker installation, the command may be `docker compose` or `docker-compose`.

Download [deploy/docker-compose.yml](./deploy/docker-compose.yml) and [deploy/.env.example](./deploy/.env.example), set `DRI_CARD_NUM` and `DRI_RENDERD_NUM` to the desired `/dev/dri/card*` and `/dev/dri/renderD*` devices.

If you have multiple GPUs, map PCI devices to DRM nodes:

```shell
lspci | grep -E 'VGA|3D'
ls -la /sys/class/drm/card*
ls -l /sys/class/drm/renderD*
```

The default Wayland desktop uses `WLR_BACKENDS=drm,libinput`, `LIBSEAT_BACKEND=seatd`, and `SEATD_VTBOUND=0`. This uses the mapped DRM device for the wlroots output while allowing Sunshine virtual input devices to be read through libinput. Set `WLR_BACKENDS=headless,libinput` if you want a virtual wlroots output instead of a DRM/KMS session.

When running multiple containers on the same host, set a unique `SUNSHINE_INPUT_SEAT` for each container, such as `steam-a` and `steam-b`. Sunshine uses this as its input seat marker, and the container only relays virtual input devices matching its own marker.

Start the service:

```shell
sudo docker compose up -d
```

After the container starts, pair Moonlight with Sunshine and launch Desktop or Steam.
