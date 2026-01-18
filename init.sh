#!/bin/bash
echo "Starting Stable Diffusion Trainer"

if [ ! -d "/sd-scripts" ] || [ ! "$(ls -A "/sd-scripts")" ]; then
  echo "Files not found, cloning..."
  mkdir -p /sd-scripts
  git clone https://github.com/bluvoll/sd-scripts.git /sd-scripts
  cd /sd-scripts
  python3.10 -m venv venv
  source venv/bin/activate
  pip install numpy<1
  pip install -r requirements.txt --extra-index-url https://download.pytorch.org/whl/cu121
  pip install torchvision scipy lycoris-lora --extra-index-url https://download.pytorch.org/whl/cu121
  accelerate config default
else
  echo "Files found, starting..."
  cd /sd-scripts
  source venv/bin/activate
  accelerate launch sdxl_train_network.py --dataset_config="$SD_DATASET" --config_file="$SD_CONFIG"  --flow_model  --flow_use_ot  --flow_timestep_distribution logit_normal --flow_uniform_static_ratio 3 --vae_batch_size 6 --flow_logit_mean -0.2  --flow_logit_std 1.5 --use_zero_cond=False --ddp_timeout 3600 --network_train_unet_only
fi

