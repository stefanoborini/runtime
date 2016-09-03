UMFPACK_VERSION=5.2
UMFPACK_TARGET=$(BUILD_FLAGS_DIR)/umfpack
UMFPACK_DEPS=
UMFPACK_PACKAGE=UMFPACK.tar.gz
UMFPACK_PACKAGE_URL= http://www.cise.ufl.edu/research/sparse/umfpack/current/UMFPACK.tar.gz \
					http://www.cise.ufl.edu/research/sparse/UFconfig/current/UFconfig.tar.gz \
					http://www.cise.ufl.edu/research/sparse/amd/current/AMD.tar.gz

.PHONY: umfpack umfpack-download
umfpack: $(UMFPACK_TARGET)
umfpack-download: $(DOWNLOAD_DIR)/$(UMFPACK_PACKAGE)

define __UMFPACK_NUMPY_FILE_TEMPLATE
[amd]
library_dirs = @RUNTIME_DIR@/lib/AMD/Lib
include_dirs = @RUNTIME_DIR@/lib/AMD/Include
amd_libs = amd

[umfpack]
library_dirs = @RUNTIME_DIR@/UMFPACK/Lib
include_dirs = @RUNTIME_DIR@/UMFPACK/Include
umfpack_libs = umfpack
endef
export __UMFPACK_NUMPY_FILE_TEMPLATE
$(UMFPACK_TARGET): $(INIT_TARGET) $(UMFPACK_DEPS) $(DOWNLOAD_DIR)/$(UMFPACK_PACKAGE)
	-rm -rf "$(UNPACK_DIR)/UFConfig" "$(UNPACK_DIR)/AMD" "$(UNPACK_DIR)/UMFPACK"
	tar -m -C "$(UNPACK_DIR)" -xzvf $(DOWNLOAD_DIR)/AMD.tar.gz
	tar -m -C "$(UNPACK_DIR)" -xzvf $(DOWNLOAD_DIR)/UFconfig.tar.gz
	tar -m -C "$(UNPACK_DIR)" -xzvf $(DOWNLOAD_DIR)/UMFPACK.tar.gz
	-cd $(UNPACK_DIR)/UFConfig; \
	for patch in $(PATCH_DIR)/UMFPACK-$(UMFPACK_VERSION)_$(ARCH)_*; \
		do patch -p1 < $$patch; \
	done
	cp "$(UNPACK_DIR)/UFConfig/UFConfig.h" "$(UNPACK_DIR)/AMD/Include"
	cp "$(UNPACK_DIR)/UFConfig/UFConfig.h" "$(UNPACK_DIR)/UMFPACK/Include"
	cd $(UNPACK_DIR)/UMFPACK; export PATH=$(RUNTIME_DIR)/bin:$$PATH; make && make hb && make clean
	cp -r "$(UNPACK_DIR)/UFConfig" "$(UNPACK_DIR)/AMD" "$(UNPACK_DIR)/UMFPACK" $(RUNTIME_DIR)/lib
	A=`echo "$(RUNTIME_DIR)"|sed "s/\//\\\\\\\\\//g"`; echo "$$__UMFPACK_NUMPY_FILE_TEMPLATE" | sed "s/@RUNTIME_DIR@/$$A/g" >$$HOME/.numpy-site.cfg
	touch $(UMFPACK_TARGET)

$(DOWNLOAD_DIR)/$(UMFPACK_PACKAGE): $(INIT_TARGET)
	for package in $(UMFPACK_PACKAGE_URL); \
	do \
		echo -n "Downloading $$package... ";  \
		$(WGET) -P $(DOWNLOAD_DIR) $$package; \
		echo "done"; \
	done
	touch $@

ALL_RUNTIME_TARGETS+=$(UMFPACK_TARGET)
ALL_DOWNLOAD_TARGETS+=$(DOWNLOAD_DIR)/$(UMFPACK_PACKAGE)

