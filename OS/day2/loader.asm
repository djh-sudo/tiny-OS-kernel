LOADER_BASE_ADDR EQU 0X900          	;加载第2个段的地址
              SECTION LOADER VSTART=LOADER_BASE_ADDR

              MOV AX, 0XB800        	;显存位置
              MOV ES, AX

              MOV BYTE[ES: 0X00], 'O'
              MOV BYTE[ES: 0X01], 0X07
              MOV BYTE[ES: 0X02], 'K'
              MOV BYTE[ES: 0X03], 0X06
              JMP $
