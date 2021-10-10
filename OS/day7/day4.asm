              EXTERN DISPLAY        	;FROM C
              [BITS 16]
              [SECTION .TEXT]
              GLOBAL _start
              GLOBAL MYPRINT
              _start:
              CALL DISPLAY          	;ASM CALL CALL
              MYPRINT:
              MOV AX, 0XB800
              MOV ES, AX
              MOV BYTE [ES: 0X00], 'O'
              MOV BYTE [ES: 0X01], 0X07
			  MOV BYTE [ES: 0X02], 'K'
              MOV BYTE [ES: 0X03], 0X06
              RET
