# documentation website
-----------------------

The vroom documentation website is hosted on [github pages][github-pages]
and uses [Middleman][middleman], a static-site generator written in ruby.

[github-pages]: https://pages.github.com
[middleman]: http://middlemanapp.com


### editing the site

There are basically two different scenarios when editing content on the
site.

If it is a minor edit (fixing typos, modifying text, etc.) then the easiest
way to go about it is the following.

1. clone the [vroom-website][vroom-website] repo from github.
2. edit the appropriate markdown file(s) in `source/documentation`
3. submit a [pull request][vroom-website-pulls] to `vroom-website`

The changes can then be merged into `master` by someone with read/write 
access.

If the changes are more substantial (changing site style/markup, modifying
metadata, adding pages, etc.) then you will need to have the necessary 
development environment setup. The easiest (and recommended) way to do this
is to use vagrant (see below).

[vroom-website]: https://github.com/ComSciCtr/vroom-website
[vroom-website-pulls]: https://github.com/ComSciCtr/vroom-website/pulls



### setting up the development environment

The vroom website comes with a `Vagrantfile` and a simple [salt][salt]
configuration for provisioning the VM. If you do not have [vagrant][vagrant]
installed you can download it [here][vagrant-downloads], as well as a virtual
machine provider (I use VirtualBox, but you can find a list of providers
[here][vagrant-providers].

Once you have these installed you need to install the base box used in the
`Vagrantfile`.

   ```sh
   vagrant box add ubuntu/trusty64
   ```

You only need to do the steps outlined above once, when you first install
vagrant from that point on you will use vagrant to interact with the VM.
Here is a brief list of commonly used vagrant commands, for more information
see the [vagrant documentation][vagrant-docs].

* bringing up a VM for development

   ```sh 
   vagrant up
   ```

  The first time you start a virtual machine it will use the base box specified
  in the `Vagrantfile` and automatically provision it. If, at a later point, you
  want to force the provisioner to run again (because of a change to the salt
  states for example) you will need to run `vagrant up --provision`.

* logging into VM

   ```sh
   vagrant ssh
   ```

  You can SSH into the running VM using the command above. The root directory 
  (the one with the `Vagrantfile` will be mapped to `/vagrant/` on the VM.
  Changes made in the VM will be seen on the host.

* shutting down the VM

   ```sh
   vagrant halt
   ```

  When you are done working on the site, you can stop the VM by running the 
  above command. The VM state will persist until the machine is destroyed
  (see below).

* destroying the VM

   ```sh
   vagrant destroy
   ```

  Vagrant boxes take up much less space than traditional VMs, but if you want
  to clear up some space on your disk you can delete a vagrant instance by
  running the above command. The next time you want to work on the site simply
  run `vagrant up` and the VM will be created and provisioned again.

[salt]: http://www.saltstack.com/community
[vagrant]: http://vagrantup.com
[vagrant-downloads]: http://vagrantup.com/downloads.html
[vagrant-providers]: http://docs.vagrantup.com/v2/providers/index.html


### using middleman

[Middleman][middleman] is a great tool for generating static websites. It
basically takes input files (usually [markdown][markdown]) and maps them to
html files. The processor that is used is determined from the input file name.
Multiple filters can be specified. For example, the file
`source/documentation/core/color.html.md.erb` is run through two processors;
first *erb* and then *markdown*.

There are only a few commands that you need to know to build and deploy the
site.

* building the site

   ```sh
   bundle exec middleman build
   ```

  This will create a static version of the site in the `build/` directory.
  There isn't as much of a reason for this now that we are using github
  pages for hosting, but you could build the site and then `scp` it to a 
  remote server if you wanted. If you want to view the generated site 
  locally you will need to run a local web server (`python -m SimpleHTTPServer`
  or `python -m http.server` depending on your python version).
  
* previewing the site

   ```sh
   bundle exec middleman
   ```

   Running the `middleman` command without any additional arguments will 
   start a websever on port `4567`. The `Vagrantfile` forwards this port
   to the host machine, so you can view the site as you are making changes
   by opening [localhost:4567](http://localhost:4567).

* pushing the site

   ```sh
   bundle exec middleman deploy
   ```

   Once you are satisfied with the changes that you've made to the site you
   can push the site to github pages with the above command. It will 
   automatically check out the proper branch and commit the changes.

[markdown]: http://daringfireball.net/projects/markdown/



### generating example screenshots

There are generally a number of code examples for each function. There should
also be a screenshot showing what the result of running the code would be.
These screenshots are generated automatically from the code in the markdown 
file. This makes it easy to create the images and has the added benefit of
verifying the code in examples (if the code is broken the image will not
be generated). There are two scripts used to generate the screenshot images:

* `tools/generate-vroom-screenshots.py`
* `tools/vroom-screenshot.sh`

The first iterates over all files in the `source/documentation/` directory
and creates a valid vroom program for each code example found. These are then
launched and a screenshot is taken after a brief wait to make sure that the
program has had time to properly initialize. If everything is configured
properly all that is needed is to do the following.

   ```sh
   cd tools/
   ./generate-vroom-screenshots.py
   ```

**NOTE:** The scripts should be run from the `tools/` directory.

**NOTE:** This obviously requires that vroom be installed on the host machine.
This means that the screenshots can only be generated on a Linux system with
the required hardware.

However, cropping the image is largely dependent on the window manager being
used. For example, I use a tiling window manager, but float vroom applications
centered on the screen. You may need to adjust the crop command used in
`tools/vroom-screenshot.sh`. 
