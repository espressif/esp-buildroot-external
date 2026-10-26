################################################################################
#
# esp-system-dashboard
#
################################################################################

ESP_SYSTEM_DASHBOARD_VERSION = $(ESP_LINUX_EXAMPLES_VERSION)
ESP_SYSTEM_DASHBOARD_SITE = $(ESP_LINUX_EXAMPLES_SITE)
ESP_SYSTEM_DASHBOARD_SITE_METHOD = $(ESP_LINUX_EXAMPLES_SITE_METHOD)
ESP_SYSTEM_DASHBOARD_SUBDIR = examples/network/system-dashboard
ESP_SYSTEM_DASHBOARD_LICENSE = Apache-2.0, CC0-1.0
ESP_SYSTEM_DASHBOARD_LICENSE_FILES = LICENSE \
	$(ESP_SYSTEM_DASHBOARD_SUBDIR)/Makefile
ESP_SYSTEM_DASHBOARD_DEPENDENCIES = host-pkgconf libmicrohttpd
ESP_SYSTEM_DASHBOARD_OVERRIDE_SRCDIR_RSYNC_EXCLUSIONS = \
	--exclude=/docs/_build \
	--exclude=/$(ESP_SYSTEM_DASHBOARD_SUBDIR)/build

define ESP_SYSTEM_DASHBOARD_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/$(ESP_SYSTEM_DASHBOARD_SUBDIR) \
		$(TARGET_CONFIGURE_OPTS)
endef

define ESP_SYSTEM_DASHBOARD_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/$(ESP_SYSTEM_DASHBOARD_SUBDIR) \
		$(TARGET_CONFIGURE_OPTS) \
		DESTDIR="$(TARGET_DIR)" install
endef

$(eval $(generic-package))
