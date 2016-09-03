FFTW_VERSION=3.2.2
FFTW_TARGET=$(BUILD_FLAGS_DIR)/fftw
FFTW_PACKAGE=fftw-$(FFTW_VERSION).tar.gz
FFTW_PACKAGE_URL=ftp://ftp.fftw.org/pub/fftw/$(FFTW_PACKAGE)

.PHONY: fftw fftw-download
fftw: $(FFTW_TARGET)
fftw-download: $(DOWNLOAD_DIR)/$(FFTW_PACKAGE)

$(FFTW_TARGET): $(INIT_TARGET) $(FFTW_DEPS) $(DOWNLOAD_DIR)/$(FFTW_PACKAGE)
	-rm -rf $(UNPACK_DIR)/fftw-$(FFTW_VERSION)
	tar -m -C $(UNPACK_DIR) -xzvf $(DOWNLOAD_DIR)/$(FFTW_PACKAGE)
	#-cd $(UNPACK_DIR)/fftw-$(FFTW_VERSION); export PATH=$(RUNTIME_DIR)/bin/:$$PATH; ./configure CC="gcc -arch i386 -arch x86_64" CXX="g++ -arch i386 -arch x86_64" CPP="gcc -E" CXXCPP="g++ -E" --prefix=$(RUNTIME_DIR); make; make install
	cd $(UNPACK_DIR)/fftw-$(FFTW_VERSION); export PATH=$(RUNTIME_DIR)/bin/:$$PATH; ./configure --prefix=$(RUNTIME_DIR)
	cd $(UNPACK_DIR)/fftw-$(FFTW_VERSION); export PATH=$(RUNTIME_DIR)/bin/:$$PATH; make -j2 && make install
	touch $(FFTW_TARGET)

$(DOWNLOAD_DIR)/$(FFTW_PACKAGE): $(INIT_TARGET)
	for package in $(FFTW_PACKAGE_URL); \
	do \
		echo -n "Downloading $$package... ";  \
		$(WGET) -P $(DOWNLOAD_DIR) $$package; \
		echo "done"; \
	done
	touch $@

ALL_RUNTIME_TARGETS+=$(FFTW_TARGET)
ALL_DOWNLOAD_TARGETS+=$(DOWNLOAD_DIR)/$(FFTW_PACKAGE)
