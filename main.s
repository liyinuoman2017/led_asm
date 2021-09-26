LED0 			EQU 	0x422101a0 
RCC_APB2ENR 	EQU 	0x40021018
GPIOA_CRH 		EQU 	0x40010804
Stack_Size      EQU     0x00000400
; EQU αָ���һ������������һ���������ʽ��һ�������ı��������������� 3 �ָ�ʽ��name EQU expression     name EQU symbol    name EQU <text>	 
; ���ų�����ռ���ڴ棬������c�ĺ�

                AREA    STACK, NOINIT, READWRITE, ALIGN=3
Stack_Mem       SPACE   Stack_Size
__initial_sp

;AREAαָ�����ڶ���һ������λ����ݶΡ������������ֿ�ͷ��ö������á�|�������� 
;AREA ���� ����1 ������2 ������  
;	CODE 		���ԣ����ڶ������Σ�Ĭ��ΪREADONLY     
;	DATA 		���ԣ����ڶ������ݶΣ�Ĭ��ΪREADWRITE     
;	READONLY 	���ԣ�ָ������Ϊֻ���������Ĭ��ΪREADONLY     
;	READWRITE 	���ԣ�ָ������Ϊ�ɶ���д�����ݶε�Ĭ������ΪREADWRITE     
;	ALIGN 		���ԣ�����κ����ݶ��ǰ��ֶ���ģ����ʽ��ȡֵ��ΧΪ0��31����Ӧ�Ķ��뷽ʽΪ2���ʽ�η���
;	NOINIT		ָ�������ݶν����������ڴ浥Ԫ����û�н�����ʼֵд���ڴ浥Ԫ�����߽������ڴ浥Ԫֵ��ʼ��Ϊ0
;SPACE  ����һƬ�ڴ�ռ� ������ֵ


                AREA    RESET, DATA, READONLY

__Vectors       DCD     __initial_sp               ; Top of Stack
                DCD     Reset_Handler              ; Reset Handler
                DCD     NMI_Handler               ; NMI Handler
                DCD     HardFault_Handler         ; Hard Fault Handler                    
                    
                AREA    |.text|, CODE, READONLY
                    
                THUMB
                REQUIRE8
                PRESERVE8

;. text ��ʾ�����
;DCD ��һ�����ڷ���һ�����߶���ֵ��ڴ棬������ڴ������ֽڶ���ģ�ͬʱ������ѷ���洢��Ԫ�ĳ�ʼ��
;��� DCD  ���ʽ    ���б��ʽ����Ϊ�����Ż����ֱ��ʽ
;ENTRYαָ������ָ�����������ڵ㡣��һ�������Ļ�����������Ҫ��һ��ENTRY 

                ENTRY
Reset_Handler 
                BL LED_Init
MainLoop        BL LED_ON
                BL Delay
                BL LED_OFF
                BL Delay
                
                B MainLoop
 
;MainLoop  ����ǳ䵱ָ�������λ�ñ�ǵı�ʶ��  ���ݱ�ű�ʶ�˱����ĵ�ַ   ������ͨ��������ת��ѭ��ָ���Ŀ���ַ(����ʡ��)
;BL ������ת�� ��תʱ����һ��ָ��ĵ�ַ����LR�Ĵ�����
;BL LED_Init   ����һ��ָ���ַ����LR�Ĵ����У�Ȼ��LED_Init�ĵ�ַ����PC��ʵ����ת

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
;PUSH ��ջ����Ĵ���ֵ   POP ��ջ  �ָ��Ĵ���ֵ   
;PUSH {R0,R1, LR}  ���� R0 �Ĵ���ֵ ��Ϊ���ӳ����õ�R0 R1  ����LR���ӼĴ�����ֵ  �����ӳ��򷵻�
           
LED_ON
                PUSH {R0,R1, LR}    
                
                MOV R0,#0 
                LDR R1,=LED0
                STR R0,[R1]
             
                POP {R0,R1,PC}
			
;PUSH ��ջ����Ĵ���ֵ   POP ��ջ  �ָ��Ĵ���ֵ   
;PUSH {R0,R1, LR}  ���� R0 �Ĵ���ֵ ��Ϊ���ӳ����õ�R0 R1  ����LR���ӼĴ�����ֵ  �����ӳ��򷵻�            
LED_OFF
                PUSH {R0,R1, LR}    
                
                MOV R0,#1 
                LDR R1,=LED0
                STR R0,[R1]
             
                POP {R0,R1,PC}  
;PUSH ��ջ����Ĵ���ֵ   POP ��ջ  �ָ��Ĵ���ֵ   
;PUSH {R0,R1, LR}  ���� R0 �Ĵ���ֵ ��Ϊ���ӳ����õ�R0 R1  ����LR���ӼĴ�����ֵ  �����ӳ��򷵻�	 
 
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
				
;LED_Init   �Ǵ����� ������������ת				
;LED_ON   �Ǵ����� ������������ת					
;LED_OFF   �Ǵ����� ������������ת
;Delay   �Ǵ����� ������������ת				
;DelayLoop0   �Ǵ����� ������������ת					
       
NMI_Handler      PROC
                 EXPORT  NMI_Handler                [WEAK]
                 B       .
                 ENDP
HardFault_Handler\
				 PROC
                 EXPORT  HardFault_Handler                [WEAK]
                 B       .
                 ENDP

					
; PROC		: �Ƕ����ӳ����αָ�λ�����ӳ���Ŀ�ʼ������ENDP�ֱ��ʾ�ӳ�����Ŀ�ʼ�ͽ������߱���ɶԳ���
; IMPORT	������Ϊ���ڻ����룬����Ҫ���õĺ���Ϊ�ⲿ�ļ�����
; EXPORTt	������Ϊ���ڻ�����������÷��ſ��Ա��ⲿģ��ʹ�ã�������C�е�extern����
;  B   .    : ��.�� ����ǰ��ַ��BΪ��������ת,������ѭ��
;[WEAK]     :һ����˵����ؼ���ʹ����IMPORT��EXPORT������������,EXPORT�ĺ�������WEAK��־�����ұ��Դ����û�ж���ͬ����������ô����ʱ���Ǹú��������򣬾��������һ��ͬ������.WEAK���ڸǺ���������


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
;Default_Handler     Ϊ�����жϺ�������Ĭ�ϵ��ж����

				END
;ENDP    ��ʾPROC������Ĺ��̽���. (end procedure)
;ENDS    ��ʾSEGMENT����Ķν���.   (end segment)
;END     �������.	

