       DA_32  EQU 4000H             	;32位
        DA_C  EQU 98H               	; 只执行代码段的属性
      DA_DRW  EQU 92H               	;可读写的数据段
     DA_DRWA  EQU 93H               	;存在的已访问的可读写的

              %MACRO DESCRIPTOR 3
              DW %2 & 0FFFFH        	;段界限1 (2字节)
              DW %1 & 0FFFFH        	;段基址1 (2字节)
              DB (%1 >> 16) & 0FFH  	;段基址2 (1字节)
              DW ((%2 >> 8) & 0F00H) | (%3 & 0F0FFH)	;属性1 + 段界限2 + 属性2 (2字节)
              DB (%1 >> 24) & 0FFH  	;段基址3
              %ENDMACRO


              ORG 0X9000           	;起始地址
              JMP PM_BEGIN          ;跳入到标号为PM_BEGIN的代码段开始推进


              [SECTION .GDT]
              ;GDT
              ;								段基址，段界限，属性
     PM_GDT:  DESCRIPTOR 0, 0, 0
PM_DESC_CODE32: DESCRIPTOR 0, SEGCODE32LEN -1, DA_C+DA_32
PM_DESC_DATA: DESCRIPTOR 0, DATALEN-1, DA_DRW
PM_DESC_STACK: DESCRIPTOR 0, TOPOFSTACK, DA_DRWA+DA_32
PM_DESC_TEST: DESCRIPTOR 0200000H, 0FFFFH, DA_DRW
PM_DESC_VIDEO: DESCRIPTOR 0B8000H, 0FFFFH, DA_DRW
              ;end of definiton gdt
      GDTLEN  EQU $ - PM_GDT
      GDTPTR  DW GDTLEN - 1
              DD 0                  	; GDT 基地址

              ;GDT 选择子
SELECTOERCODE32 EQU PM_DESC_CODE32 - PM_GDT
SELECTOERDATA EQU PM_DESC_DATA - PM_GDT
SELECTOERSTACK EQU PM_DESC_STACK - PM_GDT
SELECTOERTEST EQU PM_DESC_TEST - PM_GDT
SELECTOERVIDEO EQU PM_DESC_VIDEO - PM_GDT
              ;END of [SECTION .gdt]

              [SECTION .DATA1]
              ALIGN 32
              [BITS 32]
              PM_DATA:
              PMMESSAGE : DB "POTECT MODE", 0	;
OFFSETPMESSAGE EQU PMMESSAGE - $$
     DATALEN  EQU $- PM_DATA
              ;END of [SECTION .data]

              ;全局的堆栈段
              [SECTION .GS]
              ALIGN 32
              [BITS 32]
              PM_STACK:
              TIMES 512 DB 0
  TOPOFSTACK  EQU $ - PM_STACK -1
              ;END of STACK	

              [SECTION .S16]
              [BITS 16]
              PM_BEGIN:
              MOV AX, CS
              MOV DS, AX
              MOV ES, AX
              MOV SS, AX
              MOV SP, 0100H

              ;初始化32位的代码段
              XOR EAX, EAX
              MOV AX, CS
              SHL EAX, 4
              ADD EAX, PM_SEG_CODE32
              MOV WORD[PM_DESC_CODE32+2], AX
              SHR EAX, 16
              MOV BYTE [PM_DESC_CODE32+4], AL
              MOV BYTE [PM_DESC_CODE32+7], AH


              ;初始化32位的数据段
              XOR EAX, EAX
              MOV AX, DS
              SHL EAX, 4
              ADD EAX, PM_DATA
              MOV WORD[PM_DESC_DATA+2], AX
              SHR EAX, 16
              MOV BYTE [PM_DESC_DATA+4], AL
              MOV BYTE [PM_DESC_DATA+7], AH

              ;初始化32位的stack段
              XOR EAX, EAX
              MOV AX, DS
              SHL EAX, 4
              ADD EAX, PM_STACK
              MOV WORD[PM_DESC_STACK + 2], AX
              SHR EAX, 16
              MOV BYTE [PM_DESC_STACK + 4], AL
              MOV BYTE [PM_DESC_STACK + 7], AH

              ;加载GDTR
              XOR EAX, EAX
              MOV AX, DS
              SHL EAX, 4
              ADD EAX, PM_GDT
              MOV DWORD [GDTPTR + 2], EAX
              LGDT [GDTPTR]

              ;A20
              CLI

              IN AL, 92H
              OR AL, 00000010B
              OUT 92H, AL

              ;切换到保护模式
              MOV EAX, CR0
              OR EAX, 1
              MOV CR0, EAX

              JMP DWORD SELECTOERCODE32: 0



              [SECTION .S32]        	;32位的代码段
              [BITS 32]
              PM_SEG_CODE32 :
              MOV AX, SELECTOERDATA 	;通过数据段的选择子放入ds寄存器，就可以用段+偏移进行寻址
              MOV DS, AX

              MOV AX, SELECTOERTEST 	;通过测试段的选择子放入es寄存器，就可以用段+偏移进行寻址
              MOV ES, AX

              MOV AX, SELECTOERVIDEO
              MOV GS, AX

              MOV AX, SELECTOERSTACK
              MOV SS, AX
              MOV ESP, TOPOFSTACK

              MOV AH, 0CH
              XOR ESI, ESI
              XOR EDI, EDI
              MOV ESI, OFFSETPMESSAGE
              MOV EDI, (80*10 +0) *2
              CLD

              .1:
              LODSB
              TEST AL, AL
              JZ .2
              MOV [GS: EDI], AX
              ADD EDI, 2
              JMP .1

              .2:                   	;显示完毕

              ;测试段的寻址
              MOV AX, 'P'
              MOV [ES: 0], AX
              MOV AX, SELECTOERVIDEO
              MOV GS, AX
              MOV EDI, (80*15 +0) *2
              MOV AH, 0CH
              MOV AL, [ES: 0]
              MOV [GS: EDI], AX

              JMP $


SEGCODE32LEN  EQU $ - PM_SEG_CODE32
