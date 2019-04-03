; ==============================================================================
;
;  ▄████  ██░ ██  ▒█████    ██████ ▄▄▄█████▓   ▄▄▄█████▓ ▒█████   █     █░███▄    █
; ██▒ ▀█▒▓██░ ██▒▒██▒  ██▒▒██    ▒ ▓  ██▒ ▓▒   ▓  ██▒ ▓▒▒██▒  ██▒▓█░ █ ░█░██ ▀█   █
;▒██░▄▄▄░▒██▀▀██░▒██░  ██▒░ ▓██▄   ▒ ▓██░ ▒░   ▒ ▓██░ ▒░▒██░  ██▒▒█░ █ ░█▓██  ▀█ ██▒
;░▓█  ██▓░▓█ ░██ ▒██   ██░  ▒   ██▒░ ▓██▓ ░    ░ ▓██▓ ░ ▒██   ██░░█░ █ ░█▓██▒  ▐▌██▒
;░▒▓███▀▒░▓█▒░██▓░ ████▓▒░▒██████▒▒  ▒██▒ ░      ▒██▒ ░ ░ ████▓▒░░░██▒██▓▒██░   ▓██░
; ░▒   ▒  ▒ ░░▒░▒░ ▒░▒░▒░ ▒ ▒▓▒ ▒ ░  ▒ ░░        ▒ ░░   ░ ▒░▒░▒░ ░ ▓░▒ ▒ ░ ▒░   ▒ ▒
;  ░   ░  ▒ ░▒░ ░  ░ ▒ ▒░ ░ ░▒  ░ ░    ░           ░      ░ ▒ ▒░   ▒ ░ ░ ░ ░░   ░ ▒░
;░ ░   ░  ░  ░░ ░░ ░ ░ ▒  ░  ░  ░    ░           ░      ░ ░ ░ ▒    ░   ░    ░   ░ ░
;      ░  ░  ░  ░    ░ ░        ░                           ░ ░      ░            ░
;
;
; Ghost Town, Commodore 16 Version
; Disassembled by awsm & spider j of Mayday in 2019
;
; ==============================================================================

; ==============================================================================
; language
; ENGLISH and GERMAN are available
; OPTIONS: EN / DE
; ==============================================================================

EN = 0
DE = 1

LANGUAGE = DE

; ==============================================================================
; thse settings change the appearance of the game
; EXTENDED = 0 -> original version
; EXTENDED = 1 -> altered version
; ==============================================================================

EXTENDED            = 0       ; 0 = original version, 1 = tweaks and cosmetics

!if EXTENDED = 0{
    COLOR_FOR_INVISIBLE_ROW_AND_COLUMN = $12 ; red
    MULTICOLOR_1        = $db
    MULTICOLOR_2        = $29
    BORDER_COLOR_VALUE  = $12
    TITLE_KEY_MATRIX    = $fd           ; Original key to press on title screen: 1
    TITLE_KEY           = $01

}

!if EXTENDED = 1{
    COLOR_FOR_INVISIBLE_ROW_AND_COLUMN = $01 ; grey
    MULTICOLOR_1        = $6b
    MULTICOLOR_2        = $19
    BORDER_COLOR_VALUE  = $01
    TITLE_KEY_MATRIX    = $7f           ; Extended version key to press on title screen: space
    TITLE_KEY           = $10
}


; ==============================================================================
; cheats
;
;
; ==============================================================================

START_ROOM          = 16             ; default 0 ; address $3b45
PLAYER_START_POS_X  = 3             ; default 3
PLAYER_START_POS_Y  = 6             ; default 6
SILENT_MODE         = 0


; ==============================================================================
; ZEROPAGE

zp02                = $02
zp03                = $03
zp04                = $04
zp05                = $05
zp08                = $08
zp09                = $09
zp0A                = $0A
zp10                = $10
zp11                = $11
zpA7                = $A7
zpA8                = $A8
zpA9                = $A9

; ==============================================================================

TAPE_BUFFER         = $0333
SCREENRAM           = $0C00            ; PLUS/4 default SCREEN
COLRAM              = $0800            ; PLUS/4 COLOR RAM
PRINT_KERNAL        = $c56b
BASIC_DA89          = $da89            ; scroll screen down?
KEYBOARD_LATCH      = $FF08
INTERRUPT           = $FF09
VOICE1_FREQ_LOW     = $FF0E         ; Low byte of frequency for voice 1
VOICE2_FREQ_LOW     = $FF0F
VOICE2              = $FF10
VOLUME_AND_VOICE_SELECT = $FF11
VOICE1              = $FF12 ; Bit 0-1 : Voice #1 frequency, bits 8 & 9;  Bit 2    : TED data fetch ROM/RAM select; Bits 0-5 : Bit map base address
CHAR_BASE_ADDRESS   = $FF13
BG_COLOR            = $FF15
COLOR_1             = $FF16
COLOR_2             = $FF17
COLOR_3             = $FF18
BORDER_COLOR        = $FF19

; ==============================================================================


                    !cpu 6502


                    *= $1000
m1000:
                    jsr PRINT_KERNAL           ; jsr $c56b ? wird gar nicht benutzt ?!

; ==============================================================================
;
; display the hint messages
; ==============================================================================

display_hint_message:

                    lda #>hint_messages
                    sta zpA8
                    lda #<hint_messages
m1009:              cpy #$00
                    beq ++              ; beq $1017
-                   clc
                    adc #$28
                    bcc +               ; bcc $1014
                    inc zpA8
+                   dey
                    bne -               ; bne $100d
++                  sta zpA7
                    jsr set_charset_and_screen_for_title           ; jsr $3a9d
                    ldy #$27
-                   lda (zpA7),y
                    sta SCREENRAM+$1B8,y ; sta $0db8,y
                    lda #$07
                    sta COLRAM+$1B8,y  ; sta $09b8,y
                    dey
                    bne -               ; bne $101e
                    rts

; ==============================================================================
                    sta BORDER_COLOR          ; ?!? womöglich unbenutzt ?!?
                    rts
; ==============================================================================
; TODO: understand this one, it gets called a lot

m1031:

                    jsr m11CC           ; jsr $11cc
                    cpy #$03
                    beq +                           ;bne m10B1           ; bne $10b1
                    jmp display_hint           ; jmp $1155
+                   jsr display_hint_message           ; jsr $1003
                    jsr BASIC_DA89      ; ?!? scroll screen down ?!?
                    jsr BASIC_DA89      ; ?!? scroll screen down ?!?
                    ldy #$01
                    jsr display_hint_message           ; jsr $1003
                    ldx #$00
                    ldy #$00
bp                    beq room_16_enter_code           ; beq $105f
m104C:              lda SCREENRAM+$1B9,x ; lda $0db9,x
                    clc
                    adc #$80
                    sta SCREENRAM+$1B9,x ; sta $0db9,x
                    lda SCREENRAM+$188,y ; lda $0d88,y
                    clc
                    adc #$80
                    sta SCREENRAM+$188,y ; sta $0d88,y
                    rts

; ==============================================================================
;
;
; ==============================================================================

room_16_enter_code:
                    jsr m104C           ; jsr $104c
                    sty zp02
                    stx zp04
                    jsr m10A7           ; jsr $10a7 / wait
                    jsr m104C           ; jsr $104c / some screen stuff
                    jsr m10A7           ; jsr $10a7 / wait
                    lda #$fd           ; KEYBOARD stuff
                    sta KEYBOARD_LATCH          ; .
                    lda KEYBOARD_LATCH          ; .
                    lsr                 ; .
                    lsr
                    lsr
                    bcs +               ; bcs $1081
                    cpx #$00
                    beq +               ; beq $1081
                    dex
+                   lsr
                    bcs +               ; bcs $1089
                    cpx #$25
                    beq +               ; beq $1089
                    inx
+                   and #$08
                    bne room_16_enter_code           ; bne $105f
                    lda SCREENRAM+$1B9,x ; lda $0db9,x
                    cmp #$bc
                    bne ++              ; bne $109c
                    cpy #$00
                    beq +               ; beq $1099
                    dey
+                   jmp room_16_enter_code           ; jmp $105f
++                  sta SCREENRAM+$188,y ; sta $0d88,y
                    iny
                    cpy #$05
                    bne room_16_enter_code           ; bne $105f
                    jmp m10B4           ; jmp $10b4

; ==============================================================================
;
;
; ==============================================================================

m10A7:
                    ldy #$35
                    jsr wait
                    ldy zp02
                    ldx zp04
                    rts

; ==============================================================================
;
;
; ==============================================================================

m10B4:
                    ldx #$05
-                   lda SCREENRAM+$187,x ; lda $0d87,x
                    cmp m10CC-1,x       ; cmp $10cb,x
                    bne +               ; bne $10c4
                    dex
                    bne -               ; bne $10b6
                    jmp ++              ; jmp $10d1
+                   ldy #$05
                    jsr display_hint_message           ; jsr $1003
                    jmp m3EF9           ; jmp $3ef9
m10CC:              !byte $30, $36, $31, $33, $38
++                  jsr set_game_basics           ; jsr $3a7d
                    jsr m3A17           ; jsr $3a17
                    jsr draw_border           ; jsr $3b02
                    jmp m3B4C           ; jmp $3b4c

; ==============================================================================
;
; ITEM PICKUP MESSAGES
; ==============================================================================

; TODO this byte was added by me as
; they put the item messages in the right address
; I have yet no clue where this is read and how
; as the label is not used for it

!byte $00

item_pickup_message:              ; item pickup messages

!if LANGUAGE = EN{
!scr " There is a key in the bottle !         "
!scr "   There is a key in the coffin !       "
!scr " There is a breathing tube !            "
}

!if LANGUAGE = DE{
!scr " In der Flasche liegt ein Schluessel !  " ; Original: !scr " In der Flasche war sich ein Schluessel "
!scr "    In dem Sarg lag ein Schluessel !    "
!scr " Unter dem Stein lag ein Taucheranzug ! "
}
item_pickup_message_end:

; ==============================================================================
;
; hint system (question marks)
; ==============================================================================


display_hint:
                    cpy #$00
                    bne m11A2           ; bne $11a2
                    jsr m1000
                    ldx current_room + 1
                    cpx #$01
                    bne +               ; bne $1165
                    lda #$28
+                   cpx #$05
                    bne +               ; bne $116b
                    lda #$29
+                   cpx #$0a
                    bne +               ; bne $1171
                    lda #$47
+                   jsr m174F           ; jsr $174f
                    cpx #$0f
                    bne +               ; bne $1185
                    lda #$45
                    sta COLRAM + $26f       ; sta $0a6f
                    lda #$0f
                    sta SCREENRAM + $26f       ; sta $0e6f
+                   sta SCREENRAM + $21f       ; sta $0e1f
                    lda #$48
                    sta COLRAM + $21f       ; sta $0a1f
-                   lda #$fd
                    sta KEYBOARD_LATCH
                    lda KEYBOARD_LATCH
                    and #$80
                    bne -               ; bne $118d
                    jsr set_game_basics           ; jsr $3a7d
                    jsr m3A2D           ; jsr $3a2d
                    jmp m3B4C           ; jmp $3b4c
m11A2:              cpy #$02
                    bne +               ; bne $11ac
m11A6:              jsr m1000
                    jmp -               ; jmp $118d
+                   cpy #$04
                    bne +               ; bne $11bb
                    lda m3952 + 1       ; lda $3953
                    clc
                    adc #$40            ; this is the helping letter
                    sta helping_letter          ; sta $3fc6
                    bne m11A6               ; bne $11a6
