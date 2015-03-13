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
	; Macros

.equ N____ -1

.equ N_C_1 $EEE3  ; 32.70 Hz
.equ N_CS1 $E17A  ; 34.65 Hz
.equ N_D_1 $D4D2  ; 36.71 Hz
.equ N_DS1 $C8E0  ; 38.89 Hz
.equ N_E_1 $BD9A  ; 41.20 Hz
.equ N_F_1 $B2F6  ; 43.65 Hz
.equ N_FS1 $A8EA  ; 46.25 Hz
.equ N_G_1 $9F6F  ; 49.00 Hz
.equ N_GS1 $967C  ; 51.91 Hz
.equ N_A_1 $8E0A  ; 55.00 Hz
.equ N_AS1 $8611  ; 58.27 Hz
.equ N_B_1 $7E8B  ; 61.74 Hz

.equ N_C_2 $7771  ; 65.41 Hz
.equ N_CS2 $70BC  ; 69.30 Hz
.equ N_D_2 $6A68  ; 73.42 Hz
.equ N_DS2 $646F  ; 77.78 Hz
.equ N_E_2 $5ECC  ; 82.41 Hz
.equ N_F_2 $597A  ; 87.31 Hz
.equ N_FS2 $5474  ; 92.50 Hz
.equ N_G_2 $4FB7  ; 98.00 Hz
.equ N_GS2 $4B3D  ; 103.83 Hz
.equ N_A_2 $4704  ; 110.00 Hz
.equ N_AS2 $4308  ; 116.54 Hz
.equ N_B_2 $3F45  ; 123.47 Hz

.equ N_C_3 $3BB8  ; 130.81 Hz
.equ N_CS3 $385D  ; 138.59 Hz
.equ N_D_3 $3533  ; 146.83 Hz
.equ N_DS3 $3237  ; 155.56 Hz
.equ N_E_3 $2F65  ; 164.81 Hz
.equ N_F_3 $2CBC  ; 174.61 Hz
.equ N_FS3 $2A39  ; 185.00 Hz
.equ N_G_3 $27DB  ; 196.00 Hz
.equ N_GS3 $259E  ; 207.65 Hz
.equ N_A_3 $2381  ; 220.00 Hz
.equ N_AS3 $2183  ; 233.08 Hz
.equ N_B_3 $1FA2  ; 246.94 Hz

.equ N_C_4 $1DDB  ; 261.63 Hz
.equ N_CS4 $1C2E  ; 277.18 Hz
.equ N_D_4 $1A99  ; 293.66 Hz
.equ N_DS4 $191B  ; 311.13 Hz
.equ N_E_4 $17B2  ; 329.63 Hz
.equ N_F_4 $165D  ; 349.23 Hz
.equ N_FS4 $151C  ; 369.99 Hz
.equ N_G_4 $13ED  ; 392.00 Hz
.equ N_GS4 $12CE  ; 415.30 Hz
.equ N_A_4 $11C0  ; 440.00 Hz
.equ N_AS4 $10C1  ; 466.16 Hz
.equ N_B_4 $0FD0  ; 493.88 Hz

.equ N_C_5 $0EED  ; 523.25 Hz
.equ N_CS5 $0E16  ; 554.37 Hz
.equ N_D_5 $0D4C  ; 587.33 Hz
.equ N_DS5 $0C8D  ; 622.25 Hz
.equ N_E_5 $0BD8  ; 659.26 Hz
.equ N_F_5 $0B2E  ; 698.46 Hz
.equ N_FS5 $0A8D  ; 739.99 Hz
.equ N_G_5 $09F6  ; 783.99 Hz
.equ N_GS5 $0966  ; 830.61 Hz
.equ N_A_5 $08DF  ; 880.00 Hz
.equ N_AS5 $0860  ; 932.33 Hz
.equ N_B_5 $07E7  ; 987.77 Hz

.equ N_C_6 $0776  ; 1046.50 Hz
.equ N_CS6 $070A  ; 1108.73 Hz
.equ N_D_6 $06A5  ; 1174.66 Hz
.equ N_DS6 $0646  ; 1244.51 Hz
.equ N_E_6 $05EB  ; 1318.51 Hz
.equ N_F_6 $0596  ; 1396.91 Hz
.equ N_FS6 $0546  ; 1479.98 Hz
.equ N_G_6 $04FA  ; 1567.98 Hz
.equ N_GS6 $04B2  ; 1661.22 Hz
.equ N_A_6 $046F  ; 1760.00 Hz
.equ N_AS6 $042F  ; 1864.66 Hz
.equ N_B_6 $03F3  ; 1975.53 Hz

.equ N_C_7 $03BA  ; 2093.00 Hz
.equ N_CS7 $0384  ; 2217.46 Hz
.equ N_D_7 $0352  ; 2349.32 Hz
.equ N_DS7 $0322  ; 2489.02 Hz
.equ N_E_7 $02F5  ; 2637.02 Hz
.equ N_F_7 $02CA  ; 2793.83 Hz
.equ N_FS7 $02A2  ; 2959.96 Hz
.equ N_G_7 $027C  ; 3135.96 Hz
.equ N_GS7 $0258  ; 3322.44 Hz
.equ N_A_7 $0237  ; 3520.00 Hz
.equ N_AS7 $0217  ; 3729.31 Hz
.equ N_B_7 $01F9  ; 3951.07 Hz

.macro PATTERN pataddr
	.dw pataddr, pataddr >> 16
.endm

.macro ROW note_id, pwm_amt, volume, wait_amt
  .if (note_id >= 0) && (pwm_amt >= 0) && (volume >= 0)
	.dw $3400 | (volume << 8) | (wait_amt & 255)
	.dw note_id
	.dw (note_id * pwm_amt / 256)
  .elif (note_id >= 0) && (pwm_amt >= 0)
	.dw $3000 | (wait_amt & 255)
	.dw note_id
	.dw (note_id * pwm_amt / 256)
  .elif (pwm_amt >= 0) && (volume >= 0)
	.dw $2400 | (volume << 8) | (wait_amt & 255)
	.dw (note_id * pwm_amt / 256)
  .elif (pwm_amt >= 0)
	.dw $2000 | (wait_amt & 255)
	.dw (note_id * pwm_amt / 256)
  .elif (note_id >= 0) && (volume >= 0)
	.dw $1400 | (volume << 8) | (wait_amt & 255)
	.dw note_id
  .elif (note_id >= 0)
	.dw $1000 | (wait_amt & 255)
	.dw note_id
  .elif (volume >= 0)
	.dw $0400 | (volume << 8) | (wait_amt & 255)
  .else
	.dw $0000 | (wait_amt & 255)
  .endif
.endm

.macro WRITE_RAM address, value
	.dw $0800
	.db value, address
.endm

.macro MARK loop_id
	.dw $8000
	.db 0, (loop_id << 2)
.endm

.macro LOOP loop_id, loop_num
  .if (loop_num >= 0)
	.dw $8000
	.db loop_num, (loop_id << 2)
  .endif
.endm

.macro NEXT_PAT
	.dw $4000, $0004
.endm

.macro GOBACK_PAT patt
	.dw $4000, -(patt * 4)
.endm

.macro END_SOUND
	.dw $4401, $0000
.endm
