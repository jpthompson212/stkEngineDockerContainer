# Base Image Instance
FROM centos:centos7
LABEL Maintainer="jthompson@agi.com"

ADD ./STKEngUnix1200.zip /tmp/

RUN ls /tmp/
RUN yum update -y && \
    yum install -y redhat-lsb-core && \
    yum install -y unzip && \
    mkdir -p /app && mkdir -p /app/usr && \
    unzip /tmp/STKEngUnix1200.zip -d /tmp && \
    tar -xvf /tmp/stk_binaries_v12.0.0.tgz --directory /app/ && \
    tar -xvf /tmp/stk_data_v12.0.0.tgz --directory /app/ && \
    tar -xvf /tmp/stk_jars_v12.0.0.tgz --directory /app/ && \
    tar -xvf /tmp/stk_planetary_data_v12.0.0.tgz --directory /app/ && \
    mkdir /app/stk12.0.0/bin/LicenseData

# Set the necessary Environment Variables
ENV LD_LIBRARY_PATH=/app/stk12.0.0/bin \
    STK_INSTALL_DIR=/app/stk12.0.0 \
    STK_CONFIG_DIR=/app/usr

# Set the working directory
WORKDIR /app/

#VOLUME ["/app/stk12.0.0/bin/LicenseData"]
# Copy over the license file
COPY License/*.lic /app/stk12.0.0/bin/LicenseData
RUN /app/stk12.0.0/bin/stkxnewuser --force

ADD ./Defaults/_Default.ap /app/usr/STK12/Config/Defaults/
# Run the connect console application with noGraphics and interactive flags
CMD ["./stk12.0.0/bin/connectconsole", "--new", "--noGraphics", "--port=8001"]