+                   dey
                    dey
                    dey
                    dey
                    dey
                    lda #>item_pickup_message
                    sta zpA8
                    lda #<item_pickup_message
                    jsr m1009
                    jmp -
; ==============================================================================
m11CC:
                    jsr set_charset_and_screen_for_title           ; jsr $3a9d
                    jmp PRINT_KERNAL           ; jmp $c56b
; ==============================================================================

check_death:
                    jsr update_items_display
                    jmp m3B4C           ; jmp $3b4c

; ==============================================================================

m11E0:              ldx #$00
-                   lda TAPE_BUFFER + $9,x              ;  lda $033c,x
                    cmp #$1e            ; question mark
                    bcc m11ED           ; bcc $11ed
                    cmp #$df
                    bne room_00              ; bne $11f5
m11ED:              inx
                    cpx #$09
                    bne -               ; bne $11e2
-                   jmp m3B4C           ; jmp $3b4c








; ==============================================================================
;
;                                                             ###        ###
;          #####      ####      ####     #    #              #   #      #   #
;          #    #    #    #    #    #    ##  ##             #     #    #     #
;          #    #    #    #    #    #    # ## #             #     #    #     #
;          #####     #    #    #    #    #    #             #     #    #     #
;          #   #     #    #    #    #    #    #              #   #      #   #
;          #    #     ####      ####     #    #               ###        ###
;
; ==============================================================================

room_00:
                    ldy current_room + 1        ; load in the current room number
                    bne room_01                 ; is it not 0? then check for room 01

                    cmp #$a9                    ; has the player hit the gloves?
                    bne m11ED                   ; no
                    lda #$df                    ; yes, load in char for "empty"
                    cmp items + $4d             ; position for 1st char of ladder ($b0) -> ladder already taken?
                    bne -                       ; no
                    jsr pickup_gloves           ; yes
                    bne check_death


pickup_gloves:
                    lda #$6b                    ; load character for empty bush
                    sta items + $8              ; store 6b = gloves in inventory
                    lda #$3d                    ; set the foreground color
                    sta items + $6              ; and store the color in the items table
                    rts






; ==============================================================================
;
;                                                             ###        #
;          #####      ####      ####     #    #              #   #      ##
;          #    #    #    #    #    #    ##  ##             #     #    # #
;          #    #    #    #    #    #    # ## #             #     #      #
;          #####     #    #    #    #    #    #             #     #      #
;          #   #     #    #    #    #    #    #              #   #       #
;          #    #     ####      ####     #    #               ###      #####
;
; ==============================================================================

room_01:
                    cpy #01
                    bne room_02                 ; if not this room, go to next

                    cmp #$e0                    ; empty character in charset -> invisible key
                    beq +                       ; yes, key is there -> +
                    cmp #$e1
                    bne ++
+                   lda #$aa                    ; display the key, $AA = 1st part of key
                    sta items + $10             ; store key in items list
                    jsr update_items_display    ; update all items in the items list (we just made the key visible)
                    ldy #$f0                    ; set waiting time
                    jsr wait                    ; wait
                    lda #$df                    ; set key to empty space
                    sta items + $10             ; update items list
                    bne check_death
++                  cmp #$27                    ; question mark (I don't know why 27)
                    bcs check_death_bush
                    ldy #$00
                    jmp m1031

check_death_bush:
                    cmp #$ad                    ; wirecutters
                    bne m11ED
                    lda items + $8              ; inventory place for the gloves! 6b = gloves
                    cmp #$6b
                    beq +
                    ldy #$0f
                    jmp death                   ; 0f You were wounded by the bush!

+                   lda #$f9                    ; wirecutter picked up
                    sta items + $19
                    jmp check_death






; ==============================================================================
;
;                                                             ###       #####
;          #####      ####      ####     #    #              #   #     #     #
;          #    #    #    #    #    #    ##  ##             #     #          #
;          #    #    #    #    #    #    # ## #             #     #     #####
;          #####     #    #    #    #    #    #             #     #    #
;          #   #     #    #    #    #    #    #              #   #     #
;          #    #     ####      ####     #    #               ###      #######
;
; ==============================================================================

room_02:
                    cpy #02
                    bne room_03                 ; if not this room, go to next

                    cmp #$f5                    ; did the player hit the fence? f5 = fence character
                    bne check_lock              ; no, check for the lock
                    lda items + $19             ; fence was hit, so check if wirecuter was picked up
                    cmp #$f9                    ; where the wirecutters (f9) picked up?
                    beq remove_fence            ; yes
                    ldy #$10                    ; no, load the correct death message
                    jmp death                   ; 10 You are trapped in wire-nettings!

remove_fence:
                    lda #$df                    ; empty char
                    sta m3900 + 1               ; m3900 must be the draw routine to clear out stuff?
m1264:              jmp check_death

; ==============================================================================

check_lock:
                    cmp #$a6            ; lock
                    bne +
                    lda items + $10
                    cmp #$df
                    bne m1264
                    lda #$df
                    sta items + $38
                    bne m1264
+                   cmp #$b1            ; ladder
                    bne +
                    lda #$df
                    sta items + $4d
                    sta items + $58
                    bne m1264
+                   cmp #$b9            ; bottle
                    beq +
                    jmp m11ED
+                   lda items + $bb
                    cmp #$df            ; df = empty spot where the hammer was. = hammer taken
                    beq take_key_out_of_bottle                                   ; beq $129a
                    ldy #$03
                    jmp death        ; 03 You drank from the poisend bottle

take_key_out_of_bottle:
                    lda #$01
                    sta key_in_bottle_storage
                    ldy #$05
                    jmp m1031

; ==============================================================================
; this is 1 if the key from the bottle was taken and 0 if not

key_in_bottle_storage:              !byte $00






; ==============================================================================
;
;                                                             ###       #####
;          #####      ####      ####     #    #              #   #     #     #
;          #    #    #    #    #    #    ##  ##             #     #          #
;          #    #    #    #    #    #    # ## #             #     #     #####
;          #####     #    #    #    #    #    #             #     #          #
;          #   #     #    #    #    #    #    #              #   #     #     #
;          #    #     ####      ####     #    #               ###       #####
;
; ==============================================================================

room_03:
                    cpy #03
                    bne room_04                 ; if not this room, go to next

                    cmp #$27                    ; question mark (I don't know why 27)
                    bcc +
                    jmp m3B4C
+                   ldy #$04
                    jmp m1031






; ==============================================================================
;
;                                                             ###      #
;          #####      ####      ####     #    #              #   #     #    #
;          #    #    #    #    #    #    ##  ##             #     #    #    #
;          #    #    #    #    #    #    # ## #             #     #    #    #
;          #####     #    #    #    #    #    #             #     #    #######
;          #   #     #    #    #    #    #    #              #   #          #
;          #    #     ####      ####     #    #               ###           #
;
; ==============================================================================

room_04:
                    cpy #04
                    bne room_05                 ; if not this room, go to next

                    cmp #$3b            ; part of a coffin
                    beq +                                   ; beq $12c1
                    cmp #$42
                    bne m12C6                               ; bne $12c6
+                   ldy #$0d
                    jmp death    ; 0d You found a thirsty zombie....

; ==============================================================================

m12C6:
                    cmp #$f7
                    beq +                                       ; beq $12d1
                    cmp #$f8
                    beq +                                       ; beq $12d1
                    jmp m11ED
+                   lda #$00
                    sta m394A + 1                               ; sta $394b
                    ldy #$06
                    jmp m1031           ; jmp $1031






; ==============================================================================
;
;                                                             ###      #######
;          #####      ####      ####     #    #              #   #     #
;          #    #    #    #    #    #    ##  ##             #     #    #
;          #    #    #    #    #    #    # ## #             #     #    ######
;          #####     #    #    #    #    #    #             #     #          #
;          #   #     #    #    #    #    #    #              #   #     #     #
;          #    #     ####      ####     #    #               ###       #####
;
; ==============================================================================

room_05:
                    cpy #05
                    bne room_06                     ; if not this room, go to next

                    cmp #$27                        ; question mark (I don't know why 27)
                    bcs m12E8
                    ldy #$00
                    jmp m1031

; ==============================================================================

m12E8:
                    cmp #$fd
                    beq +                                   ; beq $12ef
m12EC:              jmp m11ED
+                   lda #$00
                    jmp m2FDF

; ==============================================================================

m12F4:              ldy #$07
                    jmp m1031           ; jmp $1031






; ==============================================================================
;
;                                                             ###       #####
;          #####      ####      ####     #    #              #   #     #     #
;          #    #    #    #    #    #    ##  ##             #     #    #
;          #    #    #    #    #    #    # ## #             #     #    ######
;          #####     #    #    #    #    #    #             #     #    #     #
;          #   #     #    #    #    #    #    #              #   #     #     #
;          #    #     ####      ####     #    #               ###       #####
;
; ==============================================================================

room_06:
                    cpy #06
                    bne room_07                     ; if not this room, go to next

                    cmp #$f6            ; is it a trapped door?
                    bne m12EC                               ; bne $12ec
                    ldy #$00
m1303:              jmp death    ; 00 You fell into a snake pit






; ==============================================================================
;
;                                                             ###      #######
;          #####      ####      ####     #    #              #   #     #    #
;          #    #    #    #    #    #    ##  ##             #     #        #
;          #    #    #    #    #    #    # ## #             #     #       #
;          #####     #    #    #    #    #    #             #     #      #
;          #   #     #    #    #    #    #    #              #   #       #
;          #    #     ####      ####     #    #               ###        #
;
; ==============================================================================

room_07:
                    cpy #07
                    bne room_08                     ; if not this room, go to next

                    cmp #$e3            ; $e3 is the char for the invisible, I mean SACRED, column
                    bne +                                   ; bne $1312
                    ldy #$01            ; 01 You'd better watched out for the sacred column
                    bne m1303                               ; bne $1303
+                   cmp #$5f
                    bne m12EC                               ; bne $12ec
                    lda #$bc            ; light picked up
                    sta items + $74                        ; sta $36fe           ; but I dont understand how the whole light is shown
                    lda #$5f
                    sta items + $72                        ; sta $36fc
                    jsr update_items_display
                    ldy #$ff
                    jsr wait
                    jsr wait
                    jsr wait
                    jsr wait
                    lda #$df
                    sta items + $74                        ; sta $36fe
                    lda #$00
                    sta items + $72                        ; sta $36fc
                    jmp check_death






; ==============================================================================
;
;                                                             ###       #####
;          #####      ####      ####     #    #              #   #     #     #
;          #    #    #    #    #    #    ##  ##             #     #    #     #
;          #    #    #    #    #    #    # ## #             #     #     #####
;          #####     #    #    #    #    #    #             #     #    #     #
;          #   #     #    #    #    #    #    #              #   #     #     #
;          #    #     ####      ####     #    #               ###       #####
;
; ==============================================================================

room_08:
                    cpy #08
                    bne room_09                     ; if not this room, go to next

                    ldy #$00
                    sty zpA7
                    cmp #$4b            ; water
                    bne check_item_water                    ; bne $135f
                    ldy m3993 + 1                           ; ldy $3994
                    bne m1366                               ; bne $1366
                    jsr get_player_pos
                    lda #$18
m1354:              sta player_pos_x + 1
                    lda #$0c
                    sta player_pos_y + 1
