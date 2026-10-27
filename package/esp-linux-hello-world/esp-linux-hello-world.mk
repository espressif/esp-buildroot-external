################################################################################
#
# esp-linux-hello-world
#
################################################################################

ESP_LINUX_HELLO_WORLD_VERSION = $(ESP_LINUX_EXAMPLES_VERSION)
ESP_LINUX_HELLO_WORLD_SITE = $(ESP_LINUX_EXAMPLES_SITE)
ESP_LINUX_HELLO_WORLD_SITE_METHOD = $(ESP_LINUX_EXAMPLES_SITE_METHOD)
ESP_LINUX_HELLO_WORLD_SUBDIR = examples/get-started/hello-world
ESP_LINUX_HELLO_WORLD_LICENSE = Apache-2.0, CC0-1.0
ESP_LINUX_HELLO_WORLD_LICENSE_FILES = LICENSE \
	$(ESP_LINUX_HELLO_WORLD_SUBDIR)/Makefile
ESP_LINUX_HELLO_WORLD_OVERRIDE_SRCDIR_RSYNC_EXCLUSIONS = \
	--exclude=/docs/_build \
	--exclude=/$(ESP_LINUX_HELLO_WORLD_SUBDIR)/build

define ESP_LINUX_HELLO_WORLD_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/$(ESP_LINUX_HELLO_WORLD_SUBDIR) \
		$(TARGET_CONFIGURE_OPTS)
endef

define ESP_LINUX_HELLO_WORLD_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/$(ESP_LINUX_HELLO_WORLD_SUBDIR) \
		$(TARGET_CONFIGURE_OPTS) \
		DESTDIR="$(TARGET_DIR)" install
endef

$(eval $(generic-package))
