#!/usr/bin/env bash

print_header "Configure system locale"

requested_locale="${USER_LOCALES:-en_US.UTF-8 UTF-8}"
read -r user_locale _ <<< "${requested_locale}"
locale_available="$(LC_ALL=C locale -a | sed 's/utf8/UTF-8/I' | grep -Fx "${user_locale}" || true)"

if ! grep -Fxq "${requested_locale}" /etc/locale.gen || [ -z "${locale_available}" ]; then
    print_note "Configuring locale to ${requested_locale}"
    printf '%s\n' "${requested_locale}" > /etc/locale.gen
    if [ "${requested_locale}" != "en_US.UTF-8 UTF-8" ]; then
        printf '%s\n' "en_US.UTF-8 UTF-8" >> /etc/locale.gen
    fi
    LC_ALL=C locale-gen
    printf 'LANG=%s\n' "${user_locale}" > /etc/locale.conf
else
    print_note "Locales already set correctly to ${requested_locale}"
fi

export LANG="${user_locale}"
unset LC_ALL

print_done
