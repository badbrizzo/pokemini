/*
  PokeMini - Pokémon-Mini Emulator
  Copyright (C) 2009-2012  JustBurn

  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#include "PokeMini.h"

TMinxPRC MinxPRC;
uint8_t PRCInvertBit[256];// Invert Bit table
int PRCAllowStall = 1;	// Allow stall CPU?
int StallCPU = 0;	// Stall CPU output flag
int PRCRenderBD = 0;	// Render backdrop? (Background overrides backdrop)
int PRCRenderBG = 1;	// Render background?
int PRCRenderSpr = 1;	// Render sprites?

#ifdef PERFORMANCE
int StallCycles = 64;	// Stall CPU cycles
#else
int StallCycles = 32;	// Stall CPU cycles
#endif

TMinxPRC_Render MinxPRC_Render = MinxPRC_Render_Mono;

//
// Functions
//

int MinxPRC_Create(void)
{
	int j;

	// Create invert bit table
	for (j=0; j<256; j++) {
		PRCInvertBit[j] = 0x00;
		if (j & 0x01) PRCInvertBit[j] |= 0x80;
		if (j & 0x02) PRCInvertBit[j] |= 0x40;
		if (j & 0x04) PRCInvertBit[j] |= 0x20;
		if (j & 0x08) PRCInvertBit[j] |= 0x10;
		if (j & 0x10) PRCInvertBit[j] |= 0x08;
		if (j & 0x20) PRCInvertBit[j] |= 0x04;
		if (j & 0x40) PRCInvertBit[j] |= 0x02;
		if (j & 0x80) PRCInvertBit[j] |= 0x01;
	}

	// Reset
	MinxPRC_Reset(1);

	return 1;
}

void MinxPRC_Destroy(void)
{
}

void MinxPRC_Reset(int hardreset)
{
	// Initialize State
	memset((void *)&MinxPRC, 0, sizeof(TMinxPRC));

	// Initialize variables
	StallCPU = 0;
	MinxPRC.PRCRateMatch = 0x10;
}

int MinxPRC_LoadState(FILE *fi, uint32_t bsize)
{
	POKELOADSS_START(1+32);
	POKELOADSS_8(StallCPU);
	POKELOADSS_32(MinxPRC.PRCCnt);
	POKELOADSS_32(MinxPRC.PRCBGBase);
	POKELOADSS_32(MinxPRC.PRCSprBase);
	POKELOADSS_8(MinxPRC.PRCMode);
	POKELOADSS_8(MinxPRC.PRCRateMatch);
	POKELOADSS_8(MinxPRC.PRCMapPX);
	POKELOADSS_8(MinxPRC.PRCMapPY);
	POKELOADSS_8(MinxPRC.PRCMapTW);
	POKELOADSS_8(MinxPRC.PRCMapTH);
	POKELOADSS_8(MinxPRC.PRCState);
	POKELOADSS_X(13);
	POKELOADSS_END(1+32);

}

int MinxPRC_SaveState(FILE *fi)
{
	POKESAVESS_START(1+32);
	POKESAVESS_8(StallCPU);
	POKESAVESS_32(MinxPRC.PRCCnt);
	POKESAVESS_32(MinxPRC.PRCBGBase);
	POKESAVESS_32(MinxPRC.PRCSprBase);
	POKESAVESS_8(MinxPRC.PRCMode);
	POKESAVESS_8(MinxPRC.PRCRateMatch);
	POKESAVESS_8(MinxPRC.PRCMapPX);
	POKESAVESS_8(MinxPRC.PRCMapPY);
	POKESAVESS_8(MinxPRC.PRCMapTW);
	POKESAVESS_8(MinxPRC.PRCMapTH);
	POKESAVESS_8(MinxPRC.PRCState);
	POKESAVESS_X(13);
	POKESAVESS_END(1+32);
}

void MinxPRC_Sync(int32_t cycles)
{
	// Process PRC Counter
	MinxPRC.PRCCnt += MINX_PRCTIMERINC * cycles;
	if ((PMR_PRC_RATE & 0xF0) >= MinxPRC.PRCRateMatch) {
		// Active frame
		if (MinxPRC.PRCCnt < 0x18000000) {
			// CPU Time
			MinxPRC.PRCState = 0;
		} else if ((MinxPRC.PRCCnt & 0xFF000000) == 0x18000000) {
			// PRC BG&SPR Trigger
			if (MinxPRC.PRCState == 1) return;
			if (MinxPRC.PRCMode == 2) {
				if (PRCAllowStall) StallCPU = 1;
				MinxPRC_Render();
				MinxPRC.PRCState = 1;
			} else if (PRCColorMap) MinxPRC_NoRender_Color();
		} else if ((MinxPRC.PRCCnt & 0xFF000000) == 0x39000000) {
			// PRC Copy Trigger
			if (MinxPRC.PRCState == 2) return;
			if (MinxPRC.PRCMode) {
				if (PRCAllowStall) StallCPU = 1;
				MinxPRC_CopyToLCD();
				MinxCPU_OnIRQAct(MINX_INTR_03);
				MinxPRC.PRCState = 2;
			}
		} else if (MinxPRC.PRCCnt >= 0x42000000) {
			// End-of-frame
			StallCPU = 0;
			PMR_PRC_RATE &= 0x0F;
			MinxPRC.PRCCnt = 0x01000000;
			MinxCPU_OnIRQAct(MINX_INTR_04);
			MinxPRC_On72HzRefresh(1);
		}
	} else {
		// Non-active frame
		if (MinxPRC.PRCCnt >= 0x42000000) {
			PMR_PRC_RATE += 0x10;
			MinxPRC.PRCCnt = 0x01000000;
			MinxPRC_On72HzRefresh(0);
		}
	}
}

uint8_t MinxPRC_ReadReg(uint8_t reg)
{
	// 0x80 to 0x8F
	switch(reg) {
		case 0x80: // PRC Stage Control
			return PMR_PRC_MODE & 0x3F;
		case 0x81: // PRC Rate Control
			return PMR_PRC_RATE;
		case 0x82: // PRC Map Tile Base (Lo)
			return PMR_PRC_MAP_LO & 0xF8;
		case 0x83: // PRC Map Tile Base (Med)
			return PMR_PRC_MAP_MID;
		case 0x84: // PRC Map Tile Base (Hi)
			return PMR_PRC_MAP_HI & 0x1F;
		case 0x85: // PRC Map Vertical Scroll
			return PMR_PRC_SCROLL_Y & 0x7F;
		case 0x86: // PRC Map Horizontal Scroll
			return PMR_PRC_SCROLL_X & 0x7F;
		case 0x87: // PRC Map Sprite Base (Lo)
			return PMR_PRC_SPR_LO & 0xC0;
		case 0x88: // PRC Map Sprite Base (Med)
			return PMR_PRC_SPR_MID;
		case 0x89: // PRC Map Sprite Base (Hi)
			return PMR_PRC_SPR_HI & 0x1F;
		case 0x8A: // PRC Counter
			return MinxPRC.PRCCnt >> 24;
		default:   // Unused
			return 0;
	}
}

void MinxPRC_WriteReg(uint8_t reg, uint8_t val)
{
	// 0x80 to 0x8F
	switch(reg) {
		case 0x80: // PRC Stage Control
			PMR_PRC_MODE = val & 0x3F;
			if (val & 0x08) {
				MinxPRC.PRCMode = (val & 0x06) ? 2 : 1;
			} else MinxPRC.PRCMode = 0;
			switch (val & 0x30) {
				case 0x00: MinxPRC.PRCMapTW = 12; MinxPRC.PRCMapTH = 16; break;
				case 0x10: MinxPRC.PRCMapTW = 16; MinxPRC.PRCMapTH = 12; break;
				case 0x20: MinxPRC.PRCMapTW = 24; MinxPRC.PRCMapTH = 8; break;
				case 0x30: MinxPRC.PRCMapTW = 24; MinxPRC.PRCMapTH = 16; break;
			}
			return;
		case 0x81: // PRC Rate Control
			if ((PMR_PRC_RATE & 0x0E) != (val & 0x0E)) PMR_PRC_RATE = (val & 0x0F);
			else PMR_PRC_RATE = (PMR_PRC_RATE & 0xF0) | (val & 0x0F);
			switch (val & 0x0E) {
				case 0x00: MinxPRC.PRCRateMatch = 0x20; break;	// Rate /3
				case 0x02: MinxPRC.PRCRateMatch = 0x50; break;	// Rate /6
				case 0x04: MinxPRC.PRCRateMatch = 0x80; break;	// Rate /9
				case 0x06: MinxPRC.PRCRateMatch = 0xB0; break;	// Rate /12
				case 0x08: MinxPRC.PRCRateMatch = 0x10; break;	// Rate /2
				case 0x0A: MinxPRC.PRCRateMatch = 0x30; break;	// Rate /4
				case 0x0C: MinxPRC.PRCRateMatch = 0x50; break;	// Rate /6
				case 0x0E: MinxPRC.PRCRateMatch = 0x70; break;	// Rate /8
			}
			return;
		case 0x82: // PRC Map Tile Base Low
			PMR_PRC_MAP_LO = val & 0xF8;
			MinxPRC.PRCBGBase = (MinxPRC.PRCBGBase & 0x1FFF00) | PMR_PRC_MAP_LO;
			return;
		case 0x83: // PRC Map Tile Base Middle
			PMR_PRC_MAP_MID = val;
			MinxPRC.PRCBGBase = (MinxPRC.PRCBGBase & 0x1F00F8) | (PMR_PRC_MAP_MID << 8);
			return;
		case 0x84: // PRC Map Tile Base High
			PMR_PRC_MAP_HI = val & 0x1F;
			MinxPRC.PRCBGBase = (MinxPRC.PRCBGBase & 0x00FFF8) | (PMR_PRC_MAP_HI << 16);
			return;
		case 0x85: // PRC Map Vertical Scroll
			PMR_PRC_SCROLL_Y = val & 0x7F;
			if (PMR_PRC_SCROLL_Y <= (MinxPRC.PRCMapTH*8-64)) MinxPRC.PRCMapPY = PMR_PRC_SCROLL_Y;
			return;
		case 0x86: // PRC Map Horizontal Scroll
			PMR_PRC_SCROLL_X = val & 0x7F;
			if (PMR_PRC_SCROLL_X <= (MinxPRC.PRCMapTW*8-96)) MinxPRC.PRCMapPX = PMR_PRC_SCROLL_X;
			return;
		case 0x87: // PRC Sprite Tile Base Low
			PMR_PRC_SPR_LO = val & 0xC0;
			MinxPRC.PRCSprBase = (MinxPRC.PRCSprBase & 0x1FFF00) | PMR_PRC_SPR_LO;
			return;
		case 0x88: // PRC Sprite Tile Base Middle
			PMR_PRC_SPR_MID = val;
			MinxPRC.PRCSprBase = (MinxPRC.PRCSprBase & 0x1F00C0) | (PMR_PRC_SPR_MID << 8);
			return;
		case 0x89: // PRC Sprite Tile Base High
			PMR_PRC_SPR_HI = val & 0x1F;
			MinxPRC.PRCSprBase = (MinxPRC.PRCSprBase & 0x00FFC0) | (PMR_PRC_SPR_HI << 16);
			return;
		case 0x8A: // PRC Counter
			return;
	}
}

//
// Default PRC Rendering
//

static inline void MinxPRC_DrawSprite8x8_Mono(uint8_t cfg, int X, int Y, int DrawT, int MaskT)
{
	int xC, xP, vaddr;
	uint8_t vdata, sdata, smask;
	uint8_t data;

	// No point to proceed if it's offscreen
	if (X >= 96) return;
	if (Y >= 64) return;

	// Pre calculate
	vaddr = 0x1000 + ((Y >> 3) * 96) + X;

	// Process top columns
	if ((Y >= 0) && (Y < 96)) {
		for (xC=0; xC<8; xC++) {
			if ((X >= 0) && (X < 96)) {
				xP = (cfg & 0x01) ? (7 - xC) : xC;

				vdata = MinxPRC_OnRead(0, vaddr + xC);
				sdata = MinxPRC_OnRead(0, MinxPRC.PRCSprBase + (DrawT * 8) + xP);
				smask = MinxPRC_OnRead(0, MinxPRC.PRCSprBase + (MaskT * 8) + xP);

				if (cfg & 0x02) {
					sdata = PRCInvertBit[sdata];
					smask = PRCInvertBit[smask];
				}
				if (cfg & 0x04) sdata = ~sdata;

				data = vdata & ((smask << (Y & 7)) | (0xFF >> (8 - (Y & 7))));
				data |= (sdata & ~smask) << (Y & 7);

				MinxPRC_OnWrite(0, vaddr + xC, data);
			}
			X++;
		}
		X -= 8;
	}

	// Calculate new vaddr;
	vaddr += 96;

	// Process bottom columns
	if ((Y >= -7) && (Y < 56) && (Y & 7)) {
		for (xC=0; xC<8; xC++) {
			if ((X >= 0) && (X < 96)) {
				xP = (cfg & 0x01) ? (7 - xC) : xC;

				vdata = MinxPRC_OnRead(0, vaddr + xC);
				sdata = MinxPRC_OnRead(0, MinxPRC.PRCSprBase + (DrawT * 8) + xP);
				smask = MinxPRC_OnRead(0, MinxPRC.PRCSprBase + (MaskT * 8) + xP);

				if (cfg & 0x02) {
					sdata = PRCInvertBit[sdata];
					smask = PRCInvertBit[smask];
				}
				if (cfg & 0x04) sdata = ~sdata;

				data = vdata & ((smask >> (8-(Y & 7))) | (0xFF << (Y & 7)));
				data |= (sdata & ~smask) >> (8-(Y & 7));

				MinxPRC_OnWrite(0, vaddr + xC, data);
			}
			X++;
		}
	}
}

void MinxPRC_Render_Mono(void)
{
	int xC, yC, tx, ty, ltileidxaddr, tileidxaddr, outaddr;
	int tiletopaddr = 0, tilebotaddr = 0;
	uint8_t data;

	int SprTB, SprAddr;
	int SprX, SprY, SprC;

	if (PRCRenderBD) {
		for (xC=0x1000; xC<0x1300; xC++) MinxPRC_OnWrite(0, xC, 0x00);
	}

	if ((PRCRenderBG) && (PMR_PRC_MODE & 0x02)) {
		outaddr = 0x1000;
		ltileidxaddr = -1;
		for (yC=0; yC<8; yC++) {
			ty = (yC << 3) + MinxPRC.PRCMapPY;
			for (xC=0; xC<96; xC++) {
				tx = xC + MinxPRC.PRCMapPX;
				tileidxaddr = 0x1360 + (ty >> 3) * MinxPRC.PRCMapTW + (tx >> 3);

				// Read tile index
				if (ltileidxaddr != tileidxaddr) {
					tiletopaddr = MinxPRC.PRCBGBase + (MinxPRC_OnRead(0, tileidxaddr) * 8);
					tilebotaddr = MinxPRC.PRCBGBase + (MinxPRC_OnRead(0, tileidxaddr + MinxPRC.PRCMapTW) * 8);
					ltileidxaddr = tileidxaddr;
				}

				// Read tile data
				data = (MinxPRC_OnRead(0, tiletopaddr + (tx & 7)) >> (ty & 7))
				     | (MinxPRC_OnRead(0, tilebotaddr + (tx & 7)) << (8 - (ty & 7)));

				// Write to VRAM
				MinxPRC_OnWrite(0, outaddr++, (PMR_PRC_MODE & 0x01) ? ~data : data);
			}
		}
	}

	if ((PRCRenderSpr) && (PMR_PRC_MODE & 0x04)) {
		SprAddr = 0x1300 + (24 * 4);
		do {
			SprC = MinxPRC_OnRead(0, --SprAddr);
			SprTB = MinxPRC_OnRead(0, --SprAddr) * 8;
			SprY = (MinxPRC_OnRead(0, --SprAddr) & 0x7F) - 16;
			SprX = (MinxPRC_OnRead(0, --SprAddr) & 0x7F) - 16;
			if (SprC & 0x08) {
				MinxPRC_DrawSprite8x8_Mono(SprC, SprX + (SprC & 0x01 ? 8 : 0), SprY + (SprC & 0x02 ? 8 : 0), SprTB+2, SprTB);
				MinxPRC_DrawSprite8x8_Mono(SprC, SprX + (SprC & 0x01 ? 8 : 0), SprY + (SprC & 0x02 ? 0 : 8), SprTB+3, SprTB+1);
				MinxPRC_DrawSprite8x8_Mono(SprC, SprX + (SprC & 0x01 ? 0 : 8), SprY + (SprC & 0x02 ? 8 : 0), SprTB+6, SprTB+4);
				MinxPRC_DrawSprite8x8_Mono(SprC, SprX + (SprC & 0x01 ? 0 : 8), SprY + (SprC & 0x02 ? 0 : 8), SprTB+7, SprTB+5);
			}
		} while (SprAddr > 0x1300);
	}
}

void MinxPRC_CopyToLCD(void)
{
	MinxLCD_LCDWritefb(MinxPRC_LCDfb);
/*
	// Can't be used with the new color mode support for LCD
	int i, j;
	MinxLCD_LCDWriteCtrl(0xEE);
	for (i=0; i<8; i++) {
		MinxLCD_LCDWriteCtrl(0xB0 + i);
		MinxLCD_LCDWriteCtrl(0x00);
		MinxLCD_LCDWriteCtrl(0x10);
		for (j=0; j<96; j++) {
			MinxLCD_LCDWrite(MinxPRC_OnRead(0, 0x1000 + (i * 96) + j));
		}
	}
*/
}
