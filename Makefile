ifeq ($(strip $(GBA_LLVM)),)
	GBA_LLVM=../Downloads/gba-llvm-devkit-1-Darwin-arm64
endif

NAME = main

BIN = $(GBA_LLVM)/bin
TOOLCHAIN = /Library/Developer/Toolchains/swift-DEVELOPMENT-SNAPSHOT-2024-04-22-a.xctoolchain/usr/bin
SC = $(TOOLCHAIN)/swiftc
CC = $(BIN)/clang
SYSROOT = $(GBA_LLVM)/lib/clang-runtimes/arm-none-eabi/armv4t
GBAFIX = $(BIN)/gbafix
CFLAGS = -O3 -mthumb -mfpu=none -fno-exceptions -fno-rtti -D_LIBCPP_AVAILABILITY_HAS_NO_VERBOSE_ABOR
SWIFT_FLAGS = -Onone -wmo -enable-experimental-feature Embedded -target armv4t-none-none-eabi -use-ld=lld
SWIFT_FILES = $(NAME).swift
LFLAGS = -lcrt0-gba
CLANG_LINKER = --sysroot=$(SYSROOT) -T gba_cart.ld

$(NAME).gba: $(NAME).elf
	$(BIN)/llvm-objcopy -O binary $^ $@
	$(GBAFIX) $@

$(NAME).elf: $(SWIFT_FILES)
	$(SC) -o $@ $^ $(SWIFT_FLAGS) $(addprefix -Xlinker , $(LFLAGS)) \
		$(addprefix -Xcc , $(CFLAGS)) \
		$(addprefix -Xclang-linker , $(CLANG_LINKER))

.PHONY: clean

clean:
	rm $(NAME).elf $(NAME).gba
