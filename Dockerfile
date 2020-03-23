FROM php:7.0.12

WORKDIR /

RUN apt-get update && apt-get install -y \
    sudo \
    libz-dev \
    git \
    vim \
    build-essential \
    automake \
    wget \
    unzip \
    libtool \
    autoconf

RUN sudo pecl install grpc-1.7.0 -y

# gRPC c 코어 라이브러리 다운
RUN git clone -b v1.27.2 https://github.com/grpc/grpc /grpc

WORKDIR /grpc
RUN git submodule update --init
RUN sudo make
RUN sudo make install

# gRPC php extension 빌드 & 설치
WORKDIR /grpc/src/php/ext/grpc
RUN phpize
RUN ./configure
RUN sudo make
RUN sudo make install

# update php.ini
# extension grpc.so 추가
RUN docker-php-ext-enable grpc

# protobuf 컴파일러 설치
WORKDIR /grpc/third_party/protobuf
RUN sudo ./autogen.sh && ./configure && make
RUN sudo make install

# protobuf 런타임 설치
RUN sudo pecl install protobuf-3.4.0

# update php.ini
# extension protobuf.so 추가
RUN docker-php-ext-enable protobuf

# php protoc plugin 설치
WORKDIR /grpc
RUN sudo make grpc_php_plugin

RUN mkdir -p /proto
WORKDIR /