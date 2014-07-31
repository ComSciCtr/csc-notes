# git-annex
-----------

Each workstation has a solid-state drive and a hard-disk. The OS is installed
on the SSD and the hard-disk is mounted at `/data` and is designed to be used
for storing data used by various applications. Some of the data sets are rather
large, so simplify the process of synchronizing data we use
[git-annex][git-annex].

Git-annex is a tool for manage files with git, without checking the file 
contents into the repository. 

[git-annex]: https://git-annex.branchable.com/


### setting up the annex

This has already been done and should not have to be repeated. If for some reason
(`/data` gets re-formatted) you need to re-create the annex you would do the 
following.

   ```sh
   mkdir /data/annex
   cd /data/annex
   git init
   git annex init "archer"
   ```

Replace `archer` with whatever name you want the annex to be labelled by.

Next, set up the remotes. For illustrative purposes let's assume that we are
setting up an annex on `archer` and we want to share/synchronize data with
`lana` and `cryil`. The remotes are added in the standard way.

   ```sh
   git remote add lana ssh://lana/data/annex
   git remote add cyril ssh://cyril/data/annex
   ```

Then synchronize the repositories.

   ```sh
   git annex sync
   ```

This will sync with all remotes. To sync with a single remote simply pass the 
name as an argument to the `sync` call (`git annex sync lana`).

Once this has finished you should see a bunch of directories with symbolic links
(at first all of these will be broken).


### getting a file

To get a file from a remote use `git annex get`. For example, to get a copy of 
the `BlueMarble.png` file you would do the following.

   ```sh
   cd /data/annex
   git annex get ImageData/BlueMarble.png
   ```

If you are setting up an annex and want to copy everything you would run.

   ```sh
   git annex get .
   ```


### removing a file

To remove a file from an annex use `git annex drop`. Before dropping a file
git-annex will verify that the file exists in some other repository, so you
never have to worry about deleting the last copy of a file. If you are certain
that you want to completely delete a file you can use the `--force` flag to
override this behavior.


### additional features

Git-annex has a really cool feature that allows you to see how many copies
of a file exist and where they are located.  Here is an example of using
`whereis`.

   ```sh
   git annex whereis ImageData/BlueMarble.png
   (merging synced/git-annex into git-annex...)
   whereis ImageData/BlueMarble.png (3 copies) 
      5eb392a5-4956-4f1f-b949-8d63d594ee20 -- cyril (iviz)
      68415003-c24e-479e-9466-5bd79f1e47f4 -- lana (lana (iviz))
      9948e24a-f59d-11e3-914b-c77ff5594947 -- here (archer (iviz))
   ok
   ```
