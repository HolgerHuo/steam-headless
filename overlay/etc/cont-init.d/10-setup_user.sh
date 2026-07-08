#!/usr/bin/env bash

print_header "Configure container user"

print_note "Setting container user uid=${PUID} gid=${PGID}"
usermod -o -u "${PUID}" player
groupmod -o -g "${PGID}" player

print_note "Setting device permissions"
input_devices=( /dev/uinput /dev/uhid )
for dev_node in "${input_devices[@]}"; do
    if [[ -c "${dev_node}" ]]; then
        chgrp input "${dev_node}" && chmod 0660 "${dev_node}"
    fi
done

card_devices=( /dev/dri/card* )
for dev_node in "${card_devices[@]}"; do
    if [[ -c "${dev_node}" ]]; then
        chgrp video "${dev_node}" && chmod 0660 "${dev_node}"
    fi
done

render_devices=( /dev/dri/renderD* )
for dev_node in "${render_devices[@]}"; do
    if [[ -c "${dev_node}" ]]; then
        chgrp render "${dev_node}" && chmod 0660 "${dev_node}"
    fi
done

print_note "Setting umask to ${UMASK}";
umask ${UMASK}

if [[ ! -f "/home/player/.config/sunshine/sunshine.conf" ]]; then
    print_note "Initializing default home directory."
    chown -R "${PUID}:${PGID}" /templates/home
    mkdir -p "/home/player"
    rsync -aq /templates/home/ /home/player/
else
    print_note "Home directory already initialized"
fi

XDG_RUNTIME_DIR="/run/user/${PUID}"
print_note "Create session runtime directory '${XDG_RUNTIME_DIR}'"
mkdir -p "${XDG_RUNTIME_DIR}"
chown -R "${PUID}:${PGID}" "${XDG_RUNTIME_DIR}"
chmod 700 "${XDG_RUNTIME_DIR}"

print_done
