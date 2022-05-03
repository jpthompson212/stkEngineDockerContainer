# Base Image Instance
FROM centos:centos7
LABEL Maintainer="jthompson@agi.com"

RUN mkdir -p /tmp/stk_install/
ADD ./STKEngineLinux_v*.zip /tmp/stk_install/

RUN yum update -y && \
    yum install -y redhat-lsb-core && \
    yum install -y unzip
RUN mkdir -p /app && mkdir -p /app/usr && mkdir -p /app/stk && \
    unzip /tmp/stk_install/STKEngineLinux_v*.zip -d /tmp/stk_install
RUN tar -xvf /tmp/stk_install/stk_binaries_v*.tgz -C /app/stk && \
    tar -xvf /tmp/stk_install/stk_data_v*.tgz -C /app/stk
RUN rm -r /tmp/stk_install

# Set the necessary Environment Variables
ENV LD_LIBRARY_PATH=/app/stk/stk12.4.0/bin \
    STK_INSTALL_DIR=/app/stk/stk12.4.0 \
    STK_CONFIG_DIR=/app/usr

# Set the working directory
WORKDIR /app/

#VOLUME ["/app/stk12.0.0/bin/LicenseData"]
# Copy over the license file
COPY License/ansyslmd.ini /app/stk/stk12.4.0/shared_files/licensing
RUN /app/stk/stk12.4.0/bin/stkxnewuser --force

ADD ./Defaults/_Default.ap /app/usr/STK12/Config/Defaults/
# Run the connect console application with noGraphics and interactive flags
CMD ["./stk/stk12.4.0/bin/connectconsole", "--new", "--noGraphics", "--port=8001"]