# Adding extra disk volume in aws instance


**Expand the Amazon EBS root volume of my Amazon EC2 Linux instance**

- With user name and password, sign in to your amazon web services console page;

- click `Elastic Block Store` panel

- go to Elastic Block Store click `Volumes`

**_ADD-VOLUME_**

* click default web server instance

* simply select "Actions" in the right corner.

* click `Modify volume`info 

![Volumes EC2 Management Console](https://user-images.githubusercontent.com/88568938/207848410-6447b3f2-2ea2-462c-9338-2e9d0b7cede5.png)

**_MODIFY-VOLUME_**

* to modify-volume information

* check volume details

* modify "Size (GiB)Info" in addition to the amount requested 150GiB

* then click modify 

![Modify volume EC2 Management Console](https://user-images.githubusercontent.com/88568938/207834118-2bd1b2ae-c1a0-48b8-aebf-5c05f576a2b0.png)

now check web-server instance root `size` changed

![Volumes EC2 Management Console](https://user-images.githubusercontent.com/88568938/207834139-e994f995-f7be-487d-89fe-4ac47f118535.png)

After adding volume in aws console page go to linux terminal and login linux instance


**_Terminal-work_**

**_To extend the file system of EBS volumes_**

1. Connect to your instance.

Resize the partition, if needed. To do so:

2. Check whether the volume has a partition. Use the lsblk command.

```bash
sudo lsblk 
```
It will appear as seen in below

```diff
NAME    MAJ:MIN RM SIZE RO TYPE MOUNTPOINT
xvda    202:0    0  50G  0 disk
└─xvda1 202:1    0  40G  0 part /
```

3. Extend the partition. Use the growpart command and specify the partition to extend.

* For example, to extend a partition named xvda1, use the following command.

```bash 
Important
Note the space between the device name (xvda) and the partition number (1).
```
```bash
sudo growpart /dev/xvda 1
```

![growpart](https://user-images.githubusercontent.com/88568938/207843780-03de9d6b-aaad-43d7-a598-30556e14f767.png)


4. Verify that the partition has been extended. Use the `lsblk` command. The partition size should now be equal to the volume size.

* The following example output shows that both the volume (xvda) and the partition (xvda1) are the same size (16 GB).

```bash
sudo lsblk               
```
```bash
NAME    MAJ:MIN RM SIZE RO TYPE MOUNTPOINT
xvda    202:0    0  150G  0 disk
└─xvda1 202:1    0  145G  0 part /
```

5.Extend the file system.

* Get the name, size, type, and mount point for the file system that you need to extend. Use the `df -hT` command.

```bash 
df -Th
```

a. Ext4 file system] Use the resize2fs command and specify the name of the file system that you noted in the previous step.

b. For example, to extend a file system mounted named /dev/xvda1, use the following command.

```bash
sudo resize2fs /dev/xvda1
```

![resize2fs](https://user-images.githubusercontent.com/88568938/207843870-9dfc0d44-8c69-4a8e-ab94-a5a269f62826.png)


6. Verify that the file system has been extended. Use the df -hT command and confirm that the file system size is equal to the volume size.

```bash
df -Th
```

* Using the mount command, mount the file systems sequentially beneath the server's primary root partition to check the fstab.

If there is no error, the mount is functioning properly

```bash
sudo mount -a
```


**_END_**
