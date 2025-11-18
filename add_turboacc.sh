#!/usr/bin/env bash
# shellcheck disable=SC2016

trap 'rm -rf "$TMPDIR"' EXIT
TMPDIR=$(mktemp -d) || exit 1

if ! [ -d "./package" ]; then
    echo "./package not found"
    exit 1
fi

kernel_versions="$(find "./target/linux/generic" | sed -n '/kernel-[0-9]/p' | sed -e "s@./target/linux/generic/kernel-@@" | sed ':a;N;$!ba;s/\n/ /g')"
if [ -z "$kernel_versions" ]; then
    echo "Error: Unable to get kernel version, script exited"
    exit 1
fi
echo "kernel version: $kernel_versions"

git clone --depth=1 --single-branch https://github.com/mufeng05/turboacc "$TMPDIR/turboacc" || exit 1

for kernel_version in $kernel_versions; do
    if [ "$kernel_version" = "6.12" ] || [ "$kernel_version" = "6.6" ]; then
        cp "$TMPDIR/turboacc/hack-$kernel_version/952-add-net-conntrack-events-support-multiple-registrant.patch" "./target/linux/generic/hack-$kernel_version"
        cp "$TMPDIR/turboacc/hack-$kernel_version/953-net-patch-linux-kernel-to-support-shortcut-fe.patch" "./target/linux/generic/hack-$kernel_version"
        cp "$TMPDIR/turboacc/hack-$kernel_version/982-add-bcm-fullconenat-support.patch" "./target/linux/generic/hack-$kernel_version"
        cp "$TMPDIR/turboacc/hack-$kernel_version/983-add-bcm-fullconenat-to-nft.patch" "./target/linux/generic/hack-$kernel_version"
        cp "$TMPDIR/turboacc/pending-$kernel_version/613-netfilter_optional_tcp_window_check.patch" "./target/linux/generic/pending-$kernel_version"

        if ! grep -q "CONFIG_SHORTCUT_FE" "./target/linux/generic/config-$kernel_version"; then
            echo "# CONFIG_SHORTCUT_FE is not set" >> "./target/linux/generic/config-$kernel_version"
        fi
    else
        echo "Unsupported kernel version: $kernel_version"
        exit 1
    fi
done

mkdir "./package/turboacc"
cp -r "$TMPDIR/turboacc/luci-app-turboacc" "./package/turboacc"
cp -r "$TMPDIR/turboacc/fullconenat" "./package/turboacc"
cp -r "$TMPDIR/turboacc/fullconenat-nft" "./package/turboacc"

sed -i 's|include ../../luci.mk|include $(TOPDIR)/feeds/luci/luci.mk|g' "./package/turboacc/luci-app-turboacc/Makefile"

mkdir -p ./package/network/config/firewall/patches && cp -r "$TMPDIR/turboacc/patches/firewall/patches/"* ./package/network/config/firewall/patches/
mkdir -p ./package/network/config/firewall4/patches && cp -r "$TMPDIR/turboacc/patches/firewall4/patches/"* ./package/network/config/firewall4/patches/
mkdir -p ./package/network/utils/iptables/patches && cp -r "$TMPDIR/turboacc/patches/iptables/patches/"* ./package/network/utils/iptables/patches/
mkdir -p ./package/network/utils/nftables/patches && cp -r "$TMPDIR/turboacc/patches/nftables/patches/"* ./package/network/utils/nftables/patches/
mkdir -p ./package/libs/libnftnl/patches && cp -r "$TMPDIR/turboacc/patches/libnftnl/patches/"* ./package/libs/libnftnl/patches/

sed -i '/^DEPENDS:=/ s/$/ +iptables-mod-fullconenat/' ./package/network/config/firewall/Makefile
sed -i '/^DEPENDS:=/ s/$/ +kmod-nft-fullcone/' ./package/network/utils/nftables/Makefile

echo "Finish"
exit 0
