@main
struct EntryPoint {
    static func main() {
        let screenWriter = ScreenWriter()
        let rectSize = Size(width: 10, height: 10)
        for y in 0..<(Screen.height / rectSize.height) {
            for x in 0..<(Screen.width / rectSize.width) {
                let color: Color = (x + y) % 2 == 0 ? .black : .green
                screenWriter.draw(
                    color,
                    at: .init(x: x * rectSize.width, y: y * rectSize.height),
                    size: rectSize
                )
            }
        }
        while true {}
    }
}
