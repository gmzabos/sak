FROM centos:centos7

RUN yum update && \
yum install -y ansible && \
yum install -y git && \
yum install -y python3 && \
yum install -y python3-pip && \
pip3 install nodejs && \
pip3 install awscli && \
pip3 install aws-shell && \
cd /dachboden && \
git clone https://github.com/gmzabos/sak.git

VOLUME ["/dachboden"]

CMD ["/bin/bash"]
