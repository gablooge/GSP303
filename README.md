# GSP303


Configure Secure RDP using a Windows Bastion Host

https://www.qwiklabs.com/focuses/1737?parent=catalog


# Terminal 1
> git clone https://github.com/gablooge/GSP303.git

> cd GSP303

> sudo chmod +x 1.sh

> ./1.sh

Note: step 6 use RDP to setup IIS in vm-securehost by connecting RDP to vm-bastionhost then use RDP inside vm-bastionhost to connect vm-securehost.

Here is the example how to setup the IIS: https://www.youtube.com/watch?v=tXsVYJUUZ_s

# Terminal 2 for gcloud authentication
> gcloud init



