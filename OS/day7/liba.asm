              BITS 16
              [GLOBAL printInPos]   	;Print content at the cursor
              [GLOBAL putchar]      	;Output one character
              [GLOBAL getch]        	;Get keyboard input
              [GLOBAL clearScreen]  	;clear the screen
              [GLOBAL poweroff]     	;power off
              [GLOBAL systime]     		;systime	  
			  [GLOBAL CALLPM]			;call pm
			  [GLOBAL getDate]			;get date
			  ;getDate
			  getDate:
			  PUSHA
			  ;---- year ----
			  MOV AL,'2'
			  MOV BH,0
			  MOV AH,0EH
			  INT 10H
			  
			  MOV AL,'0'
			  MOV BH,0
			  MOV AH,0EH
			  INT 10H
			  
			  MOV AL,09H   
			  OUT 70H,AL
			  IN AL,71H
			  MOV AH,AL
			  MOV CL,4
			  SHR AH,CL
			  AND AL,00001111B
			  ADD AH,30H
			  ADD AL,30H
			  ;AX = year
			  MOV DX,AX
			  MOV AL,DH
			  MOV BH,0
			  MOV AH,0EH
			  INT 10H
			  
			  MOV AL,DL
			  MOV BH,0
			  MOV AH,0EH
			  INT 10H
			  
			  MOV AL,'-'
			  MOV BH,0
			  MOV AH,0EH
			  INT 10H
			  ; ---- month ----
			  MOV AL,08H   
			  OUT 70H,AL
			  IN AL,71H
			  MOV AH,AL
			  MOV CL,4
			  SHR AH,CL
			  AND AL,00001111B
			  ADD AH,30H
			  ADD AL,30H
			  ;AX = month
			  MOV DX,AX
			  MOV AL,DH
			  MOV BH,0
			  MOV AH,0EH
			  INT 10H
			  
			  MOV AL,DL
			  MOV BH,0
			  MOV AH,0EH
			  INT 10H
			  
			  MOV AL,'-'
			  MOV BH,0
			  MOV AH,0EH
			  INT 10H
			  
			  ;date
			  MOV AL,07H   
			  OUT 70H,AL
			  IN AL,71H
			  MOV AH,AL
			  MOV CL,4
			  SHR AH,CL
			  AND AL,00001111B
			  ADD AH,30H
			  ADD AL,30H
			  ;AX = date
			  MOV DX,AX
			  MOV AL,DH
			  MOV BH,0
			  MOV AH,0EH
			  INT 10H
			  
			  MOV AL,DL
			  MOV BH,0
			  MOV AH,0EH
			  INT 10H
			  
			  MOV AL,0AH
			  MOV BH,0
			  MOV AH,0EH
			  INT 10H
			  
			  MOV AL,0DH
			  MOV BH,0
			  MOV AH,0EH
			  INT 10H
			  POPA
			  RETF
			  ;systime
			  systime:
			  PUSHA
			  ;hour
			  MOV AL,4   
			  OUT 70H,AL
			  IN AL,71H
			  MOV AH,AL
			  MOV CL,4
			  SHR AH,CL
			  AND AL,00001111B
			  ADD AH,30H
			  ADD AL,30H
			  ;AX = hour
			  MOV DX,AX
			  MOV AL,DH
			  MOV BH,0
			  MOV AH,0EH
			  INT 10H
			  
			  MOV AL,DL
			  MOV BH,0
			  MOV AH,0EH
			  INT 10H
			  
			  MOV AL,':'
			  MOV BH,0
			  MOV AH,0EH
			  INT 10H
			  ;---- minute ----
			  MOV AL,2   
			  OUT 70H,AL
			  IN AL,71H
			  MOV AH,AL
			  MOV CL,4
			  SHR AH,CL
			  AND AL,00001111B
			  ADD AH,30H
			  ADD AL,30H
			  ;AX = minute
			  MOV DX,AX
			  MOV AL,DH
			  MOV BH,0
			  MOV AH,0EH
			  INT 10H
			  
			  MOV AL,DL
			  MOV BH,0
			  MOV AH,0EH
			  INT 10H
			  
			  MOV AL,':'
			  MOV BH,0
			  MOV AH,0EH
			  INT 10H
			  ; ----- second ----
			  MOV AL,0  
			  OUT 70H,AL
			  IN AL,71H
			  MOV AH,AL
			  MOV CL,4
			  SHR AH,CL
			  AND AL,00001111B
			  ADD AH,30H
			  ADD AL,30H
			  ;AX = second
			  MOV DX,AX
			  MOV AL,DH
			  MOV BH,0
			  MOV AH,0EH
			  INT 10H
			  
			  MOV AL,DL
			  MOV BH,0
			  MOV AH,0EH
			  INT 10H
			  
			  MOV AL,0AH
			  MOV BH,0
			  MOV AH,0EH
			  INT 10H
			  
			  MOV AL,0DH
			  MOV BH,0
			  MOV AH,0EH
			  INT 10H
			  POPA
			  RETF
			  ;power off
              poweroff:
              MOV AX, 5307H
              MOV BX, 0001H
              MOV CX, 0003H
              INT 15H

              ;clear the screen
              clearScreen:
              PUSH AX
              MOV AX, 0003H
              INT 10H
              POP AX
              RETF
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
			  
			  
			  
			  CALLPM:
			  ;??????????????????
			  MOV EAX,20				;LBA ???????????????????????????
			  MOV BX,0X9000				;???????????????KERNEL???????????????
			  MOV CX,10					;??????????????????
			  
			  CALL READ_DISK
			  JMP 0x9000
			  READ_DISK:
              ;EAX LBA ?????????
              ;BX ???????????????????????????
              ;CX ???????????????

              ;??????????????? EAX CX
              MOV ESI, EAX
              MOV DI, CX
              ;???????????????????????????
              ;????????????
              MOV DX, 0X1F2         	;
              MOV AL, CL            	;
              OUT DX, AL

              ;?????? EAX
              MOV EAX, ESI

              ;???LBA??????????????? 0x1f3-0x1f6???????????????????????????
              ;0-7 ??????0x1f3
              MOV DX, 0X1F3
              OUT DX, AL
              ;8-15 ??????0x1f4
              MOV CL, 8
              SHR EAX, CL
              MOV DX, 0X1F4
              OUT DX, AL
              ;16-23 ??????0x1f5
              SHR EAX, CL
              AND AL, 0X0F
              MOV DX, 0X1F5
              OUT DX, AL
              ;24 - 27
              SHR EAX, CL
              AND AL, 0X0F
              OR AL, 0XE0           	;AL = 1110 0000
              MOV DX, 0X1F6
              OUT DX, AL
              ;???0x1f7 ???????????????
              MOV DX, 0X1F7
              MOV AL, 0X20          	;???????????????

              OUT DX, AL
              ;??????????????????
              .NOT_READY:
              NOP
              ;???????????????????????????
              IN AL, DX
              AND AL, 0X88          	;???4??????1????????????????????????7??????1????????????
              CMP AL, 0X08
              JNZ .NOT_READY
              ;?????????
              MOV AX, DI            	;?????? DI = 1
              MOV DX, 512
              MUL DX
              MOV CX, AX
              MOV DX, 0X1F0
              .GO_ON:
              IN AX, DX
              MOV[BX], AX           	;???BASE_ADDR(??????0x8000)?????????
              ADD BX, 2
              LOOP .GO_ON
              RET
