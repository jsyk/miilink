#include "eth.h"

/* Scheduler includes. */
#include "FreeRTOS.h"
#include "task.h"
#include "queue.h"
#include "STM32_USART.h"

#define mainCOM0                            ( 0 )

ETH_InitTypeDef ETH_InitStructure;

/* Ethernet Rx & Tx DMA Descriptors */
ETH_DMADESCTypeDef  DMARxDscrTab[ETH_RXBUFNB], DMATxDscrTab[ETH_TXBUFNB];

/* Ethernet buffers */
u8 Rx_Buff[ETH_RXBUFNB][ETH_MAX_PACKET_SIZE];
u8 Tx_Buff[ETH_TXBUFNB][ETH_MAX_PACKET_SIZE]; 


// #define TMPLEN      128
#define TMPLEN      1520

u8 tmpbuf[2*TMPLEN];

/* our next seqnum on output frame */
uint8_t next_output_seqnum = 0x01;
/* the highest input seqnum that we ack */
uint8_t acked_input_seqnum = 0x80;

/* abs frame number - to check correct transfer */
uint32_t absolute_frame_num = 0;

/* number of handled ETH IRQs */
volatile uint32_t eth_irqs_handled = 0;


/*-----------------------------------------------------------*/

uint32_t init_eth()
{
    // GPIO_PinRemapConfig(GPIO_Remap_ETH, ENABLE); 

    GPIO_ETH_MediaInterfaceConfig(GPIO_ETH_MediaInterface_RMII);


    /* Reset ETHERNET on AHB Bus */
    ETH_DeInit();

    /* Software reset */ 
    ETH_SoftwareReset();

    lSerialPutString(mainCOM0, "init_eth: waiting for sw reset...");

    /* Wait for software reset */
    while(ETH_GetSoftwareResetStatus()==SET);

    lSerialPutString(mainCOM0, "done\r\n");

    /* ETHERNET Configuration ------------------------------------------------------*/
    /* Call ETH_StructInit if you don't like to configure all ETH_InitStructure parameter */
    ETH_StructInit(&ETH_InitStructure);

    /* Fill ETH_InitStructure parametrs */
    /*------------------------   MAC   -----------------------------------*/
    // ETH_InitStructure.ETH_AutoNegotiation = ETH_AutoNegotiation_Enable  ;  
    // ETH_InitStructure.ETH_InterFrameGap = ETH_InterFrameGap_40Bit;
    ETH_InitStructure.ETH_CarrierSense = ETH_CarrierSense_Disable;
    ETH_InitStructure.ETH_Watchdog = ETH_Watchdog_Disable;
    ETH_InitStructure.ETH_Jabber = ETH_Jabber_Disable;
    // ETH_InitStructure.ETH_JumboFrame = ETH_JumboFrame_Disable;
    ETH_InitStructure.ETH_Speed = ETH_Speed_100M;                                      
    ETH_InitStructure.ETH_LoopbackMode = ETH_LoopbackMode_Disable;              
    ETH_InitStructure.ETH_Mode = ETH_Mode_FullDuplex;                                                                                  
    ETH_InitStructure.ETH_RetryTransmission = ETH_RetryTransmission_Disable;                                                                                  
    ETH_InitStructure.ETH_AutomaticPadCRCStrip = ETH_AutomaticPadCRCStrip_Disable;                                                                                                                                                                        
    ETH_InitStructure.ETH_ReceiveAll = ETH_ReceiveAll_Enable;                                                                                                       
    ETH_InitStructure.ETH_BroadcastFramesReception = ETH_BroadcastFramesReception_Enable;      
    ETH_InitStructure.ETH_PromiscuousMode = ETH_PromiscuousMode_Enable;
    ETH_InitStructure.ETH_MulticastFramesFilter = ETH_MulticastFramesFilter_Perfect;      
    ETH_InitStructure.ETH_UnicastFramesFilter = ETH_UnicastFramesFilter_Perfect;                        

    ETH_InitStructure.ETH_ReceiveStoreForward = ETH_ReceiveStoreForward_Disable;
    ETH_InitStructure.ETH_TransmitStoreForward = ETH_TransmitStoreForward_Disable;
    ETH_InitStructure.ETH_TransmitThresholdControl = ETH_TransmitThresholdControl_16Bytes;
    ETH_InitStructure.ETH_ReceiveThresholdControl = ETH_ReceiveThresholdControl_32Bytes;
    ETH_InitStructure.ETH_SecondFrameOperate = ETH_SecondFrameOperate_Enable;
    

    lSerialPutString(mainCOM0, "init_eth: waiting for ETH_Init...");
    /* Configure ETHERNET */
    uint32_t result = ETH_Init(&ETH_InitStructure, PHY_ADDRESS);
    lSerialPutString(mainCOM0, "done\r\n");

    lSerialPutString(mainCOM0, "init_eth: waiting for DMA Init...");
    /* Initialize Tx Descriptors list: Chain Mode */
    ETH_DMATxDescChainInit(DMATxDscrTab, &Tx_Buff[0][0], ETH_TXBUFNB);

    /* Initialize Rx Descriptors list: Chain Mode  */
    ETH_DMARxDescChainInit(DMARxDscrTab, &Rx_Buff[0][0], ETH_RXBUFNB);

    lSerialPutString(mainCOM0, "done\r\n");
    lSerialPutString(mainCOM0, "init_eth: waiting for ETH_Start...");

    /* Enable MAC and DMA transmission and reception */
    ETH_Start();  

    lSerialPutString(mainCOM0, "done\r\n");

    return result;
}

int send_something_eth(int length)
{
    for (int i = 0; i < TMPLEN; ++i) {
        tmpbuf[i] = i;
    }
    
    // [0-5] Dest MAC - Broadcast, all 1's
    // for (int i = 0; i < 6; ++i) {
    //     tmpbuf[i] = 0xFF;
    // }

    // *(uint32_t*)(tmpbuf+8) = absolute_frame_num++;

    // [12-13] = EtherType / Length of payload
    // tmpbuf[12] = 0;
    // tmpbuf[13] = TMPLEN - 14;

    // myseqnum
    tmpbuf[14] = next_output_seqnum++;
    // ackseqnum
    tmpbuf[15] = acked_input_seqnum;


    uint32_t res = ETH_HandleTxPkt(tmpbuf, length);

    return res;
}

void reset_protocol()
{
    next_output_seqnum = 0x01;
    acked_input_seqnum = 0x80;
}

void ETH_IRQHandler()
{
    ++eth_irqs_handled;
}

