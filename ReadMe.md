commands

for anaconda
```
pip install pillow matplotlib torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121\
python test.py
```

for docker
```
docker build -t style-transfer-gpu .
```

run the container
```
docker run --rm -it ^
  --gpus all ^
  -v .:/app ^
  style-transfer-gpu
```

another way to run the container
```
docker run --rm -it --gpus all -v .:/app style-transfer-gpu
```

commands in the container
```
python test.py
```


to see the versions of the libraries
```
python3 -c "import torch, PIL, matplotlib, torchvision; print('torch:', torch.__version__); print('PIL:', PIL.__version__); print('matplotlib:', matplotlib.__version__); print('torchvision:', torchvision.__version__)"
```
  