ifeq ($(strip $(GBA_LLVM)),)
	GBA_LLVM=../Downloads/gba-llvm-devkit-1-Darwin-arm64
endif

NAME = test

BIN = $(GBA_LLVM)/bin
TOOLCHAIN = /Library/Developer/Toolchains/swift-DEVELOPMENT-SNAPSHOT-2024-04-22-a.xctoolchain/usr/bin
SC = $(TOOLCHAIN)/swiftc
CC = $(BIN)/clang
GBAFIX = $(BIN)/gbafix
SWIFT_FLAGS = -Onone -wmo -enable-experimental-feature Embedded -target armv4t-none-none-eabi -parse-as-library -use-ld=lld

SWIFT_FILES = $(wildcard *.swift)
C_FILES = $(wildcard *.c)
OBJ_FILES = $(SWIFT_FILES:.swift=.o) $(C_FILES:.c=.o)

CFLAGS = -O0 -mthumb -mfpu=none -fno-exceptions -fno-rtti -D_LIBCPP_AVAILABILITY_HAS_NO_VERBOSE_ABORT
SYSROOT = $(GBA_LLVM)/lib/clang-runtimes/arm-none-eabi/armv4t
LFLAGS = -lcrt0-gba 
CLANG_LINKER_FLAGS = -T gba_cart.ld --sysroot $(SYSROOT)

$(NAME).gba: main.elf
	$(BIN)/llvm-objcopy -O binary $^ $@
	$(GBAFIX) $@

%.elf: %.swift
	$(SC) -o $@ $< csupport.o $(SWIFT_FLAGS)  $(addprefix -Xcc , $(CFLAGS)) $(addprefix -Xlinker , $(LFLAGS)) $(addprefix -Xclang-linker , $(CLANG_LINKER_FLAGS)) 

.PHONY: clean

run: $(NAME).gba
	/Applications/mGBA.app/Contents/MacOS/mGBA $^

clean:
	rm -f main.o *.elf $(NAME).gba *.bc
