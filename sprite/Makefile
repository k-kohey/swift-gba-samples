GBA_LLVM ?= ../../Downloads/gba-llvm-devkit-1-Darwin-arm64
TOOLCHAIN ?= /Library/Developer/Toolchains/swift-DEVELOPMENT-SNAPSHOT-2024-04-22-a.xctoolchain/usr/bin

NAME = my_game

BIN = $(GBA_LLVM)/bin
SC = $(TOOLCHAIN)/swiftc
CC = $(BIN)/clang
SWIFT_FLAGS = -wmo -enable-experimental-feature Embedded -target armv4t-none-none-eabi -parse-as-library -import-objc-header Bridging-Header.h -I$(SYSROOT)/include -Xfrontend -internalize-at-link -lto=llvm-thin -Xfrontend -disable-stack-protector -Xfrontend -disable-objc-interop -g
CFLAGS = -mthumb -mfpu=none -fno-exceptions -fno-rtti -D_LIBCPP_AVAILABILITY_HAS_NO_VERBOSE_ABORT -fshort-enums -g
SYSROOT = $(GBA_LLVM)/lib/clang-runtimes/arm-none-eabi/armv4t
LFLAGS = -lcrt0-gba -ltonc -lc
CLANG_LINKER_FLAGS = -T gba_cart.ld --sysroot $(SYSROOT) -fuse-ld=lld

SWIFT_FILES = $(wildcard Sources/swift-gba/*.swift)
C_FILES = $(wildcard *.c)
C_OBJ_FILES = $(C_FILES:.c=.o)
SWIFT_OBJ_FILES = $(SWIFT_FILES:.swift=.o)

all: $(NAME).gba

$(NAME).gba: $(NAME).elf
	$(BIN)/llvm-objcopy -O binary $^ $@
	$(BIN)/gbafix $@

$(NAME).elf: $(SWIFT_FILES) $(C_OBJ_FILES)
	$(SC) -o $@ $(SWIFT_FILES) $(C_OBJ_FILES) \
		$(SWIFT_FLAGS) $(addprefix -Xcc , $(CFLAGS)) \
		$(addprefix -Xlinker , $(LFLAGS)) \
		$(addprefix -Xclang-linker , $(CLANG_LINKER_FLAGS))

%.o: %.c
	$(CC) $< -o $@ -O3 -mthumb --config armv4t-gba.cfg -c

.PHONY:
run: $(NAME).gba
	make clean
	make
	mGBA $<

.PHONY: all clean run
clean:
	rm -f *.o *.elf *.gba *.bc
