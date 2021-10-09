LED0 		EQU 	0x422101a0 
RCC_APB2ENR 	EQU 	0x40021018
GPIOA_CRH 	EQU 	0x40010804
Stack_Size      EQU     0x00000400
; EQU 伪指令把一个符号名称与一个整数表达式或一个任意文本连接起来，它有 3 种格式：name EQU expression     name EQU symbol    name EQU <text>	 
; 符号常量不占用内存，类似于c的宏

                AREA    STACK, NOINIT, READWRITE, ALIGN=3
Stack_Mem       SPACE   Stack_Size
__initial_sp

;AREA伪指令用于定义一个代码段或数据段。段名若以数字开头则该段名需用“|”括起来 
;AREA 段名 属性1 ，属性2 ，……  
;	CODE 		属性：用于定义代码段，默认为READONLY     
;	DATA 		属性：用于定义数据段，默认为READWRITE     
;	READONLY 	属性：指定本段为只读，代码段默认为READONLY     
;	READWRITE 	属性：指定本段为可读可写，数据段的默认属性为READWRITE     
;	ALIGN 		属性：代码段和数据段是按字对齐的，表达式的取值范围为0～31，相应的对齐方式为2表达式次方。
;	NOINIT		指定此数据段仅仅保留了内存单元，而没有将各初始值写入内存单元，或者将各个内存单元值初始化为0
;SPACE  申请一片内存空间 不赋初值


                AREA    RESET, DATA, READONLY

__Vectors       DCD     __initial_sp               ; Top of Stack
                DCD     Reset_Handler              ; Reset Handler
                DCD     NMI_Handler               ; NMI Handler
                DCD     HardFault_Handler         ; Hard Fault Handler                    
                    
                AREA    |.text|, CODE, READONLY
                    
                THUMB
                REQUIRE8
                PRESERVE8

;. text 表示代码段
;DCD ：一般用于分配一个或者多个字的内存，分配的内存是四字节对齐的，同时可完成已分配存储单元的初始化
;标号 DCD  表达式    其中表达式可以为程序标号或数字表达式
;ENTRY伪指令用于指定汇编程序的入口点。在一个完整的汇编程序中至少要有一个ENTRY 

                ENTRY
Reset_Handler 
                BL LED_Init
MainLoop        BL LED_ON
                BL Delay
                BL LED_OFF
                BL Delay
                
                B MainLoop
 
;MainLoop  标号是充当指令或数据位置标记的标识符  数据标号标识了变量的地址   代码标号通常用作跳转和循环指令的目标地址(可以省略)
;BL 连接跳转， 跳转时将下一条指令的地址存入LR寄存器中
;BL LED_Init   将下一条指令地址存入LR寄存器中，然后将LED_Init的地址放入PC中实现跳转

LED_Init
                PUSH {R0,R1, LR}
                
                LDR R0,=RCC_APB2ENR
                ORR R0,R0,#0x04
                LDR R1,=RCC_APB2ENR
                STR R0,[R1]
                
                LDR R0,=GPIOA_CRH
                BIC R0,R0,#0x0F
                LDR R1,=GPIOA_CRH
                STR R0,[R1]
                
                LDR R0,=GPIOA_CRH
                ORR R0,R0,#0x03
                LDR R1,=GPIOA_CRH
                STR R0,[R1]
                
                MOV R0,#1 
                LDR R1,=LED0
                STR R0,[R1]
             
                POP {R0,R1,PC} 		
;PUSH 入栈保存寄存器值   POP 出栈  恢复寄存器值   
;PUSH {R0,R1, LR}  保存R0,R1 寄存器值 因为子程序将用到R0 R1 ,保存LR连接寄存器的值,用于子程序返回
           
LED_ON
                PUSH {R0,R1, LR}    
                
                MOV R0,#0 
                LDR R1,=LED0
                STR R0,[R1]
             
                POP {R0,R1,PC}
			
;PUSH 入栈保存寄存器值   POP 出栈  恢复寄存器值   
;PUSH {R0,R1, LR}  保存R0,R1 寄存器值 因为子程序将用到R0 R1 ,保存LR连接寄存器的值,用于子程序返回          
LED_OFF
                PUSH {R0,R1, LR}    
                
                MOV R0,#1 
                LDR R1,=LED0
                STR R0,[R1]
             
                POP {R0,R1,PC}  
;PUSH 入栈保存寄存器值   POP 出栈  恢复寄存器值   
;PUSH {R0,R1, LR}  保存R0,R1 寄存器值 因为子程序将用到R0 R1 ,保存LR连接寄存器的值,用于子程序返回	 
 
Delay
                PUSH {R0,R1, LR}
                
                MOVS R0,#0
                MOVS R1,#0
                MOVS R2,#0
                
DelayLoop0        
                ADDS R0,R0,#1

                CMP R0,#330
                BCC DelayLoop0
                
                MOVS R0,#0
                ADDS R1,R1,#1
                CMP R1,#330
                BCC DelayLoop0

                MOVS R0,#0
                MOVS R1,#0
                ADDS R2,R2,#1
                CMP R2,#15
                BCC DelayLoop0
                
                
                POP {R0,R1,PC}
				
;LED_Init   	是代码标号 ，用作程序跳转				
;LED_ON   	是代码标号 ，用作程序跳转					
;LED_OFF   	是代码标号 ，用作程序跳转
;Delay   	是代码标号 ，用作程序跳转				
;DelayLoop0   	是代码标号 ，用作程序跳转					
       
NMI_Handler      PROC
                 EXPORT  NMI_Handler                [WEAK]
                 B       .
                 ENDP
HardFault_Handler\
				 PROC
                 EXPORT  HardFault_Handler                [WEAK]
                 B       .
                 ENDP

					
; PROC		: 是定义子程序的伪指令，位置在子程序的开始处，和ENDP分别表示子程序定义的开始和结束两者必须成对出现
; IMPORT	：翻译为进口或引入，表明要调用的函数为外部文件定义
; EXPORTt	：翻译为出口或输出，表明该符号可以被外部模块使用，类似于C中的extern功能
;  B   .    	: “.” 代表当前地址，B为无条件跳转,用于死循环
;[WEAK]     :一般来说这个关键字使用在IMPORT和EXPORT这两个声明段,EXPORT的函数带有WEAK标志，并且别的源代码没有定义同名函数，那么连接时就是该函数；否则，就是另外的一个同名函数.WEAK有掩盖函数的作用

;Default_Handler     为所有中断函数定义默认的中断入口
Default_Handler PROC
                EXPORT  IRQ000_Handler        [WEAK]
                EXPORT  IRQ001_Handler        [WEAK]
                EXPORT  IRQ002_Handler        [WEAK]
                EXPORT  IRQ003_Handler        [WEAK]
                EXPORT  IRQ004_Handler        [WEAK]
                EXPORT  IRQ005_Handler        [WEAK]
IRQ000_Handler
IRQ001_Handler
IRQ002_Handler
IRQ003_Handler
IRQ004_Handler
IRQ005_Handler

                B       .
                ENDP
		
		END
;ENDP    表示PROC所定义的过程结束. (end procedure)
;ENDS    表示SEGMENT定义的段结束.   (end segment)
;END     程序结束.	