m135C:              jmp m3B4C           ; jmp $3b4c


; ==============================================================================

check_item_water:
                    cmp #$56        ; water character
                    bne check_item_shovel                   ; bne $1374
                    ldy m3993 + 1                           ; ldy $3994
m1366:              bne +                                   ; bne $136f
                    jsr get_player_pos
                    lda #$0c
                    bne m1354                               ; bne $1354
+                   ldy #$02
                    jmp death       ; 02 You drowned in the deep river

; ==============================================================================

check_item_shovel:
                    cmp #$c1            ; shovel
                    beq +                                   ; beq $137c
                    cmp #$c3            ; shovel
                    bne m1384                               ; bne $1384
+                   lda #$df
                    sta items + $96                        ; sta $3720
m1381:              jmp check_death

; ==============================================================================

m1384:
                    cmp #$cb
                    bne m13B0
                    lda items + $bb                         ; hammer
                    cmp #$df
                    bne m135C                               ; bne $135c
                    lda #$df
                    sta items + $84                        ; sta $370e
                    bne m1381                               ; bne $1381






; ==============================================================================
;
;                                                             ###       #####
;          #####      ####      ####     #    #              #   #     #     #
;          #    #    #    #    #    #    ##  ##             #     #    #     #
;          #    #    #    #    #    #    # ## #             #     #     ######
;          #####     #    #    #    #    #    #             #     #          #
;          #   #     #    #    #    #    #    #              #   #     #     #
;          #    #     ####      ####     #    #               ###       #####
;
; ==============================================================================

room_09:            cpy #09
                    bne room_10                     ; if not this room, go to next

                    cmp #$27                        ; question mark (I don't know why 27)
                    bcs m13B0
                    ldy #$02
                    jmp m1031






; ==============================================================================
;
;                                                             #        ###
;          #####      ####      ####     #    #              ##       #   #
;          #    #    #    #    #    #    ##  ##             # #      #     #
;          #    #    #    #    #    #    # ## #               #      #     #
;          #####     #    #    #    #    #    #               #      #     #
;          #   #     #    #    #    #    #    #               #       #   #
;          #    #     ####      ####     #    #             #####      ###
;
; ==============================================================================

room_10:
                    cpy #10
                    bne room_11                     ; if not this room, go to next

                    cmp #$27                        ; question mark (I don't know why 27)
                    bcs m13B3
                    ldy #$00
                    jmp m1031
; ==============================================================================

m13B0:              jmp m11ED

; ==============================================================================

m13B3:
                    cmp #$cc
                    beq +                                   ; beq $13bb
                    cmp #$cf
                    bne m13B0
+                   lda #$df
                    cmp items + $74                        ; cmp $36fe
                    bne m13CD           ; bne $13cd
                    cmp items + $c8                        ; cmp $3752
                    bne m13CD           ; bne $13cd
                    sta items + $ac                        ; sta $3736
m13CA:              jmp check_death

; ==============================================================================
; death by 240 volts

m13CD:
                    ldy #$06
                    jmp death    ; 06 240 Volts! You got an electrical shock!






; ==============================================================================
;
;                                                             #        #
;          #####      ####      ####     #    #              ##       ##
;          #    #    #    #    #    #    ##  ##             # #      # #
;          #    #    #    #    #    #    # ## #               #        #
;          #####     #    #    #    #    #    #               #        #
;          #   #     #    #    #    #    #    #               #        #
;          #    #     ####      ####     #    #             #####    #####
;
; ==============================================================================

room_11:
                    cpy #11
                    bne room_12                     ; if not this room, go to next

                    cmp #$d1
                    bne m13B0
                    lda #$df                ; player takes the hammer
                    sta items + $bb                         ; hammer
                    bne m13CA                               ; bne $13ca






; ==============================================================================
;
;                                                             #       #####
;          #####      ####      ####     #    #              ##      #     #
;          #    #    #    #    #    #    ##  ##             # #            #
;          #    #    #    #    #    #    # ## #               #       #####
;          #####     #    #    #    #    #    #               #      #
;          #   #     #    #    #    #    #    #               #      #
;          #    #     ####      ####     #    #             #####    #######
;
; ==============================================================================

room_12:
                    cpy #12
                    bne room_13                     ; if not this room, go to next

                    cmp #$27                        ; question mark (I don't know why 27)
                    bcs m13EE
                    ldy #$00
                    jmp m1031
; ==============================================================================

m13EE:
                    cmp #$d2
                    beq +                                   ; beq $13f6
                    cmp #$d5
                    bne m13B0
+                   lda #$df
                    sta items + $c8                        ; sta $3752
                    bne m13CA                               ; bne $13ca






; ==============================================================================
;
;                                                             #       #####
;          #####      ####      ####     #    #              ##      #     #
;          #    #    #    #    #    #    ##  ##             # #            #
;          #    #    #    #    #    #    # ## #               #       #####
;          #####     #    #    #    #    #    #               #            #
;          #   #     #    #    #    #    #    #               #      #     #
;          #    #     ####      ####     #    #             #####     #####
;
; ==============================================================================

room_13:            cpy #13
                    bne room_14                     ; if not this room, go to next

                    cmp #$27                        ; question mark (I don't know why 27)
                    bcs m140A
                    ldy #$00
                    jmp m1031

; ==============================================================================

m140A:
                    cmp #$d6
                    bne m13B0
                    lda items + $84                        ; lda $370e
                    cmp #$df
                    beq m141A                               ; beq $141a
                    ldy #$07
                    jmp death    ; 07 You stepped on a nail!

; ==============================================================================

m141A:
                    lda #$e2
                    sta items + $d5                        ; sta $375f
                    bne m13CA                               ; bne $13ca






; ==============================================================================
;
;                                                             #      #
;          #####      ####      ####     #    #              ##      #    #
;          #    #    #    #    #    #    ##  ##             # #      #    #
;          #    #    #    #    #    #    # ## #               #      #    #
;          #####     #    #    #    #    #    #               #      #######
;          #   #     #    #    #    #    #    #               #           #
;          #    #     ####      ####     #    #             #####         #
;
; ==============================================================================

room_14:            cpy #14
                    bne room_15                     ; if not this room, go to next

                    cmp #$d7
                    bne m13B0
                    ldy #$08
                    jmp death    ; 08 A foot trap stopped you!






; ==============================================================================
;
;                                                             #      #######
;          #####      ####      ####     #    #              ##      #
;          #    #    #    #    #    #    ##  ##             # #      #
;          #    #    #    #    #    #    # ## #               #      ######
;          #####     #    #    #    #    #    #               #            #
;          #   #     #    #    #    #    #    #               #      #     #
;          #    #     ####      ####     #    #             #####     #####
;
; ==============================================================================

room_15:
                    cpy #15
                    bne room_16                     ; if not this room, go to next

                    cmp #$27                        ; question mark (I don't know why 27)
                    bcs m143B
                    ldy #$00
                    jmp m1031

; ==============================================================================

m143B:
                    jmp m11ED           ; jmp m13B0 -> target just jumps again, so replacing with target jmp address






; ==============================================================================
;
;                                                             #       #####
;          #####      ####      ####     #    #              ##      #     #
;          #    #    #    #    #    #    ##  ##             # #      #
;          #    #    #    #    #    #    # ## #               #      ######
;          #####     #    #    #    #    #    #               #      #     #
;          #   #     #    #    #    #    #    #               #      #     #
;          #    #     ####      ####     #    #             #####     #####
;
; ==============================================================================

room_16:

                    cmp #$f4
                    bne m144B                               ; bne $144b
                    ldy #$0a
m1448:              jmp death    ; 0a You were locked in and starved!

; ==============================================================================

m144B:
                    cmp #$d9
                    beq +                                   ; beq $1453
                    cmp #$db
                    bne ++                                  ; bne $1457
+                   ldy #$09          ; 09 This room is doomed by the wizard Manilo!
                    bne m1448                               ; bne $1448
++                  cmp #$b8
                    beq +                                   ; beq $145f
                    cmp #$bb
                    bne m143B                               ; bne $143b
+                   ldy #$03
                    jmp m1031           ; jmp $1031






; ==============================================================================
;
;                                                             #      #######
;          #####      ####      ####     #    #              ##      #    #
;          #    #    #    #    #    #    ##  ##             # #          #
;          #    #    #    #    #    #    # ## #               #         #
;          #####     #    #    #    #    #    #               #        #
;          #   #     #    #    #    #    #    #               #        #
;          #    #     ####      ####     #    #             #####      #
;
; ==============================================================================

room_17:
                    cpy #17
                    bne room_18                     ; if not this room, go to next

                    cmp #$dd
                    bne m143B                               ; bne $143b
                    lda #$df
                    sta items + $1a7                        ; sta $3831
                    jmp check_death






; ==============================================================================
;
;                                                             #       #####
;          #####      ####      ####     #    #              ##      #     #
;          #    #    #    #    #    #    ##  ##             # #      #     #
;          #    #    #    #    #    #    # ## #               #       #####
;          #####     #    #    #    #    #    #               #      #     #
;          #   #     #    #    #    #    #    #               #      #     #
;          #    #     ####      ####     #    #             #####     #####
;
; ==============================================================================

room_18:
                    cmp #$81
                    bcs +                   ; bcs $147b
                    jmp check_death
+
                    lda key_in_bottle_storage           ; lda $12a4
                    bne +               ; bne $1b97
                    jmp m3B4C           ; jmp $3b4c
+                   jsr set_charset_and_screen_for_title           ; jsr $3a9d
                    jmp print_endscreen ; jmp $1b44

; ==============================================================================

m147E:              ldy current_room + 1
                    cpy #$0e
                    bne m148A               ; bne $148a
                    ldy #$20
                    jmp wait

; ==============================================================================

m148A:              cpy #$0f
                    bne m14C8               ; bne $14c8
                    lda #$00
                    sta zpA7
                    ldy #$0c
m1494:              ldx #$06
                    jsr m3608
                    lda #$eb
                    sta zpA8
                    lda #$39
                    sta zp0A
                    ldx m1494 + 1           ; ldx $1495
m14A4:              lda #$01
                    bne m14B2               ; bne $14b2
                    cpx #$06
                    bne +                   ; bne $14ae
                    lda #$01
+                   dex
                    jmp +                   ; jmp $14b9

; ==============================================================================

m14B2:              cpx #$0b
                    bne ++                              ; bne $14b8
                    lda #$00
++                  inx
+                   stx m1494 + 1                       ; stx $1495
                    sta m14A4 + 1                       ; sta $14a5
                    lda #$01
                    sta zpA7
                    ldy #$0c
                    jmp m3608

; ==============================================================================

m14C8:              cpy #$11
                    bne +                               ; bne $14d3
m14CC:              lda #$01
                    beq ++                              ; beq $14e4
                    jmp m15C1                           ; jmp $15c1
+                   lda #$0f
                    sta m3624 + 1                       ; sta $3625
                    sta m3626 + 1                       ; sta $3627
                    cpy #$0a
                    bne m1523                           ; bne $1523
                    dec m2FBF                           ; dec $2fbf
                    beq m14E5                           ; beq $14e5
++                  rts

; ==============================================================================
;
;
; ==============================================================================

m14E5:              ldy #$08
                    sty m2FBF                           ; sty $2fbf
                    lda #$09
                    sta zp05
                    lda #$0d
                    sta zp03
                    lda #$7b
                    sta zp02
                    sta zp04
                    lda #$df
                    cmp m1506 + 1                       ; cmp $1507
                    bne +                               ; bne $1501
                    lda #$d8
