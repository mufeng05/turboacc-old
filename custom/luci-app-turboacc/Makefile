# SPDX-Identifier-License: GPL-3.0-only
#
# Copyright (C) 2024 Lean <coolsnowwolf@gmail.com>
# Copyright (C) 2019-2022 ImmortalWrt.org

include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-turboacc

PKG_CONFIG_DEPENDS:= \
	CONFIG_PACKAGE_TURBOACC_INCLUDE_NO_FASTPATH \
	CONFIG_PACKAGE_TURBOACC_INCLUDE_FLOW_OFFLOADING \
	CONFIG_PACKAGE_TURBOACC_INCLUDE_FAST_CLASSIFIER \
	CONFIG_PACKAGE_TURBOACC_INCLUDE_SHORTCUT_FE_CM \
	CONFIG_PACKAGE_TURBOACC_INCLUDE_BBR_CCA \
  CONFIG_PACKAGE_TURBOACC_INCLUDE_FULLCONE \
  CONFIG_TURBOACC_FULLCONE_NFT \
	CONFIG_TURBOACC_FULLCONE_IPT

PKG_LICENSE:=GPL-3.0-only
PKG_MAINTAINER:=Tianling Shen <cnsztl@immortalwrt.org>

LUCI_TITLE:=LuCI support for FastPath (FW3 or FW4)
LUCI_DEPENDS:= \
	+PACKAGE_TURBOACC_INCLUDE_FLOW_OFFLOADING:kmod-ipt-offload \
	+PACKAGE_TURBOACC_INCLUDE_FAST_CLASSIFIER:kmod-fast-classifier \
	+PACKAGE_TURBOACC_INCLUDE_SHORTCUT_FE_CM:kmod-shortcut-fe-cm \
	+PACKAGE_TURBOACC_INCLUDE_BBR_CCA:kmod-tcp-bbr \
	+TURBOACC_FULLCONE_NFT:kmod-nft-fullcone \
	+TURBOACC_FULLCONE_IPT:iptables-mod-fullconenat
LUCI_PKGARCH:=all

define Package/luci-app-turboacc/config
  choice
    prompt "FastPath Engine"
    default PACKAGE_TURBOACC_INCLUDE_FLOW_OFFLOADING if !(TARGET_qualcommax)

    config PACKAGE_TURBOACC_INCLUDE_NO_FASTPATH
    bool "Disable" if (TARGET_qualcommax)

    config PACKAGE_TURBOACC_INCLUDE_FLOW_OFFLOADING
    bool "Use flow offloading"

    config PACKAGE_TURBOACC_INCLUDE_FAST_CLASSIFIER
    bool "Use fast classifier"

    config PACKAGE_TURBOACC_INCLUDE_SHORTCUT_FE_CM
    bool "Use shortcut-fe connection manager"
  endchoice

  config PACKAGE_TURBOACC_INCLUDE_BBR_CCA
    bool "Enable BBR CCA"
    default y

  config PACKAGE_TURBOACC_INCLUDE_FULLCONE
    bool "Include fullcone NAT"
    default y

  config TURBOACC_FULLCONE_NFT
    bool "Use nftables fullcone"
    depends on PACKAGE_TURBOACC_INCLUDE_FULLCONE
    depends on PACKAGE_firewall4
    select PACKAGE_kmod-nft-fullcone

  config TURBOACC_FULLCONE_IPT
    bool "Use iptables fullcone"
    depends on PACKAGE_TURBOACC_INCLUDE_FULLCONE
    depends on PACKAGE_firewall
    select PACKAGE_iptables-mod-fullconenat
endef

include $(TOPDIR)/feeds/luci/luci.mk

# call BuildPackage - OpenWrt buildroot signature
