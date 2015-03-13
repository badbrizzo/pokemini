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
	; ROM Content
	;
	; Timers used:
	; TIMER 2 to tick music
	; TIMER 3 for the sound
	;
	; Ctrl [Data...]
	; Bit 15  - Loop*
	; Bit 14  - Jump Pattern or End Sound*
	; Bit 13  - Set Pivot*
	; Bit 12  - Set Frequency*
	; Bit 11  - Write RAM*
	; Bit 10  - Set Volume
	; Bit 8~9 - Volume, 0 to 3
	; Bit 0~7 - Wait time, 0 to 255 (0 = Immediate)

	; (( Initialize tracker ))
	; BA = RAM Pointer
	; HL = Master time
	; No return
pmmusic_init:
	push i
	push ba
	mov i, 0
	; Set master time
	mov [REG_BASE+TMR2_PRE], hl
	; Set RAM pointer
	mov [pmmusram_ram_ptr], ba
	; Registers to zero
	mov ba, 0
	mov [pmmusram_aud_ena], a
	mov [pmmusram_bgm_frq], ba
	mov [pmmusram_bgm_pvt], ba
	mov [pmmusram_sfx_frq], ba
	mov [pmmusram_sfx_pvt], ba
	or [n+IRQ_PRI1], IRQ_PRI1_TMR2
	mov [n+AUD_VOL], a
	mov [n+TMR2_OSC], a
	mov [n+TMR2_SCALE], TMR_DIV_256
	mov [n+TMR3_OSC], a
	mov [n+TMR3_SCALE], TMR_DIV_2
	mov [REG_BASE+TMR2_CTRL], ba
	mov [REG_BASE+TMR3_PRE], ba
	mov [REG_BASE+TMR3_PVT], ba
	; Registers to non-zero
	mov a, 3
	call pmmusic_setvolbgm
	mov a, 3
	call pmmusic_setvolsfx
	mov ba, TMR_ENABLE | TMR_16BITS | TMR_PRESET
	mov [REG_BASE+TMR3_CTRL], ba
	or [n+TMR1_ENA_OSC], TMRS_OSC1
	pop ba
	pop i
	ret

	; (( Set master time ))
	; HL = Master time
	; No return
pmmusic_setmastertime:
	push i
	mov i, 0
	mov [REG_BASE+TMR2_PRE], hl
	pop i
	ret

	; (( Get master time ))
	; No parameters
	; Return HL = Master time
pmmusic_getmastertime:
	push i
	mov i, 0
	mov hl, [REG_BASE+TMR2_PRE]
	pop i
	ret

	; (( Set BGM master volume ))
	; A = Volume
	; No return
pmmusic_setvolbgm:
	cmp a, 4
	jncb pmmusic_setvolbgm_end
	push i
	push ba
	push x
	push y
	mov i, 0
	mov [pmmusram_bgm_mvol], a
	shl a
	shl a
	mov y, pmmusram_bgm_tvol
	mov x, pmmusic_voltable
	mov b, 0
	add x, ba
	mov [y], [x]
	inc x
	int y
	mov [y], [x]
	inc x
	int y
	mov [y], [x]
	inc x
	int y
	mov [y], [x]
	pop y
	pop x
	pop ba
	pop i
pmmusic_setvolbgm_end:
	ret

	; (( Get BGM master volume ))
	; No parameters
	; Return A = Volume
pmmusic_getvolbgm:
	push i
	mov i, 0
	mov a, [pmmusram_bgm_mvol]
	pop i
	ret

	; (( Set SFX master volume ))
	; A = Volume
	; No return
pmmusic_setvolsfx:
	cmp a, 4
	jncb pmmusic_setvolsfx_end
	push i
	push ba
	push x
	push y
	mov i, 0
	mov [pmmusram_sfx_mvol], a
	shl a
	shl a
	mov y, pmmusram_sfx_tvol
	mov x, pmmusic_voltable
	mov b, 0
	add x, ba
	mov [y], [x]
	inc x
	int y
	mov [y], [x]
	inc x
	int y
	mov [y], [x]
	inc x
	int y
	mov [y], [x]
	pop y
	pop x
	pop ba
	pop i
