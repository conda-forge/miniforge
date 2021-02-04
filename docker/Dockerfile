FROM ubuntu:focal-20210119

ARG TINI_VERSION=v0.18.0
ARG MINIFORGE_NAME=Miniforge3
ARG ARCH=aarch64
ARG MINIFORGE_VERSION=4.9.2-0

ENV CONDA_DIR=/opt/conda
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV PATH=${CONDA_DIR}/bin:${PATH}

# Install just enough for conda to work
RUN apt-get update > /dev/null && \
    apt-get install --no-install-recommends --yes \
        wget bzip2 ca-certificates > /dev/null && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Keep $HOME clean (no .wget-hsts file), since HSTS isn't useful in this context
RUN wget --no-hsts --quiet https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini -O /usr/local/bin/tini && \
    chmod +x /usr/local/bin/tini

ADD build/${MINIFORGE_NAME}-${MINIFORGE_VERSION}-Linux-${ARCH}.sh /tmp/miniforge.sh
# 1. Install miniforge from GitHub releases
# 2. Apply some cleanup tips from https://jcrist.github.io/conda-docker-tips.html
#    Particularly, we remove pyc and a files. The default install has no js, we can skip that
RUN /bin/bash /tmp/miniforge.sh -b -p ${CONDA_DIR} && \
    rm /tmp/miniforge.sh && \
    conda clean -tipsy && \
    find ${CONDA_DIR} -follow -type f -name '*.a' -delete && \
    find ${CONDA_DIR} -follow -type f -name '*.pyc' -delete && \
    conda clean -afy

# Activate base by default when running as any *non-root* user as well
# Good security practice requires running most workloads as non-root
# This makes sure any non-root users created also have base activated
# for their interactive shells.
RUN echo ". ${CONDA_DIR}/etc/profile.d/conda.sh && conda activate base" >> /etc/skel/.bashrc

# Activate base by default when running as root as well
# The root user is already created, so won't pick up changes to /etc/skel
RUN echo ". ${CONDA_DIR}/etc/profile.d/conda.sh && conda activate base" >> ~/.bashrc

ENTRYPOINT ["tini", "--"]
CMD [ "/bin/bash" ]
