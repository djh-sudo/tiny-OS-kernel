              ORG 07C00H            	;告诉编译器程序被加载的地址为0x7c00
              MOV AX, CS
              MOV DS, AX
              MOV ES, AX
              CALL SHOW
              JMP $
              SHOW:
              MOV AX, MESSAGE
              MOV BP, AX
              MOV CX, 16
              MOV AX, 01301H        	;AH = 13H AL = 01H
              MOV BX, 000CH         	;页号为0 BH = 0 红底黑字 BL = 0CH
              MOV DL, 0
              INT 10H
              RET
    MESSAGE:  DB "HELLO, OS WORLD!"
              TIMES 510 - ($ - $$) DB 0	;剩下的字节全部使用0填充

              DW 0XAA55             	;
