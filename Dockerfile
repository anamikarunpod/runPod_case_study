FROM pytorch/pytorch:2.1.0-cuda12.1-cudnn8-runtime

WORKDIR /app
COPY my_handler.py /app/my_handler.py

RUN pip install --upgrade pip
RUN pip install torch diffusers runpod transformers accelerate huggingface_hub sentencepiece protobuf

ARG HF_TOKEN
ENV HUGGINGFACE_HUB_TOKEN=${HF_TOKEN}

ENV MODEL_DIR=/app/model
RUN mkdir -p $MODEL_DIR

RUN huggingface-cli download stabilityai/stable-diffusion-3.5-large \
    --local-dir $MODEL_DIR \
    --local-dir-use-symlinks False \
    --token $HUGGINGFACE_HUB_TOKEN

EXPOSE 8000
CMD ["python3", "my_handler.py"]