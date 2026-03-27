FROM pytorch/pytorch:2.2.2-cuda11.8-cudnn8-runtime

# 设置工作目录
WORKDIR /app

# 安装依赖 + wget
RUN apt-get update && apt-get install -y wget && \
    pip install --no-cache-dir pillow matplotlib

# 创建 PyTorch 模型缓存目录
RUN mkdir -p /root/.cache/torch/hub/checkpoints

# 下载 VGG19 模型权重（来自 PyTorch 官网）
RUN wget -O /root/.cache/torch/hub/checkpoints/vgg19-dcbb9e9d.pth \
    https://download.pytorch.org/models/vgg19-dcbb9e9d.pth


    