/*
    FreeRTOS V8.2.1 - Copyright (C) 2015 Real Time Engineers Ltd.
    All rights reserved

    VISIT http://www.FreeRTOS.org TO ENSURE YOU ARE USING THE LATEST VERSION.

    This file is part of the FreeRTOS distribution.

    FreeRTOS is free software; you can redistribute it and/or modify it under
    the terms of the GNU General Public License (version 2) as published by the
    Free Software Foundation >>!AND MODIFIED BY!<< the FreeRTOS exception.

    >>!   NOTE: The modification to the GPL is included to allow you to     !<<
    >>!   distribute a combined work that includes FreeRTOS without being   !<<
    >>!   obliged to provide the source code for proprietary components     !<<
    >>!   outside of the FreeRTOS kernel.                                   !<<

    FreeRTOS is distributed in the hope that it will be useful, but WITHOUT ANY
    WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
    FOR A PARTICULAR PURPOSE.  Full license text is available on the following
    link: http://www.freertos.org/a00114.html

    1 tab == 4 spaces!

    ***************************************************************************
     *                                                                       *
     *    Having a problem?  Start by reading the FAQ "My application does   *
     *    not run, what could be wrong?".  Have you defined configASSERT()?  *
     *                                                                       *
     *    http://www.FreeRTOS.org/FAQHelp.html                               *
     *                                                                       *
    ***************************************************************************

    ***************************************************************************
     *                                                                       *
     *    FreeRTOS provides completely free yet professionally developed,    *
     *    robust, strictly quality controlled, supported, and cross          *
     *    platform software that is more than just the market leader, it     *
     *    is the industry's de facto standard.                               *
     *                                                                       *
     *    Help yourself get started quickly while simultaneously helping     *
     *    to support the FreeRTOS project by purchasing a FreeRTOS           *
     *    tutorial book, reference manual, or both:                          *
     *    http://www.FreeRTOS.org/Documentation                              *
     *                                                                       *
    ***************************************************************************

    ***************************************************************************
     *                                                                       *
     *   Investing in training allows your team to be as productive as       *
     *   possible as early as possible, lowering your overall development    *
     *   cost, and enabling you to bring a more robust product to market     *
     *   earlier than would otherwise be possible.  Richard Barry is both    *
     *   the architect and key author of FreeRTOS, and so also the world's   *
     *   leading authority on what is the world's most popular real time     *
     *   kernel for deeply embedded MCU designs.  Obtaining your training    *
     *   from Richard ensures your team will gain directly from his in-depth *
     *   product knowledge and years of usage experience.  Contact Real Time *
     *   Engineers Ltd to enquire about the FreeRTOS Masterclass, presented  *
     *   by Richard Barry:  http://www.FreeRTOS.org/contact
     *                                                                       *
    ***************************************************************************

    ***************************************************************************
     *                                                                       *
     *    You are receiving this top quality software for free.  Please play *
     *    fair and reciprocate by reporting any suspected issues and         *
     *    participating in the community forum:                              *
     *    http://www.FreeRTOS.org/support                                    *
     *                                                                       *
     *    Thank you!                                                         *
     *                                                                       *
    ***************************************************************************

    http://www.FreeRTOS.org - Documentation, books, training, latest versions,
    license and Real Time Engineers Ltd. contact details.

    http://www.FreeRTOS.org/plus - A selection of FreeRTOS ecosystem products,
    including FreeRTOS+Trace - an indispensable productivity tool, a DOS
    compatible FAT file system, and our tiny thread aware UDP/IP stack.

    http://www.FreeRTOS.org/labs - Where new FreeRTOS products go to incubate.
    Come and try FreeRTOS+TCP, our new open source TCP/IP stack for FreeRTOS.

    http://www.OpenRTOS.com - Real Time Engineers ltd license FreeRTOS to High
    Integrity Systems ltd. to sell under the OpenRTOS brand.  Low cost OpenRTOS
    licenses offer ticketed support, indemnification and commercial middleware.

    http://www.SafeRTOS.com - High Integrity Systems also provide a safety
    engineered and independently SIL3 certified version for use in safety and
    mission critical applications that require provable dependability.

    1 tab == 4 spaces!
*/

/* FreeRTOS includes. */
#include "FreeRTOS.h"
#include "task.h"
#include "queue.h"

/* Xilinx includes. */
#include "xil_printf.h"
#include "xgpio.h"
#include "xemaclite.h"
#include "xparameters.h"

/*-----------------------------------------------------------*/

/* The Tx and Rx tasks as described at the top of this file. */
static void prvTxTask( void *pvParameters );
static void prvRxTask( void *pvParameters );

int EmacLiteRecvFrame(u32 PayloadSize);
int EmacLiteSendFrame(XEmacLite *InstancePtr, u32 PayloadSize);

/*-----------------------------------------------------------*/

/* The queue used by the Tx and Rx tasks, as described at the top of this
file. */
static QueueHandle_t xQueue = NULL;
char HWstring[15] = "Hello World";


/*
 * The Size of the Test Frame.
 */
#define EMACLITE_TEST_FRAME_SIZE	1000

