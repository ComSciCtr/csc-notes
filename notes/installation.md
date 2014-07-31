# workstation installation
--------------------------

The visualization workstations have been installed with the latest Ubuntu LTS
release (14.04). They are provisioned using [salt][salt]. The salt master is
running on `iviz.csc.ucdavis.edu`. 

Each machine has two storage devices, one solid-state drive and one hard-disk.
The SSD is used for the operating system and the HD is used for data. User 
accounts are mounted over the network, this allows users to access their files
from any workstation. Datasets on the hard-disks are managed using `git-annex`.

There are two nVidia graphics cards installed on each workstation. One is used
to run the display for the OS and the other is used to run the 3DTV. There is a
separate X server running for each display (`synergy` is used to share the
keyboard and mouse between the two displays). The motivation for this slightly
unusual configuration is that it allows visualization applications on the 3DTV 
to run without having to share resources with the desktop environment.

[salt]: http://www.saltstack.com/community


### install ubuntu
   
The installation process is fairly straight forward. When presented with the 
"installation type" option select "do something else". This will enable you to
manually select the partitions. The solid-state drive should be used for the 
OS; set the filesystem type to `ext4` and the mount point to `/`. For the 
hard-disk, set the filesystem type to `ext4` and the mount point to `/data`. 
**Do not format the hard-disk (`/data` partition).** 

These systems have a huge amount of memory making a swap partition unnecessary.
I generally setup a swapfile on `/data` with a size of 2GB. I think this could
probably be skipped, but the HDs have plenty of storage to spare.

As mentioned above the user accounts are mounted over the network. This means 
any user accounts that are created by the system will be mounted over once
`autofs` is installed during provisioning. In order to have a usable system
without a network connection (like at Maker Faire) a local demo account 
(`maker`) is created at `/data/home/maker`. This account also serves as the
system adminstrator.

However, an admin account is still needed in order to install `salt` and
bootstrap the system. The simplest way to deal with this is to create a
temporary admin account during installation, and then delete it once salt has
been run and the local admin account has been configured.


### install nvidia driver and update system

After the system reboots, log in as the temporary administrator and perform a
system update and install the proprietary nvidia driver. When this is finished
reboot the system.


### install and configure salt

Log in once more using the temporary admin account. Install `salt` and
provision the system.

First, add the salt PPA and install the `salt-minion` package.

   ```sh
   sudo add-apt-repository ppa:saltstack/salt
   sudo apt-get update
   sudo apt-get install salt-minion
   ```

Once `salt` is installed, configure the `minion` file and then restart the
`salt-minion` service. (See [salt-states](salt-states.html) for more details
and a complete `minion` example.)

Edit `/etc/salt/minion`.

   ```yaml
   master: iviz.csc.ucdavis.edu
   id: $MINION_ID
   ```

Then restart the salt-minion service.

   ```sh
   sudo service salt-minion restart
   ```

After the `salt-minion` service has restarted, log onto the machine running the
`salt-master` (`iviz.csc.ucdavis.edu`) and accept the key. From this point on 
you will be able to control the minion machine from the master.

Accept key on salt master.

   ```sh
   salt-key -a KEY_NAME
   ```

Finally, provision the system by running the following command to provision the
machine.

   ```sh
   # salt '*' state.highstate
   ```

At this point all the required software should be installed and configured.
The maker account should also exist. Log in as `maker` and verify that it
has admin access. You can now delete the temporary admin account. For example,
if you created a user named `tmp-admin` during the installation process you
would do the following (you will need to stop the `autofs` service first).

   ```sh
   sudo service autofs stop
   sudo deluser --remove-home tmp
   ```


### known issues

* Both `archer` and `cyril` have booted into "Low Graphics Mode". This is
sporadic and rebooting solved the problem.

* When getting `cyril` ready for the retreat the `xorg.conf` file was removed
at some point by the system (it was saved as `/etc/X11/xorg.conf.XXXXXXXX`
where `XXXXXXXX` is a number). These backup files exist on other machines, but
the original `xorg.conf` file has not been removed. Since I have not had access
to `cyril` I have not been able to determine the cause of this. Enforcing the
`salt` highstate should restore the proper `xorg.conf`.

* There are two ethernet ports on the motherboards. If you move the machine
and plug the ethernet cable to the "wrong" port you will not get the correct IP
address and `autofs` will not work properly.

