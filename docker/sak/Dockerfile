FROM centos7

RUN yum update && \
yum install ansible -y && \
yum install git -y && \
yum install python3 -y && \
yum install python3-pip -y && \
pip3 install nodejs && \
pip3 install awscli && \
pip3 install aws-shell && \
cd /dachboden && \
git clone https://github.com/gmzabos/sak.git

VOLUME ['/dachboden']

CMD ['/bin/bash']
