#!/usr/bin/env bash

set -e

if [ "$#" -gt 0 ]; then
    exec "$@"
fi

function print_header {
    echo -e "\e[35m**** ${@} ****\e[0m"
}

function print_warning {
    echo -e "\e[33mWARNING: ${@}\e[0m"
}

function print_error {
    echo -e "\e[31mERROR: ${@}\e[0m"
}

function print_note {
    echo -e "\e[36mNOTE: ${@}\e[0m"
}

function print_done {
    echo -e "\e[34mDONE\e[0m"
}

for init_script in /etc/cont-init.d/*.sh ; do
    print_note "[ ${init_script:?}: executing... ]"
    source "${init_script:?}"
done

mkdir -p /home/player/init.d
chown -R player /home/player/init.d
for user_init_script in /home/player/init.d/*.sh ; do
    if [[ -e "${user_init_script:?}" ]]; then

        print_note "[ USER:${user_init_script:?}: executing... ]"
        sed -i 's/\r$//' "$(readlink -e "${user_init_script:?}")"

        chmod +x "${user_init_script:?}"
        (
            set +e
            "${user_init_script:?}" || print_error "Failed to execute user script '${user_init_script:?}'"
        )

    fi
done

print_header "Starting supervisord"
mkdir -p /var/log/supervisor
chmod a+rw /var/log/supervisor
exec /usr/bin/supervisord -c /etc/supervisord.conf --nodaemon --user root
