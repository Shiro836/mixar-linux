#!/bin/sh
# SPDX-FileCopyrightText: 2026 Adeveda Enterprises Private Limited
#
# SPDX-License-Identifier: GPL-2.0-or-later

# Launcher for the packaged Mixar portable tree in /opt/mixar.
#
#   MIXAR_LINUX_BACKEND=x11   (default) X11, i.e. XWayland on a Wayland desktop.
#                             The Agent Bubble's own window chrome (borderless
#                             island, capsule pill with Mixie, header drag,
#                             minimise to the pill) is only implemented there.
#   MIXAR_LINUX_BACKEND=auto  Blender's own choice: native Wayland when available,
#                             where the bubble falls back to ordinary decorated
#                             windows. "wayland" means the same.

case "${MIXAR_LINUX_BACKEND:-x11}" in
	x11 | X11)
		if [ -z "${DISPLAY:-}" ]; then
			if [ -n "${MIXAR_LINUX_BACKEND:-}" ]; then
				echo "mixar: MIXAR_LINUX_BACKEND=x11 but DISPLAY is unset (no X server or XWayland)." >&2
				exit 1
			fi
			# Only the default asked for X11: without one, run natively.
			exec /opt/mixar/mixar "$@"
		fi
		# GHOST tries Wayland first and only falls back to X11 when that fails.
		# Unset, libwayland would default to the wayland-0 socket and connect
		# anyway; set but empty, it names no socket and the attempt fails cleanly.
		WAYLAND_DISPLAY= exec /opt/mixar/mixar "$@"
		;;
	auto | AUTO | wayland | Wayland | '')
		exec /opt/mixar/mixar "$@"
		;;
	*)
		echo "mixar: MIXAR_LINUX_BACKEND must be 'x11' or 'auto', got '$MIXAR_LINUX_BACKEND'." >&2
		exit 1
		;;
esac
