# Neural Style Transfer 神经风格迁移

基于 PyTorch 的神经风格迁移实现，使用预训练 VGG19 网络将任意风格图像的绘画风格应用到内容图像上。

A PyTorch implementation of neural style transfer that applies the artistic style of one image onto the content of another, using a pretrained VGG19 network.

---

## 功能特性 / Features

- 使用 **VGG19** 提取内容特征与风格特征
- 支持三种优化模式：
  - **Mode 1 — LBFGS**：收敛快，适合高质量输出
  - **Mode 2 — Adam**：内存占用低，适合资源受限场景
  - **Mode 3 — LBFGS → Adam（混合）**：先用 LBFGS 快速降低风格损失，达到阈值后自动切换至 Adam 继续精细化优化
- 支持 GPU 加速（CUDA）和 CPU 降级运行
- 支持 Anaconda 环境与 Docker 容器两种部署方式

---

## 环境依赖 / Requirements

| 依赖 | 版本 |
|------|------|
| Python | 3.10+ |
| PyTorch | 2.2.2 |
| torchvision | 0.17.2 |
| Pillow | 10.2.0 |
| matplotlib | 3.10+ |
| CUDA（可选） | 12.x |

---

## 安装 / Installation

### 方式一：Anaconda / Conda environment

```bash
pip install pillow matplotlib torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121
```

### 方式二：Docker（推荐用于 GPU 环境）

构建镜像 / Build the image:

```bash
docker build -t style-transfer-gpu .
```

启动容器 / Run the container:

```bash
# Windows (cmd/PowerShell)
docker run --rm -it ^
  --gpus all ^
  -v .:/app ^
  style-transfer-gpu

# Linux / macOS
docker run --rm -it --gpus all -v $(pwd):/app style-transfer-gpu
```

---

## 目录结构 / Directory Structure

运行前请按以下结构准备图片目录：

```
neural-style-transfer/
├── test.py               # 主程序
├── Dockerfile
├── README.md
├── pics/
│   ├── style/            # 风格图像（Style images）
│   │   └── your_style.jpg
│   └── content/          # 内容图像（Content images）
│       └── your_content.jpg
└── data/                 # 输出目录（自动生成）
    ├── input_img.png
    ├── style_img.png
    └── output_img.png
```

---

## 使用方法 / Usage

### 1. 配置参数 / Configure parameters

编辑 `test.py` 顶部的配置变量：

```python
style       = "your_style.jpg"       # 风格图像文件名（放入 pics/style/）
content     = "your_content.jpg"     # 内容图像文件名（放入 pics/content/）
gpu_output  = 512                    # GPU 模式下的输出分辨率（像素）
cpu_output  = 128                    # CPU 模式下的输出分辨率（像素）
mode        = 3                      # 优化模式：1=LBFGS, 2=Adam, 3=混合

# LBFGS 参数
LBFGSStepORCycle = 2000             # LBFGS 最大迭代步数

# Adam 参数
AdamStepORCycle  = 2000             # Adam 最大迭代步数
AdamLR           = 0.001            # Adam 学习率

# 混合模式阈值（仅 mode=3 生效）
LBFGSToAdamThreshold = 1.5         # 风格损失（×10⁻⁶）低于此值时切换到 Adam
```

### 2. 运行 / Run

```bash
python test.py
```

输出图像将保存在 `./data/` 目录中：
- `input_img.png` — 原始内容图像
- `style_img.png` — 风格图像
- `output_img.png` — 风格迁移结果

---

## 验证依赖版本 / Verify library versions

```bash
python3 -c "import torch, PIL, matplotlib, torchvision; \
  print('torch:', torch.__version__); \
  print('PIL:', PIL.__version__); \
  print('matplotlib:', matplotlib.__version__); \
  print('torchvision:', torchvision.__version__)"
```

---

## 工作原理 / How It Works

神经风格迁移 (Neural Style Transfer) 由 Gatys et al. (2015) 提出，核心思想：

1. **内容损失（Content Loss）**：使用 VGG19 中间层（`conv_4`）的特征图衡量生成图像与内容图像的差异。
2. **风格损失（Style Loss）**：使用多个卷积层（`conv_1` ~ `conv_5`）的 Gram 矩阵衡量生成图像与风格图像的纹理差异。
3. **优化目标**：以内容图像为初始值，通过梯度下降最小化加权总损失，直至生成兼具内容结构与风格纹理的输出图像。

```
Total Loss = content_weight × Content Loss + style_weight × Style Loss
```

---

## 参考 / References

- Gatys, L. A., Ecker, A. S., & Bethge, M. (2015). [A Neural Algorithm of Artistic Style](https://arxiv.org/abs/1508.06576)
- [PyTorch Neural Style Transfer Tutorial](https://pytorch.org/tutorials/advanced/neural_style_tutorial.html)
