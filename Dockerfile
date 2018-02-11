#FROM daocloud.io/library/python:2.7.13
#FROM daocloud.io/library/python:3.6.2
FROM index.docker.io/continuumio/anaconda3


MAINTAINER peterz3g <peterz3g@163.com>

RUN mkdir -p /code
WORKDIR /code

COPY . /code/
ADD cron_jobs.txt /var/spool/cron/crontabs/root


# install nginx  E: dpkg was interrupted, you must manually run 'dpkg --configure -a' to correct the problem. 
# pip install --no-cache-dir -r requirements.txt -i http://mirrors.aliyun.com/pypi/simple/ --trusted-host mirrors.aliyun.com

RUN apt-get update && \
apt-get install -y cron && \
apt-get install -y vim && \
apt-get install -y telnet && \
touch /code/jobs.log && \
chmod +x /code/entrypoint.sh && \
chmod 0600 /var/spool/cron/crontabs/root && \
pip install --upgrade pip && \
pip install --upgrade setuptools && \
pip install -r /code/requirements.txt && \
apt-get clean && \
apt-get autoclean && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
service cron restart && \
echo "#add by zhangyang32"  >> /etc/profile && \
ls


EXPOSE 8000
ENTRYPOINT ["/bin/bash", "/code/entrypoint.sh"]