pmmusic_setvolsfx_end:
	ret

	; (( Get SFX master volume ))
	; No parameters
	; Return A = Volume
pmmusic_getvolsfx:
	push i
	mov i, 0
	mov a, [pmmusram_sfx_mvol]
	pop i
	ret

	; (( Play BGM ))
	; B+HL = BGM Address
	; No return
pmmusic_playbgm:
	push f
	push i
	push ba
	mov f, $C0
	mov i, 0
	; Set pattern table
	mov [pmmusram_bgm_ptb+2], b
	mov [pmmusram_bgm_ptb], hl
	; Set BGM pointer
	mov a, b
	mov i, a
	mov ba, [hl]
	inc hl
	inc hl
	mov l, [hl]
	mov i, 0
	mov [pmmusram_bgm_ppr], ba
	mov [pmmusram_bgm_ppr+2], l
	mov a, 1
	mov [pmmusram_bgm_wait], a
	; Enable BGM play
	mov a, [pmmusram_aud_ena]
	or a, $01
	mov [pmmusram_aud_ena], a
	or [n+IRQ_ENA1], IRQ_ENA1_TMR2_HI
	tst a, $02
	jnzb pmmusic_playbgm_exit
	mov ba, TMR_ENABLE | TMR_16BITS | TMR_PRESET
	mov [REG_BASE+TMR2_CTRL], ba
	mov ba, 0
	mov [REG_BASE+TMR3_PRE], ba
	or [n+TMR3_CTRL], TMR_ENABLE | TMR_PRESET
pmmusic_playbgm_exit:
	pop ba
	pop i
	pop f
	ret

	; (( Stop BGM ))
	; No parameters
	; No return
pmmusic_stopbgm:
	push f
	push i
	push ba
	mov f, $C0
	mov i, 0
	; Disable BGM play
	mov a, $02
	and a, [pmmusram_aud_ena]
	mov [pmmusram_aud_ena], a
	jnzb pmmusic_stopbgm_nostopirq
	and [n+IRQ_ENA1], ~IRQ_ENA1_TMR2_HI
	and [n+TMR2_CTRL], ~TMR_ENABLE
	and [n+TMR3_CTRL], ~TMR_ENABLE
pmmusic_stopbgm_nostopirq:
	pop ba
	pop i
	pop f
	ret

	; (( Is playing BGM? ))
	; No parameters
	; Return F = Playing if Non-Zero
	; Return A = Playing is Non-Zero
pmmusic_isplayingbgm:
	push i
	mov i, 0
	mov a, $01
	and a, [pmmusram_aud_ena]
	pop i
	ret

	; (( Play SFX ))
	; B+HL = SFX Address
	; No return
pmmusic_playsfx:
	push f
	push i
	push ba
	mov f, $C0
	mov i, 0
	; Set SFX pointer
	mov [pmmusram_sfx_ppr+2], b
	mov [pmmusram_sfx_ppr], hl
	mov a, 1
	mov [pmmusram_sfx_wait], a
	; Enable SFX play
	mov a, $02
	or a, [pmmusram_aud_ena]
	mov [pmmusram_aud_ena], a
	or [n+IRQ_ENA1], IRQ_ENA1_TMR2_HI
	mov ba, TMR_ENABLE | TMR_16BITS | TMR_PRESET
	mov [REG_BASE+TMR2_CTRL], ba
	; Clear timer 3 preset
	mov a, [pmmusram_sfx_mvol]
	cmp a, 0
	jzb pmmusic_playsfx_end
	mov ba, 0
	mov [REG_BASE+TMR3_PRE], ba
	or [n+TMR3_CTRL], TMR_ENABLE | TMR_PRESET
