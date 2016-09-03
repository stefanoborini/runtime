MPFR_VERSION=2.3.1
MPFR_TARGET=$(BUILD_FLAGS_DIR)/mpfr
MPFR_DEPS=$(GMP_TARGET)
MPFR_PACKAGE=mpfr-$(MPFR_VERSION).tar.bz2
MPFR_PACKAGE_URL=ftp://ftp.skynet.be/mirror1/slackware.com/slackware-current/source/l/mpfr/$(MPFR_PACKAGE)

mpfr: $(MPFR_TARGET) 
mpfr-download: $(DOWNLOAD_DIR)/$(MPFR_PACKAGE)

$(MPFR_TARGET): $(INIT_TARGET) $(MPFR_DEPS) $(DOWNLOAD_DIR)/$(MPFR_PACKAGE) 
	-rm -rf $(UNPACK_DIR)/mpfr-$(MPFR_VERSION)
	
	tar -m -C $(UNPACK_DIR) -xjvf $(DOWNLOAD_DIR)/$(MPFR_PACKAGE)
	cd $(UNPACK_DIR)/mpfr-$(MPFR_VERSION)/ && ./configure --with-gmp=$(RUNTIME_DIR) --prefix=$(RUNTIME_DIR)
	cd $(UNPACK_DIR)/mpfr-$(MPFR_VERSION)/; make -j2 && make install
	touch $(MPFR_TARGET)

$(DOWNLOAD_DIR)/$(MPFR_PACKAGE): $(INIT_TARGET)
	$(WGET) -P $(DOWNLOAD_DIR) $(MPFR_PACKAGE_URL)
	touch $@
	
ALL_RUNTIME_TARGETS+=$(MPFR_TARGET)
ALL_DOWNLOAD_TARGETS+=$(DOWNLOAD_DIR)/$(MPFR_PACKAGE)


