#!/bin/bash

# ./run-tf-sing-ucx-openmpi.sh 4 1 64 ib
#usage: ./run-tf-sing-ucx-openmpi.sh <NUM_NODES> <WORKERS_PER_SOCKET> <batch_size> <fabric(ib,sock)>
#If WORKERS_PER_SOCKET=0, then WORKERS_PER_NODE=1

# Following examples are assuming a 2-socket server
# To run 4nodes, 8 workers, with infiniband
#Ex: ./run-tf-sing-ucx-openmpi.sh 4 1 64 ib 2>&1 | tee ~/logs/tfmn-4n-64b-real-ib-r1.log

# To run 2nodes, 4 workers, with Sockets(Ethernet)
#Ex: ./run-tf-sing-ucx-openmpi.sh 2 1 64 sock 2>&1 | tee ~/logs/tfmn-2n-64b-real-sock-r1.log

source /mnt/shared/setenv

PATH_TO_SINGULARITY="/usr/bin/singularity"
PATH_TO_SIMG="/mnt/shared/tensorflow/tf-hvd-gcc-ompi-ucx-mlnx.sif"

TF_RECORDS_DIR="/mnt/shared/tensorflow/ilsvrc2012_tfrecords_20of1024"
SING_EXEC_CMD="${PATH_TO_SINGULARITY} exec --bind ${TF_RECORDS_DIR}:${TF_RECORDS_DIR} ${PATH_TO_SIMG}"
#SING_EXEC_CMD="${PATH_TO_SINGULARITY} exec ${PATH_TO_SIMG}"

PATH_TO_SIMG_TF_BENCH="/opt/tensorflow-benchmarks"

HOSTFILEPATH="/home/$USER/nodeips.txt"

NUM_NODES=${1}
WORKERS_PER_SOCKET=${2}
BATCH_SIZE=${3}
FABRIC=${4}

NUM_WARMUP_BATCHES=50
NUM_BATCHES=100
MODEL=resnet50
INTER_T=2

NUM_SOCKETS=`lscpu | grep "Socket(s)" | cut -d':' -f2 | xargs`
CORES_PER_SOCKET=`lscpu | grep "Core(s) per socket" | cut -d':' -f2 | xargs`

if (( $WORKERS_PER_SOCKET == 0 )); then
    CORES_PER_WORKER=$((CORES_PER_SOCKET * NUM_SOCKETS))
    WORKERS_PER_NODE=1
else
    CORES_PER_WORKER=$((CORES_PER_SOCKET / WORKERS_PER_SOCKET))
    WORKERS_PER_NODE=$((WORKERS_PER_SOCKET * NUM_SOCKETS))
fi

INTRA_T=$((CORES_PER_WORKER / INTER_T))
OMP_NUM_THREADS=$INTRA_T
TOTAL_WORKERS=$((NUM_NODES * WORKERS_PER_NODE))

echo "TOTAL_NODES: $NUM_NODES"
echo "WORKERS_PER_NODE: $WORKERS_PER_NODE"
echo "TOTAL_WORKERS: $TOTAL_WORKERS"
echo "CORES_PER_WORKER: $CORES_PER_WORKER"
echo "OMP_NUM_THREADS: $OMP_NUM_THREADS"
echo "NUM_INTRA_THREADS: $INTRA_T"
echo "NUM_INTER_THREADS: $INTER_T"

export OMP_NUM_THREADS=$OMP_NUM_THREADS

TF_ARGS=" \
 --batch_size=${BATCH_SIZE} \
 --num_warmup_batches=${NUM_WARMUP_BATCHES} \
 --num_batches=${NUM_BATCHES} \
 --model=${MODEL} \
 --num_intra_threads=${INTRA_T} \
 --num_inter_threads=${INTER_T} \
 --kmp_blocktime=1 \
 --kmp_affinity=granularity=fine,noverbose,compact,1,0 \
 --display_every=10 \
 --data_format=NCHW \
 --optimizer=momentum \
 --forward_only=False \
 --device=cpu \
 --mkl=TRUE \
 --variable_update=horovod \
 --horovod_device=cpu \
 --local_parameter_device=cpu \
 --data_dir=${TF_RECORDS_DIR} \
 --data_name=imagenet "

echo -e "Common Args: $args"

if [ "${FABRIC}" == "ib" ]; then
    FABRIC_ARGS="-mca pml ucx \
    --mca btl ^vader,tcp,openib \
    -mca coll_hcoll_enable 1 \
    -x HCOLL_MAIN_IB=mlx5_0:1 \
    -x UCX_NET_DEVICES=mlx5_0:1 \
    -x UCX_IB_PKEY=`cat /sys/class/infiniband/mlx5_0/ports/1/pkeys/0 | sed 's/\(.\{2\}\)./\10/'` \
    -x UCX_TLS=rc_x,sm,self "
else
    FABRIC_ARGS="-mca pml ^ucx "
fi

echo -e "TF Args: $FABRIC_ARGS"

run_cmd="mpirun \
--oversubscribe -np ${TOTAL_WORKERS} \
-hostfile ${HOSTFILEPATH} \
--map-by ppr:${WORKERS_PER_SOCKET}:socket,pe=${CORES_PER_WORKER} \
${FABRIC_ARGS} \
-x OMP_NUM_THREADS=$OMP_NUM_THREADS \
-x HOROVOD_FUSION_THRESHOLD=134217728 \
-x HOROVOD_MPI_THREADS_DISABLE=1 \
${SING_EXEC_CMD} \
python ${PATH_TO_SIMG_TF_BENCH}/scripts/tf_cnn_benchmarks/tf_cnn_benchmarks.py \
$TF_ARGS "

echo -e "$run_cmd"

$run_cmd
