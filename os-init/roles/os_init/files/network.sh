#!/bin/bash
enoname=`nmcli device status | awk '$2~/ethernet/{print $4}'`
KernelVersion=$(uname -r| cut -d "." -f 1)
cp /etc/sysconfig/network-scripts/ifcfg-$enoname /etc/sysconfig/network-scripts/networkcard.bak
oldname=NAME\=$enoname
newname=NAME\={{ifcfg_name}}
sed -i "s/$oldname/$newname/" /etc/sysconfig/network-scripts/ifcfg-$enoname
olddname=DEVICE\=$enoname
newdname=DEVICE\={{ifcfg_name}}
sed -i "s/$olddname/$newdname/" /etc/sysconfig/network-scripts/ifcfg-$enoname
mv /etc/sysconfig/network-scripts/ifcfg-$enoname /etc/sysconfig/network-scripts/ifcfg-{{ifcfg_name}}
cp -r /etc/default/grub /etc/default/grub.bak
#strb=\GRUB_CMDLINE_LINUX\=\"rd.lvm.lv\=centos\/root\ rd.lvm.lv\=centos\/swap\ crashkernel\=auto\ rhgb\ quiet\ net.ifnames\=0\ biosdevname\=0\"
if [ $KernelVersion -gt 3 ]; then
    rocky8=\GRUB_CMDLINE_LINUX\=\"crashkernel\=auto\ resume\=\/dev\/mapper\/rl-swap\ rd.lvm.lv\=rl\/root\ rd.lvm.lv\=rl\/swap\ rhgb\ quiet\ net.ifnames\=0\ biosdevname\=0\"
    sed -i 's/^.*GRUB_CMDLINE_LINUX/\#&/g'  /etc/default/grub
    echo $rocky8 >> /etc/default/grub
    grub2-mkconfig -o /boot/grub2/grub.cfg
else
    centos7=\GRUB_CMDLINE_LINUX\=\"crashkernel\=auto\ rd.lvm.lv\=centos\/root\ rd.lvm.lv\=centos\/swap\ rhgb\ quiet\ net.ifnames\=0\ biosdevname\=0\"
    sed -i 's/^.*GRUB_CMDLINE_LINUX/\#&/g'  /etc/default/grub
    echo $centos7 >> /etc/default/grub
    grub2-mkconfig -o /boot/grub2/grub.cfg
fi

#修改了grub，必须重启才可生效
