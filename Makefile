TARGET := iphone:clang:13.0
PREFIX = $(THEOS)/toolchain/linux/usr/bin/
SYSROOT = $(THEOS)/sdks/iPhoneOS13.7.sdk
INSTALL_TARGET_PROCESSES = SpringBoard


include $(THEOS)/makefiles/common.mk

TWEAK_NAME = PinkClock

PinkClock_FILES = Tweak.x
PinkClock_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