pmmusic_playsfx_end:
	pop ba
	pop i
	pop f
	ret

	; (( Stop SFX ))
	; No parameters
	; No return
pmmusic_stopsfx:
	push f
	push i
	push ba
	mov f, $C0
	mov a, i
	mov i, 0
	; Disable SFX play
	mov a, $01
	and a, [pmmusram_aud_ena]
	mov [pmmusram_aud_ena], a
	jnzb pmmusic_stopsfx_nostopirq
	and [n+IRQ_ENA1], ~IRQ_ENA1_TMR2_HI
	and [n+TMR2_CTRL], ~TMR_ENABLE
	and [n+TMR3_CTRL], ~TMR_ENABLE
pmmusic_stopsfx_nostopirq:
	pop ba
	pop i
	pop f
	ret

	; (( Is playing SFX? ))
	; No parameters
	; Return F = Playing if Non-Zero
	; Return A = Playing is Non-Zero
pmmusic_isplayingsfx:
	push i
	mov i, 0
	mov a, $02
	and a, [pmmusram_aud_ena]
	pop i
	ret

	; (( Process sound from interrupt ))
	; No parameters
	; No return
irq_tmr2_hi:
	push ba
	push hl
	push x
	push i
	pushx
	mov i, 0
	; Process BGM
pmmusic_irq_checkBGM:
	mov a, $01
	and a, [pmmusram_aud_ena]
	jzw pmmusic_irq_checkSFX
pmmusic_irq_decwaitBGM:
	; Decrease BGM wait
	mov hl, pmmusram_bgm_wait
	dec [hl]
	jnzw pmmusic_irq_checkSFX
pmmusic_irq_goBGM:
	; Read data from BGM pointer
	mov x, [pmmusram_bgm_ppr]
	mov a, [pmmusram_bgm_ppr+2]
	mov xi, a
	; Set wait and volume
	mov ba, [x]
	mov [pmmusram_bgm_wait], a
	mov [pmmusram_aud_cfg], b
	tst b, $04
	jzb pmmusic_irq_BGMnovol
	mov a, b
	mov b, 0
	and a, $03
	mov hl, pmmusram_bgm_tvol
	add hl, ba
	mov a, [hl]
	mov [pmmusram_bgm_pvol], a
pmmusic_irq_BGMnovol:
	; Increment BGM pointer to next command
	mov b, 0
	mov a, [pmmusram_aud_cfg]
	shr a
	shr a
	shr a
	mov hl, pmmusic_cmdextableadd
	add hl, ba
	mov a, [hl]
	mov hl, x
	add hl, ba
	mov [pmmusram_bgm_ppr], hl
	jnzb pmmusic_irq_bgm_noinc1
	mov hl, pmmusram_bgm_ppr+2
	inc [hl]
pmmusic_irq_bgm_noinc1:
	; ---------
	; Write RAM
pmmusic_irq_BGM_Cwriteram:
	mov a, $08
	and a, [pmmusram_aud_cfg]
	jzb pmmusic_irq_BGM_Csetfreq
	inc x
	inc x
	jncb pmmusic_irq_BGM_Rwriteram
	mov a, xi
	inc a
	mov xi, a
pmmusic_irq_BGM_Rwriteram:
	mov hl, [pmmusram_ram_ptr]
	mov b, 0
	mov a, [x+1]
	add hl, ba
	mov [hl], [x]
	; -------------
	; Set Frequency
pmmusic_irq_BGM_Csetfreq:
	mov a, $10
	and a, [pmmusram_aud_cfg]
	jzb pmmusic_irq_BGM_Csetpivot
	inc x
	inc x
	jncb pmmusic_irq_BGM_Rsetfreq
	mov a, xi
	inc a
	mov xi, a
pmmusic_irq_BGM_Rsetfreq:
	mov ba, [x]
	mov [pmmusram_bgm_frq], ba
	; ---------
	; Set Pivot
