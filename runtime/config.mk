ARCH=x86_64-apple-darwin10

THIS_DIR=$(PWD)
HOME_DIR=$$HOME
PATCH_DIR=$(THIS_DIR)/patch
RUNTIME_DIR=/Users/sbo/runtimes/py24-base-scientific
TMP_DIR=$(RUNTIME_DIR)/__tmp
UNPACK_DIR=$(RUNTIME_DIR)/__unpack
BUILD_FLAGS_DIR=$(RUNTIME_DIR)/buildflags
BUILD_LOGS_DIR=$(RUNTIME_DIR)/buildlogs
DOWNLOAD_DIR=$(RUNTIME_DIR)/download
OPT_DIR=$(RUNTIME_DIR)/opt
MANUAL_INSTALL=$(RUNTIME_DIR)/manual_install

LIBS=-L$(RUNTIME_DIR)/lib
INCLUDES=-I$(RUNTIME_DIR)/include

WGET=wget -nc --passive-ftp --progress=dot

