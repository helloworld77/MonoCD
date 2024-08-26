## torch 选择了1.10.0, 注意切一下DCN的版本
pip install ~/software/torch/torch-1.10.0+cu113-cp37-cp37m-linux_x86_64.whl ~/software/torch/torchvision-0.11.0+cu113-cp37-cp37m-linux_x86_64.whl
# 竟然用了inplace_abn
pip install setuptools==57.0.0
## 切换setuptools安装一下inplace_abn
pip install -r requirements.txt
pip install scikit-learn
# DCNv2 注意切换对应pytorch版本： 1.10.0对应使用的1.9.0版本
cd model/backbone
rm -rf DCNv2
git clone https://mirror.ghproxy.com/https://github.com/lbin/DCNv2.git
cd DCNv2
git checkout pytorch_1.9
./make.sh
cd ../../../
## 注意修改一下setup.py， 这里其实主要是装个环境路径
python setup.py develop

### 数据准备
wget https://download.openmmlab.com/mmdetection3d/data/train_planes.zip

## 训练
## 改一下数据路径 config/paths_catalog.py --- /home/system/projects/7_phd/monocular3d/MonoCD/dataset/
CUDA_VISIBLE_DEVICES=0 python tools/plain_train_net.py --batch_size 8 --config runs/monocd.yaml --output output/exp
# 1080ti差不多训练一天。

### MONOLss用这个也可以训练， 不用装其他任何东西, basesize调小到8，1080ti刚好能训练。这差不多1分钟100iteration，一个epoch大概10分钟。。。设定了跑600epoch。。。差不多4天。。。
# cd /home/ssd2t/datasets/public/KITTI/training/ &&  tar cf - label_2 | ssh -p 15027 root@connect.westb.seetacloud.com "cd /root/autodl-tmp/dataset/kitti/training && tar xf -" 
python tools/train_val.py