pmmusic_irq_BGM_Csetpivot:
	mov a, $20
	and a, [pmmusram_aud_cfg]
	jzb pmmusic_irq_BGM_Cnextend
	inc x
	inc x
	jncb pmmusic_irq_BGM_Rsetpivot
	mov a, xi
	inc a
	mov xi, a
pmmusic_irq_BGM_Rsetpivot:
	mov ba, [x]
	mov [pmmusram_bgm_pvt], ba
	; ------------------------
	; Jump pattern / End Sound
pmmusic_irq_BGM_Cnextend:
	mov a, $40
	and a, [pmmusram_aud_cfg]
	jzb pmmusic_irq_BGM_Cloop
	inc x
	inc x
	jncb pmmusic_irq_BGM_Rnextend
	mov a, xi
	inc a
	mov xi, a
pmmusic_irq_BGM_Rnextend:
	mov ba, [x]
	cmp ba, 0
	jnzb pmmusic_irq_BGM_Rpatt
	call pmmusic_stopbgm
	jmpb pmmusic_irq_BGM_Cloop
pmmusic_irq_BGM_Rpatt:
	tst b, $80
	jnzb pmmusic_irq_BGM_Rpattsub
	mov hl, [pmmusram_bgm_ptb]
	add hl, ba
	mov [pmmusram_bgm_ptb], hl
	mov a, [pmmusram_bgm_ptb+2]
	jncb pmmusic_irq_BGM_Rpatt_noinc1
	inc a
	mov [pmmusram_bgm_ptb+2], a
pmmusic_irq_BGM_Rpatt_noinc1:
	jmpb pmmusic_irq_BGM_Rpatt_set
pmmusic_irq_BGM_Rpattsub:
	mov hl, [pmmusram_bgm_ptb]
	add hl, ba
	mov [pmmusram_bgm_ptb], hl
	mov a, [pmmusram_bgm_ptb+2]
	jcb pmmusic_irq_BGM_Rpatt_noinc2
	inc a
	mov [pmmusram_bgm_ptb+2], a
pmmusic_irq_BGM_Rpatt_noinc2:
pmmusic_irq_BGM_Rpatt_set:
	mov i, a
	mov ba, [hl]
	inc hl
	inc hl
	mov l, [hl]
	mov i, 0
	mov [pmmusram_bgm_ppr], ba
	mov [pmmusram_bgm_ppr+2], l
	; ----
	; Loop
pmmusic_irq_BGM_Cloop:
	mov a, $80
	and a, [pmmusram_aud_cfg]
	jzb pmmusic_irq_BGM_Cdone
	inc x
	inc x
	jncb pmmusic_irq_BGM_Rloop
	mov a, xi
	inc a
	mov xi, a
pmmusic_irq_BGM_Rloop:
	mov hl, [x]
	and h, $0C
	cmp l, 0
	jnzb pmmusic_irq_BGM_Rloop_loop
	; Mark Loop
	mov a, h
	mov b, 0
	mov hl, pmmusram_bgm_loop0
	add hl, ba
	mov ba, [pmmusram_bgm_ppr]
	mov [hl], ba
	inc hl
	inc hl
	mov a, [pmmusram_bgm_ppr+2]
	mov [hl], a
	inc hl
	xor a, a
	mov [hl], a
	jmpb pmmusic_irq_BGM_Cdone
pmmusic_irq_BGM_Rloop_loop:
	; Loop back
	mov a, h
	mov b, 0
	mov hl, pmmusram_bgm_loop0+3
	add hl, ba
	mov a, [x]
	cmp a, [hl]
	jzb pmmusic_irq_BGM_Cdone
	inc [hl]
	dec hl
	mov a, [hl]
	mov [pmmusram_bgm_ppr+2], a
	dec hl
	dec hl
	mov ba, [hl]
	mov [pmmusram_bgm_ppr], ba
	; ---------
	; All done!
