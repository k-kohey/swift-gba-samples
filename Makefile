ifeq ($(strip $(GBA_LLVM)),)
	GBA_LLVM=../Downloads/gba-llvm-devkit-1-Darwin-arm64
endif

NAME = test

BIN = $(GBA_LLVM)/bin
TOOLCHAIN = /Library/Developer/Toolchains/swift-DEVELOPMENT-SNAPSHOT-2024-04-22-a.xctoolchain/usr/bin
SC = $(TOOLCHAIN)/swift-frontend
CC = $(BIN)/clang
GBAFIX = $(BIN)/gbafix
SWIFT_FLAGS = -Onone -wmo -enable-experimental-feature Embedded -target armv4t-none-none-eabi -parse-as-library
CFLAGS = -O3 -mthumb --config armv4t-gba.cfg

SWIFT_FILES = $(wildcard *.swift)
C_FILES = $(wildcard *.c)
OBJ_FILES = $(SWIFT_FILES:.swift=.o) $(C_FILES:.c=.o)

# CFLAGS = -O0 -mthumb -mfpu=none -fno-exceptions -fno-rtti -D_LIBCPP_AVAILABILITY_HAS_NO_VERBOSE_ABORT
# SYSROOT = $(GBA_LLVM)/lib/clang-runtimes/arm-none-eabi/armv4t
# LFLAGS = -lcrt0-gba 
# CLANG_LINKER_FLAGS = -T gba_cart.ld --sysroot $(SYSROOT) -nostdlib

$(NAME).gba: $(NAME).elf
	$(BIN)/llvm-objcopy -O binary $^ $@
	$(GBAFIX) $@

$(NAME).elf: $(OBJ_FILES)
	$(CC) -o $@ $^ $(CFLAGS) -Wl,-T,gba_cart.ld

%.o: %.swift
	$(SC) -c -o $@ $< $(SWIFT_FLAGS)

%.o: %.c
	$(CC) -o $@ -c $< $(CFLAGS)

.PHONY: clean

run: $(NAME).gba
	/Applications/mGBA.app/Contents/MacOS/mGBA --gdb $^

clean:
	rm -f *.o $(NAME).elf $(NAME).gba *.bc
