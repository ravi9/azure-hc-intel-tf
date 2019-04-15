
# azure-hc-intel-tf
Setup Azure HC-series to run deep learning distributed training with  intel-tensorflow and Horovod

## Documentation is WIP 

#### Step 1: Launch a Azure HC-series node

#### Step 2: Setup the Azure HC-series node

```
#install the pre-req
sudo yum install -y git tmux 

#Clone the repo
cd ~
git clone https://github.com/ravi9/azure-hc-intel-tf.git
cd ~/azure-hc-intel-tf/

# Start a tmux session, as the setup installations take a while (majority of the time is building GCC8.2).
tmux

# Inside the tmux window pane, start the installations, pass an argument for appropriate MPI. <intelmpi|openmpi>
time sudo sh -c "./2-setup-host-and-build-container.sh intelmpi 2>&1 | tee /tmp/2-setup-host-and-build-container.log"


```

#### Step 3: Take an image of the VM
[Click here](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/capture-image) for more detailed steps to create an image of the VM. Below are the required steps.

Inside the VM shell, run:
```
sudo waagent -deprovision+user
```

In the azure client shell, where you install AZ CLI, run:
```
az vm deallocate -g <resource-group-name> -n <VM-name>
az vm generalize -g <resource-group-name> -n <VM-name>
az image create -g <resource-group-name> -n <image-name> --source <VM-name>
```

#### Step 4: Launch a cluster with the created image

#### Step 5: Run benchmarks
