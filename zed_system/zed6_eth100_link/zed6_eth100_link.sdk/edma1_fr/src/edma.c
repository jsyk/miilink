#include "edma.h"
#include "xparameters.h"
#include "xil_printf.h"

volatile uint32_t *ETH100TX_REG_STAT = (void*)XPAR_AXI_ETH100_TXREGS_0_S_AXI_BASEADDR;
volatile uint32_t *ETH100TX_REG_RBOT_WFRLEN = (void*)(XPAR_AXI_ETH100_TXREGS_0_S_AXI_BASEADDR+4);
volatile uint32_t *ETH100TX_REG_INFO_TXFRAMES = (void*)(XPAR_AXI_ETH100_TXREGS_0_S_AXI_BASEADDR+0x10);
volatile uint32_t *ETH100TX_REG_INFO_TXBYTES = (void*)(XPAR_AXI_ETH100_TXREGS_0_S_AXI_BASEADDR+0x14);
volatile uint32_t *ETH100TX_FRBUF = (void*)XPAR_AXI_ETH100_TXBUF_0_S_AXI_BASEADDR;

volatile uint32_t *ETH100RX_REG_STAT = (void*)XPAR_AXI_ETH100_RXREGS_0_S_AXI_BASEADDR;
volatile uint32_t *ETH100RX_REG_CFRLEN = (void*)(XPAR_AXI_ETH100_RXREGS_0_S_AXI_BASEADDR+4);
volatile uint32_t *ETH100RX_REG_REMFR = (void*)(XPAR_AXI_ETH100_RXREGS_0_S_AXI_BASEADDR+8);
volatile uint32_t *ETH100RX_REG_INFO_RXFRAMES = (void*)(XPAR_AXI_ETH100_RXREGS_0_S_AXI_BASEADDR+0x10);
volatile uint32_t *ETH100RX_REG_INFO_RXSOFS = (void*)(XPAR_AXI_ETH100_RXREGS_0_S_AXI_BASEADDR+0x14);
volatile uint32_t *ETH100RX_REG_INFO_RXOVF = (void*)(XPAR_AXI_ETH100_RXREGS_0_S_AXI_BASEADDR+0x18);
volatile uint32_t *ETH100RX_FRBUF = (void*)XPAR_AXI_ETH100_RXBUF_0_S_AXI_BASEADDR;


/* Mark the slot in txlink as unused, move the bottom pointer */
void EdmaTx_DoMarkSlotUnused(edma_txlink_t *txlink, uint32_t tag)
{
    /* move bottom frame buffer pointer */
    txlink->bottom = txlink->txslots[tag].top;
    /* frame finished because it was already acked */
    txlink->txslots[tag].state = ETXSTATE_UNUSED;
}

/* look if some frame slots have been processed by hardware */
void EdmaTx_UpdateSlotsByHw(edma_txlink_t *txlink)
{
    /* get the last completed tag from hardware */
    const uint32_t etag = (*ETH100TX_REG_RBOT_WFRLEN >> 2*FRBUF_MEMADDR_W) & TXTAGMASK;
    uint32_t t;

    if (etag != txlink->hwbottom_tag) {
        xil_printf("EdmaTx_UpdateSlotsByHw: hwbottom_tag=%d, etag=%d\r\n", txlink->hwbottom_tag, etag);
    }

    /* process all tags from hwbottom_tag to tag */
    for (t = ((txlink->hwbottom_tag+1) & TXTAGMASK); 
                t != ((etag+1) & TXTAGMASK); t = (t+1) & TXTAGMASK) {
        switch (txlink->txslots[t].state) {
            case ETXSTATE_SENDING:
                /* frame sent, and it must wait for ack */
                txlink->txslots[t].state = ETXSTATE_WAIT_FOR_ACK;
                break;

            case ETXSTATE_SENDING_BUT_ACKED:
                EdmaTx_DoMarkSlotUnused(txlink, t);
                break;

            default:
                xil_printf("EdmaTx_UpdateSlotsByHw: tag=%d is in state %d\r\n",
                            t, txlink->txslots[t].state);
                break;
        }

    }

    /* record what tags we have processed */
    txlink->hwbottom_tag = etag;

    /* update info */
    txlink->info_txframes = *ETH100TX_REG_INFO_TXFRAMES;
    txlink->info_txbytes = *ETH100TX_REG_INFO_TXBYTES;
}

