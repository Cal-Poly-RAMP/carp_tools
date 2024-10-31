# Debian 12, Python 3,11
FROM debian
SHELL ["/bin/bash", "-c"]  

ENV HOME=/home/carp
RUN mkdir /home/carp
RUN cp /etc/skel/.bashrc ~/.bashrc
WORKDIR /home/carp

RUN apt update
# Install Core Tools
RUN apt install -y git vim bsdmainutils wget make

# Install RISC-V Toolchain
RUN wget https://github.com/stnolting/riscv-gcc-prebuilt/releases/download/rv32i-131023/riscv32-unknown-elf.gcc-13.2.0.tar.gz &&\
    mkdir /opt/riscv &&\
    tar -xzf riscv32-unknown-elf.gcc-13.2.0.tar.gz -C /opt/riscv/ &&\
    rm -rf riscv32-unknown-elf.gcc-13.2.0.tar.gz
RUN echo "PATH=\$PATH:/opt/riscv/bin" >> ~/.bashrc

# Install OSS CAD Suite
RUN wget https://github.com/YosysHQ/oss-cad-suite-build/releases/download/2023-04-23/oss-cad-suite-linux-x64-20230423.tgz &&\
    mkdir /opt/oss-cad-suite &&\
    tar -xzf oss-cad-suite-linux-x64-20230423.tgz -C /opt/oss-cad-suite/ &&\
    rm -rf oss-cad-suite-linux-x64-20230423.tgz
RUN  echo "source /opt/oss-cad-suite/oss-cad-suite/environment" >> ~/.bashrc 

## LibFFI 7
RUN wget http://es.archive.ubuntu.com/ubuntu/pool/main/libf/libffi/libffi7_3.3-4_amd64.deb && \
    dpkg -i libffi7_3.3-4_amd64.deb && \
    rm -rf libffi7_3.3-4_amd64.deb
  
RUN source /opt/oss-cad-suite/oss-cad-suite/environment &&\
    pip3 install --upgrade pip &&\
    git clone https://github.com/wallento/cocotbext-wishbone.git &&\
    python3 -m pip install -e cocotbext-wishbone