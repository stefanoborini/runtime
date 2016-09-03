NUMPY_VERSION=1.3.0
NUMPY_DEPS=$(PYTHON_TARGET) $(FFTW_TARGET) $(GFORTRAN_TARGET) $(UMFPACK_TARGET)
NUMPY_TARGET=$(BUILD_FLAGS_DIR)/numpy
NUMPY_PACKAGE=numpy-$(NUMPY_VERSION).tar.gz
NUMPY_PACKAGE_URL=http://switch.dl.sourceforge.net/sourceforge/numpy/$(NUMPY_PACKAGE)

numpy: $(NUMPY_TARGET)
numpy-download: $(DOWNLOAD_DIR)/$(NUMPY_PACKAGE)

$(NUMPY_TARGET): $(INIT_TARGET) $(NUMPY_DEPS) $(DOWNLOAD_DIR)/$(NUMPY_PACKAGE)
	export MACOSX_DEPLOYMENT_TARGET=10.6
	export CFLAGS="-arch i386 -arch x86_64"
	export FFLAGS="-arch i386 -arch x86_64"
	export LDFLAGS="-Wall -undefined dynamic_lookup -bundle -arch i386 -arch x86_64"
	-rm -rf $(UNPACK_DIR)/numpy-$(NUMPY_VERSION)/
	tar -m -C $(UNPACK_DIR) -xzvf $(DOWNLOAD_DIR)/$(NUMPY_PACKAGE)
	cd $(UNPACK_DIR)/numpy-$(NUMPY_VERSION); \
	 export PATH=$(RUNTIME_DIR)/bin:$$PATH LDFLAGS="$(LIBS):$(LDFLAGS)" CPPFLAGS="$(INCLUDES):$(CPPFLAGS)" PYTHONPATH=$(RUNTIME_DIR)/lib/python2.4/site-packages/; \
	 $(RUNTIME_DIR)/bin/python2.4 setup.py build --fcompiler=gnu95; \
	 $(RUNTIME_DIR)/bin/python2.4 setup.py install --prefix=$(RUNTIME_DIR)
	touch $(NUMPY_TARGET)

$(DOWNLOAD_DIR)/$(NUMPY_PACKAGE): $(INIT_TARGET)
	for package in $(NUMPY_PACKAGE_URL); \
	do \
		echo -n "Downloading $$package... ";  \
		$(WGET) -P $(DOWNLOAD_DIR) $$package; \
		echo "done"; \
	done
	touch $@

ALL_RUNTIME_TARGETS+=$(NUMPY_TARGET)
ALL_DOWNLOAD_TARGETS+=$(DOWNLOAD_DIR)/$(NUMPY_PACKAGE)
