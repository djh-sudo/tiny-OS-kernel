LOADER_BASE_ADDR EQU 0X900          	;加载第2个段的地址
KERNEL_BASE_ADDR EQU 0X1500
KERNEL_START_SECTOR EQU 0X9         	;kernel从第9个扇区开始读
              SECTION LOADER VSTART=LOADER_BASE_ADDR

              MOV AX, 0XB800        	;显存位置
              MOV ES, AX

              MOV BYTE[ES: 0X00], 'O'
              MOV BYTE[ES: 0X01], 0X07
              MOV BYTE[ES: 0X02], 'K'
              MOV BYTE[ES: 0X03], 0X06

              MOV EAX, KERNEL_START_SECTOR	;LBA 读入的扇区个数
              MOV BX, KERNEL_BASE_ADDR	;KERNEL的起始地址
              MOV CX, 1

              CALL READ_DISK
              JMP KERNEL_BASE_ADDR



              ;--------------------读扇区
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