+                   sta m1506 + 1                       ; sta $1507
                    ldx #$06
m1506:              lda #$df
                    ldy #$00
                    sta (zp02),y
                    lda #$ee
                    sta (zp04),y
                    lda zp02
                    clc
                    adc #$28
                    sta zp02
                    sta zp04
                    bcc +                               ; bcc $151f
                    inc zp03
                    inc zp05
+                   dex
                    bne m1506                           ; bne $1506
-                   rts

; ==============================================================================
;
;
; ==============================================================================

m1523:              cpy #$09
                    bne -                           ; bne $1522
                    jmp m15AD                       ; jmp $15ad

; ==============================================================================
m152B:
                    lda #$0c
                    sta zp03
                    lda #$0f
                    sta zp02
                    sta zp04
m1535:              ldx #$06
m1537:              lda #$00
                    bne +                           ; bne $1544
                    dex
                    cpx #$02
                    bne ++                          ; bne $154b
                    lda #$01
                    bne ++                          ; bne $154b
+                   inx
                    cpx #$07
                    bne ++                          ; bne $154b
                    lda #$00
++                  sta m1537 + 1                   ; sta $1538
                    stx m1535 + 1                   ; stx $1536
-                   ldy #$00
                    lda #$df
                    sta (zp02),y
                    iny
                    iny
                    sta (zp02),y
                    dey
                    lda #$ea
                    sta (zp02),y
                    sta (zp04),y
                    jsr m159D                       ; jsr $159d
                    dex
                    bne -                           ; bne $1551
                    lda #$e4
                    sta zpA8
                    ldx #$02
--                  ldy #$00
-                   lda zpA8
                    sta (zp02),y
                    lda #$da
                    sta (zp04),y
                    inc zpA8
                    iny
                    cpy #$03
                    bne -                           ; bne $1570
                    jsr m159D                       ; jsr $159d
                    dex
                    bne --                          ; bne $156e
                    ldy #$00
                    lda #$e7
                    sta zpA8
-                   lda (zp02),y
                    cmp zpA8
                    bne +                           ; bne $1595
                    lda #$df
                    sta (zp02),y
+                   inc zpA8
                    iny
                    cpy #$03
                    bne -                           ; bne $158b
                    rts

; ==============================================================================
;
;
; ==============================================================================

m159D:              lda zp02
                    clc
                    adc #$28
                    sta zp02
                    sta zp04
                    bcc +                                   ; bcc $15ac
                    inc zp03
                    inc zp05
+                   rts

; ==============================================================================
;
;
; ==============================================================================

m15AD:              ldx #$01
                    cpx #$01
                    bne m15B7                               ; bne $15b7
                    dec m15AD + 1                           ; dec $15ae
                    rts

; ==============================================================================
;
;
; ==============================================================================

m15B7:              inc m15AD + 1                           ; inc $15ae
                    lda #$08
                    sta zp05
                    jmp m152B           ; jmp $152b

; ==============================================================================

m15C1:              lda #$00
                    cmp #$00
                    bne m15CB                               ; bne $15cb
                    inc m15C1 + 1                           ; inc $15c2
                    rts

; ==============================================================================
;
;
; ==============================================================================

m15CB:              dec m15C1 + 1                           ; dec $15c2
                    jmp m3620

; ==============================================================================
;
;
; ==============================================================================

m15D1:              lda items + $ac                        ; lda $3736
                    cmp #$df
                    bne +                                   ; bne $15dd
                    lda #$59
                    sta items + $12c                        ; sta $37b6
+                   lda current_room + 1
                    cmp #$11
                    bne m162A                               ; bne $162a
                    lda m14CC + 1                           ; lda $14cd
                    bne m15FC                               ; bne $15fc
                    lda player_pos_y + 1
                    cmp #$06
                    bne m15FC                               ; bne $15fc
                    lda player_pos_x + 1
                    cmp #$18
                    bne m15FC                               ; bne $15fc
                    lda #$00
                    sta m15FC + 1                           ; sta $15fd
m15FC:              lda #$01
                    bne +                                   ; bne $1616
                    ldy #$06
m1602:              ldx #$1e
                    lda #$00
                    sta zpA7
                    jsr m3608
                    ldx m1602 + 1                   ; ldx $1603
                    cpx #$03
                    beq ++                          ; beq $1613
                    dex
++                  stx m1602 + 1                   ; stx $1603
+                   lda #$78
                    sta zpA8
                    lda #$49
                    sta zp0A
                    ldy #$06
                    lda #$01
                    sta zpA7
                    ldx m1602 + 1                   ; ldx $1603
                    jsr m3608
m162A:              jmp m147E                   ; jmp $147e


; ==============================================================================

m162d:
                    ldx #$09
-                   lda TAPE_BUFFER + $8,x         ; lda $033b,x              ; cassette tape buffer
                    sta TAPE_BUFFER + $18,x         ; sta $034b,x              ; cassette tape buffer
                    dex
                    bne -                       ; bne $162f
                    lda #$02
                    sta zpA7
                    ldx player_pos_x + 1
                    ldy player_pos_y + 1
                    jsr m3608
                    ldx #$09
m1647:              lda TAPE_BUFFER + $8,x      ; lda $033b,x              ; cassette tape buffer
                    cmp #$d8
                    bne +                   ; bne $1653
m164E:              ldy #$05
m1650:              jmp death               ; 05 Didn't you see the laser beam?

; ==============================================================================

+                   ldy current_room + 1
                    cpy #$11
                    bne +                       ; bne $166a
                    cmp #$78
                    beq ++                      ; beq $1666
                    cmp #$7b
                    beq ++                      ; beq $1666
                    cmp #$7e
                    bne +                       ; bne $166a
++                  ldy #$0b                      ; 0b You were hit by a big rock and died!
                    bne m1650                   ; bne $1650
+                   cmp #$9c
                    bcc m1676                   ; bcc $1676
                    cmp #$a5
                    bcs m1676                   ; bcs $1676
                    jmp m16A7                 ; jmp $16a7

; ==============================================================================

m1676:              cmp #$e4
                    bcc +                           ; bcc $168a
                    cmp #$eb
                    bcs ++                          ; bcs $1682
-                   ldy #$04                        ; 04 Boris the spider got you and killed you
                    bne m1650                       ; bne $1650
++                  cmp #$f4
                    bcs +                           ; bcs $168a
                    ldy #$0e                      ; 0e The monster grabbed you you. You are dead!
                    bne m1650                       ; bne $1650
+                   dex
                    bne m1647                       ; bne $1647
                    ldx #$09
--                  lda $034b,x
                    sta TAPE_BUFFER + $8,x          ; sta $033b,x
                    cmp #$d8
                    beq m164E                       ; beq $164e
                    cmp #$e4
                    bcc +                           ; bcc $16a1
                    cmp #$ea
                    bcc -                           ; bcc $167e
+                   dex
                    bne --                          ; bne $168f
                    jmp m11E0                     ; jmp $11e0

m16A7:
                    ldy items + $1a7                ; ldy $3831
                    cpy #$df
                    beq +                           ; beq $16b2
                    ldy #$0c                      ; 0c Belegro killed you!
                    bne m1650                       ; bne $1650
+                   ldy #$00
                    sty m14CC + 1                   ; sty $14cd
                    jmp m1676                       ; jmp $1675








; ==============================================================================
; this might be the inventory/ world reset
; puts all items into the level data again
; maybe not. not all characters for e.g. the wirecutter is put back
; addresses are mostly within items.asm address space ( $368a )
; contains color information of the chars
; ==============================================================================

reset_items:
                    lda #$a5                        ; $a5 = lock of the shed
                    sta items + $38

                    lda #$a9                        ;
                    sta items + $8                  ; gloves
                    lda #$79
                    sta items + $6                  ; gloves color

                    lda #$e0                        ; empty char
                    sta items + $10                 ; invisible key

                    lda #$ac                        ; wirecutter
                    sta items + $19

                    lda #$b8                        ; bottle
                    sta items + $29

                    lda #$b0                        ; ladder
                    sta items + $4d
                    lda #$b5                        ; more ladder
                    sta items + $58

                    lda #$5e                        ; seems to be water?
                    sta items + $74

                    lda #$c6                        ; boots in the whatever box
                    sta items + $84

                    lda #$c0                        ; shovel
                    sta items + $96

                    lda #$cc                        ; power outlet
                    sta items + $ac

                    lda #$d0                        ; hammer
                    sta items + $bb

                    lda #$d2                        ; light bulb
                    sta items + $c8

                    lda #$d6                        ; nails
                    sta items + $d5

                    lda #$00                        ; door
                    sta items + $12c

                    lda #$dd                        ; sword
                    sta items + $1a7

                    lda #$01                        ; door
                    sta items + $2c1

                    lda #$01                        ; door
                    sta items + $30a

                    lda #$f5                        ; fence
                    sta items + $277

                    lda #$00                        ; key in the bottle
                    sta key_in_bottle_storage

                    lda #$01                        ; door
                    sta m15FC + 1

                    lda #$1e
                    sta m1602 + 1

                    lda #$01
                    sta m14CC + 1

m1732:              ldx #$05
                    cpx #$07
                    bne +
                    ldx #$ff
+                   inx
                    stx m1732 + 1                           ; stx $1733
                    lda m1747,x                             ; lda $1747,x
                    sta m3952 + 1                   ; sta $3953
                    jmp print_title     ; jmp $310d

; ==============================================================================

m1747:
                    !byte $02, $07, $04, $06, $08, $01, $05, $03


m174F:
                    cpx #$0c
                    bne +           ; bne $1755
                    lda #$49
+                   cpx #$0d
                    bne +           ; bne $175b
                    lda #$45
+                   rts



screen_win_src:
                    !if LANGUAGE = EN{
                        !bin "includes/screen-win-en.scr"
                    }
                    !if LANGUAGE = DE{
                        !bin "includes/screen-win-de.scr"
                    }
screen_win_src_end:


; ==============================================================================
;
; PRINT WIN SCREEN
; ==============================================================================

print_endscreen:
                    lda #>SCREENRAM       ; lda #$0c
                    sta zp03
                    lda #>COLRAM        ; lda #$08
                    sta zp05
                    lda #<SCREENRAM       ; lda #$00
                    sta zp02
                    sta zp04
                    ldx #$04
                    lda #>screen_win_src;lda #$17
                    sta zpA8
                    lda #<screen_win_src;lda #$5c
                    sta zpA7
                    ldy #$00
-                   lda (zpA7),y        ; copy from $175c + y
                    sta (zp02),y        ; to SCREEN
                    lda #$00           ; color = BLACK
                    sta (zp04),y        ; to COLRAM
                    iny
                    bne -               ; bne $1b5e
                    inc zp03
                    inc zp05
                    inc zpA8
                    dex
                    bne -               ; bne $1b5e
                    lda #$ff           ; PISSGELB
                    sta BG_COLOR          ; background
                    sta BORDER_COLOR          ; und border
-                   lda #$fd
                    sta KEYBOARD_LATCH
                    lda KEYBOARD_LATCH
                    and #$80           ; WAITKEY?
                    bne -               ; bne $1b7a
                    jsr print_title     ; jsr $310d
                    jsr print_title     ; jsr $310d
                    jmp init            ; jmp $3ab3


; ==============================================================================
;
; INTRO TEXT SCREEN
; ==============================================================================

