FROM kbase/kb_minideb:stretch
ARG BUILD_DATE
ARG VCS_REF
ARG BRANCH=develop
ENV LANG C.UTF-8

# Some common packages that are useful + Java runtime from the openjdk:8-jdk dockerfile
RUN apt-get update -y \
	&& apt-get install -y apt-transport-https ca-certificates make software-properties-common \
    	git apt-utils bzip2 unzip curl sudo wget \
	&& apt-get install -y --no-install-recommends \
		bzip2 \
		unzip \
	&& apt-get clean

ENV PATH $PATH:/kb/runtime/bin
RUN cd /tmp \
	&& wget https://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh \
	&& bash Miniconda2-latest-Linux-x86_64.sh -b -p /kb/runtime \
	&& conda install pyopenssl ndg-httpsclient pyasn1 pyyaml gitpython requests 'requests[security]' \
		coverage biopython \
	&& conda install -c conda-forge uwsgi wsgiref \
	&& conda install -c auto jsonrpcbase \
	&& conda install -c richardotis nose2 \
	&& apt-get install -y python3-minimal python3-pip \
	&& pip3 install jsonrpcbase numpy biopython \
	&& apt-get clean

# The BUILD_DATE value seem to bust the docker cache when the timestamp changes, move to
# the end
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-url="https://github.com/kbase/kb_python.git" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.schema-version="1.0.0-rc1" \
      us.kbase.vcs-branch=$BRANCH \
      maintainer="Steve Chan sychan@lbl.gov"
      
