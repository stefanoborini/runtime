include config.mk
# collects all the runtime targets one by one.
ALL_RUNTIME_TARGETS=
ALL_DOWNLOAD_TARGETS=


include Makefiles/init.mk
include Makefiles/readline-5.2.mk
include Makefiles/python-2.4.6.mk


clean:
	-rm -rf $(TMP_DIR) $(UNPACK_DIR)

everything: $(ALL_RUNTIME_TARGETS)
download_everything: $(ALL_DOWNLOAD_TARGETS)

distclean: clean
	-rm -rf $(RUNTIME_DIR)
packageclean: 
	-rm -rf $(DOWNLOAD_DIR)
