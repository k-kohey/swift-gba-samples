// struct LifeGame {
//     let size: Size
//     var gridBuffer: UnsafeMutablePointer<Bool>
//     var currentLayer: Int = 0
//     var maxLayer: Int = 2

//     init(size: Size) {
//         self.size = size
//         let bufferSize = size.width * size.height * maxLayer
//         gridBuffer = .allocate(capacity: bufferSize)
//         for i in 0..<bufferSize {
//             (gridBuffer + i).initialize(to: false)
//         }
//     }

//     private var nextLayer: Int {
//         (currentLayer + 1) % maxLayer
//     }

//     mutating func toggleCell(x: Int, y: Int) {
//         guard x >= 0, x < size.width, y >= 0, y < size.height else { return }
//         gridBuffer[index(x: x, y: y)] = !gridBuffer[index(x: x, y: y)]
//     }

//     private func index(x: Int, y: Int, layer: Int? = nil) -> Int {
//         let layer = layer ?? currentLayer
//         let offset: Int = size.width * size.height * layer
//         return x + y * size.width + offset
//     }

//     mutating func update() {
//         for y in 0..<size.height {
//             for x in 0..<size.width {
//                 let aliveNeighbors = countAliveNeighbors(x: x, y: y)
//                 if gridBuffer[index(x: x, y: y)] {
//                     if aliveNeighbors < 2 || aliveNeighbors > 3 {
//                         gridBuffer[index(x: x, y: y, layer: nextLayer)] = false
//                         continue
//                     }
//                 } else {
//                     if aliveNeighbors == 3 {
//                         gridBuffer[index(x: x, y: y, layer: nextLayer)] = true
//                         continue
//                     }
//                 }
//                 gridBuffer[index(x: x, y: y, layer: nextLayer)] = gridBuffer[index(x: x, y: y)]
//             }
//         }
//         currentLayer = nextLayer
//     }

//     private func countAliveNeighbors(x: Int, y: Int) -> Int {
//         var count = 0
//         for dx in -1...1 {
//             for dy in -1...1 {
//                 let nx = x + dx
//                 let ny = y + dy
//                 if !(dx == 0 && dy == 0),
//                    nx >= 0, nx < size.width,
//                    ny >= 0, ny < size.height,
//                    gridBuffer[index(x: nx, y: ny)] {
//                     count += 1
//                 }
//             }
//         }
//         return count
//     }

//     func draw(on screen: ScreenWriter) {
//         for y in 0..<size.height {
//             for x in 0..<size.width {
//                 let color = gridBuffer[index(x: x, y: y)] ? Color.yellow : Color.blue
//                 screen.draw(color, x: x, y: y)
//             }
//         }
//     }
// }

// extension LifeGame {
//     mutating func initializePatterns() {
//         for i in 0...30 {
//             toggleCell(x: 1 + i, y: 2 + i)
//             toggleCell(x: 1 + i, y: 3 + i)
//             toggleCell(x: 2 + i, y: 1 + i)
//             toggleCell(x: 2 + i, y: 2 + i)
//             toggleCell(x: 2 + i, y: 3 + i)
//         }
//     }
// }
