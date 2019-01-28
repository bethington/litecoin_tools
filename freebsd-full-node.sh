pkg install autoconf automake boost-libs git gmake libevent libtool openssl pkgconf python3
cd /home
mkdir root
cd root
git clone https://github.com/litecoin-project/litecoin.git
cd litecoin
./autogen.sh
./configure --without-gui --disable-wallet
