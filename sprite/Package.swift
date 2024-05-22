// swift-tools-version: 5.10

import PackageDescription

let GBA_LLVM = "../Downloads/gba-llvm-devkit-1-Darwin-arm64"
let SYSROOT = "\(GBA_LLVM)/lib/clang-runtimes/arm-none-eabi/armv4t"

let package = Package(
    name: "my_game",
    platforms: [.macOS(.v14)],
    products: [
        .library(
            name: "my_game",
            targets: ["my_game"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "my_game",
            dependencies: [],
            publicHeadersPath: "include",
            cSettings: [
                .define("_LIBCPP_AVAILABILITY_HAS_NO_VERBOSE_ABORT"),
                .unsafeFlags(["-O3", "-mthumb", "-mfpu=none", "-fno-exceptions", "-fno-rtti", "-fshort-enums"])
            ],
            swiftSettings: [
                .enableExperimentalFeature("Embedded"),
                .unsafeFlags(
                    [
                        "-Osize",
                        "-wmo",
                        "-target", "armv4t-none-none-eabi",
                        "-parse-as-library",
                        "-I\(SYSROOT)/include",
                        "-Xfrontend", "-internalize-at-link", "-lto=llvm-thin",
                        "-Xfrontend", "-disable-stack-protector",
                        "-Xfrontend", "-disable-objc-interop",
                        "-import-objc-header", "Bridging-Header.h"
                    ]
                )
            ],
            linkerSettings: [
                .linkedLibrary("crt0-gba"),
                .linkedLibrary("tonc"),
                .linkedLibrary("c"),
                .unsafeFlags(
                    [
                        "-T", "gba_cart.ld",
                        "--sysroot", SYSROOT,
                        "-fuse-ld=lld"
                    ]
                )
            ]
        )
    ]
)
