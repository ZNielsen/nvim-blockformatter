.PHONY: test

TEST_FILES := $(shell find $(TEST_DIR) -name "*test.lua" | tr '\n' ' ')

test: $(TEST_FILES)
	@busted $<
