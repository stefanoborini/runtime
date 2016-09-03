MATPLOTLIB_VERSION=0.99.0
MATPLOTLIB_TARGET=$(BUILD_FLAGS_DIR)/matplotlib
MATPLOTLIB_PACKAGE=matplotlib-$(MATPLOTLIB_VERSION).tar.gz
MATPLOTLIB_PACKAGE_URL=http://switch.dl.sourceforge.net/sourceforge/matplotlib/$(MATPLOTLIB_PACKAGE)

matplotlib: $(MATPLOTLIB_TARGET)
matplotlib-download: $(DOWNLOAD_DIR)/$(MATPLOTLIB_PACKAGE)

$(MATPLOTLIB_TARGET): $(INIT_TARGET) $(MATPLOTLIB_DEPS) $(DOWNLOAD_DIR)/$(MATPLOTLIB_PACKAGE)
	-rm -rf $(UNPACK_DIR)/matplotlib-$(MATPLOTLIB_VERSION)
	tar -m -C $(UNPACK_DIR) -xzvf $(DOWNLOAD_DIR)/$(MATPLOTLIB_PACKAGE)
	cd $(UNPACK_DIR)/matplotlib-$(MATPLOTLIB_VERSION); \
	echo "[egg_info]"  >>./setup.cfg; \
	echo "tag_svn_revision = 1"  >>./setup.cfg; \
	echo "[status]"  >>./setup.cfg; \
	echo "[provide_packages]"  >>./setup.cfg; \
	echo "[gui_support]"  >>./setup.cfg; \
	echo "gtk = False"  >>./setup.cfg; \
	echo "gtkagg = False"  >>./setup.cfg; \
	echo "tkagg = False"  >>./setup.cfg; \
	echo "wxagg = False"  >>./setup.cfg; \
	echo "macosx = False" >>./setup.cfg; \
	echo "[rc_options]" >>./setup.cfg; \
	echo "backend = Pdf" >>./setup.cfg;
	cd $(UNPACK_DIR)/matplotlib-$(MATPLOTLIB_VERSION); export PATH=$(RUNTIME_DIR)/bin:$$PATH PYTHONPATH=$(RUNTIME_DIR)/lib/python2.4/site-packages/; $(RUNTIME_DIR)/bin/python2.4 setup.py install --prefix=$(RUNTIME_DIR)
	touch $(MATPLOTLIB_TARGET)

$(DOWNLOAD_DIR)/$(MATPLOTLIB_PACKAGE): $(INIT_TARGET)
	for package in $(MATPLOTLIB_PACKAGE_URL); \
	do \
		echo -n "Downloading $$package... ";  \
		$(WGET) -P $(DOWNLOAD_DIR) $$package; \
		echo "done"; \
	done
	touch $@

ALL_RUNTIME_TARGETS+=$(MATPLOTLIB_TARGET)
ALL_DOWNLOAD_TARGETS+=$(DOWNLOAD_DIR)/$(MATPLOTLIB_PACKAGE)
