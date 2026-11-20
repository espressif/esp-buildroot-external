#!/bin/bash
#
# Thin hook: image packaging lives in esp-linux-bsp.

set -eu

IMAGES_DIR="$1"
STORAGE_TYPE="${2:-nor}"

[ "$STORAGE_TYPE" = "nor" ] || {
    echo "✗ Error: ESP32-S31 only supports NOR image packaging"
    exit 1
}

set -a
# shellcheck disable=SC1090
source "${BR2_CONFIG:-${CONFIG_DIR:+$CONFIG_DIR/.config}}" >/dev/null 2>&1 || true
set +a

apply_kernel_overlays() {
    [ -n "${BR2_LINUX_KERNEL_INTREE_DTSO_NAMES:-}" ] || return

    local dtb_name dtb merged_dtb overlay overlay_name
    local overlays=()
    local fdtoverlay="${HOST_DIR}/bin/fdtoverlay"
    local fdtget="${HOST_DIR}/bin/fdtget"

    dtb_name="$(basename "${BR2_LINUX_KERNEL_INTREE_DTS_NAME%% *}").dtb"
    dtb="$IMAGES_DIR/$dtb_name"
    merged_dtb="${dtb}.merged"

    [ -f "$dtb" ] || {
        echo "✗ Error: kernel DTB not found: $dtb"
        exit 1
    }
    [ -x "$fdtoverlay" ] || {
        echo "✗ Error: fdtoverlay not found: $fdtoverlay"
        exit 1
    }

    for overlay in ${BR2_LINUX_KERNEL_INTREE_DTSO_NAMES}; do
        overlay_name="$(basename "$overlay").dtbo"
        [ -f "$IMAGES_DIR/$overlay_name" ] || {
            echo "✗ Error: kernel DT overlay not found: $IMAGES_DIR/$overlay_name"
            exit 1
        }
        overlays+=("$IMAGES_DIR/$overlay_name")
    done

    echo "Applying kernel DT overlays to $dtb_name"
    "$fdtoverlay" -i "$dtb" -o "$merged_dtb" "${overlays[@]}"

    if [ -x "$fdtget" ]; then
        local rootfs_mtd_name
        rootfs_mtd_name="$(
            "$fdtget" "$merged_dtb" /soc/flash@40b00000 linux,mtd-name 2>/dev/null || true
        )"
        if [ "$rootfs_mtd_name" != "rootfs" ]; then
            echo "✗ Error: merged ESP32-S31 DTB does not define the rootfs MTD device"
            exit 1
        fi
    fi

    mv "$merged_dtb" "$dtb"
}

# Locate esp-linux-bsp. Resolution order:
#   1) ESP_BSP_DIR if set (manual override / CI).
#   2) host package install dir (when BR2_PACKAGE_HOST_ESP_LINUX_BSP fetched it).
#   3) sibling checkout next to the buildroot tree (dev convenience).
if [ -z "${ESP_BSP_DIR:-}" ]; then
    if [ -x "${HOST_DIR:-}/share/esp-linux-bsp/tools/buildroot_post_image.sh" ]; then
        ESP_BSP_DIR="${HOST_DIR}/share/esp-linux-bsp"
    else
        ESP_BSP_DIR="$(pwd)/../esp-linux-bsp"
    fi
fi
ORCH="$ESP_BSP_DIR/tools/buildroot_post_image.sh"
if [ ! -x "$ORCH" ]; then
    echo "✗ Error: esp-linux-bsp orchestrator not found: $ORCH (set ESP_BSP_DIR)"
    exit 1
fi

apply_kernel_overlays

exec "$ORCH" esp32s31 "$STORAGE_TYPE" "$IMAGES_DIR"
