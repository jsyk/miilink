
/* Standard includes. */
#include <string.h>

/* Scheduler includes. */
#include "FreeRTOS.h"
#include "task.h"
#include "queue.h"
#include "timers.h"

/* Library includes. */
#include "stm32f10x_it.h"

/* Driver includes. */
#include "STM32_USART.h"
#include "eth.h"

/* ETHERNET errors */
#define  ETH_ERROR              ((uint32_t)0)
#define  ETH_SUCCESS            ((uint32_t)1)

/* The time between cycles of the 'check' task - which depends on whether the
check task has detected an error or not. */
#define mainCHECK_DELAY_NO_ERROR			( ( TickType_t ) 5000 / portTICK_PERIOD_MS )
#define mainCHECK_DELAY_ERROR				( ( TickType_t ) 500 / portTICK_PERIOD_MS )

/* The LED controlled by the 'check' task. */
#define mainCHECK_LED						( 3 )

/* Task priorities. */
#define mainSEM_TEST_PRIORITY				( tskIDLE_PRIORITY + 1 )
#define mainBLOCK_Q_PRIORITY				( tskIDLE_PRIORITY + 2 )
#define mainCHECK_TASK_PRIORITY				( tskIDLE_PRIORITY + 3 )
#define mainFLASH_TASK_PRIORITY				( tskIDLE_PRIORITY + 2 )
#define mainECHO_TASK_PRIORITY				( tskIDLE_PRIORITY + 1 )
#define mainINTEGER_TASK_PRIORITY           ( tskIDLE_PRIORITY )
#define mainGEN_QUEUE_TASK_PRIORITY			( tskIDLE_PRIORITY )

/* COM port and baud rate used by the echo task. */
#define mainCOM0							( 0 )
// #define mainBAUD_RATE                       ( 115200 )
#define mainBAUD_RATE						( 9600 )

/*-----------------------------------------------------------*/

#define RXTMPLEN        1024

u8 rxtmpbuf[RXTMPLEN];

volatile uint32_t current_tick = 0;

/*-----------------------------------------------------------*/

/*
 * Configure the hardware for the demo.
 */
static void prvSetupHardware( void );

void reconfigure_RCC_from_ref_clk();

/* The 'check' task as described at the top of this file. */
static void prvCheckTask( void *pvParameters );

/* A simple task that echoes all the characters that are received on COM0
(USART1). */
static void prvUSARTEchoTask( void *pvParameters );

void vTickTimerCallback(TimerHandle_t pxTimer);

/*-----------------------------------------------------------*/

int main( void )
{
#ifdef DEBUG
  debug();
#endif

	/* Set up the clocks and memory interface. */
	prvSetupHardware();

    TimerHandle_t tick_timer = xTimerCreate("timer", 10, pdTRUE, NULL, vTickTimerCallback);
    xTimerStart( tick_timer, 0 );

	/* Create the 'echo' task, which is also defined within this file. */
	xTaskCreate( prvUSARTEchoTask, "Echo", configMINIMAL_STACK_SIZE, NULL, mainECHO_TASK_PRIORITY, NULL );

	/* Create the 'check' task, which is also defined within this file. */
	// xTaskCreate( prvCheckTask, "Check", configMINIMAL_STACK_SIZE, NULL, mainCHECK_TASK_PRIORITY, NULL );

    /* Start the scheduler. */
	vTaskStartScheduler();

    /* Will only get here if there was insufficient memory to create the idle
    task.  The idle task is created within vTaskStartScheduler(). */
	for( ;; );
}

/*-----------------------------------------------------------*/

void vTickTimerCallback(TimerHandle_t pxTimer)
{
    ++current_tick;
}

/*-----------------------------------------------------------*/

void print_hex_u4(uint32_t x)
{
    static const char hexchar[16] = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f' };
    xSerialPutChar( mainCOM0, hexchar[x & 0x0F], 5 );
}

