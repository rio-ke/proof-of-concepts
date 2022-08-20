## link the jenkins with bitbucket

**PURPOSE**

This article will provide you a complete detailed knowledge of configuring Jenkins with Bitbucket repository which will help to set the path for the interaction of Jenkins continuous integration tool with bitbucket repository.


**Requirements**

| SERVER | OPERATING SYSTEM | |
| --- | --- | --- |
| virtual machine | ubuntu |

**Note**

ubuntu server must have jenkins service

## Ways for Enabling Jenkins with Bitbucket

**STEP 1:**

Login to your Jenkins and then select Manage Jenkins->Plugin Manager and on the tab available select the option bitbucket plugin and click on install without restart.
| PLUGIN NAME |
|---|
|bitbucket plugins|
|bitbucket Oauth plugins|
|bitbucket build status notification plugin|

**Step 2:**
```bash
ssh-keygen
```
To achieve this we require a SSH key pair, if the command execute we get pubilc and private keys in the instance.

**Step 3:**

Let’s upload the private key in jenkins,navigate to Jenkins URL and following menu

Manage Jenkins –> configure credentials –> credentials –> system –>Add credentials

past the privatekey credentials “kind” to “SSH Username with private key” in follow with username that is being used in the bitbucket account,private key and passphrase that used to unlock the private key.

**Step 4:**

Now add the public key to bit bucket,
follow the given menu
Bitbucket –> settings –>ssh keys –>add keys.

**Step 5:**

We have setup our keys in both Jenkins and bitbucket,let see how we gonna using it.
copy the ssh url from bitbuckect and past it in the jenkins ui,you have to chosen credentials that created just now before.


**done**




