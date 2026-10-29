ESP_LINUX_EXAMPLES_COMMON_MK = \
	$(BR2_EXTERNAL_ESP_LINUX_BSP_PATH)/package/esp-linux-examples/esp-linux-examples.mk
ESP_LINUX_EXTERNAL_PACKAGES = \
	$(wildcard $(BR2_EXTERNAL_ESP_LINUX_BSP_PATH)/package/*/*.mk)

include $(ESP_LINUX_EXAMPLES_COMMON_MK)
include $(sort $(filter-out \
	$(ESP_LINUX_EXAMPLES_COMMON_MK),$(ESP_LINUX_EXTERNAL_PACKAGES)))

OPENSBI_DEPENDENCIES += host-esp-cross-linker-wrapper
UBOOT_DEPENDENCIES += host-esp-cross-linker-wrapper
