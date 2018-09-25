TARGET_OS_DEPLOYMENT_VERSION = 9.0
ARCHS = arm64

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = lockdownd_is_jailbroken
lockdownd_is_jailbroken_FILES = lockdownd_is_jailbroken.xm

include $(THEOS_MAKE_PATH)/tweak.mk
