# packaging
-----------

At this point pretty much everything that we use on the workstations is
packaged and available in the [KeckCAVES PPA][keckcaves-ppa]. There are some
benefits and drawbacks to this approach. On the plus side, packages are
automatically created for all currently supported Ubuntu releases (both 32 and
64-bit architectures). The trade-off is that there is some lag between the time
a re-build is triggered and when the updated package shows up in the repo. I
think that it is worth the slight delay, but if you find this unacceptable
there is an override option in the `salt-states` configuration.

[keckcaves-ppa]: https://launchpad.net/~keckcaves/+archive/ubuntu/ppa


### using the ppa

To add the [KeckCAVES PPA][keckcaves-ppa] to your system run the following
commands.

   ```sh
   sudo add-apt-repository keckcaves/ppa
   sudo apt-get update
   ```

You should now see VRUI, and related software in your package repository.
To get a list of all packages available in the KeckCAVES PPA run the
following command.

   ```sh
   aptitude search "?origin(keckcaves)?architecture(native)"
   ```

### list of packages 

Here is a list of software that is maintained by CSC and packaged by KeckCAVES.

* flow
* mycelia
* python-mycelia
* python-pyvrui
* vroom
* vroom-examples
* vrui-launcher

Additionally, the `python-pyftgl` package is required by vroom and packaged by
KeckCAVES.


### updating packages

If you decide to continue packaging for Ubuntu, this is the procedure for
updating. For illustrative purposes, let's assume that a bug was found in the
vroom source code.

**NOTE:** We do not maintain the packages or the scripts used to generate them.
This is all done by individuals in the Geology department who have been kind
enough to add our packages to their system.

1. edit source code and fix bug

2. commit changes to `vroom` repo

3. push changes github

   The `packaging` scripts are all configured to pull from
   `github.com/ComSciCtr` so make sure this is set as your `origin`.

3. fork `packaging` repo ([github.com/KeckCAVES/packaging][packaging]) if you
   haven't done so already.

4. update `SRCREV` variable in `share/sw/vroom/vars`

   The new value for this should be the hash of the latest git commit.
   You can run `git log` to get the hash.

5. commit changes to `packaging` repo

6. submit a [pull request][packaging-pulls] to `packaging`

Once the pull request has been accepted the packages will be built automatically. 
The next time you run `sudo apt-get update` on a system that has added the PPA
the `vroom` package will be updated.

[packaging]: https://github.com/KeckCAVES/packaging
[packaging-pulls]: https://github.com/KeckCAVES/packaging/pulls
