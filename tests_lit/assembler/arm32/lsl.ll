; Show that we know how to translate lsl.

; NOTE: We use -O2 to get rid of memory stores.

; REQUIRES: allow_dump

; Compile using standalone assembler.
; RUN: %p2i --filetype=asm -i %s --target=arm32 --args -O2 \
; RUN:   | FileCheck %s --check-prefix=ASM

; Show bytes in assembled standalone code.
; RUN: %p2i --filetype=asm -i %s --target=arm32 --assemble --disassemble \
; RUN:   --args -O2 | FileCheck %s --check-prefix=DIS

; Compile using integrated assembler.
; RUN: %p2i --filetype=iasm -i %s --target=arm32 --args -O2 \
; RUN:   | FileCheck %s --check-prefix=IASM

; Show bytes in assembled integrated code.
; RUN: %p2i --filetype=iasm -i %s --target=arm32 --assemble --disassemble \
; RUN:   --args -O2 | FileCheck %s --check-prefix=DIS

define internal i32 @ShlAmt(i32 %a) {
; ASM-LABEL:ShlAmt:
; DIS-LABEL:00000000 <ShlAmt>:
; IASM-LABEL:ShlAmt:

entry:
; ASM-NEXT:.LShlAmt$entry:
; IASM-NEXT:.LShlAmt$entry:

  %shl = shl i32 %a, 23

; ASM-NEXT:     lsl     r0, r0, #23
; DIS-NEXT:   0:        e1a00b80
; IASM-NEXT:    .byte 0x80
; IASM-NEXT:    .byte 0xb
; IASM-NEXT:    .byte 0xa0
; IASM-NEXT:    .byte 0xe1

  ret i32 %shl
}

define internal i32 @ShlReg(i32 %a, i32 %b) {
; ASM-LABEL:ShlReg:
; DIS-LABEL:00000010 <ShlReg>:
; IASM-LABEL:ShlReg:

entry:
; ASM-NEXT:.LShlReg$entry:
; IASM-NEXT:.LShlReg$entry:

  %shl = shl i32 %a, %b

; ASM-NEXT:     lsl     r0, r0, r1
; DIS-NEXT:  10:        e1a00110
; IASM-NEXT:    .byte 0x10
; IASM-NEXT:    .byte 0x1
; IASM-NEXT:    .byte 0xa0
; IASM-NEXT:    .byte 0xe1

  ret i32 %shl
}
