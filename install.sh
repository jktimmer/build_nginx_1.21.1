PWD_DIR=`pwd`
SH_RELATIVE_DIR=`dirname "$0"`
BASE_DIR=$PWD_DIR/${SH_RELATIVE_DIR#*.}

#BASE_DIR=/home/chen/nginx_builder
NGINX_DIR=$BASE_DIR/nginx-1.21.1
BUILD_DIR=$BASE_DIR/build
BUILD_LIB_DIR=$BUILD_DIR/lib
BUILD_MODULE_DIR=$BUILD_DIR/module
OPENSSL=openssl-1.1.1m
PCRE=pcre-8.45
ZLIB=zlib-1.2.11
MODULE=ngx_http_proxy_connect_module

# 这条命令单独运行
#cd $NGINX_DIR
#patch -p1 < $BUILD_MODULE_DIR/$MODULE/patch/proxy_connect_rewrite_102101.patch
# end
CC=gcc
BUILD_OUT_DIR=$BUILD_DIR/objs
BUILD_OUT_PREFIX=$BUILD_DIR/out


# set user and group
USER_NAME=www
GROUP_NAME=www

cd $NGINX_DIR

make clean

sleep 3
echo "开始构建configure....."
auto/configure 													\
	--with-cc=$CC												\
	--user=$USER_NAME											\
	--group=$GROUP_NAME											\
	--builddir=$BUILD_OUT_DIR									\
	--with-debug												\
	--with-threads												\
	--prefix=$BUILD_OUT_PREFIX									\
	--conf-path=conf/nginx.conf									\
	--pid-path=logs/nginx.pid									\
	--http-log-path=logs/access.log								\
	--error-log-path=logs/error.log								\
	--sbin-path=sbin/nginx										\
	--http-client-body-temp-path=temp/client_body_temp			\
	--http-proxy-temp-path=temp/proxy_temp						\
	--http-fastcgi-temp-path=temp/fastcgi_temp					\
	--http-scgi-temp-path=temp/scgi_temp						\
	--http-uwsgi-temp-path=temp/uwsgi_temp						\
	--with-cc-opt=-DFD_SETSIZE=1024								\
	--with-pcre=$BUILD_LIB_DIR/$PCRE							\
	--with-zlib=$BUILD_LIB_DIR/$ZLIB							\
	--with-openssl=$BUILD_LIB_DIR/$OPENSSL						\
	--with-openssl-opt="no-asm no-tests"						\
	--with-http_v2_module										\
	--with-http_realip_module									\
	--with-http_addition_module									\
	--with-http_sub_module										\
	--with-http_dav_module										\
	--with-http_stub_status_module								\
	--with-http_flv_module										\
	--with-http_mp4_module										\
	--with-http_gunzip_module									\
	--with-http_gzip_static_module								\
	--with-http_auth_request_module								\
	--with-http_random_index_module								\
	--with-http_secure_link_module								\
	--with-http_slice_module									\
	--with-mail													\
	--with-stream												\
	--with-http_ssl_module										\
	--with-mail_ssl_module										\
	--with-stream_ssl_module									\
	--add-module=$BUILD_MODULE_DIR/$MODULE

# create temp dir
mkdir -p $BUILD_OUT_PREFIX/temp
echo "configure success, wait secends will make and install"
echo "当前目录==>$(pwd)"
sleep 3
make && make install