intro_text:

; instructions screen
; "Search the treasure..."

!if LANGUAGE = EN{
!scr "Search the treasure of Ghost Town and   "
!scr "open it ! Kill Belegro, the wizard, and "
!scr "dodge all other dangers. Don't forget to"
!scr "use all the items you'll find during    "
!scr "your yourney through 19 amazing hires-  "
!scr "graphics-rooms! Enjoy the quest and play"
!scr "it again and again and again ...      > "
}

!if LANGUAGE = DE{
!scr "Suchen Sie die Schatztruhe der Geister- "
!scr "stadt und oeffnen Sie diese ! Toeten    "
!scr "Sie Belegro, den Zauberer und weichen   "
!scr "Sie vielen anderen Wesen geschickt aus. "
!scr "Bedienen Sie sich an den vielen Gegen-  "
!scr "staenden, welche sich in den 19 Bildern "
!scr "befinden. Viel Spass !                > "
}

; ==============================================================================
;
; DISPLAY INTRO TEXT
; ==============================================================================

display_intro_text:

                    ; i think this part displays the introduction text

                    lda #>SCREENRAM       ; lda #$0c
                    sta zp03
                    lda #>COLRAM        ; lda #$08
                    sta zp05
                    lda #$a0
                    sta zp02
                    sta zp04
                    lda #>intro_text
                    sta zpA8
                    lda #<intro_text
                    sta zpA7
                    ldx #$07
--                  ldy #$00
-                   lda (zpA7),y
                    sta (zp02),y
                    lda #$68
                    sta (zp04),y
                    iny
                    cpy #$28
                    bne -
                    lda zpA7
                    clc
                    adc #$28
                    sta zpA7
                    bcc +           ; bcc $1ce7
                    inc zpA8
+                   lda zp02
                    clc
                    adc #$50
                    sta zp02
                    sta zp04
                    bcc +           ; bcc $1cf6
                    inc zp03
                    inc zp05
+                   dex                ; 1cf6
                    bne --          ; bne $1ccd
                    lda #$00
                    sta BG_COLOR
                    rts

; ==============================================================================
;
; DISPLAY INTRO TEXT AND WAIT FOR INPUT (SHIFT & JOY)
; DECREASES MUSIC VOLUME
; ==============================================================================

start_intro:        sta KEYBOARD_LATCH
                    jsr PRINT_KERNAL           ; jsr $c56b
                    jsr display_intro_text           ; jsr $1cb5
                    jsr check_shift_key ; jsr $1ef9
                    lda #$ba
                    sta music_volume+1         ; sta $1ed9    ; sound volume
                    rts





; ==============================================================================
; MUSIC
; ==============================================================================
                    !zone MUSIC
music_data:         !source "includes/music_data.asm"
; ==============================================================================
music_get_data:
.voice1_dur_pt:     ldy #$00
                    bne +
                    lda #$40
                    sta music_voice1+1
                    jsr music_voice1
.voice1_dat_pt:     ldx #$00
                    lda music_data_voice1,x
                    inc .voice1_dat_pt+1
                    tay
                    and #$1f
                    sta music_voice1+1
                    tya
                    lsr
                    lsr
                    lsr
                    lsr
                    lsr
                    tay
+                   dey
                    sty .voice1_dur_pt + 1
.voice2_dur_pt:     ldy #$00
                    bne +
                    lda #$40
                    sta music_voice2 + 1
                    jsr music_voice2
.voice2_dat_pt:     ldx #$00
                    lda music_data_voice2,x
                    tay
                    inx
                    cpx #$65
                    beq music_reset
                    stx .voice2_dat_pt + 1
                    and #$1f
                    sta music_voice2 + 1
                    tya
                    lsr
                    lsr
                    lsr
                    lsr
                    lsr
                    tay
+                   dey
                    sty .voice2_dur_pt + 1
                    jsr music_voice1
                    jmp music_voice2
; ==============================================================================
music_reset:        lda #$00
                    sta .voice1_dur_pt + 1
                    sta .voice1_dat_pt + 1
                    sta .voice2_dur_pt + 1
                    sta .voice2_dat_pt + 1
                    jmp music_get_data
; ==============================================================================
; write music data for voice1 / voice2 into TED registers
; ==============================================================================
music_voice1:       ldx #$04
                    cpx #$1c
                    bcc +
                    lda VOLUME_AND_VOICE_SELECT
                    and #$ef
                    jmp writeFF11
+                   lda freq_tab_lo,x
                    sta VOICE1_FREQ_LOW
                    lda VOICE1
                    and #$fc
                    ora freq_tab_hi, x
                    sta VOICE1
                    lda VOLUME_AND_VOICE_SELECT
                    ora #$10
writeFF11           sta VOLUME_AND_VOICE_SELECT
                    rts
; ==============================================================================
music_voice2:       ldx #$0d
                    cpx #$1c
                    bcc +
                    lda VOLUME_AND_VOICE_SELECT
                    and #$df
                    jmp writeFF11
+                   lda freq_tab_lo,x
                    sta VOICE2_FREQ_LOW
                    lda VOICE2
                    and #$fc
                    ora freq_tab_hi,x
                    sta VOICE2
                    lda VOLUME_AND_VOICE_SELECT
                    ora #$20
                    sta VOLUME_AND_VOICE_SELECT
                    rts
; ==============================================================================
; TED frequency tables
; ==============================================================================
freq_tab_lo:        !byte $07, $76, $a9, $06, $59, $7f, $c5
                    !byte $04, $3b, $54, $83, $ad, $c0, $e3
                    !byte $02, $1e, $2a, $42, $56, $60, $71
                    !byte $81, $8f, $95
freq_tab_hi:        !byte $00, $00, $00, $01, $01, $01, $01
                    !byte $02, $02, $02, $02, $02, $02, $02
                    !byte $03, $03, $03, $03, $03, $03, $03
                    !byte $03, $03, $03
; ==============================================================================
                    MUSIC_DELAY_INITIAL   = $09
                    MUSIC_DELAY           = $0B
music_play:         ldx #MUSIC_DELAY_INITIAL
                    dex
                    stx music_play+1
                    beq +
                    rts
+                   ldx #MUSIC_DELAY
                    stx music_play+1
                    lda VOLUME_AND_VOICE_SELECT
                    ora #$37
music_volume:       and #$bf
                    sta VOLUME_AND_VOICE_SELECT
                    jmp music_get_data







; ==============================================================================
; irq init
; ==============================================================================
                    !zone IRQ
irq_init0:          sei
                    lda #<irq0          ; lda #$06
                    sta $0314          ; irq lo
                    lda #>irq0          ; lda #$1f
                    sta $0315          ; irq hi
                                        ; irq at $1F06
                    lda #$02
                    sta $ff0a          ; set IRQ source to RASTER

                    lda #$bf
                    sta music_volume+1         ; sta $1ed9    ; sound volume
                    cli

                    jmp set_charset_and_screen_for_title           ; jmp $3a9d

; ==============================================================================
; intro text
; wait for shift or joy2 fire press
; ==============================================================================

check_shift_key:

-                   lda #$fd
                    sta KEYBOARD_LATCH
                    lda KEYBOARD_LATCH
                    and #$80            ; checks for SHIFT key, same as joy 2 fire?
                    bne -               ; bne $1ef9
                    rts

; ==============================================================================
;
; INTERRUPT routine for music
; ==============================================================================

                    ; *= $1F06
irq0:
                    DEC INTERRUPT

                                        ; this IRQ seems to handle music only!
                    !if SILENT_MODE = 1 {
                        jsr fake
                    } else {
                        jsr music_play  ; jsr $1ebc
                    }
                    pla
                    tay
                    pla
                    tax
                    pla
                    rti

; ==============================================================================
; gets called immediately after start of game
; looks like some sound/irq initialization?
; i think the branching part does fade the sound
; ==============================================================================

m1F15:                                  ; call from init
                    lda music_volume+1         ; lda $1ed9           ; sound volume
--                  cmp #$bf           ; is true on init
                    bne +               ; bne $1f1f
                    jmp irq_init0       ; jmp $1ee0
+                   ldx #$04
-                   stx zpA8            ; buffer serial input byte ?
                    ldy #$ff
                    jsr wait
                    ldx zpA8
                    dex
                    bne -               ; bne $1f21 / some weird wait loop ?
                    clc
                    adc #$01           ; add 1 (#$C0 on init)
                    sta music_volume+1         ; sta $1ed9             ; sound volume
                    jmp --              ; jmp $1f18



                    ; 222222222222222         000000000          000000000          000000000
                    ;2:::::::::::::::22     00:::::::::00      00:::::::::00      00:::::::::00
                    ;2::::::222222:::::2  00:::::::::::::00  00:::::::::::::00  00:::::::::::::00
                    ;2222222     2:::::2 0:::::::000:::::::00:::::::000:::::::00:::::::000:::::::0
                    ;            2:::::2 0::::::0   0::::::00::::::0   0::::::00::::::0   0::::::0
                    ;            2:::::2 0:::::0     0:::::00:::::0     0:::::00:::::0     0:::::0
                    ;         2222::::2  0:::::0     0:::::00:::::0     0:::::00:::::0     0:::::0
                    ;    22222::::::22   0:::::0 000 0:::::00:::::0 000 0:::::00:::::0 000 0:::::0
                    ;  22::::::::222     0:::::0 000 0:::::00:::::0 000 0:::::00:::::0 000 0:::::0
                    ; 2:::::22222        0:::::0     0:::::00:::::0     0:::::00:::::0     0:::::0
                    ;2:::::2             0:::::0     0:::::00:::::0     0:::::00:::::0     0:::::0
                    ;2:::::2             0::::::0   0::::::00::::::0   0::::::00::::::0   0::::::0
                    ;2:::::2       2222220:::::::000:::::::00:::::::000:::::::00:::::::000:::::::0
                    ;2::::::2222222:::::2 00:::::::::::::00  00:::::::::::::00  00:::::::::::::00
                    ;2::::::::::::::::::2   00:::::::::00      00:::::::::00      00:::::::::00
                    ;22222222222222222222     000000000          000000000          000000000

; ==============================================================================
; CHARSET
; $2000 - $2800
; ==============================================================================


charset_start:
                    *= $2000
                    !if EXTENDED {
                        !bin "includes/charset-new-charset.bin"
                    }else{
                        !bin "includes/charset.bin"
                    }
charset_end:    ; $2800


                    ; 222222222222222         888888888          000000000           000000000
                    ;2:::::::::::::::22     88:::::::::88      00:::::::::00       00:::::::::00
                    ;2::::::222222:::::2  88:::::::::::::88  00:::::::::::::00   00:::::::::::::00
                    ;2222222     2:::::2 8::::::88888::::::8 0:::::::000:::::::0 0:::::::000:::::::0
                    ;            2:::::2 8:::::8     8:::::8 0::::::0   0::::::0 0::::::0   0::::::0
                    ;            2:::::2 8:::::8     8:::::8 0:::::0     0:::::0 0:::::0     0:::::0
                    ;         2222::::2   8:::::88888:::::8  0:::::0     0:::::0 0:::::0     0:::::0
                    ;    22222::::::22     8:::::::::::::8   0:::::0 000 0:::::0 0:::::0 000 0:::::0
                    ;  22::::::::222      8:::::88888:::::8  0:::::0 000 0:::::0 0:::::0 000 0:::::0
                    ; 2:::::22222        8:::::8     8:::::8 0:::::0     0:::::0 0:::::0     0:::::0
                    ;2:::::2             8:::::8     8:::::8 0:::::0     0:::::0 0:::::0     0:::::0
                    ;2:::::2             8:::::8     8:::::8 0::::::0   0::::::0 0::::::0   0::::::0
                    ;2:::::2       2222228::::::88888::::::8 0:::::::000:::::::0 0:::::::000:::::::0
                    ;2::::::2222222:::::2 88:::::::::::::88   00:::::::::::::00   00:::::::::::::00
                    ;2::::::::::::::::::2   88:::::::::88       00:::::::::00       00:::::::::00
                    ;22222222222222222222     888888888           000000000           000000000



