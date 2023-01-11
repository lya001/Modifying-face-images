#!/bin/bash
#SBATCH --gres=gpu:1
#SBATCH --mail-type=ALL # required to send email notifcations
#SBATCH --mail-user=yl4519 # required to send email notifcations - please replace <your_username> with your college login name or email address
#export PATH=/vol/bitbucket/yl4519/myenv/bin/:$PATH
#source activate
export PATH=/vol/bitbucket/${USER}/miniconda3/bin/:$PATH
source activate
#. /vol/cuda/11.0.3-cudnn8.0.5.39/setup.sh
source /vol/cuda/10.0.130-cudnn7.6.4.38/setup.sh
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/vol/cuda/10.0.130-cudnn7.6.4.38/targets/x86_64-linux/
TERM=vt100 # or TERM=xterm
/usr/bin/nvidia-smi

sh main.sh input
