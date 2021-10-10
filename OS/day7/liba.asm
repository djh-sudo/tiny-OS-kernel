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
			  ;进入保护模式
			  MOV EAX,20				;LBA 读入的扇区起始偏移
			  MOV BX,0X9000				;保护模式下KERNEL的起始地址
			  MOV CX,10					;读入扇区个数
			  
			  CALL READ_DISK
			  JMP 0x9000
			  READ_DISK:
              ;EAX LBA 扇区号
              ;BX 数据写入内存的地址
              ;CX 读入扇区数

              ;保存寄存器 EAX CX
              MOV ESI, EAX
              MOV DI, CX
              ;设置读取扇区的数量
              ;读写硬盘
              MOV DX, 0X1F2         	;
              MOV AL, CL            	;
              OUT DX, AL

              ;恢复 EAX
              MOV EAX, ESI

              ;将LBA的地址存入 0x1f3-0x1f6，设置起始扇区编号
              ;0-7 写入0x1f3
              MOV DX, 0X1F3
              OUT DX, AL
              ;8-15 写入0x1f4
              MOV CL, 8
              SHR EAX, CL
              MOV DX, 0X1F4
              OUT DX, AL
              ;16-23 写入0x1f5
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
              ;向0x1f7 写入读命令
              MOV DX, 0X1F7
              MOV AL, 0X20          	;表示读命令

              OUT DX, AL
              ;检测硬盘状态
              .NOT_READY:
              NOP
              ;读取端口，查看状态
              IN AL, DX
              AND AL, 0X88          	;第4位为1表示可以传输，第7位为1表示繁忙
              CMP AL, 0X08
              JNZ .NOT_READY
              ;读数据
              MOV AX, DI            	;这里 DI = 1
              MOV DX, 512
              MUL DX
              MOV CX, AX
              MOV DX, 0X1F0
              .GO_ON:
              IN AX, DX
              MOV[BX], AX           	;向BASE_ADDR(内存0x8000)写数据
              ADD BX, 2
              LOOP .GO_ON
              RET