; ==============================================================================
; LEVEL DATA
; Based on tiles
;                     !IMPORTANT!
;                     has to be page aligned or
;                     display_room routine will fail
; ==============================================================================

                    *= $2800
level_data:
                    !source "includes/levels.asm"
level_data_end:

!if 1=2{
!byte $00, $00, $00, $00, $00, $00, $00
}


;$2fbf
m2FBF:
!byte $01



; ==============================================================================
;
;
; ==============================================================================

m2fCB:              lda current_room + 1
                    cmp #$04
                    bne ++                   ; bne $2fca
                    lda #$03
                    ldy m394A + 1           ; ldy $394b
                    beq +
                    lda #$f6
+                   sta SCREENRAM + $f9     ; sta $0cf9
++                  rts

; ==============================================================================
;
;
; ==============================================================================

m2FDF:              ldy items + $96     ; ldy $3720
                    cpy #$df
                    bne +               ; bne $2fec
                    sta m3993 + 1       ; sta $3994
                    jmp m12F4           ; jmp $12f4
+                   jmp m3B4C           ; jmp $3b4c

m2FEF:
                    jsr poll_raster
                    jsr check_door ; jsr $39f4
                    jmp m15D1           ; jmp $15d1




!if 1=2{
; $2ffd
unknown: ; haven't found a call for this code area yet. might be waste
!byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
!byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
!byte $00
}

; ==============================================================================
;
; tileset definition
; these are the first characters in the charset of each tile.
; example: rocks start at $0c and span 9 characters in total
; ==============================================================================

tileset_definition:
tiles_chars:        ;     $00, $01, $02, $03, $04, $05, $06, $07
                    !byte $df, $0c, $15, $1e, $27, $30, $39, $42
                    ;     $08, $09, $0A, $0B, $0C, $0D, $0E, $0F
                    !byte $4b, $54, $5d, $66, $6f, $78, $81, $8a
                    ;     $10
                    !byte $03
tiles_colors:       ;     $00, $01, $02, $03, $04, $05, $06, $07
                    !byte $00, $39, $19, $0e, $3d, $7f, $2a, $2a
                    ;     $08, $09, $0A, $0B, $0C, $0D, $0E, $0F
                    !byte $1e, $1e, $1e, $3d, $3d, $19, $2f, $2f
                    ;     $10
                    !byte $39

; ==============================================================================
;
; displays a room based on tiles
; ==============================================================================

display_room:
                    jsr draw_border
                    lda #$00
                    sta zp02
                    ldx #>COLRAM        ; HiByte of COLRAM
                    stx zp05
                    ldx #>SCREENRAM     ; HiByte of SCREENRAM
                    stx zp03
                    ldx #>level_data    ; HiByte of level_data
                    stx zp0A            ; in zp0A
current_room:       ldx #$01            ; current_room in X
                    beq ++              ; if 0 -> skip
-                   clc                 ; else
                    adc #$68            ; add $68 [= 104 = 13*8 (size of a room]
                    bcc +               ; to zp09/zp0A
                    inc zp0A            ;
+                   dex                 ; X times
                    bne -               ; => current_room_data = ( level_data + ( $68 * current_room ) )
++                  sta zp09            ; LoByte from above
                    ldy #$00
                    sty zpA8
                    sty zpA7
m3066:              lda (zp09),y        ; get Tilenumber
                    tax                 ; in X
                    lda tiles_colors,x  ; get Tilecolor
                    sta zp10            ; => zp10
                    lda tiles_chars,x   ; get Tilechar
                    sta zp11            ; => zp11
                    ldx #$03            ; (3 rows)
--                  ldy #$00
-                   lda zp02            ; LoByte of SCREENRAM pointer
                    sta zp04            ; LoByte of COLRAM pointer
                    lda zp11            ; Load Tilechar
                    sta (zp02),y        ; to SCREENRAM + Y
                    lda zp10            ; Load Tilecolor
                    sta (zp04),y        ; to COLRAM + Y
                    lda zp11            ; Load Tilechar again
                    cmp #$df            ; if empty tile
                    beq +               ; -> skip
                    inc zp11            ; else: Tilechar + 1
+                   iny                 ; Y = Y + 1
                    cpy #$03            ; Y = 3 ? (Tilecolumns)
                    bne -               ; no -> next Char
                    lda zp02            ; yes:
                    clc
                    adc #$28            ; next SCREEN row
                    sta zp02
                    bcc +
                    inc zp03
                    inc zp05            ; and COLRAM row
+                   dex                 ; X = X - 1
                    bne --              ; X != 0 -> next Char
                    inc zpA8            ; else: zpA8 = zpA8 + 1
                    inc zpA7            ; zpA7 = zpA7 + 1
                    lda #$75            ; for m30B8 + 1
                    ldx zpA8
                    cpx #$0d            ; zpA8 < $0d ? (same Tilerow)
                    bcc +               ; yes: -> skip (-$75 for next Tile)
                    ldx zpA7            ; else:
                    cpx #$66            ; zpA7 >= $66
                    bcs display_door    ; yes: display_door
                    lda #$00            ; else:
                    sta zpA8            ; clear zpA8
                    lda #$24            ; for m30B8 + 1
+                   sta m30B8 + 1       ;
                    lda zp02
                    sec
m30B8:              sbc #$75            ; -$75 (next Tile in row) or -$24 (next row )
                    sta zp02
                    bcs +
                    dec zp03
                    dec zp05
+                   ldy zpA7
                    jmp m3066
                    rts                 ; will this ever be used?
display_door:       lda #>SCREENRAM
                    sta zp03
                    lda #>COLRAM
                    sta zp05
                    lda #$00
                    sta zp02
                    sta zp04
-                   ldy #$28
                    lda (zp02),y        ; read from SCREENRAM
                    cmp #$06            ; $06 (part from Door?)
                    bcs +               ; >= $06 -> skip
                    sec                 ; else:
                    sbc #$03            ; subtract $03
                    ldy #$00            ; set Y = $00
                    sta (zp02),y        ; and copy to one row above
                    lda #$39            ; color brown - luminance $3
                    sta (zp04),y
+                   lda zp02
                    clc
                    adc #$01            ; add 1 to SCREENRAM pointer low
                    bcc +
                    inc zp03            ; inc pointer HiBytes if necessary
                    inc zp05
+                   sta zp02
                    sta zp04
                    cmp #$98            ; SCREENRAM pointer low = $98
                    bne -               ; no -> loop
                    lda zp03            ; else:
                    cmp #>(SCREENRAM+$300)
                    bne -               ; no -> loop
                    rts                 ; else: finally ready with room display

; ==============================================================================

print_title:        lda #>SCREENRAM       ; lda #$0c
                    sta zp03
                    lda #>COLRAM        ; lda #$08
                    sta zp05
                    lda #<SCREENRAM       ; lda #$00
                    sta zp02
                    sta zp04
                    lda #>screen_start_src
                    sta zpA8
                    lda #<screen_start_src
                    sta zpA7
                    ldx #$04
--                  ldy #$00
-                   lda (zpA7),y        ; $313C + Y ( Titelbild )
                    sta (zp02),y        ; nach SCREEN
                    lda #$00           ; BLACK
                    sta (zp04),y        ; nach COLRAM
                    iny
                    bne -               ; bne $3127
                    inc zp03
                    inc zp05
                    inc zpA8
                    dex
                    bne --              ; bne $3125
                    rts

; ==============================================================================
; TITLE SCREEN DATA
;
; ==============================================================================

screen_start_src:

                    !if EXTENDED {
                        !bin "includes/screen-start-extended.scr"
                    }else{
                        !bin "includes/screen-start.scr"
                    }

screen_start_src_end:


; ==============================================================================
; i think this might be the draw routine for the player sprite
;
; ==============================================================================


draw_player:
                    lda #>COLRAM                        ; store colram high in zp05
                    sta zp05
                    lda #>SCREENRAM                     ; store screenram high in zp03
                    sta zp03
                    lda #$00
                    sta zp02
                    sta zp04                            ; 00 for zp02 and zp04 (colram low and screenram low)
                    cpy #$00                            ; Y is probably the player Y position
                    beq +                               ; Y is 0 -> +
-                   clc                                 ; Y not 0
                    adc #$28                            ; add $28 (=#40 = one line) to A (which is now $28)
                    bcc ++                              ; <256? -> ++
                    inc zp03
                    inc zp05
++                  dey                                 ; Y = Y - 1
                    bne -                               ; Y = 0 ? -> -
+                   clc                                 ;
m3548:              adc #$16                            ; add $15 (#21) why? -> selfmod address
                    sta zp02
                    sta zp04
                    bcc +
                    inc zp03
                    inc zp05
+                   ldx #$03                            ; draw 3 rows for the player "sprite"
                    lda #$00
                    sta zp09
--                  ldy #$00
-                   lda zpA7
                    bne +
                    lda #$df                            ; empty char, but not sure why
                    sta (zp02),y
                    bne ++
+                   cmp #$01
                    bne +
                    lda zpA8
                    sta (zp02),y
                    lda zp0A
                    sta (zp04),y
                    bne ++
+                   lda (zp02),y
                    stx zp10
                    ldx zp09
                    sta TAPE_BUFFER + $9,x
                    inc zp09
                    ldx zp10
++                  inc zpA8
                    iny
                    cpy #$03                            ; width of the player sprite in characters (3)
                    bne -
                    lda zp02
                    clc
                    adc #$28                            ; $28 = #40, draws one row of the player under each other
                    sta zp02
                    sta zp04
                    bcc +
                    inc zp03
                    inc zp05
+                   dex
                    bne --
                    rts


; ==============================================================================
; $359b
; JOYSTICK CONTROLS
; ==============================================================================

check_joystick:

                    lda #$fd
                    sta KEYBOARD_LATCH
                    lda KEYBOARD_LATCH
player_pos_y:       ldy #$09
player_pos_x:       ldx #$15
                    lsr
                    bcs +                   ; bcs $35af
                    cpy #$00
                    beq +                   ; beq $35af
                    dey                                           ; JOYSTICK UP
+                   lsr
                    bcs +                   ; bcs $35b7
                    cpy #$15
                    bcs +                   ; bcs $35b7
                    iny                                           ; JOYSTICK DOWN
+                   lsr
                    bcs +                   ; bcs $35bf
                    cpx #$00
                    beq +                   ; beq $35bf
                    dex                                           ; JOYSTICK LEFT
+                   lsr
                    bcs +                   ; bcs $35c7
                    cpx #$24
                    bcs +                   ; bcs $35c7
                    inx                                           ; JOYSTICK RIGHT
+                   sty m35E7 + 1           ; sty $35e8
                    stx m35EC + 1           ; stx $35ed
                    stx m3548 + 1           ; stx $3549
                    lda #$02
                    sta zpA7
                    jsr draw_player           ; jsr $3534
                    ldx #$09
