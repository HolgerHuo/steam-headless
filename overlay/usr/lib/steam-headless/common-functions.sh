#!/usr/bin/env bash

wait_until() {
    local description="${1:?}"
    shift

    local count=0
    until "$@" >/dev/null 2>&1; do
        sleep 1
        count=$(( count + 1 ))
        if [ "${count}" -ge 60 ]; then
            echo "FATAL: $0: Gave up waiting for ${description}"
            exit 11
        fi
    done
}

wait_for_file() {
    local path="${1:?}"
    local description="${2:-file ${path}}"
    wait_until "${description}" test -f "${path}"
}

wait_for_socket() {
    local path="${1:?}"
    local description="${2:-socket ${path}}"
    wait_until "${description}" test -S "${path}"
}

wait_for_command() {
    local description="${1:?}"
    shift
    wait_until "${description}" "$@"
}

wait_for_wayland() {
    wait_for_socket "${XDG_RUNTIME_DIR:?}/${WAYLAND_DISPLAY:?}" "Wayland socket ${XDG_RUNTIME_DIR}/${WAYLAND_DISPLAY}"
}

wait_for_session_dbus() {
    wait_for_socket "${XDG_RUNTIME_DIR}/bus" "DBus session bus"
}
