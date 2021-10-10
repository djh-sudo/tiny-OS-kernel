/*
* Realize some functions of C language string
* if you have any problem,contact me at djh113@126.com
* or visit my homepage at https://github.com/djh-sudo
*/ 
#include <stdint.h>

extern void printInPos(char*msg,uint16_t len,uint8_t row,uint8_t col); 	// Print content at the cursor
extern void putchar(char c);		// Output one character
extern char getch();				// Get keyboard input


// Calculate string length
uint16_t strlen(char *str){
	uint16_t count = 0;
	while(str[count++] != 0);
	return count - 1;
}

// Compare strings
uint8_t strcmp(char* str1,char* str2){
	int i = 0;
	while(1){
		if(str1[i] == 0 || str2[i] == 0)
			break;
		if(str1[i] != str2[i])
			break;
		i++;
	}
	return (str1[i] - str2[i]);
}

// Display characters at the cursor
void print(char*str){
	uint16_t len = strlen(str);
	for(int i = 0; i < len; i++){
		putchar(str[i]);
	}
}

// Get the first word of the string
void getFirstWord(char*str,char*buf){
	int i = 0;
	while(str[i] && str[i] != ' ' && str[i] != '\n'){
		buf[i] = str[i];
		i++;
	}
	buf[i] = 0;
}

// Read the string into the buffer
void read2Buf(char*buffer,uint16_t maxLen){
	int i = 0;
	while(1){
		char tempc = getch();// Read character by character
		if(!(tempc == 0x0D || tempc == '\b' || (tempc >= 32 && tempc <= 127))){
			continue;// Invaild symbol
		}
		if(i > 0 && i < maxLen - 1){
			if(tempc == 0x0D){// press enter stop!
				break;	
			}else if(tempc == '\b'){// back
				putchar('\b');
				putchar(' ');
				putchar('\b');
				i--;
			}else{// Valid characters
				 putchar(tempc);
				 buffer[i] = tempc;
				 i++;
			}
		}else if(i >= maxLen - 1){
			// Buffer exceeded
			if(tempc == '\b'){
				putchar('\b');
				putchar(' ');
				putchar('\b');
				i--;
			}else if(tempc == 0x0D){
				break;
			}
		}else if(i <= 0){
			if(tempc == 0x0D)
				break;
			else if(tempc != '\b'){
				putchar(tempc);
				buffer[i] = tempc;
				i++;
			}
		}
	}
	putchar('\r');
	putchar('\n');
	buffer[i] = 0;
}
