KERNEL_BASE_ADDR EQU 0X1500
              SECTION LOADER VSTART=KERNEL_BASE_ADDR
              MOV AX, 0XB800
              MOV ES, AX

              MOV BYTE [ES: 0X00], 'D'
              MOV BYTE [ES: 0X01], 0X07
              MOV BYTE [ES: 0X02], 'X'
              MOV BYTE [ES: 0X03], 0X06
              JMP $
