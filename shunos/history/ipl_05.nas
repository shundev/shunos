; hello-os
; TAB=4

; 定数
CYLS    EQU     10

    ORG     0x7c00

; For FAT12
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
    MOV     DS,AX   ; セグメントレジスタ. バッファアドレスに加算される.

; Read disk
    MOV     AX,0x0820
    MOV     ES,AX   ; バッファアドレス
    MOV     CH,0    ; シリンダ番号
    MOV     DH,0    ; ヘッド番号
    MOV     CL,2    ; セクタ番号

readloop:
    MOV     SI,0    ; 失敗回数

retry:
    MOV     AH,0x02 ; 0x13のモード読み込み
    MOV     AL,1    ; 処理するセクタ数
    MOV     BX,0    ; バッファアドレス
    MOV     DL,0x00 ; ドライブ番号
    INT     0x13    ; ディスクアクセス命令
    JNC      next   ; 0x13でエラーが無ければ次のセクタ
    ADD     SI,1
    CMP     SI,5
    JAE     error   ; SI >=5 でerrorへ
    MOV     AH,0x00
    MOV     DL,0x00
    INT     0x13
    JMP     retry

next:
    MOV     AX,ES       ; アドレス +0x20
    ADD     AX,0x0020   ; 1セクタ512バイト. 0x20=16 512/16=20バイト進める
    MOV     ES,AX
    ADD     CL,1
    CMP     CL,18
    JBE     readloop    ; CL <= 18
    MOV     CL,1        ; セクタを1にリセット
    ADD     DH,1
    CMP     DH,2
    JB      readloop    ; DH=0 表 DH=1 裏 その他=次
    MOV     DH,0
    ADD     CH,1
    CMP     CH,CYLS
    JB      readloop    ; CH < CYLSなら次

    MOV     [0x0ff0],CH ; IPLがどこまで呼んだかメモ
    JMP     0xc200

error:
    MOV     AX,0
    MOV     ES,AX
    MOV     SI,msg

putloop:
    MOV     AL,[SI]
    ADD     SI,1
    CMP     AL,0
    JE      fin
    MOV     AH,0x0e
    MOV     BX,15
    INT     0x10
    JMP     putloop

fin:
    HLT
    JMP     fin

msg:
    DB      0x0a, 0x0a
    DB      "load error"
    DB      0x0a
    DB      0
    RESB    0x7dfe-$
    DB      0x55, 0xaa
