# luci-app-turboacc

一个适用于官方OpenWrt(24.10/snapshot) firewall3/firewall4的turboacc  
包括以下功能：软件流量分载、Shortcut-FE、全锥型 NAT、BBR 拥塞控制算法

目前仅测试了2025-11-20的x86平台的snapshot版本OpenWrt，fw3(iptables)和fw4(nftables)均可用

## 使用方法

+ 在openwrt源代码所在目录执行：

    ```bash
    curl -sSL https://raw.githubusercontent.com/mufeng05/turboacc/luci/add_turboacc.sh -o add_turboacc.sh && bash add_turboacc.sh
    ```

+ 之后执行

```bash
make menuconfig
```

+ 在 > LuCI > 3. Applications中选中luci-app-turboacc

## 注意

1. 软件流量分载默认使用`flow offloading`，可根据需要自行更换为`fast classifier`或`shortcut-fe`。
2. 因OpenWrt现在使用`firewall4`作为默认防火墙，如果切换为`firewall3`的话，请把所有与nft相关的包手动取消掉，并替换为相应的ipt包(例如: `iptables-nft`替换为`iptables-zz-legacy`)。

## 插件预览

![fw3预览](https://raw.githubusercontent.com/mufeng05/turboacc/luci/img/fw3.png)
![fw4预览](https://raw.githubusercontent.com/mufeng05/turboacc/luci/img/fw4.png)

## 关于

此仓库的luci-app-turboacc是基于LEDE仓库的[luci-app-turboacc](https://github.com/coolsnowwolf/luci/tree/master/applications/luci-app-turboacc)修改而来的，去除了DNS相关功能并使其支持firewall4，但不再支持firewall3。

各功能的依赖：

软件流量分载(Flow Offload)：[kmod-nft-offload](https://github.com/openwrt/openwrt/blob/80edfaf675364835e6d2e17d97ebec6afc6b2103/package/kernel/linux/modules/netfilter.mk#L1182C1-L1199C42)(官方openwrt自带)

Shortcut-FE：[shortcut-fe](https://github.com/chenmozhijin/turboacc/tree/package/shortcut-fe)、952补丁、953补丁

全锥型 NAT（FULLCONE NAT）：[nft-fullcone](https://github.com/fullcone-nat-nftables/nft-fullcone)、修补的firewall4、libnftnl、nftables与952补丁

BBR 拥塞控制算法：[kmod-tcp-bbr](https://github.com/openwrt/openwrt/blob/80edfaf675364835e6d2e17d97ebec6afc6b2103/package/kernel/linux/modules/netsupport.mk#L1036C1-L1057C38)(官方openwrt自带)

非官方openwrt自带的依赖存档在[package分支](https://github.com/chenmozhijin/turboacc/tree/package)。

## 感谢

 感谢以下项目：

+ [coolsnowwolf/lede](https://github.com/coolsnowwolf/lede)(952、953补丁与sfe来源)
+ [wongsyrone/lede-1](https://github.com/wongsyrone/lede-1)(firewall4、libnftnl、nftables修补补丁来源)
+ [fullcone-nat-nftables/nft-fullcone](https://github.com/fullcone-nat-nftables/nft-fullcone)(全锥型 NAT依赖)