pmmusic_irq_BGM_Cdone:
	mov a, $FF
	and a, [pmmusram_bgm_wait]
	jzw pmmusic_irq_goBGM
	; Check SFX first as it have higher priority
	mov a, [pmmusram_sfx_mvol]
	cmp a, 0
	jzb pmmusic_irq_setBGMaudio
	mov a, $02
	and a, [pmmusram_aud_ena]
	jnzb pmmusic_irq_checkSFX
	; Set BGM audio
pmmusic_irq_setBGMaudio:
	mov hl, [pmmusram_bgm_frq]
	mov [REG_BASE+TMR3_PRE], hl
	mov hl, [pmmusram_bgm_pvt]
	mov a, [pmmusram_bgm_pvol]
	tst a, $04
	jzb pmmusic_irq_BGM_noSHRpivot
	mov ba, hl
	shr b
	rorc a
	shr b
	rorc a
	shr b
	rorc a
	shr b
	rorc a
	shr b
	rorc a
	mov hl, ba
	mov a, [pmmusram_bgm_pvol]
pmmusic_irq_BGM_noSHRpivot:
	mov [REG_BASE+TMR3_PVT], hl
	and a, $03
	mov [n+AUD_VOL], a
	; Process SFX
pmmusic_irq_checkSFX:
	mov a, $02
	and a, [pmmusram_aud_ena]
	jzw pmmusic_irq_goEND
pmmusic_irq_decwaitSFX:
	; Decrease SFX wait
	mov hl, pmmusram_sfx_wait
	dec [hl]
	jnzw pmmusic_irq_goEND
pmmusic_irq_goSFX:
	; Read data from SFX pointer
	mov x, [pmmusram_sfx_ppr]
	mov a, [pmmusram_sfx_ppr+2]
	mov xi, a
	; Set wait and volume
	mov ba, [x]
	mov [pmmusram_sfx_wait], a
	mov [pmmusram_aud_cfg], b
	tst b, $04
	jzb pmmusic_irq_SFXnovol
	mov a, b
	mov b, 0
	and a, $03
	mov hl, pmmusram_sfx_tvol
	add hl, ba
	mov a, [hl]
	mov [pmmusram_sfx_pvol], a
pmmusic_irq_SFXnovol:
	; Increment SFX pointer to next command
	mov b, 0
	mov a, [pmmusram_aud_cfg]
	shr a
	shr a
	shr a
	mov hl, pmmusic_cmdextableadd
	add hl, ba
	mov a, [hl]
	mov hl, x
	add hl, ba
	mov [pmmusram_sfx_ppr], hl
	jnzb pmmusic_irq_sfx_noinc1
	mov hl, pmmusram_sfx_ppr+2
	inc [hl]
pmmusic_irq_sfx_noinc1:
	; ---------
	; Write RAM
pmmusic_irq_SFX_Cwriteram:
	mov a, $08
	and a, [pmmusram_aud_cfg]
	jzb pmmusic_irq_SFX_Csetfreq
	inc x
	inc x
	jncb pmmusic_irq_SFX_Rwriteram
	mov a, xi
	inc a
	mov xi, a
pmmusic_irq_SFX_Rwriteram:
	mov hl, [pmmusram_ram_ptr]
	mov b, 0
	mov a, [x+1]
	add hl, ba
	mov [hl], [x]
	; -------------
	; Set Frequency
pmmusic_irq_SFX_Csetfreq:
	mov a, $10
	and a, [pmmusram_aud_cfg]
	jzb pmmusic_irq_SFX_Csetpivot
	inc x
	inc x
	jncb pmmusic_irq_SFX_Rsetfreq
	mov a, xi
	inc a
	mov xi, a
pmmusic_irq_SFX_Rsetfreq:
	mov ba, [x]
	mov [pmmusram_sfx_frq], ba
	; ---------
	; Set Pivot
pmmusic_irq_SFX_Csetpivot:
	mov a, $20
	and a, [pmmusram_aud_cfg]
	jzb pmmusic_irq_SFX_Cnextend
	inc x
	inc x
	jncb pmmusic_irq_SFX_Rsetpivot
	mov a, xi
	inc a
	mov xi, a
