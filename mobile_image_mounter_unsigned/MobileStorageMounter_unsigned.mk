TARGET_OS_DEPLOYMENT_VERSION = 9.0
ARCHS = arm64
ADDITIONAL_CFLAGS = -Oz

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = MobileStorageMounter_unsigned
MobileStorageMounter_unsigned_FILES = MobileStorageMounter_unsigned.xm

include $(THEOS_MAKE_PATH)/tweak.mk