void print_hex_u8(uint32_t x)
{
    print_hex_u4(x >> 4);
    print_hex_u4(x);
}

void print_hex_u32(uint32_t x)
{
    for (int i = 0; i < 8; ++i) {
        int n = (x >> 28) & 0x0F;           // extract top 4 MSB
        print_hex_u4(n);
        x <<= 4;                            // shift left to prepare next nibble
    }
}

void print_u32(uint32_t x)
{
    char tmpbuf[12];
    /* special case */
    if (x == 0) {
        xSerialPutChar( mainCOM0, '0', 5 );
        return;
    }
    /* write digits */
    char *s = tmpbuf;
    while (x > 0) {
        *s++ = '0' + (x % 10);
        x = x / 10;
    }
    *s-- = '\0';
    /* reverse order */
    char *s1 = tmpbuf;
    while (s > s1) {
        char c = *s1;
        *s1++ = *s;
        *s-- = c;
    }
    /* print */
    lSerialPutString( mainCOM0, tmpbuf );
}

/*-----------------------------------------------------------*/

/* Described at the top of this file. */
static void prvUSARTEchoTask( void *pvParameters )
{
    signed char cChar;
    int pa15 = 0;

    int tx_frame_length = 128;

    /* String declared static to ensure it does not end up on the stack, no matter
    what the optimisation level. */
    static const char *pcLongishString =
        "\r\nSTM32-ETH Test\r\nPress [i] to initialize RMII, [s] to send, [q] to query state.\r\n"
        "[r] to restart seq numbers\r\n";

	/* Just to avoid compiler warnings. */
	( void ) pvParameters;

	/* Initialise COM0, which is USART1 according to the STM32 libraries. */
	lCOMPortInit( mainCOM0, mainBAUD_RATE );

	/* Try sending out a string all in one go, as a very basic test of the
    lSerialPutStringN() function. */
    lSerialPutStringN( mainCOM0, pcLongishString, strlen( pcLongishString ) );

	for( ;; )
	{
		/* Block to wait for a character to be received on COM0. */
		if (xSerialGetChar( mainCOM0, &cChar, 1 ) == pdFAIL) {
            /* no character... */

            uint32_t rxsize = ETH_GetRxPktSize();
            if (rxsize > 0) {
                /* eth frame received! */
                rxsize = ETH_HandleRxPkt(rxtmpbuf);
                xSerialPutChar( mainCOM0, 'R', 5 );
                xSerialPutChar( mainCOM0, ':', 5 );
                print_hex_u32(rxsize);
                
                xSerialPutChar( mainCOM0, ' ', 0 );
                for (int i = 0; i < rxsize; ++i) {
                    print_hex_u8(rxtmpbuf[i]);
                    xSerialPutChar( mainCOM0, ':', 0 );
                }
                xSerialPutChar( mainCOM0, '\r', 5 );
                xSerialPutChar( mainCOM0, '\n', 5 );

                uint8_t rx_seqnum = rxtmpbuf[14];
                uint8_t rx_acknum = rxtmpbuf[15];

                lSerialPutString(mainCOM0, "rx_seqnum = 0x"); print_hex_u8(rx_seqnum);
                lSerialPutString(mainCOM0, ", rx_acknum = 0x"); print_hex_u8(rx_acknum);
                lSerialPutString(mainCOM0, "\r\n");
                
                uint8_t d = (rx_seqnum - acked_input_seqnum);
                if ((d > 0) && (d < 16)) {
                    acked_input_seqnum = rx_seqnum;
                    lSerialPutString(mainCOM0, "   Accepted new highest acknum = 0x");
                    print_hex_u8(acked_input_seqnum);
                    lSerialPutString(mainCOM0, "\r\n");
                }
            }

            continue;
        }

        // pa15 = ~pa15;
        // GPIO_WriteBit(GPIOA, GPIO_Pin_15, pa15);

        /* Write the received character back to COM0. */
        xSerialPutChar( mainCOM0, '[', 0 );
        xSerialPutChar( mainCOM0, cChar, 0 );
        xSerialPutChar( mainCOM0, ']', 0 );

        switch (cChar) {
            case 'i': {
                reconfigure_RCC_from_ref_clk();
                xSerialPutChar( mainCOM0, '.', 0 );     // OK
                uint32_t res = init_eth();
                if (res) {
                    xSerialPutChar( mainCOM0, 'S', 0 );     // OK
                    /* use external ref_clk 50MHz for PLL source */
                } else {
                    xSerialPutChar( mainCOM0, 'E', 0 );
                }
                break;
            } 
            case 's': {
                lSerialPutString(mainCOM0, "tx_seqnum = 0x"); print_hex_u8(next_output_seqnum);
                lSerialPutString(mainCOM0, ", tx_acknum = 0x"); print_hex_u8(acked_input_seqnum);
                lSerialPutString(mainCOM0, "\r\n");

                uint32_t res = send_something_eth(tx_frame_length);
                if (res) {
                    xSerialPutChar( mainCOM0, 'S', 0 );     // OK
                } else {
                    xSerialPutChar( mainCOM0, 'E', 0 );
                }
                break;
            }
            case 'r': {         /* restart sequence numbers */
                reset_protocol();
                xSerialPutChar( mainCOM0, 'S', 0 );     // OK
                break;
            }
            case '+': {
                tx_frame_length = 2*tx_frame_length;
                if (tx_frame_length > 1500) {
                    tx_frame_length = 1500;
                }
                lSerialPutString(mainCOM0, "Tx frame len = "); print_u32(tx_frame_length);
                lSerialPutString(mainCOM0, "\r\n");
                break;
            }
            case '-': {
                tx_frame_length = tx_frame_length / 2;
                if (tx_frame_length < 64) {
                    tx_frame_length = 64;
                }
                lSerialPutString(mainCOM0, "Tx frame len = "); print_u32(tx_frame_length);
                lSerialPutString(mainCOM0, "\r\n");
                break;
            }
            case 'b': {         /* bandwidth test */
                int frames_sent = 0;
                int frames_received = 0;
                uint32_t start_tick = current_tick;
                uint32_t start_eth_irqs_handled = eth_irqs_handled;

                // ETH_DMAITConfig(ETH_DMA_IT_R | ETH_DMA_IT_T, ENABLE);

                while (1) {
                    /* try sending a frame */
                    if (ETH_HandleTxPkt(rxtmpbuf, tx_frame_length) == ETH_SUCCESS) {
                        /* packet send success */
                        ++frames_sent;
                    }
                    /* try receiving a frame */
                    if (ETH_GetRxPktSize() > 0) {
                        /* eth frame received! */
                        int32_t rxsize = ETH_HandleRxPkt(rxtmpbuf);
                        ++frames_received;
                    }
                    if (xSerialGetChar( mainCOM0, &cChar, 0 ) != pdFAIL) {
                        break;
                    }
                }
                uint32_t end_tick = current_tick;

                lSerialPutString(mainCOM0, "Sent frames = "); print_u32(frames_sent);
                lSerialPutString(mainCOM0, "\r\nReceived frames = "); print_u32(frames_received);
                lSerialPutString(mainCOM0, "\r\nTicks = "); print_u32(end_tick - start_tick);
                lSerialPutString(mainCOM0, "\r\nETH IRQs = "); print_u32(eth_irqs_handled - start_eth_irqs_handled);
                lSerialPutString(mainCOM0, "\r\n");
                break;
            }
            case 'l': {         /* latency test */
                int frames_sent = 0;
                int frames_received = 0;
                uint32_t start_tick = current_tick;
                uint32_t start_eth_irqs_handled = eth_irqs_handled;
                int next_round = 1;
                GPIO_ResetBits(GPIOA, GPIO_Pin_15);

                while (next_round) {
                    GPIO_SetBits(GPIOA, GPIO_Pin_15);
                    
                    /* send a frame - wait until it is done */
                    while (ETH_HandleTxPkt(rxtmpbuf, tx_frame_length) != ETH_SUCCESS) {
                        /* packet send no success */
                        // if (xSerialGetChar( mainCOM0, &cChar, 0 ) != pdFAIL) {
                        //     next_round = 0;
                        //     break;
                        // }
                    }

                    if (!next_round) break;

                    ++frames_sent;

                    /* receive a frame */
                    while (ETH_GetRxPktSize() == 0) {
                        /* no frame recieved yet */
                        // if (xSerialGetChar( mainCOM0, &cChar, 0 ) != pdFAIL) {
                        //     next_round = 0;
                        //     break;
                        // }
                    }

                    if (!next_round) break;

                    /* eth frame received! */
                    int32_t rxsize = ETH_HandleRxPkt(rxtmpbuf);
                    GPIO_ResetBits(GPIOA, GPIO_Pin_15);

                    if (xSerialGetChar( mainCOM0, &cChar, 0 ) != pdFAIL) {
                        next_round = 0;
                        break;
                    }
                    ++frames_received;
                    vTaskDelay(1);
                }
                uint32_t end_tick = current_tick;
                GPIO_ResetBits(GPIOA, GPIO_Pin_15);

                lSerialPutString(mainCOM0, "Sent frames = "); print_u32(frames_sent);
                lSerialPutString(mainCOM0, "\r\nReceived frames = "); print_u32(frames_received);
                lSerialPutString(mainCOM0, "\r\nTicks = "); print_u32(end_tick - start_tick);
                lSerialPutString(mainCOM0, "\r\n");
                break;
            }
            case 'q': {
                for (int ib = 0; ib < ETH_TXBUFNB; ++ib) {
                    print_hex_u32(DMATxDscrTab[ib].Status);
                    xSerialPutChar( mainCOM0, ';', 0 );
                }
                break;
            }
        }

        xSerialPutChar( mainCOM0, ' ', 0 );
	}
}
/*-----------------------------------------------------------*/

