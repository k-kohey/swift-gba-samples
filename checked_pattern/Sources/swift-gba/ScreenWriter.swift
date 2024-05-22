struct Color {
    static let red = Color(red: 31, green: 0, blue: 0)
    static let green = Color(red: 0, green: 31, blue: 0)
    static let blue = Color(red: 0, green: 0, blue: 31)
    static let white = Color(red: 31, green: 31, blue: 31)
    static let black = Color(red: 0, green: 0, blue: 0)
    static let yellow = Color(red: 31, green: 31, blue: 0)
    static let cyan = Color(red: 0, green: 31, blue: 31)
    static let magenta = Color(red: 31, green: 0, blue: 31)

    var red: UInt8   // 0-31
    var green: UInt8 // 0-31
    var blue: UInt8  // 0-31

    func to16Bit() -> UInt16 {
        return (UInt16(red) & 0x1F) | (UInt16(blue) & 0x1F) << 10 | (UInt16(green) & 0x1F) << 5
    }
}

struct Position {
    var x: Int
    var y: Int
}

struct Size {
    var width: Int
    var height: Int
}

enum Screen {
    static let width = 240
    static let height = 160

    static var pixels: Int {
        Screen.width * Screen.height
    }
}

final class ScreenWriter {
    private let vram = UnsafeMutablePointer<UInt16>(bitPattern: 0x6000000)!

    init() {
        let displayControl = UnsafeMutablePointer<UInt32>(bitPattern: 0x4000000)!
        displayControl.pointee = 0x403
    }

    func draw(_ color: Color, at origin: Position, size: Size) {
        let color16 = color.to16Bit()
        let startX = max(origin.x, 0)
        let startY = max(origin.y, 0)
        let endX = min(origin.x + size.width, Screen.width)
        let endY = min(origin.y + size.height, Screen.height)

        guard startX < endX && startY < endY else { return }
        for y in startY..<endY {
            let rowStartIndex = y * Screen.width + startX
            let count = endX - startX
            let destination = vram.advanced(by: rowStartIndex)
            destination.initialize(repeating: color16, count: count)
        }
    }
}

