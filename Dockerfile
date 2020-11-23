FROM python:3.6

# 安装 Nodejs
RUN apt update && curl -sL https://deb.nodesource.com/setup_12.x | bash - && apt install -y nodejs

#安装必要环境
RUN apt-get update \
 && apt-get install -yq --no-install-recommends \
    wget \
    bzip2 \
    ca-certificates \
    sudo \
    locales \
    fonts-liberation \
    run-one \
 && apt-get clean && rm -rf /var/lib/apt/lists/*

# 安装 jupyterlab
RUN python -m pip install jupyterlab

# 安装 Tensorflow等插件
RUN pip install --quiet --no-cache-dir \
    'tensorflow==2.3.1' \
    'scipy==1.5.4' \
    'pandas==1.1.4'

# 安装 jupyterlab 插件
RUN jupyter labextension install @jupyterlab/git && pip install jupyterlab-git && jupyter serverextension enable --py jupyterlab_git

# 设置默认环境变量
ENV NOTEBOOK_APP_TOKEN=123456
ENV NOTEBOOK_DIR=/jupyter/work

# 暴露端口号
EXPOSE 8888

#  运行 jupyterlab
CMD jupyter lab --ip=0.0.0.0 --no-browser --allow-root --NotebookApp.token=${NOTEBOOK_APP_TOKEN} --notebook-dir=${NOTEBOOK_DIR}