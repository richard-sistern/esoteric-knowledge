FROM ubuntu:latest

RUN apt-get update && \
    apt-get install build-essential\ 
    libpcre3 \
    libpcre3-dev \
    zlib1g \
    zlib1g-dev \
    libssl1.1 \
    libssl-dev \
    -y && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Let the daemon download the file during build proccess
ARG FILENAME="nginx-1.19.2"
ARG EXTENSION="tar.gz"

ADD https://nginx.org/download/${FILENAME}.${EXTENSION} .
# COPY nginx-1.19.2.tar.gz .

# Required as ADD doesn't extract files from the internet by default
RUN tar -xvf ${FILENAME}.${EXTENSION} && rm ${FILENAME}.${EXTENSION}

RUN cd ${FILENAME} && \
    ./configure \
    --sbin-path=/usr/bin/nginx \
    --conf-path=/etc/nginx/nginx.conf \
    --error-log-path=/var/log/nginx/error.log \
    --http-log-path=/var/log/nginx/access.log \
    --with-pcre \
    --pid-path=/var/run/nginx.pid \
    --with-http_ssl_module && \
    make && make install

RUN rm -rf /${FILENAME}}

CMD ["nginx", "-g", "daemon off;"]