; Copyright (C) 2012 by JustBurn
;
; Permission is hereby granted, free of charge, to any person obtaining a copy
; of this software and associated documentation files (the "Software"), to deal
; in the Software without restriction, including without limitation the rights
; to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
; copies of the Software, and to permit persons to whom the Software is
; furnished to do so, subject to the following conditions:
;
; The above copyright notice and this permission notice shall be included in
; all copies or substantial portions of the Software.
;
; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
; THE SOFTWARE.

	; PokeMini Music Player
	; RAM Content
pmmusic_ram_init:

	; Main Data

pmmusram_aud_ena:       .ds 1   ; &1 = BGM, &2 = SFX
pmmusram_aud_cfg:       .ds 1
	; &128 = Unused
	; &64  = Unused
	; &32  = Jump pattern / End Sound
	; &16  = Write to RAM
	; &8   = Set Pivot
	; &4   = Set Frequency

pmmusram_ram_ptr:	.ds 2   ; RAM pointer

pmmusram_bgm_ptb:       .ds 3   ; BGM Absolute pattern address

	; BGM Data

pmmusram_bgm_wait:      .ds 1   ; BGM wait num ticks

pmmusram_bgm_mvol:      .ds 1   ; BGM Master volume
pmmusram_bgm_pvol:      .ds 1   ; BGM Play volume

pmmusram_bgm_ppr:       .ds 3   ; BGM Absolute music pointer address

pmmusram_bgm_frq:       .ds 2   ; BGM Playing Frequency
pmmusram_bgm_pvt:       .ds 2   ; BGM Playing Pivot

pmmusram_bgm_tvol:      .ds 4   ; BGM volume table, &3 = Volume, &4 = SHR Pivot

pmmusram_bgm_loop0:     .ds 4   ; BGM Loop 0 (Ptr3, Num loops)
pmmusram_bgm_loop1:     .ds 4   ; BGM Loop 1 (Ptr3, Num loops)
pmmusram_bgm_loop2:     .ds 4   ; BGM Loop 2 (Ptr3, Num loops)
pmmusram_bgm_loop3:     .ds 4   ; BGM Loop 3 (Ptr3, Num loops)

	; SFX Data

pmmusram_sfx_wait:      .db 1   ; SFX Wait num ticks

pmmusram_sfx_mvol:      .ds 1   ; SFX Master volume
pmmusram_sfx_pvol:      .ds 1   ; SFX Play volume

pmmusram_sfx_ppr:       .ds 3   ; SFX Absolute music pointer address

pmmusram_sfx_frq:       .ds 2   ; SFX Playing Frequency
pmmusram_sfx_pvt:       .ds 2   ; SFX Playing Pivot

pmmusram_sfx_tvol:      .ds 4   ; SFX volume table, &3 = Volume, &4 = SHR Pivot

pmmusram_sfx_loop0:     .ds 4   ; SFX Loop 0 (Ptr3, Num loops)
pmmusram_sfx_loop1:     .ds 4   ; SFX Loop 1 (Ptr3, Num loops)
pmmusram_sfx_loop2:     .ds 4   ; SFX Loop 2 (Ptr3, Num loops)
pmmusram_sfx_loop3:     .ds 4   ; SFX Loop 3 (Ptr3, Num loops)