static u8 LocalAddress[XEL_MAC_ADDR_SIZE] =
{
	0x00, 0x01, 0x02, 0x03, 0x04, 0x05
};

static u8 RemoteAddress[XEL_MAC_ADDR_SIZE] =
{
	0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
};

static XGpio gpio_leds;
static XGpio gpio_btns;
static XEmacLite emac;

/*
 * Buffers used for Transmission and Reception of Packets. These are declared
 * as global so that they are not a part of the stack.
 */
u8 TxFrame[XEL_MAX_FRAME_SIZE];
u8 RxFrame[XEL_MAX_FRAME_SIZE];

volatile u32 RecvFrameLength;	/* Indicates the length of the Received packet
				 */
volatile int TransmitComplete;	/* Flag to indicate that the Transmission
				 * is complete
				 */



int main( void )
{
	xil_printf( "Hello from Freertos\r\n" );

	if (XGpio_Initialize(&gpio_leds, XPAR_GPIO_LEDS_DEVICE_ID) != XST_SUCCESS) {
		xil_printf( "ERR: Xgpio Leds init failed\r\n" );
	} else {
		XGpio_SetDataDirection(&gpio_leds, 1, 0xFFFFFF00);
	}

	if (XGpio_Initialize(&gpio_btns, XPAR_GPIO_BTNS_DEVICE_ID) != XST_SUCCESS) {
		xil_printf( "ERR: Xgpio Btns init failed\r\n" );
	} else {
		XGpio_SetDataDirection(&gpio_btns, 1, 0xFFFFFFFF);
	}

	if (XEmacLite_Initialize(&emac, XPAR_EMACLITE_0_DEVICE_ID) != XST_SUCCESS) {
		xil_printf( "ERR: emacline init failed\r\n" );
	}

	XEmacLite_SetMacAddress(&emac, LocalAddress);

	XEmacLite_FlushReceive(&emac);

	RecvFrameLength = 0;

	if (XEmacLite_TxBufferAvailable(&emac) != TRUE) {
		xil_printf( "ERR: Xemac TxBuffer not available\r\n" );
	}

//	XEmacLite_EnableLoopBack(&emac);
	XEmacLite_DisableLoopBack(&emac);



	/* Create the two tasks.  The Tx task is given a lower priority than the
	Rx task, so the Rx task will leave the Blocked state and pre-empt the Tx
	task as soon as the Tx task places an item in the queue. */
	xTaskCreate( 	prvTxTask, 					/* The function that implements the task. */
					( const char * ) "Tx", 		/* Text name for the task, provided to assist debugging only. */
					configMINIMAL_STACK_SIZE, 	/* The stack allocated to the task. */
					NULL, 						/* The task parameter is not used, so set to NULL. */
					tskIDLE_PRIORITY,			/* The task runs at the idle priority. */
					NULL );

	xTaskCreate( prvRxTask, ( const char * ) "GB",	configMINIMAL_STACK_SIZE, NULL,	tskIDLE_PRIORITY + 1, NULL );

	/* Create the queue used by the tasks.  The Rx task has a higher priority
	than the Tx task, so will preempt the Tx task and remove values from the
	queue as soon as the Tx task writes to the queue - therefore the queue can
	never have more than one item in it. */
	xQueue = xQueueCreate( 	1,						/* There is only one space in the queue. */
							sizeof( HWstring ) );	/* Each space in the queue is large enough to hold a uint32_t. */

	/* Check the queue was created. */
	configASSERT( xQueue );

	/* Start the tasks and timer running. */
	vTaskStartScheduler();

	/* If all is well, the scheduler will now be running, and the following line
	will never be reached.  If the following line does execute, then there was
	insufficient FreeRTOS heap memory available for the idle and/or timer tasks
	to be created.  See the memory management section on the FreeRTOS web site
	for more details. */
	for( ;; );
}


/*-----------------------------------------------------------*/
static void prvRxTask( void *pvParameters )
{
	char Recdstring[15] = "";
	int i;
	int Status;
	u32 prev_btns = 0;

	/* Print the received data. */
	xil_printf( "Rx task starting.\r\n");

	for( ;; )
	{
		RecvFrameLength = 0;

		/*
		 * Poll for receive packet.
		 */
		while ((volatile u32)RecvFrameLength == 0)  {

			vTaskDelay(1);
			u32 btns = XGpio_DiscreteRead(&gpio_btns, 1);
			if (btns != prev_btns) {
				xil_printf("btns=%d\r\n", btns);
				if (btns == 1) {
					/* send a frame */
					xil_printf( "Rx emac: sending a frame\r\n");
					Status = EmacLiteSendFrame(&emac, 128);
					if (Status != XST_SUCCESS) {
						xil_printf( "Rx emac: send frame fail\r\n");
					}
				}
				prev_btns = btns;
			}

			RecvFrameLength = XEmacLite_Recv(&emac,	(u8 *)RxFrame);
		}

		xil_printf( "Rx emac: frame recv, len=%d\r\n", RecvFrameLength);

		/*
		 * Check the received frame.
		 */
		Status = EmacLiteRecvFrame(128);
		if ((Status != XST_SUCCESS) && (Status != XST_NO_DATA)) {
			xil_printf( "Rx emac: frame rx check no success\r\n");
		}
		for (i = 0; i < RecvFrameLength; ++i) {
			xil_printf("%02x:", RxFrame[i]);
		}
		xil_printf("\r\n");
	}
}

