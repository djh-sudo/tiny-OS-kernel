# Day 6

这一章也会比较轻松，因为我们只是对`day5`完善，实现一些简单的功能。

这里我们将实现几个简单的函数，包括清屏、获取时间调用，以及`shell`提示符。

先看上层结构，这段`C`语言可谓再熟悉不过了。

```c
void shell(){
	clearScreen();
	showHelp();
	char cmdStr[BUF_LEN + 1] = {0};
	char cmdFirstWord[BUF_LEN + 1] = {0};
	enum{help,clear,time,power_off};
	char*command[] = {"help","cls","time","poweroff"};
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
		else{
			if(cmdFirstWord[0] != 0){
				char*errMsg = ": command not dound\r\n";
				print(cmdFirstWord);
				print(errMsg);
			}
		}
	}
}
```

但上面这些函数`poweroff()`，`systime()`，`clearScreen`的具体实现在`liba.asm`中，也就是依旧需要汇编语言的支持。

更确切地说，其实就是借助`BIOS`的各种中断调用、端口读写，完成我们的功能。

这里我们简单说明这几个函数的实现。

* `system`

  ```assembly
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
  					;... ... TODO
  ```

  这里我们使用端口读写，将时钟的小时`hour`两位数读到`AL`寄存器中，在分别显示。显示使用的是`BIOS`的`10H`中断。而后面的分钟`minute`和秒`second`是类似的，只需要修改一开始的`AL`的值即可，这些方法都可以去查询`X86`汇编手册。

关机和清屏的操作，比较简单，调用`BIOS`对应的系统调用即可，具体细节你可以参考源代码。

最后将`liba.asm`和`libc.c`拷贝至虚拟机中，重新编译。这里便能够看到脚本`com.sh`的优势，每次只需要重新执行即可。

执行`Makefile`中命令。

```makefile
make all
```

再次开机，可以发现，这些命令都能够使用了。

写到这里，我们基本在实模式下实现了一个简易版本的操作系统，系统还很小、很简陋，但这的确是操作系统的原型。

## [Day 7](OS/day7/day7.md)

