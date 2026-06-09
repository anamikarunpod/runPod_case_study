FROM pytorch/pytorch:2.1.0-cuda12.1-cudnn8-runtime

WORKDIR /app
COPY my_handler.py /app/my_handler.py

RUN pip install --upgrade pip
RUN pip install torch diffusers runpod transformers accelerate huggingface_hub sentencepiece protobuf

# Build-time inputs (ONLY available during docker build)
ARG HF_TOKEN
ARG MODEL_ID="stabilityai/stable-diffusion-3.5-large"

# Where to store the model in the image
ENV MODEL_DIR=/app/model
RUN mkdir -p "$MODEL_DIR"

# (Optional) fail fast if token not provided
RUN test -n $HF_TOKEN || (echo "HF_TOKEN build-arg is required" && exit 1)

# run
RUN hf auth_login

RUN hf download $MODEL_ID \
    --local-dir $MODEL_DIR \
    --local-dir-use-symlinks False

EXPOSE 8000
CMD ["python3", "my_handler.py"]
