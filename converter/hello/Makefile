MAKEFILEDIR := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
CALABASH = $(MAKEFILEDIR)/calabash/calabash.sh
OUT_FILE = $(basename $(notdir $(IN_FILE))).out.xml

conversion:
	-mkdir -p $(OUT_DIR)
	$(CALABASH) -D \
	-i source=$(IN_FILE) \
  -o result=$(OUT_DIR)/$(OUT_FILE) \
  $(MAKEFILEDIR)/xpl/hello-world.xpl
