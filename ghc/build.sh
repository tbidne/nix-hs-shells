set -e

./boot

./configure

./hadrian/build -j --flavour=validate+werror
