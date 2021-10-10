/* Using C language expansion kernel
 * if you have any problem,contact me at djh113@126.com
 * or visit my homepage at https://github.com/djh-sudo
*/
#include "stringio.h"
#define BUF_LEN 32
extern void clearScreen();
extern void poweroff();
extern void systime();
extern void drawPic();
extern void getDate();
// start menu
void startUp(){
	clearScreen();
	char* title = "TinyOS Oerating System version 1.0";
	char* subTitle = "Designed by DJH-sudo";
	char* copyRight = "Coypleft by GNU";
	char* hint = "System is ready.Press ENTER\r\n";
	
	printInPos(title,strlen(title),5,23);
	printInPos(subTitle,strlen(subTitle),6,23);
	printInPos(copyRight,strlen(copyRight),8,23);
	printInPos(hint,strlen(hint),15,23);
}

//print shell
void promptString(){
	char*p_string = "TinyOS v1#>";
	print(p_string);
}

// help me
void showHelp(){
	char * help = "shell for OS version 1.1 x86 PC\r\n"
	"This is the shell command!\r\n"
	"Use `help` to see the list \r\n"
	"\r\n"
	"\rcls - clear the ternimal \r\n"
	"\rtime - get current time \r\n"
	"\rdrawpic - draw a animate pic \r\n"
	"\rpoweroff - force the OS shut down"
	"\r\n";
	print(help);
}

void shell(){
	clearScreen();
	showHelp();
	char cmdStr[BUF_LEN + 1] = {0};
	char cmdFirstWord[BUF_LEN + 1] = {0};
	enum{help,clear,time,power_off,date};
	char*command[] = {"help","cls","time","poweroff","date"};
	while(1){
		promptString();
		read2Buf(cmdStr,BUF_LEN);
		getFirstWord(cmdStr,cmdFirstWord);
		if(strcmp(cmdFirstWord,command[clear]) == 0){
			clearScreen();
		}
		else if(strcmp(cmdFirstWord,command[help]) == 0){
			showHelp();
		}
		else if(strcmp(cmdFirstWord,command[power_off]) == 0){
        	poweroff();
		}
		else if(strcmp(cmdFirstWord,command[time]) == 0){
			systime();
		}
		else if(strcmp(cmdFirstWord,command[date]) == 0){
			getDate();
		}
		else{
			if(cmdFirstWord[0] != 0){
				char*errMsg = ": command not dound\r\n";
				print(cmdFirstWord);
				print(errMsg);
			}
		}
	}
}







