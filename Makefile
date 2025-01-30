# LuCI PeDitX Theme
# Copyright 2024 PeDitX <pedram.ale@me.com>
#
# Licensed under the Apache License v2.0
# http://www.apache.org/licenses/LICENSE-2.0

include $(TOPDIR)/rules.mk

THEME_NAME:=peditx
THEME_TITLE:=PeDitX

PKG_NAME:=luci-theme-$(THEME_NAME)
PKG_VERSION:=1.2.3
PKG_RELEASE:=01

include $(INCLUDE_DIR)/package.mk

define Package/luci-theme-$(THEME_NAME)
  SECTION:=luci
  CATEGORY:=LuCI
  SUBMENU:=4. Themes
  DEPENDS:=+libc
  TITLE:=LuCi Theme For OpenWrt - $(THEME_TITLE)
  URL:=http://t.me/peditx
  PKGARCH:=all
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/luci-theme-$(THEME_NAME)/install
	$(INSTALL_DIR) $(1)/etc/uci-defaults
	echo "uci set luci.themes.$(THEME_TITLE)=/luci-static/$(THEME_NAME); uci commit luci" > $(1)/etc/uci-defaults/30-luci-theme-$(THEME_NAME)
	$(INSTALL_DIR) $(1)/www/luci-static/$(THEME_NAME)
	$(CP) -a ./luasrc/* $(1)/www/luci-static/$(THEME_NAME)/ 2>/dev/null || true
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/view/themes/$(THEME_NAME)
	$(CP) -a ./template/* $(1)/usr/lib/lua/luci/view/themes/$(THEME_NAME)/ 2>/dev/null || true
	$(INSTALL_DIR) $(1)/www/luci-static/resources
	$(CP) -a ./js/* $(1)/www/luci-static/resources/ 2>/dev/null || true
	$(INSTALL_DIR) $(1)/www/luci-static/$(THEME_NAME)
	$(CP) -a ./luasrc/manifest.json $(1)/www/luci-static/$(THEME_NAME)/ 2>/dev/null || true
	$(INSTALL_DIR) $(1)/etc/config
	$(CP) -a ./root/etc/config/* $(1)/etc/config/ 2>/dev/null || true
endef

define Package/luci-theme-$(THEME_NAME)/postinst
#!/bin/sh
[ -n "$${IPKG_INSTROOT}" ] || {
	uci get luci.themes.peditx >/dev/null 2>&1 || \
	uci batch <<-EOF
		set luci.themes.peditx=/luci-static/$(THEME_NAME)
		set luci.main.mediaurlbase=/luci-static/$(THEME_NAME)
		commit luci
	EOF
}
exit 0
endef

$(eval $(call BuildPackage,luci-theme-$(THEME_NAME)))
