func draw() {
    // Set background mode 3 (bitmap) and turn on background 2
    let displayControl = UnsafeMutablePointer<UInt32>(bitPattern: 0x4000000)!
    displayControl.pointee = 0x403

    // Set the video memory address to the beginning of the screen
    let vram = UnsafeMutablePointer<UInt16>(bitPattern: 0x6000000)!
    // Write red to every pixel on the 240x160 screen
    for x in 0..<240 {
        for y in 0..<160 {
            vram[x + y * 240] = 0b1111110100000000
        }
    }
}

@_silgen_name("main")
public func main() -> Int32 {
    draw()
    while true {}
    return 1
}