; hello-os
; TAB=4

; For FAT12
    ORG     0x7c00
    JMP     entry
    DB      0x90
    DB    "HELLOIPL"
    DW    512
    DB    1
    DW    1
    DB    2
    DW    224
    DW    2880
    DB    0xf0
    DW    9
    DW    18
    DW    2
    DD    0
    DD    2880
    DB    0,0,0x29
    DD    0xffffffff
    DB    "HELLO-OS   "
    DB    "FAT12   "
    RESB  18

; プログラム本体

entry:
    MOV     AX,0
    MOV     SS,AX
    MOV     SP,0x7c00
    MOV     DS,AX
    MOV     SI,AX

msg:
    DB      0x0a, 0x0a
    DB      "Hello, ShunOS!"
    DB      0x0a
    MOV     AH,0x0e
    MOV     BX,15
    MOV     AL,0x0a
    INT     0x10
    MOV     AL,0x0a
    INT     0x10
    MOV     AL,"h"
    INT     0x10
    MOV     AL,"e"
    INT     0x10
    MOV     AL,"l"
    INT     0x10
    MOV     AL,"l"
    INT     0x10
    MOV     AL,"o"
    INT     0x10
    MOV     AL,0x0a
    INT     0x10

    RESB    0x7dfe-$
    DB      0x55, 0xaa

    DB      0xf0, 0xff, 0xff, 0x00, 0x00, 0x00, 0x00, 0x00
    RESB    4600
    DB      0xf0, 0xff, 0xff, 0x00, 0x00, 0x00, 0x00, 0x00
    RESB    1469432

