GBA_LLVM ?= ../../Downloads/gba-llvm-devkit-1-Darwin-arm64
TOOLCHAIN ?= /Library/Developer/Toolchains/swift-DEVELOPMENT-SNAPSHOT-2024-04-22-a.xctoolchain/usr/bin

NAME = my_game

BIN = $(GBA_LLVM)/bin
SC = $(TOOLCHAIN)/swiftc

SWIFT_FLAGS = -wmo -enable-experimental-feature Embedded -target armv4t-none-none-eabi -Xfrontend -internalize-at-link -lto=llvm-thin -Osize
CFLAGS = -mthumb -mfpu=none -fno-exceptions -fno-rtti -D_LIBCPP_AVAILABILITY_HAS_NO_VERBOSE_ABORT -fshort-enums
SYSROOT = $(GBA_LLVM)/lib/clang-runtimes/arm-none-eabi/armv4t
LFLAGS = -lcrt0-gba
CLANG_LINKER_FLAGS = -T gba_cart.ld --sysroot $(SYSROOT) -fuse-ld=lld

SWIFT_FILES = $(wildcard Sources/swift-gba/*.swift)
SWIFT_OBJ_FILES = $(SWIFT_FILES:.swift=.o)

all: $(NAME).gba

$(NAME).gba: $(NAME).elf
	$(BIN)/llvm-objcopy -O binary $^ $@
	$(BIN)/gbafix $@

$(NAME).elf: $(SWIFT_FILES)
	$(SC) -o $@ $(SWIFT_FILES) \
		$(SWIFT_FLAGS) $(addprefix -Xcc , $(CFLAGS)) \
		$(addprefix -Xlinker , $(LFLAGS)) \
		$(addprefix -Xclang-linker , $(CLANG_LINKER_FLAGS))

run: $(NAME).gba
	make
	mGBA $<

.PHONY: all clean run
clean:
	rm -f *.o *.elf *.gba *.bc
