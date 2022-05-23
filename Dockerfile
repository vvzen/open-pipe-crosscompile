FROM centos:centos7.9.2009
# See https://hub.docker.com/_/centos?tab=tags

RUN yum update -y

# Install pre-requisites
RUN yum groupinstall "Development Tools" -y
RUN yum install wget -y
RUN yum install git -y
RUN yum install cmake -y 
RUN yum install make -y 
RUN yum install gcc-c++ -y
RUN yum install tree -y
RUN yum install epel-release -y
RUN yum install ncurses-devel -y
RUN yum install cmake3 --enablerepo="epel" -y

RUN mkdir -p /opt/recipes
COPY ./recipes/*.sh /opt/recipes

# Do the actual build of the payloads
RUN /opt/recipes/fish.sh /opt/payload
RUN /opt/recipes/rust.sh /opt/payload
RUN /opt/recipes/helix-editor.sh /opt/payload

CMD ["tree", "-L", "3", "/opt/payload"]