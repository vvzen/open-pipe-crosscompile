FROM centos:centos7.9.2009
# See https://hub.docker.com/_/centos?tab=tags

RUN yum update -y

# Install pre-requisites
RUN yum groupinstall "Development Tools" -y
RUN yum install wget -y
RUN yum install git -y
RUN yum install cmake -y 
RUN yum install make -y 
RUN yum install gcc -y
RUN yum install gcc-c++ -y
RUN yum install epel-release -y
RUN yum install ncurses-devel -y
RUN yum install cmake3 --enablerepo="epel" -y
RUN yum install glibc -y
# Nice utils
RUN yum install which -y
RUN yum install tree -y
# Needed by tmux
RUN yum install libevent-devel -y

# Use the latest gcc
RUN yum install centos-release-scl -y
RUN yum install devtoolset-9 -y
RUN yum install devtoolset-9-gcc -y
RUN yum install devtoolset-9-gcc-c++ -y

RUN echo "source /opt/rh/devtoolset-9/enable" >> ~/.bashrc
# Make sure to always run a login shell,
# to ensure .bashrc is sourced on the next commands
SHELL ["/bin/bash", "--login", "-c"]

# Install RUST
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

RUN mkdir -p /opt/recipes
COPY ./recipes/*.sh /opt/recipes

# Do the actual build of the payloads
#RUN /opt/recipes/rust.sh /opt/payload
#RUN /opt/recipes/fish.sh /opt/payload
#RUN /opt/recipes/helix-editor.sh /opt/payload
RUN /opt/recipes/tmux.sh /opt/payload

CMD ["tree", "-L", "2", "/opt/payload/install"]