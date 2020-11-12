TARGET := iphone:clang:latest:7.0
INSTALL_TARGET_PROCESSES = Zebra
ARCHS = armv7 arm64 arm64e

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = ZebraWishlistForAll

ZebraWishlistForAll_FILES = Tweak.x
ZebraWishlistForAll_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
