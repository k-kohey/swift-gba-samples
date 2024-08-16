func ATTR2_BUILD(_ id: UInt16, _ pb: UInt16, _ prio: UInt16) -> UInt16 {
    (id & 0x3FF) | ((pb & 15) << 12) | ((prio & 3) << 10)
}

func ATTR2_PALBANK(_ n: UInt16) -> UInt16 {
    n << 12
}

func BG_CBB(_ n: UInt16) -> UInt16 {
    n << 2
}

func BG_SBB(_ n: UInt16) -> UInt16 {
    n << 8
}

enum Mem {
    static let bg0cnt = UnsafeMutablePointer<UInt16>(bitPattern: 0x4000008)!
    static let palBg = UnsafeMutablePointer<UInt16>(bitPattern: 0x05000000)!
    static let pal = UnsafeMutablePointer<UInt16>(bitPattern: 0x05000200)!
    static let tile = UnsafeMutablePointer<CHARBLOCK>(bitPattern: 0x06000000)!
    static let screenBlock = UnsafeMutablePointer<SCREENBLOCK>(bitPattern: 0x06000000)!
    static let oam = UnsafeMutablePointer<OBJ_ATTR>(bitPattern: 0x07000000)!
}

final class Charcter {
    private let objBuffer = UnsafeMutablePointer<OBJ_ATTR>.allocate(capacity: 128)
    private var x: Int32 = 0
    private var y: Int32 = 0

    func setUp() {
        withUnsafePointer(to: characterTiles) { characterTilesPointer in
            characterTilesPointer.withMemoryRebound(to: CHARBLOCK.self, capacity: 1) { source in
                Mem.tile[4] = source.pointee
            }
        }

        withUnsafePointer(to: characterPal) { pointer in
            pointer.withMemoryRebound(to: UInt16.self, capacity: 256) { uint16Pointer in
                Mem.pal.update(from: uint16Pointer, count: 256)
            }
        }

        oam_init(objBuffer, 128)
        obj_set_attr(&objBuffer[0], .init(ATTR0_SQUARE), .init(ATTR1_SIZE_32), ATTR2_PALBANK(0))
        obj_set_pos(&objBuffer[0], x, y)
        objBuffer[0].attr2 = ATTR2_BUILD(0, 0, 0)
    }

    func move(tx: Int32, ty: Int32) {
        x += tx
        y += ty
        obj_set_pos(&objBuffer[0], x, y)
        oam_copy(Mem.oam, objBuffer, 1)
    }
}

final class Background {
    func setUp() {
        withUnsafePointer(to: backgroundTiles) { backgroundTilesPointer in
            backgroundTilesPointer.withMemoryRebound(to: CHARBLOCK.self, capacity: 1) { source in
                Mem.tile[0] = source.pointee
            }
        }

        withUnsafePointer(to: backgroundMap1) { backgroundMapPointer in
            backgroundMapPointer.withMemoryRebound(to: SCREENBLOCK.self, capacity: 1) { source in
                Mem.screenBlock[30] = source.pointee
            }
        }

        withUnsafePointer(to: backgroundMap2) { backgroundMapPointer in
            backgroundMapPointer.withMemoryRebound(to: SCREENBLOCK.self, capacity: 1) { source in
                Mem.screenBlock[31] = source.pointee
            }
        }

        withUnsafePointer(to: backgroundPal) { pointer in
            pointer.withMemoryRebound(to: UInt16.self, capacity: 256) { uint16Pointer in
                Mem.palBg.update(from: uint16Pointer, count: 256)
            }
        }
    }
}

@main
struct EntryPoint {
    static func main() {
        let chaarcter = Charcter()
        chaarcter.setUp()
        let background = Background()
        background.setUp()

        Mem.bg0cnt.pointee = BG_CBB(0) | BG_SBB(30) | .init(BG_4BPP) | .init(BG_REG_64x32)
        SetMode(DCNT_OBJ | DCNT_OBJ_1D | DCNT_MODE0 | DCNT_BG0)

        while true {
            vid_vsync()
            key_poll()

            chaarcter.move(
                tx: 2 * key_tri_horz(),
                ty: 2 * key_tri_vert()
            )
        }
    }
}