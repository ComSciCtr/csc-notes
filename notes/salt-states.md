# salt-states
-------------

The visualization workstations are provisioned using `salt`.  The basic unit
in `salt` is a state, which can be anything from a particular package being
installed (or absent), to a user account existing on the system, or an entry
in the `/etc/hosts` file.

States are defined in `.sls` files and are written in [YAML][yaml]. The
sections below briefly cover some `salt` basics. For more information see the
[salt website][salt].

[yaml]: http://www.yaml.org
[salt]: http://www.saltstack.com/community


### connection between salt-master and salt-minion

Before a system can be provisioned,  it must first register its key with the
`salt-master`. To do this, you must first set the `master` variable in the
`minion` file and then restart the `salt-minion` service. This will send a
request to the `salt-master` specified in the minion file. On the machine
hosting the `salt-master` you can then accept the key, at which point the
minion can be provisioned by enforcing the `highstate`. 

On the minion machine, create (or edit) `/etc/salt/minion` file and specify
salt master.

   ```yaml
   master: iviz.csc.ucdavis.edu
   id: 'archer'
   ```

Then restart the salt minion service.

   ```sh
   $ sudo service salt-minion restart
   ```

On the master machine (`iviz.csc.ucdavis.edu`) list all keys. The new minion
machine should be listed in the **Pending** section.

   ```sh
   # salt-key -L
   ```

You can accept all pending keys with the following command.

   ```sh
   # salt-key -A
   ```

Or, if you have multiple keys pending you can select a single key with the 
following command.

   ```sh
   # salt-key -a <minion name>
   ```

To verify the connection to minions run the following command.

   ```sh
   # salt '*' test.ping
   ```


### minion grain data

Minions are provisioned based on grain values which are added to
`/etc/salt/minion`. For example, `archer` is currently set up to run the Oculus
Rift and requires some additional states. Here are example minion files for the
workstations.

Here is what `/etc/salt/minion` looks like on `archer`.

   ```yaml
   grains:
     display: dual-screen
     devices:
         - razer-hydra
         - oculus-rift
      roles:
         - iviz-workstation 
   ```


You can get a list of all grain data for a minion (or for all minions) by running.

   ```sh
   # salt '*' grains.items
   ```

You can also get the value of a specific grain.

   ```sh
   # salt '*' grain.item os
   ```


### provisioning machines

To update (provision) a machine you enforce the salt `highstate`. You run this 
command from the machine that hosts the `salt-master`. For example, if you wanted
to provision `archer` you would do the following.

   ```sh
   # salt 'archer' state.highstate
   ```

You can do a dry-run by adding `test=True` to the above command. Salt will
output all of the actions that would have been performed during a normal run. 


### running commands on minions

On of the really awesome things about `salt` is that it allows you to run 
arbitrary commands on minions using the `cmd.run` module. For example, to see 
the contents of all minion files you would run the following command.

   ```sh
   # salt '*' cmd.run 'cat /etc/salt/minion
   ```