/******************************************************************************/
/**
*
* This function receives a frame of given size. This function assumes interrupt
* mode, receives the frame and verifies its contents.
*
* @param	PayloadSize is the size of the frame to receive.
*		The size only reflects the payload size, it does not include the
*		Ethernet header size (14 bytes) nor the Ethernet CRC size (4
*		bytes).
*
* @return	XST_SUCCESS if successful, a driver-specific return code if not.
*
* @note		None.
*
******************************************************************************/
int EmacLiteRecvFrame(u32 PayloadSize)
{
	u8 *FramePtr;

	/*
	 * This assumes MAC does not strip padding or CRC.
	 */
	if (RecvFrameLength != 0) {
		int Index;

		/*
		 * Verify length, which should be the payload size.
		 */
		if ((RecvFrameLength- (XEL_HEADER_SIZE + XEL_FCS_SIZE)) !=
				PayloadSize) {
			return XST_LOOPBACK_ERROR;
		}

		/*
		 * Verify the contents of the Received Frame.
		 */
		FramePtr = (u8 *)RxFrame;
		FramePtr += XEL_HEADER_SIZE;	/* Get past the header */

		for (Index = 0; Index < PayloadSize; Index++) {
			if (*FramePtr++ != (u8)Index) {
				return XST_LOOPBACK_ERROR;
			}
		}
	}

	return XST_SUCCESS;
}

/******************************************************************************/
/**
*
* This function sends a frame of given size.
*
* @param	XEmacInstancePtr is a pointer to the XEmacLite instance.
* @param	PayloadSize is the size of the frame to create. The size only
*		reflects the payload size, it does not include the Ethernet
*		header size (14 bytes) nor the Ethernet CRC size (4 bytes).
*
* @return	XST_SUCCESS if successful, else a driver-specific return code.
*
* @note		None.
*
******************************************************************************/
int EmacLiteSendFrame(XEmacLite *InstancePtr, u32 PayloadSize)
{
	u8 *FramePtr;
	int Index;
	FramePtr = (u8 *)TxFrame;

	/*
	 * Set up the destination address as the local address for
	 * Phy Loopback.
	 */
	/*
	 * Fill in the valid Destination MAC address if
	 * the Loopback is not enabled.
	 */
	*FramePtr++ = RemoteAddress[0];
	*FramePtr++ = RemoteAddress[1];
	*FramePtr++ = RemoteAddress[2];
	*FramePtr++ = RemoteAddress[3];
	*FramePtr++ = RemoteAddress[4];
	*FramePtr++ = RemoteAddress[5];

	/*
	 * Fill in the source MAC address.
	 */
	*FramePtr++ = LocalAddress[0];
	*FramePtr++ = LocalAddress[1];
	*FramePtr++ = LocalAddress[2];
	*FramePtr++ = LocalAddress[3];
	*FramePtr++ = LocalAddress[4];
	*FramePtr++ = LocalAddress[5];

	/*
	 * Set up the type/length field - be sure its in network order.
	 */
    *((u16 *)FramePtr) = Xil_Htons(PayloadSize);
	FramePtr++;
	FramePtr++;

	/*
	 * Now fill in the data field with known values so we can verify them
	 * on receive.
	 */
	for (Index = 0; Index < PayloadSize; Index++) {
		*FramePtr++ = (u8)Index;
	}

	/*
	 * Now send the frame.
	 */
	return XEmacLite_Send(InstancePtr, (u8 *)TxFrame,
				PayloadSize + XEL_HEADER_SIZE);

}

/*-----------------------------------------------------------*/
static void prvTxTask( void *pvParameters )
{
	int cnt = 0;
	const TickType_t x1second = pdMS_TO_TICKS( 1000UL );

	for( ;; )
	{
		/* Delay for 1 second. */
		vTaskDelay( x1second );

		XGpio_DiscreteWrite(&gpio_leds, 1, ++cnt);

#if 0
		/* Send the next value on the queue.  The queue should always be
		empty at this point so a block time of 0 is used. */
		xQueueSend( xQueue,			/* The queue being written to. */
					HWstring, /* The address of the data being sent. */
					0UL );			/* The block time. */
#endif
	}
}

#if 0
/*-----------------------------------------------------------*/
static void prvRxTask( void *pvParameters )
{
	char Recdstring[15] = "";
	int cnt = 0;

	for( ;; )
	{
		/* Block to wait for data arriving on the queue. */
		xQueueReceive( 	xQueue,				/* The queue being read. */
						Recdstring,	/* Data is read into this address. */
						portMAX_DELAY );	/* Wait without a timeout for data. */

		/* Print the received data. */
		xil_printf( "Rx task received string from Tx task: %s\r\n", Recdstring );

		XGpio_DiscreteWrite(&gpio_leds, 1, ++cnt);
	}
}

#endif
