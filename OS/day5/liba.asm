              BITS 16
              [GLOBAL printInPos]   	;Print content at the cursor
              [GLOBAL putchar]      	;Output one character
              [GLOBAL getch]        	;Get keyboard input

              ;Get keyboard input
              getch:
              MOV AH, 0             	;Function number
              INT 16H
              MOV AH, 0             	;Read characters, AL = characters
              RETF

              ;Print characters at the cursor
              putchar:
              PUSHA                 	;Protect the scene
              MOV BP, SP            	;Save the top of the stack
              ADD BP, 16 + 4        	;Parameter address
              MOV AL, [BP]          	;AL = Print characters
              MOV BH, 0             	;BH = page number
              MOV AH, 0EH           	;function number
              INT 10H
              POPA
              RETF

              ;Display the string at the specified position
              printInPos:
              PUSHA
              MOV SI, SP            	;use SI
              ADD SI, 16 + 4        	;First parameter address
              MOV AX, CS
              MOV DS, AX
              MOV BP, [SI]          	;BP = offset
              MOV AX, DS            	;
              MOV ES, AX            	;ES = DS
              MOV CX, [SI + 4]      	;CX = String length
              MOV AX, 1301H         	;functon number AH = 13 AL = 01H,Indicates that the cursor displays the end of the string
              MOV BX, 0007H         	;BH = page number BL = 07 black and white
              MOV DH, [SI + 8]      	;Line number= 0
              MOV DL, [SI + 12]     	;Column number = 0
              INT 10H               	;BIOS 10H interrupt call
              POPA
              RETF
