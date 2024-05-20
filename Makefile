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
CFLAGS = -O3 -mthumb -mfpu=none -fno-exceptions -fno-rtti -D_LIBCPP_AVAILABILITY_HAS_NO_VERBOSE_ABORT
SWIFT_FLAGS = -Onone -wmo -enable-experimental-feature Embedded -target armv4t-none-none-eabi
SWIFT_FILES = $(NAME).swift
OBJ_FILES = $(NAME).o
LFLAGS = -lcrt0-gba
CLANG_LINKER_FLAGS = --sysroot=$(SYSROOT) -T gba_cart.ld

$(NAME).gba: $(NAME).elf
	$(BIN)/llvm-objcopy -O binary $^ $@
	$(GBAFIX) $@

$(NAME).elf: $(OBJ_FILES)
	$(CC) -o $@ $^ -O3 -mthumb --config armv4t-gba.cfg -Wl,-T,gba_cart.ld

$(NAME).o: $(SWIFT_FILES)
	$(SC) -c -o $@ $^ $(SWIFT_FLAGS) $(addprefix -Xcc , $(CFLAGS)) -parse-as-library ーXclang-linker -nostdlib

.PHONY: clean

clean:
	rm -f $(NAME).o $(NAME).elf $(NAME).gba