pmmusic_irq_SFX_Rsetpivot:
	mov ba, [x]
	mov [pmmusram_sfx_pvt], ba
	; ------------------------
	; Jump pattern / End Sound
pmmusic_irq_SFX_Cnextend:
	mov a, $40
	and a, [pmmusram_aud_cfg]
	jzb pmmusic_irq_SFX_Cloop
	inc x
	inc x
	jncb pmmusic_irq_SFX_Rnextend
	mov a, xi
	inc a
	mov xi, a
pmmusic_irq_SFX_Rnextend:
	call pmmusic_stopsfx
	; ----
	; Loop
pmmusic_irq_SFX_Cloop:
	mov a, $80
	and a, [pmmusram_aud_cfg]
	jzb pmmusic_irq_SFX_Cdone
	inc x
	inc x
	jncb pmmusic_irq_SFX_Rloop
	mov a, xi
	inc a
	mov xi, a
pmmusic_irq_SFX_Rloop:
	mov hl, [x]
	and h, $0C
	cmp l, 0
	jnzb pmmusic_irq_SFX_Rloop_loop
	; Mark Loop
	mov a, h
	mov b, 0
	mov hl, pmmusram_sfx_loop0
	add hl, ba
	mov ba, [pmmusram_sfx_ppr]
	mov [hl], ba
	inc hl
	inc hl
	mov a, [pmmusram_sfx_ppr+2]
	mov [hl], a
	inc hl
	xor a, a
	mov [hl], a
	jmpb pmmusic_irq_SFX_Cdone
pmmusic_irq_SFX_Rloop_loop:
	; Loop back
	mov a, h
	mov b, 0
	mov hl, pmmusram_sfx_loop0+3
	add hl, ba
	mov a, [x]
	cmp a, [hl]
	jzb pmmusic_irq_SFX_Cdone
	inc [hl]
	dec hl
	mov a, [hl]
	mov [pmmusram_sfx_ppr+2], a
	dec hl
	dec hl
	mov ba, [hl]
	mov [pmmusram_sfx_ppr], ba
	; ---------
	; All done!
pmmusic_irq_SFX_Cdone:
	mov a, $FF
	and a, [pmmusram_sfx_wait]
	jzw pmmusic_irq_goSFX
	; Set SFX audio
	mov a, [pmmusram_sfx_mvol]
	cmp a, 0
	jzb pmmusic_irq_goEND
pmmusic_irq_setSFXaudio:
	mov hl, [pmmusram_sfx_frq]
	mov [REG_BASE+TMR3_PRE], hl
	mov hl, [pmmusram_sfx_pvt]
	mov a, [pmmusram_sfx_pvol]
	tst a, $04
	jzb pmmusic_irq_SFX_noSHRpivot
	mov ba, hl
	shr b
	rorc a
	shr b
	rorc a
	shr b
	rorc a
	shr b
	rorc a
	shr b
	rorc a
	mov hl, ba
	mov a, [pmmusram_sfx_pvol]
pmmusic_irq_SFX_noSHRpivot:
	mov [REG_BASE+TMR3_PVT], hl
	and a, $03
	mov [n+AUD_VOL], a
pmmusic_irq_goEND:
	popx
	pop i
	pop x
	pop hl
	pop ba
	mov [n+IRQ_ACT1], $20
	reti

pmmusic_voltable:
	.db $00, $00, $00, $00
	.db $00, $00, $06, $06
	.db $00, $06, $02, $02
	.db $00, $06, $02, $03

pmmusic_cmdextableadd:
	.db  2,  4,  4,  6,  4,  6,  6,  8,  4,  6,  6,  8,  6,  8,  8, 10
	.db  4,  6,  6,  8,  6,  8,  8, 10,  6,  8,  8, 10,  8, 10, 10, 12
