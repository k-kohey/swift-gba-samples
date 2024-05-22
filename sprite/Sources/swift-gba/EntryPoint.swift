func ATTR2_BUILD(_ id: UInt16, _ pb: UInt16, _ prio: UInt16) -> UInt16 {
    (id & 0x3FF) | ((pb & 15) << 12) | ((prio & 3) << 10)
}

func ATTR2_PALBANK(_ n: UInt16) -> UInt16 {
    n << 12
}

@main
struct EntryPoint {
    static func main() {
        let tileMem: UnsafeMutablePointer<CHARBLOCK> = UnsafeMutablePointer(bitPattern: 0x06000000)!
        withUnsafePointer(to: characterTiles) { characterTilesPointer in
            characterTilesPointer.withMemoryRebound(to: CHARBLOCK.self, capacity: 1) { source in
                tileMem[4] = source.pointee
            }
        }

        let palMem = UnsafeMutablePointer<UInt16>(bitPattern: 0x05000200)!
        withUnsafePointer(to: characterPal) { pointer in
            pointer.withMemoryRebound(to: UInt16.self, capacity: 256) { uint16Pointer in
                palMem.update(from: uint16Pointer, count: 256)
            }
        }

        var objBuffer = UnsafeMutablePointer<OBJ_ATTR>.allocate(capacity: 128)

        oam_init(objBuffer, 128)
        SetMode(DCNT_OBJ | DCNT_OBJ_1D)

        obj_set_attr(&objBuffer[0], .init(ATTR0_SQUARE), .init(ATTR1_SIZE_32), ATTR2_PALBANK(0))
        obj_set_pos(&objBuffer[0], 0, 0)

        let oamMem = UnsafeMutablePointer<OBJ_ATTR>(bitPattern: 0x07000000)!

        var x: Int32 = 0
        var y: Int32 = 0
        while true {
            vid_vsync()
            key_poll()

            x += 2 * key_tri_horz()
            y += 2 * key_tri_vert()

            objBuffer[0].attr2 = ATTR2_BUILD(0, 0, 0)
            obj_set_pos(&objBuffer[0], x, y)
            oam_copy(oamMem, objBuffer, 1)
        }
    }
}