-                   lda TAPE_BUFFER + $8,x      ; lda $033b,x
                    cmp #$df
                    beq +                   ; beq $35e4
                    cmp #$e2
                    bne ++                  ; bne $35f1
+                   dex
                    bne -                   ; bne $35d9
m35E7:              lda #$0a
                    sta player_pos_y + 1
m35EC:              lda #$15
                    sta player_pos_x + 1
++                  lda #$ff
                    sta KEYBOARD_LATCH
                    lda #$01
                    sta zpA7
                    lda #$93                ; first character of the player graphic
                    sta zpA8
                    lda #$3d
                    sta zp0A
get_player_pos:     ldy player_pos_y + 1
                    ldx player_pos_x + 1
m3608:              stx m3548 + 1           ; stx $3549
                    jmp draw_player           ; jmp $3534

; ==============================================================================
;
; POLL RASTER
; ==============================================================================

poll_raster:
                    sei                     ; disable interrupt
                    lda #$c0                ; A = $c0
-                   cmp $ff1d               ; vertical line bits 0-7
                    bne -                   ; loop until we hit line c0
                    lda #$00                ; A = 0
                    sta zpA7                ; zpA7 = 0

                    jsr get_player_pos
                    jsr check_joystick
                    cli
                    rts

; ==============================================================================
;
;
; ==============================================================================
m3620:
                    lda #$00
                    sta zpA7
m3624:              ldx #$0f
m3626:              ldy #$0f
                    jsr m3608
                    ldx m3624 + 1
                    ldy m3626 + 1
                    cpx player_pos_x + 1
                    bcs +
                    inx
                    inx
+                   cpx player_pos_x + 1
                    beq +
                    dex
+                   cpy player_pos_y + 1
                    bcs +
                    iny
                    iny
+                   cpy player_pos_y + 1
                    beq +
                    dey
+                   stx m3668 + 1
                    stx m3548 + 1
                    sty m366D + 1
                    lda #$02
                    sta zpA7
                    jsr draw_player
                    ldx #$09
-                   lda TAPE_BUFFER + $8,x
                    cmp #$92
                    bcc +
                    dex
                    bne -
m3668:              ldx #$10
                    stx m3624 + 1
m366D:              ldy #$0e
                    sty m3626 + 1
+                   lda #$9c
                    sta zpA8
                    lda #$3e
                    sta zp0A
                    ldy m3626 + 1
                    ldx m3624 + 1
                    stx m3548 + 1
                    lda #$01
                    sta zpA7
                    jmp draw_player


; ==============================================================================
; items
; This area seems to be responsible for items placement
;
; ==============================================================================

items:
                    !source "includes/items.asm"
items_end:

next_item:
                    lda zpA7
                    clc
                    adc #$01
                    sta zpA7
                    bcc +                       ; bcc $3845
                    inc zpA8
+                   rts

; ==============================================================================
; TODO
; no clue yet. level data has already been drawn when this is called
; probably placing the items on the screen
; ==============================================================================

update_items_display:
                    lda #>items                 ; load address for items into zeropage
                    sta zpA8
                    lda #<items
                    sta zpA7
                    ldy #$00                    ; y = 0
--                  lda (zpA7),y                ; load first value
                    cmp #$ff                    ; is it $ff?
                    beq +                       ; yes -> +
-                   jsr next_item               ; no -> set zero page to next value
                    jmp --                      ; and loop
+                   jsr next_item               ; value was $ff, now get the next value in the list
                    lda (zpA7),y
                    cmp #$ff                    ; is the next value $ff again?
                    beq m38DF                   ; yes -> m38DF
                    cmp current_room + 1        ; is the number the current room number?
                    bne -                       ; no -> loop
                    lda #>COLRAM                ; yes the number is the current room number
                    sta zp05                    ; store COLRAM and SCREENRAM in zeropage
                    lda #>SCREENRAM
                    sta zp03
                    lda #$00                    ; A = 0
                    sta zp02                    ; zp02 = 0, zp04 = 0
                    sta zp04
                    jsr next_item               ; move to next value
                    lda (zpA7),y                ; get next value in the list
-                   cmp #$fe                    ; is it $FE?
                    beq +                       ; yes -> +
                    cmp #$f9                    ; no, is it $f9?
                    bne +++                     ; no -> +++
                    lda zp02                    ; value is $f9
                    jsr m38D7                   ; add 1 to zp02 and zp04
                    bcc ++                      ; if neither zp02 nor zp04 have become 0 -> ++
+                   inc zp03                    ; value is $fe
                    inc zp05                    ; increase zp03 and zp05
++                  lda (zpA7),y                ; get value from list
+++                 cmp #$fb                    ; it wasn't $f9, so is it $fb?
                    bne +                       ; no -> +
                    jsr next_item               ; yes it's $fb, get the next value
                    lda (zpA7),y                ; get value from list
                    sta zp09                    ; store value in zp09
                    bne ++                      ; if value was 0 -> ++
+                   cmp #$f8
                    beq +
                    cmp #$fc
                    bne +++
                    lda zp0A
                    jmp m399F
+++                 cmp #$fa
                    bne ++
                    jsr next_item
                    lda (zpA7),y
                    sta zp0A
m38B7:
+                   lda zp09
                    sta (zp04),y
                    lda zp0A
                    sta (zp02),y
++                  cmp #$fd
                    bne +
                    jsr next_item
                    lda (zpA7),y
                    sta zp02
                    sta zp04
+                   jsr next_item
                    lda (zpA7),y
                    cmp #$ff
                    bne -
                    beq m38DF
m38D7:              clc
                    adc #$01
                    sta zp02
                    sta zp04
                    rts

; ==============================================================================
;
;
; ==============================================================================

m38DF:              lda current_room + 1
                    cmp #$02
                    bne m3919           ; bne $3919
                    lda #$0d
                    sta zp02
                    sta zp04
                    lda #>COLRAM        ; lda #$08
                    sta zp05
                    lda #>SCREENRAM       ; lda #$0c
                    sta zp03
                    ldx #$18
-                   lda (zp02),y
                    cmp #$df
                    beq m3900               ; beq $3900
                    cmp #$f5
                    bne ++              ; bne $3906
m3900:              lda #$f5
                    sta (zp02),y
                    sta (zp04),y
++                  lda zp02
                    clc
                    adc #$28
                    sta zp02
                    sta zp04
                    bcc +               ; bcc $3915
                    inc zp03
                    inc zp05
+                   dex
                    bne -               ; bne $38f6
                    rts

; ==============================================================================
;
;
; ==============================================================================

m3919:
                    cmp #$07
                    bne m392F       ; bne $392f
                    ldx #$17
-                   lda SCREENRAM + $168,x     ; lda $0d68,x
                    cmp #$df
                    bne +                       ; bne $392b
                    lda #$e3
                    sta SCREENRAM + $168,x     ; sta $0d68,x
+                   dex
                    bne -                       ; bne $391f
                    rts


