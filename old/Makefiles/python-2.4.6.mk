PYTHON_VERSION=2.4.6
PYTHON_TARGET=$(BUILD_FLAGS_DIR)/python
PYTHON_DEPS=$(READLINE_TARGET)
PYTHON_PACKAGE=Python-$(PYTHON_VERSION).tar.bz2
PYTHON_PACKAGE_URL=http://www.python.org/ftp/python/$(PYTHON_VERSION)/$(PYTHON_PACKAGE)

python24: $(PYTHON_TARGET)
python24-download: $(DOWNLOAD_DIR)/$(PYTHON_PACKAGE)

$(PYTHON_TARGET): $(INIT_TARGET) $(PYTHON_DEPS) $(DOWNLOAD_DIR)/$(PYTHON_PACKAGE) 
	-rm -rf $(UNPACK_DIR)/Python-$(PYTHON_VERSION)
	tar -m -C $(UNPACK_DIR) -xjvf $(DOWNLOAD_DIR)/$(PYTHON_PACKAGE)
	-cd $(UNPACK_DIR)/Python-$(PYTHON_VERSION); \
	for patch in $(PATCH_DIR)/Python-$(PYTHON_VERSION)_$(ARCH)_*; \
		do patch -p1 < $$patch; \
	done
	cd $(UNPACK_DIR)/Python-$(PYTHON_VERSION); $(COMPILER_PARAMS) $(UNPACK_DIR)/Python-$(PYTHON_VERSION)/configure --enable-framework=$(RUNTIME_DIR) --prefix=$(RUNTIME_DIR) MACOSX_DEPLOYMENT_TARGET=10.6 && make && make install
	touch $(PYTHON_TARGET)

$(DOWNLOAD_DIR)/$(PYTHON_PACKAGE): $(INIT_TARGET)
	for package in $(PYTHON_PACKAGE_URL); \
	do \
		echo -n "Downloading $$package... ";  \
		$(WGET) -P $(DOWNLOAD_DIR) $$package; \
		echo "done"; \
	done
	touch $@

ALL_RUNTIME_TARGETS+=$(PYTHON_TARGET) 
ALL_DOWNLOAD_TARGETS+=$(DOWNLOAD_DIR)/$(PYTHON_PACKAGE)

