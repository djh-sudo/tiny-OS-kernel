              BITS 16
              [EXTERN startUp]
              [EXTERN shell]

              GLOBAL _start
			  ;entry
              _start:
              CALL DWORD startUp
			  ;wait the keyboard
              KeyBoard:
              MOV AH, 0
              INT 16H
              CMP AL, 0DH
              JNE KeyBoard
              CALL DWORD shell
              JMP KeyBoard