; ==============================================================================
;
;
; ==============================================================================
m392F:
                    cmp #$06
                    bne +
                    lda #$f6
                    sta SCREENRAM + $9c        ; sta $0c9c
                    sta SCREENRAM + $9c        ;sta $0c9c    (yes, it's really 2 times the same sta)
                    sta SCREENRAM + $27c       ; sta $0e7c
                    sta SCREENRAM + $36c       ; sta $0f6c
                    rts

; ==============================================================================
;
;
; ==============================================================================

+                   cmp #$04
                    bne ++
                    ldx #$f7
                    ldy #$f8
m394A:              lda #$01
                    bne m3952           ; bne $3952
                    ldx #$3b
                    ldy #$42
m3952:              lda #$01        ; there seems to happen some self mod here
                    cmp #$01
                    bne +           ; bne $395b
                    stx SCREENRAM+ $7a ; stx $0c7a
+                   cmp #$02
                    bne +           ; bne $3962
                    stx SCREENRAM + $16a   ;stx $0d6a
+                   cmp #$03
                    bne +           ; bne $3969
                    stx SCREENRAM + $25a       ;stx $0e5a
+                   cmp #$04
                    bne +           ; bne $3970
                    stx SCREENRAM + $34a   ; stx $0f4a
+                   cmp #$05
                    bne +           ; bne $3977
                    sty SCREENRAM + $9c    ; sty $0c9c
+                   cmp #$06
                    bne +           ; bne $397e
                    sty SCREENRAM + $18c   ; sty $0d8c
+                   cmp #$07
                    bne +           ; bne $3985
                    sty SCREENRAM + $27c ; sty $0e7c
+                   cmp #$08
                    bne +           ; bne $398c
                    sty SCREENRAM + $36c   ; sty $0f6c
+                   rts

; ==============================================================================
;
;
; ==============================================================================

++                  cmp #$05
                    bne ++      ; bne m399D   ;bcs +           ;bne m399D          ; todo: understand why it jumps to an RTS
+                   lda #$fd
m3993:              ldx #$01
                    bne +               ; bne $3999
                    lda #$7a
+                   sta SCREENRAM + $2d2   ;sta $0ed2
++                  rts


; ==============================================================================

!if 1=2 {
m399D:
                    rts

!byte $ff
}

m399F:
                    cmp #$df
                    beq +               ; beq $39a5
                    inc zp0A            ; inc $0a
+                   lda (zpA7),y        ; lda ($a7),y
                    jmp m38B7           ; jmp $38b7

; ==============================================================================
; Kein Schrott, wird in m3A17 eingelesen
; $39aa
; ==============================================================================
m39AA:
!byte $06, $03, $12, $21, $03, $03, $12, $21, $03, $03, $15, $21, $03, $03, $0f, $21
!byte $15, $1e, $06, $06, $06, $03, $12, $21, $03, $03, $09, $21, $03, $03, $12, $21
!byte $03, $03, $0c, $21, $03, $03, $12, $21, $0c, $03, $0c, $20, $0c, $03, $0c, $21
!byte $0c, $03, $09, $15, $03, $03, $06, $21, $03, $03, $03, $21, $06, $03, $12, $21
!byte $03, $03, $03, $1d, $03, $03, $06, $21, $03, $03

; ==============================================================================
;
;
; ==============================================================================

check_door:

                    ldx #$09                ; set loop to 9
-                   lda TAPE_BUFFER + $8,x  ; get value from tape buffer
                    cmp #$05                ; is it a 05? -> right side of the door, meaning LEFT DOOR
                    beq m3A08               ; yes -> m3A08
                    cmp #$03                ; is it a 03? -> left side of the door, meaning RIGHT DOOR
                    beq m3A17               ; yes -> m3A17
                    dex                     ; decrease loop
                    bne -                   ; loop
-                   rts

; ==============================================================================
;
;
; ==============================================================================

m3A08:              ldx current_room + 1
                    beq -               ;beq $3a07
                    dex
                    jmp m3A64           ; jmp $3a64

!if 1=2{
!byte $34, $38, $32, $38, $02, $ff
}

m3A17:
                    ldx current_room + 1
                    inx
                    stx current_room + 1
                    ldy m3A33 + $17, x         ; ldy $3a4a,x
m3A21:              lda m39AA,y                ; lda $39aa,y
                    sta player_pos_y + 1
                    lda m39AA + 1,y            ; lda $39ab,y
                    sta player_pos_x + 1
m3A2D:              jsr display_room           ; jsr $3040
                    jmp update_items_display



; ==============================================================================
; $3a33
; Kein Schrott
; ==============================================================================

m3A33:
!byte $02 ,$06 ,$0a ,$0e ,$12 ,$16 ,$1a ,$1e ,$22 ,$26 ,$2a ,$2e ,$32 ,$36 ,$3a ,$3e
!byte $42 ,$46 ,$4a ,$4e ,$52 ,$56 ,$5a ,$5e ,$04 ,$08 ,$0c ,$10 ,$14 ,$18 ,$1c ,$20
!byte $24 ,$28 ,$2c ,$30 ,$34 ,$38 ,$3c ,$40 ,$44 ,$48 ,$4c ,$50 ,$54 ,$58 ,$5c ,$60
!byte $00

m3A64:
                    stx current_room + 1                           ; stx $3051
                    ldy m3A33,x                             ; ldy $3A33,x
                    jmp m3A21                               ; jmp $3A21


; ==============================================================================
;
; wait routine
; usually called with Y set before
; ==============================================================================

wait:
                    dex
                    bne wait
                    dey
                    bne wait
fake:               rts

; ==============================================================================
; sets the game screen
; multicolor, charset, main colors
; ==============================================================================

set_game_basics:
                    lda VOICE1           ; 0-1 TED Voice, 2 TED data fetch rom/ram select, Bits 0-5 : Bit map base address
                    and #$fb           ; clear bit 2
                    sta VOICE1          ; => get data from RAM
                    lda #$21
                    sta CHAR_BASE_ADDRESS   ; sta $ff13          ; bit 0 : Status of Clock   ( 1 )
                                        ; bit 1 : Single clock set  ( 0 )
                                        ; b.2-7 : character data base address
                                        ;         %00100$x ($2000)
                    lda $ff07
                    ora #$90           ; multicolor ON - reverse OFF
                    sta $ff07

                    ; set the main colors for the game


                    lda #MULTICOLOR_1            ; original: #$db
                    sta COLOR_1           ; char color 1
                    lda #MULTICOLOR_2            ; original: #$29
                    sta COLOR_2           ; char color 2

                    rts

; ==============================================================================
; set font and screen setup (40 columns and hires)
; $3a9d
; ==============================================================================

set_charset_and_screen_for_title:    ; set text screen

                    lda VOICE1
                    ora #$04           ; set bit 2
                    sta VOICE1          ; => get data from ROM
                    lda #$d5           ; ROM FONT
                    sta CHAR_BASE_ADDRESS   ; sta $ff13          ; set
                    lda $ff07
                    lda #$08           ; 40 columns and Multicolor OFF
                    sta $ff07
                    rts


; ==============================================================================
; init
; start of game (original $3ab3)
; ==============================================================================

code_start:
init:
                    jsr m1F15           ; jsr $1f15
                    lda #$01
                    sta BG_COLOR          ; background color
                    sta BORDER_COLOR          ; border color
                    jsr reset_items           ; might be a level data reset, and print the title screen
                    ldy #$20
                    jsr wait

                    ; waiting for key press on title screen

                    lda #TITLE_KEY_MATRIX    ;#$7f           ; read row 7 of keyboard matrix (http://plus4world.powweb.com/plus4encyclopedia/500012)
-                   sta KEYBOARD_LATCH          ; Latch register for keyboard
                    lda KEYBOARD_LATCH
                    and #TITLE_KEY    ;#$10            ; $10 = space
                    bne -               ; bne $3ac8 / wait for keypress ?

                    lda #$ff
                    jsr start_intro           ; displays intro text, waits for shift/fire and decreases the volume


                    ; TODO: unclear what the code below does
                    ; i think it fills the level data with "DF", which is a blank character
                    lda #>SCREENRAM       ; lda #$0c
                    sta zp03
                    lda #$00
                    sta zp02
                    ldx #$04
                    ldy #$00
                    lda #$df
-                   sta (zp02),y
                    iny
                    bne -               ; bne $3ae5
                    inc zp03
                    dex
                    bne -               ; bne $3ae5

                    jsr set_game_basics           ; jsr $3a7d -> multicolor, charset and main char colors

                    ; set background color
                    lda #$00
                    sta BG_COLOR

                    ; border color. default is a dark red
                    lda #BORDER_COLOR_VALUE
                    sta BORDER_COLOR
                    jsr draw_border
                    jmp set_start_screen           ; jmp $3b3a
; ==============================================================================
draw_border:        ; draws the extended "border"
                    lda #$27
                    sta zp02
                    sta zp04
                    lda #>COLRAM
                    sta zp05
                    lda #>SCREENRAM
                    sta zp03
                    ldx #$18
                    ldy #$00
-                   lda #$5d
                    sta (zp02),y
                    lda #COLOR_FOR_INVISIBLE_ROW_AND_COLUMN
                    sta (zp04),y
                    tya
                    clc
                    adc #$28
                    tay
                    bcc +
                    inc zp03
                    inc zp05
+                   dex
                    bne -
-                   lda #$5d
                    sta SCREENRAM + $3c0,x
                    lda #COLOR_FOR_INVISIBLE_ROW_AND_COLUMN
                    sta COLRAM + $3c0,x
                    inx
                    cpx #$28
                    bne -
                    rts

; ==============================================================================
; SETUP FIRST ROOM
; player xy position and room number
; ==============================================================================

set_start_screen:
                    lda #PLAYER_START_POS_Y
                    sta player_pos_y + 1               ; Y player start position (0 = top)
                    lda #PLAYER_START_POS_X
                    sta player_pos_x + 1               ; X player start position (0 = left)
                    lda #START_ROOM              ; room number (start screen) ($3b45)
                    sta current_room + 1
                    jsr m3A2D                   ; jsr $3a2d

m3B4C:
                    jsr m2FEF                   ; jsr $2fef
                    ldy #$30
                    jsr wait
                    jsr m2fCB                   ; jsr $2fcb
                    jmp m162d
; ==============================================================================

death_messages:

; death messages
; like "You fell into a snake pit"

; scr conversion

; 00 You fell into a snake pit
; 01 You'd better watched out for the sacred column
; 02 You drowned in the deep river
; 03 You drank from the poisend bottle
; 04 Boris the spider got you and killed you
; 05 Didn't you see the laser beam?
; 06 240 Volts! You got an electrical shock!
; 07 You stepped on a nail!
; 08 A foot trap stopped you!
; 09 This room is doomed by the wizard Manilo!
; 0a You were locked in and starved!
; 0b You were hit by a big rock and died!
; 0c Belegro killed you!
; 0d You found a thirsty zombie....
; 0e The monster grabbed you you. You are dead!
; 0f You were wounded by the bush!
; 10 You are trapped in wire-nettings!

!if LANGUAGE = EN{
!scr "You fell into a          snake pit !              "
!scr "You'd better watched out for the sacred column!   "
!scr "You drowned in the deep  river !                  "
!scr "You drank from the       poisened bottle ........ "
!scr "Boris, the spider, got   you and killed you !     "
!scr "Didn't you see the       laser beam ?!?           "
!scr "240 Volts ! You got an   electrical shock !       " ; original: !scr "240 Volts ! You got an electrical shock !         "
!scr "You stepped on a nail !                           "
!scr "A foot trap stopped you !                         "
!scr "This room is doomed      by the wizard Manilo !   "
!scr "You were locked in and   starved !                " ; original: !scr "You were locked in and starved !                  "
!scr "You were hit by a big    rock and died !          "
!scr "Belegro killed           you !                    "
!scr "You found a thirsty      zombie .......           "
!scr "The monster grapped       you. You are dead !     "
!scr "You were wounded by      the bush !               "
!scr "You are trapped in       wire-nettings !          "
}


!if LANGUAGE = DE{
!scr "Sie sind in eine         Schlangengrube gefallen !"
!scr "Gotteslaesterung wird    mit dem Tod bestraft !   "
!scr "Sie sind in dem tiefen   Fluss ertrunken !        "
!scr "Sie haben aus der Gift-  flasche getrunken....... "
!scr "Boris, die Spinne, hat   Sie verschlungen !!      "
!scr "Den Laserstrahl muessen  Sie uebersehen haben ?!  "
!scr "220 Volt !! Sie erlitten einen Elektroschock !    "
!scr "Sie sind in einen Nagel  getreten !               "
!scr "Eine Fussangel verhindertIhr Weiterkommen !       "
!scr "Auf diesem Raum liegt einFluch des Magiers Manilo!"
!scr "Sie wurden eingeschlossenund verhungern !         "
!scr "Sie wurden von einem     Stein ueberollt !!       "
!scr "Belegro hat Sie          vernichtet !             "
!scr "Im Sarg lag ein durstigerZombie........           "
!scr "Das Monster hat Sie      erwischt !!!!!           "
!scr "Sie haben sich an dem    Dornenbusch verletzt !   "
!scr "Sie haben sich im        Stacheldraht verfangen !!"
}

; ==============================================================================
;
; Display the death message
; End of game and return to start screen
; ==============================================================================

death:
                    lda #>death_messages
                    sta zpA8
                    lda #<death_messages
                    sta zpA7
                    cpy #$00
                    beq ++           ; beq $3ec4
-                   clc
                    adc #$32
                    sta zpA7
                    bcc +            ; bcc $3ec1
                    inc zpA8
+                   dey
                    bne -           ; bne $3eb8
++                  lda #$0c
                    sta zp03
                    sty zp02
                    ldx #$04
                    lda #$20
-                   sta (zp02),y
                    iny
                    bne -               ; bne $3ece
                    inc zp03
                    dex
                    bne -               ; bne $3ece
                    jsr set_charset_and_screen_for_title
-                   lda (zpA7),y
                    sta SCREENRAM + $1c0,x   ; sta $0dc0,x         ; position of the death message
                    lda #$00                                    ; color of the death message
                    sta COLRAM + $1c0,x     ; sta $09c0,x
                    inx
                    iny
                    cpx #$19
                    bne +               ; bne $3eed
                    ldx #$50
+                   cpy #$32
                    bne -               ; bne $3edb
                    lda #$fd
                    sta BG_COLOR
                    sta BORDER_COLOR
m3EF9:
                    lda #$08
-                   ldy #$ff
                    jsr wait           ; jsr $3a76
                    sec
                    sbc #$01
                    bne -               ; bne $3efb
                    jmp init            ; jmp $3ab3
; ==============================================================================
; screen messages
; and the code entry text
; ==============================================================================

!if LANGUAGE = EN{

hint_messages:
!scr " A part of the code number is :         "
!scr " ABCDEFGHIJKLMNOPQRSTUVWXYZ 0123456789",$bc," "
!scr " You need: bulb, bulb holder, socket !  "
!scr " Tell me the Code number ?     ",$22,"     ",$22,"  "
!scr " *****   A helping letter :   "
helping_letter: !scr "C   ***** "
!scr " Wrong code number ! DEATH PENALTY !!!  " ; original: !scr " Sorry, bad code number! Better luck next time! "

}

!if LANGUAGE = DE{

hint_messages:
!scr " Ein Teil des Loesungscodes lautet:     "
!scr " ABCDEFGHIJKLMNOPQRSTUVWXYZ 0123456789",$bc," "
!scr " Du brauchst:Fassung,Gluehbirne,Strom ! "
!scr " Wie lautet der Loesungscode ? ",$22,"     ",$22,"  "
!scr " *****   Ein Hilfsbuchstabe:  "
helping_letter: !scr "C   ***** "
!scr " Falscher Loesungscode ! TODESSTRAFE !!!"

}