static void prvSetupHardware( void )
{
    GPIO_InitTypeDef GPIO_InitStruct;

    SystemInit();

	/* RCC system reset (for debug purpose). */
    /* System clock = 8MHz from HSI, no PLL */
	RCC_DeInit ();

 //    /* Enable HSE. */
	// RCC_HSEConfig( RCC_HSE_ON );

	// /* Wait till HSE is ready. */
	// while (RCC_GetFlagStatus(RCC_FLAG_HSERDY) == RESET);

    /* HCLK = SYSCLK. */
	RCC_HCLKConfig( RCC_SYSCLK_Div1 );

    /* PCLK2  = HCLK. */
	RCC_PCLK2Config( RCC_HCLK_Div1 );

    /* PCLK1  = HCLK. */
	RCC_PCLK1Config( RCC_HCLK_Div1 );

	// /* ADCCLK = PCLK2/4. */
	// RCC_ADCCLKConfig( RCC_PCLK2_Div4 );

    /* Flash 1 wait state. */
	// *( volatile unsigned long  * )0x40022000 = 0x01;
    FLASH_SetLatency(FLASH_Latency_1);          /* 1T when 24MHz < SYSCLK <= 48MHz */

	// /* PLLCLK = 8MHz * 9 = 72 MHz */
 //    // RCC_PLLConfig( RCC_PLLSource_HSE_Div1, RCC_PLLMul_9 );   //orig
    RCC_PLLConfig( RCC_PLLSource_HSI_Div2, RCC_PLLMul_9 );     // 8/2 * 9 = 36 MHz
	// RCC_PLLConfig( RCC_PLLSource_PREDIV1, RCC_PLLMul_9 );     // 8 * 9 = 72 MHz

    /* Enable PLL. */
	RCC_PLLCmd( ENABLE );

	/* Wait till PLL is ready. */
	while (RCC_GetFlagStatus(RCC_FLAG_PLLRDY) == RESET);

	/* Select PLL as system clock source. */
	RCC_SYSCLKConfig (RCC_SYSCLKSource_PLLCLK);

	/* Wait till PLL is used as system clock source. */
	while (RCC_GetSYSCLKSource() != 0x08)
        ;

	/* Enable GPIOA, GPIOB, GPIOC, GPIOD, GPIOE and AFIO clocks */
	RCC_APB2PeriphClockCmd(	RCC_APB2Periph_GPIOA | RCC_APB2Periph_GPIOB |RCC_APB2Periph_GPIOC
							| RCC_APB2Periph_GPIOD | RCC_APB2Periph_GPIOE | RCC_APB2Periph_AFIO, ENABLE );

	/* Set the Vector Table base address at 0x08000000. */
	NVIC_SetVectorTable( NVIC_VectTab_FLASH, 0x0 );

	NVIC_PriorityGroupConfig( NVIC_PriorityGroup_4 );

	/* Configure HCLK clock as SysTick clock source. */
	SysTick_CLKSourceConfig( SysTick_CLKSource_HCLK );

	/* Initialise the IO used for the LED outputs. */
	// vParTestInitialise();

	/* SPI2 Periph clock enable */
	// RCC_APB1PeriphClockCmd( RCC_APB1Periph_SPI2, ENABLE );

    /* enable clock to MAC */
    RCC_AHBPeriphClockCmd(RCC_AHBPeriph_ETH_MAC | RCC_AHBPeriph_ETH_MAC_Tx | RCC_AHBPeriph_ETH_MAC_Rx, ENABLE);

    /* Disable JTAG, but leave SW-DP enabled */
    GPIO_PinRemapConfig(GPIO_Remap_SWJ_JTAGDisable, ENABLE);

    /** ETH_RMII GPIO Configuration  
    XX PC1   ------> ETH_RMII_MDC
    PA1   ------> ETH_RMII_REF_CLK
    XX PA2   ------> ETH_RMII_MDIO
    PA7   ------> ETH_RMII_CRS_DV
    PC4   ------> ETH_RMII_RXD0
    PC5   ------> ETH_RMII_RXD1
    PB11   ------> ETH_RMII_TX_EN
    PB12   ------> ETH_RMII_TXD0
    PB13   ------> ETH_RMII_TXD1
    */

    /*Configure GPIO pin : PC */
    GPIO_InitStruct.GPIO_Pin = GPIO_Pin_4|GPIO_Pin_5;
    GPIO_InitStruct.GPIO_Speed = GPIO_Speed_50MHz;
    GPIO_InitStruct.GPIO_Mode = GPIO_Mode_IPD;
    GPIO_Init(GPIOC, &GPIO_InitStruct);

    /*Configure GPIO pin : PA */
    GPIO_InitStruct.GPIO_Pin = GPIO_Pin_1|GPIO_Pin_7;
    GPIO_InitStruct.GPIO_Speed = GPIO_Speed_50MHz;
    GPIO_InitStruct.GPIO_Mode = GPIO_Mode_IPD;
    GPIO_Init(GPIOA, &GPIO_InitStruct);

    /*Configure GPIO pin : PA */
    GPIO_InitStruct.GPIO_Pin = GPIO_Pin_15;
    GPIO_InitStruct.GPIO_Speed = GPIO_Speed_50MHz;
    GPIO_InitStruct.GPIO_Mode = GPIO_Mode_Out_PP;
    GPIO_Init(GPIOA, &GPIO_InitStruct);
    GPIO_ResetBits(GPIOA, GPIO_Pin_15);

    /*Configure GPIO pin : PB */
    GPIO_InitStruct.GPIO_Pin = GPIO_Pin_11;
    GPIO_InitStruct.GPIO_Speed = GPIO_Speed_50MHz;
    GPIO_InitStruct.GPIO_Mode = GPIO_Mode_AF_PP;
    GPIO_Init(GPIOB, &GPIO_InitStruct);

    GPIO_InitStruct.GPIO_Pin = GPIO_Pin_12 | GPIO_Pin_13;
    GPIO_InitStruct.GPIO_Speed = GPIO_Speed_50MHz;
    GPIO_InitStruct.GPIO_Mode = GPIO_Mode_AF_PP;
    GPIO_Init(GPIOB, &GPIO_InitStruct);
}


