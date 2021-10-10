/* Using C language expansion kernel
 * if you have any problem,contact me at djh113@126.com
 * or visit my homepage at https://github.com/djh-sudo
*/
#include "stringio.h"
#define BUF_LEN 32

// start menu
void startUp(){
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
	"Use `help` to see the list \r\n"
	"\r\n"
	"clc - clear the ternimal \r\n"
	"time - get current time \r\n"
	"drawpic - draw a animate pic \r\n"
	"power off - force the OS shut down"
	"\r\n";
	print(help);
}

void shell(){
	showHelp();
}
