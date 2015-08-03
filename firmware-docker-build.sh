#!/bin/bash
IMAGETAG=trezor-mcu-build
FIRMWARETAG=${1:-stable}

docker build -t $IMAGETAG .
docker run -t -v $(pwd)/output:/output $IMAGETAG /bin/sh -c "\
	git clone https://github.com/trezor/trezor-mcu && \
	cd trezor-mcu && \
	git checkout $FIRMWARETAG && \
	git submodule update --init && \
	make && \
	cd firmware && \
	make && \
	cp trezor.bin /output/trezor-$FIRMWARETAG.bin"

echo "---------------------"
echo "Firmware fingerprint:"

sha256sum output/trezor-$FIRMWARETAG.bin
