FROM centos:centos7

USER root
ENV CODE_ROOT=/opt/code-root

RUN yum update -y && \
yum install -y ansible && \
yum install -y git && \
yum install -y python3 && \
yum install -y python3-pip && \
pip3 install nodejs && \
pip3 install awscli && \
pip3 install aws-shell && \
mkdir -p /opt/code-root
cd /opt/code-root && \
git clone https://github.com/gmzabos/sak.git

CMD ["/bin/bash"]
