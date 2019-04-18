## Benchmarking Azure HC-Series with Intel optimized Tensorflow w/ Horovod
Setup Azure HC-series to run deep learning distributed training with  intel-tensorflow and Horovod

### Contributors:
- [https://github.com/jithinjosepkl/azhpc-images/](https://github.com/jithinjosepkl/azhpc-images/)
- Kathik Raman
- 
## << Documentation is WIP  >>

#### Step 1: Launch a Azure HC-series node

#### Step 2: Setup the Azure HC-series node

```
#install the pre-req
sudo yum install -y git tmux 

#Clone the repo
cd ~
git clone https://github.com/ravi9/azure-hc-intel-tf.git
cd ~/azure-hc-intel-tf/

# Start a tmux or screen session, as the installations take about 80min ! 
# Most of the time taken is building GCC8.2 twice: on the host and inside the container.
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

#### Step 5: Setup Cluster
- Login into the first node in the cluster .
- Clone the repo
```
# Clone the repo and run prep-cluster.sh script
cd ~
git clone https://github.com/ravi9/azure-hc-intel-tf.git
cd ~/azure-hc-intel-tf/azure-scripts

# Run the script with your Azure VM pwd
./prep-cluster.sh <Azure-VM-login-pwd>
```

#### Step 6: Run Benchmarks
Run `benchmark-scripts/run-tf-sing-ucx-openmpi.sh` script. See below for usage
```
cd ~/azure-hc-intel-tf/benchmark-scripts
#usage: ./run-tf-sing-ucx-openmpi.sh <NUM_NODES> <WORKERS_PER_SOCKET> <batch_size> <fabric(ib,sock)>

# Following examples are assuming a 2-socket server
# To run 4nodes, 8 workers, with infiniband
./run-tf-sing-ucx-openmpi.sh 4 1 64 ib 

# To run 2nodes, 4 workers, with Sockets(Ethernet)
./run-tf-sing-ucx-openmpi.sh 2 1 64 sock
```
