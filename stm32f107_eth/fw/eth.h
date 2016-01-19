#ifndef ETH_H
#define ETH_H

#include "stm32f10x_conf.h"

/*-----------------------------------------------------------*/

#define PHY_ADDRESS       0x01 /* Relative to STM3210C-EVAL Board */
// #define MII_MODE          /* MII mode for STM3210C-EVAL Board (MB784) (check jumpers setting) */
#define RMII_MODE       /* RMII mode for STM3210C-EVAL Board (MB784) (check jumpers setting) */

#define ETH_RXBUFNB        4
#define ETH_TXBUFNB        4 

extern ETH_InitTypeDef ETH_InitStructure;

/* Ethernet Rx & Tx DMA Descriptors */
extern ETH_DMADESCTypeDef  DMARxDscrTab[ETH_RXBUFNB], DMATxDscrTab[ETH_TXBUFNB];

/* Ethernet buffers */
extern u8 Rx_Buff[ETH_RXBUFNB][ETH_MAX_PACKET_SIZE], Tx_Buff[ETH_TXBUFNB][ETH_MAX_PACKET_SIZE]; 


/* our next seqnum on output frame */
extern uint8_t next_output_seqnum;
/* the highest input seqnum that we ack */
extern uint8_t acked_input_seqnum;

/* abs frame number - to check correct transfer */
extern uint32_t absolute_frame_num;

/* number of handled ETH IRQs */
extern volatile uint32_t eth_irqs_handled;

/*-----------------------------------------------------------*/

uint32_t init_eth();

int send_something_eth(int length);

void reset_protocol();

#endif
