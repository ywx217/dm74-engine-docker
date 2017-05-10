# battle manager debian build environment
FROM debian:jessie
MAINTAINER Wenxuan Yang "gzyangwenxuan@corp.netease.com"
RUN sed --in-place 's/httpredir\.debian\.org/apt.x.netease.com:8660/g' /etc/apt/sources.list \
    && apt-get update -y \
    && apt-get install -y \
        build-essential \
        gcc \
        'g++' \
        cmake \
        git \
        python-dev \
        python2.7-dev \
        libbz2-dev \
        libprotobuf-dev \
        libgoogle-glog-dev \
        libgoogle-perftools-dev


# python-dev python2.7-dev
# copy asio source files and boost jam user config.
VOLUME /data
WORKDIR /battle_manager

# build boost
RUN apt-get install -y wget \
    && mkdir /boost \
    && cd /boost \
    && wget -O boost_1_57_0.tar.gz https://nchc.dl.sourceforge.net/project/boost/boost/1.57.0/boost_1_57_0.tar.gz \
    && tar xzf boost_1_57_0.tar.gz \
    && rm -f boost_1_57_0.tar.gz \
    && cd boost_1_57_0/ \
    && ./bootstrap.sh --prefix=/usr/local \
    && ./bjam cxxflags=-fPIC install \
    && cd / \
    && (rm -rf /boost; echo OK)

# build battle manager
COPY demo-math/ext ./ext
COPY demo-math/include ./include
COPY demo-math/py-wrap ./py-wrap
COPY demo-math/src ./src
COPY demo-math/test ./test
COPY demo-math/CMakeLists.txt ./CMakeLists.txt
COPY build.sh ./build.sh
RUN chmod +x build.sh

CMD ["/bin/bash"]
