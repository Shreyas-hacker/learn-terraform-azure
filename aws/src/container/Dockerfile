FROM python:3.9

#first layers should be dependency install so changes in code won't cause the build to start from scratch
COPY requirements.txt /opt/program/requirements.txt

RUN apt-get-y update && apt-get install -y --no-install-recommends \
        wget \
        nginx \
        ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN  pip3 install --no-cache-dir -r /opt/program/requirements.txt

# Setting environment variables. PYTHONUNBUFFERED keeps Python from buffering our standard output stream.
# PYTHONDONTWRITEBYTECODE keeps Python from writing pyc files to disc, which is unnecessary in this case.
# Update path so that train and serve can be found when container is invoked

ENV PYTHONUNBUFFERED=TRUE
ENV PYTHONDONTWRITEBYTECODE=TRUE
ENV PATH="/opt/program:${PATH}"
ENV MODEL_PATH="/opt/ml/model"


# Set up the program in the image
COPY algorithm_code /opt/program
WORKDIR /opt/program