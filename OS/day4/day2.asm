LOADER_BASE_ADDR EQU 0X900          	;加载第2个段的地址
LOADER_START_SECTOR EQU 0X2         	;以LBA方式,loader存在第2个扇区,第一个是主引导扇区


              SECTION MBR VSTART=0X7C00	;程序加载到0x7c00
              ;初始化寄存器
              MOV AX, CS
              MOV DS, AX
              MOV ES, AX
              MOV SS, AX
              MOV FS, AX
              MOV SP, 0X7C00
              MOV AX, 0XB800        	;显存位置
              MOV GS, AX
              ;调用BIOS 0x10中断
              MOV AX, 0X0600        	;AH 功能 AL是内容，这里都是0
              MOV BX, 0X0700        	;BH 上卷行的属性
              MOV CX, 0             	;(CL,CH)->(X0,Y0)左上角
              MOV DX, 184FH         	;(DL,DH)->(X1,Y1) 右下角 (80,25)
              INT 10H               	;调用BIOS 0x10中断
              ;输出
              MOV BYTE [GS: 0X00], '*'
              MOV BYTE [GS: 0X01], 0XA4

              MOV BYTE [GS: 0X02], '*'
              MOV BYTE [GS: 0X03], 0XA4

              MOV BYTE [GS: 0X04], 'M'
              MOV BYTE [GS: 0X05], 0XA4

              MOV BYTE [GS: 0X06], 'B'
              MOV BYTE [GS: 0X07], 0XA4

              MOV BYTE [GS: 0X08], 'R'
              MOV BYTE [GS: 0X09], 0XA4

              ;读LOADER
              MOV EAX, LOADER_START_SECTOR	;LBA方式读入扇区
              MOV BX, LOADER_BASE_ADDR	;LBA方式写入地址
              MOV CX, 1             	;读一个扇区
              CALL READ_DISK
              JMP LOADER_BASE_ADDR  	;跳转至 LOADER

              ;读扇区
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
              MOV[BX], AX           	;向BASE_ADDR(内存0x900)写数据
              ADD BX, 2
              LOOP .GO_ON
              RET

              TIMES 510 - ($ - $$) DB 0
              DB 0X55, 0XAA








