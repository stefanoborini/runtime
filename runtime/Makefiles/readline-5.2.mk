READLINE_DEPS=$(GCC_TARGET)
READLINE_VERSION=5.2
READLINE_TARGET=$(BUILD_FLAGS_DIR)/readline
READLINE_PACKAGE=readline-$(READLINE_VERSION).tar.gz
READLINE_PACKAGE_URL=http://ftp.gnu.org/gnu/readline/$(READLINE_PACKAGE)

readline: $(READLINE_TARGET)
readline-download: $(DOWNLOAD_DIR)/$(READLINE_PACKAGE)

$(READLINE_TARGET): $(INIT_TARGET) $(READLINE_DEPS)  $(DOWNLOAD_DIR)/$(READLINE_PACKAGE) 
	-rm -rf $(UNPACK_DIR)/readline-$(READLINE_VERSION)/
	tar -m -C $(UNPACK_DIR) -xzvf $(DOWNLOAD_DIR)/$(READLINE_PACKAGE)
	cd $(UNPACK_DIR)/readline-$(READLINE_VERSION); \
	for patch in $(PATCH_DIR)/readline-$(READLINE_VERSION)_$(ARCH)_*; \
		do patch -p1 < $$patch; \
	done
	cd $(UNPACK_DIR)/readline-$(READLINE_VERSION)/; export PATH=$(RUNTIME_DIR)/bin:$$PATH; ./configure --build=x86_64-apple-darwin10 --prefix=$(RUNTIME_DIR);
	cd $(UNPACK_DIR)/readline-$(READLINE_VERSION)/; export PATH=$(RUNTIME_DIR)/bin:$$PATH; make -j 2 && make install
	touch $(READLINE_TARGET)

$(DOWNLOAD_DIR)/$(READLINE_PACKAGE): $(INIT_TARGET)
	for package in $(READLINE_PACKAGE_URL); \
	do \
		echo -n "Downloading $$package... ";  \
		$(WGET) -P $(DOWNLOAD_DIR) $$package; \
		echo "done"; \
	done
	touch $@

ALL_RUNTIME_TARGETS+=$(READLINE_TARGET)
ALL_DOWNLOAD_TARGETS+=$(DOWNLOAD_DIR)/$(READLINE_PACKAGE)

