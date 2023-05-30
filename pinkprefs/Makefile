TARGET := iphone:clang:14.5:12.0
THEOS_PACKAGE_SCHEME = rootless

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = pinkprefs

pinkprefs_FILES = PINKRootListController.m
pinkprefs_FRAMEWORKS = UIKit
pinkprefs_PRIVATE_FRAMEWORKS = Preferences
pinkprefs_INSTALL_PATH = /Library/PreferenceBundles
pinkprefs_CFLAGS = -fobjc-arc
pinkprefs_LIBRARIES = colorpicker
# pinkprefs_EXTRA_FRAMEWORKS = Cephei CepheiPrefs Alderis

include $(THEOS_MAKE_PATH)/bundle.mk
