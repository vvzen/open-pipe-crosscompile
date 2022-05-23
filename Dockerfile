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

RUN mkdir -p /opt/recipes
COPY ./recipes/*.sh /opt/recipes

# Do the actual build of the payloads
#RUN /opt/recipes/cmake.sh /opt/payload
RUN /opt/recipes/fish.sh /opt/payload

CMD ["tree", "-L", "3", "/opt/payload"]