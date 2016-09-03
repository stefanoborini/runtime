SCIPY_VERSION=0.7.1
SCIPY_TARGET=$(BUILD_FLAGS_DIR)/scipy
SCIPY_DEPS=$(NUMPY_TARGET)
SCIPY_PACKAGE=scipy-$(SCIPY_VERSION).tar.gz
SCIPY_PACKAGE_URL=http://switch.dl.sourceforge.net/sourceforge/scipy/$(SCIPY_PACKAGE)

scipy: $(SCIPY_TARGET)
scipy-download: $(DOWNLOAD_DIR)/$(SCIPY_PACKAGE)

$(SCIPY_TARGET): $(INIT_TARGET) $(SCIPY_DEPS) $(DOWNLOAD_DIR)/$(SCIPY_PACKAGE) 
	-rm -rf $(UNPACK_DIR)/scipy-$(SCIPY_VERSION)/
	tar -m -C $(UNPACK_DIR) -xzvf $(DOWNLOAD_DIR)/$(SCIPY_PACKAGE)
	cd $(UNPACK_DIR)/scipy-$(SCIPY_VERSION); export PATH=$(RUNTIME_DIR)/bin:$$PATH PYTHONPATH=$(RUNTIME_DIR)/lib/python2.4/site-packages/; $(RUNTIME_DIR)/bin/python2.4 setup.py install --prefix=$(RUNTIME_DIR)
	touch $(SCIPY_TARGET)

$(DOWNLOAD_DIR)/$(SCIPY_PACKAGE): $(INIT_TARGET)
	for package in $(SCIPY_PACKAGE_URL); \
	do \
		echo -n "Downloading $$package... ";  \
		$(WGET) -P $(DOWNLOAD_DIR) $$package; \
		echo "done"; \
	done
	touch $@

ALL_RUNTIME_TARGETS+=$(SCIPY_TARGET)
ALL_DOWNLOAD_TARGETS+=$(DOWNLOAD_DIR)/$(SCIPY_PACKAGE)
