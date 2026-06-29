
FROM ubuntu:24.04


ARG USERNAME=ubuntu

SHELL ["/bin/bash", "-c"]


# Install Base dependencies
RUN apt-get update && apt-get install -y \
    python3 python3-pip python3-venv libpython3-dev \
    make cmake autoconf flex bison \
    g++ gcc git \
    libfl2 libfl-dev zlib1g zlib1g-dev \
    liblz4-dev z3 \
    ccache mold libjemalloc-dev \
    numactl gtkwave help2man curl sudo \
    clang libreadline-dev gawk tcl-dev libffi-dev \
    graphviz xdot pkg-config gperf libgmp-dev \
    gawk lld tcl-dev \
&& rm -rf /var/lib/apt/lists/*

# Installs Neovim 0.12.3 directly from binary
RUN cd /tmp \
 && curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz \
 && tar -C /opt -xzf nvim-linux-x86_64.tar.gz \
 && ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim \
 && rm nvim-linux-x86_64.tar.gz

# Make vi an alias of nvim 
RUN echo "alias vi='nvim'" >> /home/$USERNAME/.bashrc \
 && echo "alias vim='nvim'" >> /home/$USERNAME/.bashrc

# Install Verilator
RUN git clone --depth 1 https://github.com/verilator/verilator /tmp/verilator/ \
  && unset VERILATOR_ROOT \
  && cd /tmp/verilator/ \
  && autoconf \
  && ./configure \
  && make -j `nproc` \
  && make install \
  && rm -rf /tmp/verilator/




# Install Yosys (Cannot not run Symbiyosys without it)
RUN git clone --depth 1 --recurse-submodules --shallow-submodules https://github.com/YosysHQ/yosys.git /tmp/yosys/ \
  && cd /tmp/yosys/ \
  && git submodule update --init --recursive \
  && cmake -B build . -DCMAKE_BUILD_TYPE=Release --fresh \
  && cmake --build build --config Release --parallel $(nproc) \
  && sudo cmake --install build --strip \
  && rm -rf /tmp/yosys/

# Install Symbiyosys
RUN git clone --depth 1 https://github.com/YosysHQ/sby /tmp/sby/ \
  && cd /tmp/sby \
  && sudo make install \
  && rm -rf /tmp/sby/


# Install boolector solver
RUN git clone --depth 1 https://github.com/boolector/boolector /tmp/boolector \
  && cd /tmp/boolector \
  && ./contrib/setup-btor2tools.sh \
  && ./contrib/setup-lingeling.sh \
  &&./configure.sh \
  && make -C build -j$(nproc) \
  && sudo cp build/bin/{boolector,btor*} /usr/local/bin/ \
  && sudo cp deps/btor2tools/build/bin/btorsim /usr/local/bin/ \
  && rm -rf /tmp/boolector/


# Install Yices2 solver
RUN git clone --depth 1 https://github.com/SRI-CSL/yices2.git /tmp/yices2 \
  && cd /tmp/yices2 \
  && autoconf \
  && ./configure \
  && make -j$(nproc) \
  && sudo make install \
  && rm -rf /tmp/yices2


# Pip3 package dependencies 
COPY requirements.txt /tmp/requirements.txt


# Python virtual environment 
RUN python3 -m venv /home/$USERNAME/.venv/ \
  && /home/$USERNAME/.venv/bin/pip3 install -U pip \
  && /home/$USERNAME/.venv/bin/pip3 install -r /tmp/requirements.txt

