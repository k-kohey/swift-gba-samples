
//{{BLOCK(background)

//======================================================================
//
//	background, 512x256@4,
//	+ palette 256 entries, not compressed
//	+ 56 tiles (t|f reduced) not compressed
//	+ regular map (in SBBs), not compressed, 64x32
//	Total size: 512 + 1792 + 4096 = 6400
//
//	Time-stamp: 2024-08-17, 01:39:35
//	Exported by Cearn's GBA Image Transmogrifier, v0.9.2
//	( http://www.coranac.com/projects/#grit )
//
//======================================================================

#ifndef GRIT_BACKGROUND_H
#define GRIT_BACKGROUND_H

#define backgroundTilesLen 1792
extern const unsigned int backgroundTiles[448];

#define backgroundMapLen 4096
extern const unsigned short backgroundMap1[1024];
extern const unsigned short backgroundMap2[1024];

#define backgroundPalLen 512
extern const unsigned short backgroundPal[256];

#endif // GRIT_BACKGROUND_H

//}}BLOCK(background)
