################################################################################
#
# esp-linux-blink
#
################################################################################

ESP_LINUX_BLINK_VERSION = $(ESP_LINUX_EXAMPLES_VERSION)
ESP_LINUX_BLINK_SITE = $(ESP_LINUX_EXAMPLES_SITE)
ESP_LINUX_BLINK_SITE_METHOD = $(ESP_LINUX_EXAMPLES_SITE_METHOD)
ESP_LINUX_BLINK_SUBDIR = examples/get-started/blink
ESP_LINUX_BLINK_LICENSE = Apache-2.0, CC0-1.0
ESP_LINUX_BLINK_LICENSE_FILES = LICENSE \
	$(ESP_LINUX_BLINK_SUBDIR)/Makefile
ESP_LINUX_BLINK_DEPENDENCIES = host-pkgconf libgpiod
ESP_LINUX_BLINK_OVERRIDE_SRCDIR_RSYNC_EXCLUSIONS = \
	--exclude=/docs/_build \
	--exclude=/$(ESP_LINUX_BLINK_SUBDIR)/build

define ESP_LINUX_BLINK_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/$(ESP_LINUX_BLINK_SUBDIR) \
		$(TARGET_CONFIGURE_OPTS)
endef

define ESP_LINUX_BLINK_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/$(ESP_LINUX_BLINK_SUBDIR) \
		$(TARGET_CONFIGURE_OPTS) \
		DESTDIR="$(TARGET_DIR)" install
endef

$(eval $(generic-package))