void reconfigure_RCC_from_ref_clk()
{
    /* Select HSI 8MHz as system clock source. */
    RCC_SYSCLKConfig (RCC_SYSCLKSource_HSI);

    /* Wait till HSI is used as system clock source. */
    while (RCC_GetSYSCLKSource() != 0x00)
        ;

    /* Disable PLL. */
    RCC_PLLCmd( DISABLE );

    /* Enable HSE. */
    RCC_HSEConfig( RCC_HSE_ON );

    /* Wait till HSE is ready. */
    while (RCC_GetFlagStatus(RCC_FLAG_HSERDY) == RESET)
        ;

    /* HCLK = SYSCLK. */
    RCC_HCLKConfig( RCC_SYSCLK_Div1 );

    /* PCLK2  = HCLK/2. */
    RCC_PCLK2Config( RCC_HCLK_Div2 );

    /* PCLK1  = HCLK/2. */
    RCC_PCLK1Config( RCC_HCLK_Div2 );

    /* ADCCLK = PCLK2/8. */
    RCC_ADCCLKConfig( RCC_PCLK2_Div8 );

    /* Flash 2 wait state. */
    FLASH_SetLatency(FLASH_Latency_2);          /* 1T when 48MHz < SYSCLK <= 72MHz */

    /* PLL */
    RCC_PREDIV1Config(RCC_PREDIV1_Source_HSE, RCC_PREDIV1_Div5);
    RCC_PLLConfig( RCC_PLLSource_PREDIV1, RCC_PLLMul_7 );     // 50 / 10 * 7 = 70 MHz

    /* Enable PLL. */
    RCC_PLLCmd( ENABLE );

    /* Wait till PLL is ready. */
    while (RCC_GetFlagStatus(RCC_FLAG_PLLRDY) == RESET)
        ;

    /* Select PLL as system clock source. */
    RCC_SYSCLKConfig (RCC_SYSCLKSource_PLLCLK);

    /* Wait till PLL is used as system clock source. */
    while (RCC_GetSYSCLKSource() != 0x08)
        ;

    /* reconfigure USART */
    // USART_InitTypeDef USART_InitStructure;
    // /* The common (not port dependent) part of the initialisation. */
    // USART_InitStructure.USART_BaudRate = mainBAUD_RATE;
    // USART_InitStructure.USART_WordLength = USART_WordLength_8b;
    // USART_InitStructure.USART_StopBits = USART_StopBits_1;
    // USART_InitStructure.USART_Parity = USART_Parity_No;
    // USART_InitStructure.USART_HardwareFlowControl = USART_HardwareFlowControl_None;
    // USART_InitStructure.USART_Mode = USART_Mode_Rx | USART_Mode_Tx;

    USART_Cmd(USART1, DISABLE);
    // USART_Init( USART1, &USART_InitStructure );
    // USART_Cmd(USART1, ENABLE);

    /* Initialise COM0, which is USART1 according to the STM32 libraries. */
    lCOMPortInit( mainCOM0, mainBAUD_RATE );
}

/*-----------------------------------------------------------*/


void vApplicationStackOverflowHook( TaskHandle_t pxTask, char *pcTaskName )
{
	/* This function will get called if a task overflows its stack.   If the
	parameters are corrupt then inspect pxCurrentTCB to find which was the
	offending task. */

	( void ) pxTask;
	( void ) pcTaskName;

	for( ;; );
}
/*-----------------------------------------------------------*/

void assert_failed( unsigned char *pucFile, unsigned long ulLine )
{
	( void ) pucFile;
	( void ) ulLine;

	for( ;; );
}