/* calculate the free space in hw tx buffer */
uint32_t EdmaTx_CalcFreeBufferSpace(edma_txlink_t *txlink)
{
    uint32_t space = 0;
    /* Occupied space: bottom...(top-1)
     * Empty space: top...(bottom-1)
     */
    if (txlink->top >= txlink->bottom) {
        /* top...end-of-buffer */
        space = (1 << FRBUF_MEMADDR_W) - txlink->top;
        /* 0...bottom-1 */
        space += txlink->bottom;
    } else {
        /* top...(bottom-1) */
        space = txlink->bottom - 1 - txlink->top;
    }
    return space;
}

/* Copy buffer buf of the wlen words to hardware buffer. 
 * Returns the slot index used. */
uint32_t EdmaTx_CopyToHwBuffer(edma_txlink_t *txlink, uint32_t *buf, uint32_t wlen, uint8_t seqnum)
{
    uint32_t i;
    for (i = 0; i < wlen; ++i) {
        ETH100TX_FRBUF[(txlink->top + i) & TX_FRBUF_MASK] = buf[i];
    }

    txlink->txslots[txlink->frm_ntag].state = ETXSTATE_PREPARE;
    txlink->txslots[txlink->frm_ntag].wlen = wlen;
    txlink->txslots[txlink->frm_ntag].seqnum = seqnum;
    txlink->txslots[txlink->frm_ntag].bottom = txlink->top;
    txlink->top = (txlink->top + wlen) & TX_FRBUF_MASK;
    txlink->txslots[txlink->frm_ntag].top = txlink->top;
    ++txlink->frm_num;

    i = txlink->frm_ntag;
    txlink->frm_ntag = (txlink->frm_ntag + 1) & TXTAGMASK;
    return i;
}

/* Enqueue the frame prepared in buffer to hardware */
void EdmaTx_EnqueueFrameToHw(edma_txlink_t *txlink, uint32_t tag, uint32_t ctick)
{
    /* enqueue the frame to hardware */
    *ETH100TX_REG_RBOT_WFRLEN = (tag << (2*FRBUF_MEMADDR_W))
            | (txlink->txslots[tag].wlen << FRBUF_MEMADDR_W) 
            | (txlink->txslots[tag].bottom);
    txlink->txslots[tag].state = ETXSTATE_SENDING;
    txlink->txslots[tag].sendtime = ctick;
}


/* update hw state, return the length of received waiting frame in hw buffer */
uint32_t EdmaRx_CheckHw(edma_rxlink_t *rxlink)
{
    uint32_t frlen = 0;

    /* update current known value */
    rxlink->info_rxsofs = *ETH100RX_REG_INFO_RXSOFS;
    rxlink->info_rxframes = *ETH100RX_REG_INFO_RXFRAMES;
    rxlink->info_rxovf = *ETH100RX_REG_INFO_RXOVF;

    /* check frame presence */
    if ((*ETH100RX_REG_STAT & ETH100RX_RSTAT_NOFRAME) == 0) {
        /* there is frame in rx hw buffer */
        frlen = *ETH100RX_REG_CFRLEN;
    }

    return frlen;
}

/* copy received frame from hw buffer to buf memory */
void EdmaRx_CopyFromHwBuffer(edma_rxlink_t *rxlink, uint32_t *buf)
{
    /* get frame length in words */
    const uint32_t frame_len = *ETH100RX_REG_CFRLEN;
    
    /* copy out the data */
    uint32_t i;
    for (i = 0; i < frame_len; ++i) {
        buf[i] = ETH100RX_FRBUF[(rxlink->bottom + i) & RX_FRBUF_MASK];
    }
}

/* signalize to hw that current received frame is finished */
void EdmaRx_ReleaseFrameInHwBuffer(edma_rxlink_t *rxlink)
{
    /* get frame length in words */
    const uint32_t frame_len = *ETH100RX_REG_CFRLEN;

    /* move bottom by frame length */
    rxlink->bottom = (rxlink->bottom + frame_len) & RX_FRBUF_MASK;

    /* remove frame from the hw buffer - move bottom in the hw */
    *ETH100RX_REG_REMFR = frame_len;

    /* deq frame info from the queue */
    *ETH100RX_REG_CFRLEN = 1;
}

