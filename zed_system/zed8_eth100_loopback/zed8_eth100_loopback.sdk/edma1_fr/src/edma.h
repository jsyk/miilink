#ifndef EDMA_H
#define EDMA_H

#include <stdint.h>

#define FRBUF_MEMADDR_W             10
#define FRTAG_W                     4

#define TXNTAGS                     (1 << FRTAG_W)
#define TXTAGMASK                   (TXNTAGS - 1)

/* buffer mask in words */
#define TX_FRBUF_MASK               ((1 << FRBUF_MEMADDR_W) - 1)
#define RX_FRBUF_MASK               ((1 << FRBUF_MEMADDR_W) - 1)


#define ETH100TX_RSTAT_RESET        0x80000000


#define ETH100RX_RSTAT_RESET        0x80000000
#define ETH100RX_RSTAT_NOFRAME      0x00000001
#define ETH100RX_RSTAT_IRQ_EN       0x00000002
#define ETH100RX_RSTAT_IRQ_ST       0x00000004


#define ACK_WAIT_TIMEOUT            100


extern volatile uint32_t *ETH100TX_REG_STAT;
extern volatile uint32_t *ETH100TX_REG_RBOT_WFRLEN;
extern volatile uint32_t *ETH100TX_REG_INFO_TXFRAMES;
extern volatile uint32_t *ETH100TX_REG_INFO_TXBYTES;
extern volatile uint32_t *ETH100TX_FRBUF;

extern volatile uint32_t *ETH100RX_REG_STAT;
extern volatile uint32_t *ETH100RX_REG_CFRLEN;
extern volatile uint32_t *ETH100RX_REG_REMFR;
extern volatile uint32_t *ETH100RX_REG_INFO_RXFRAMES;
extern volatile uint32_t *ETH100RX_REG_INFO_RXSOFS;
extern volatile uint32_t *ETH100RX_REG_INFO_RXOVF;
extern volatile uint32_t *ETH100RX_FRBUF;

/**
 * enum State of a frame slot.
 */
typedef enum {
    /* the tag slot is unused */
    ETXSTATE_UNUSED = 0,
    /* frame is being prepared */
    ETXSTATE_PREPARE = 1,
    /* frame was submitted to hw and is being sent, not acked */
    ETXSTATE_SENDING = 2,
    /* frame is being sent and it was acked in the meantime */
    ETXSTATE_SENDING_BUT_ACKED = 3,
    /* sent frame is awaiting ack from the peer */
    ETXSTATE_WAIT_FOR_ACK = 4
} edma_txstate_t;


/**
 * TX Slot descriptor.
 */
typedef struct {
    /* state of the frame slot */
    edma_txstate_t state;
    /* start and end of this frame */
    uint32_t bottom, top, wlen;
    /* tick time when the frame was last sent - for retransmit */
    uint32_t sendtime;
    /* my sequence number of the frame */
    uint8_t seqnum;
} edma_txslot_t;


/**
 * TX Link descriptor.
 */
typedef struct {
    /* bottom of the hw frame buffer */
    uint32_t bottom;
    /* top of the hw frame buffer */
    uint32_t top;

    /* next tag to use for a new frame; check that txslots[frm_ntag].state is UNUSED */
    uint32_t frm_ntag;
    /* the last returned tag from hardware */
    uint32_t hwbottom_tag;

    /* TX slot descriptors - one for each tag */
    edma_txslot_t txslots[TXNTAGS];

    /* counter of produced unique frames */
    uint32_t frm_num;
    /* total TX frames counter from hw, including retransmissions */
    uint32_t info_txframes;
    /* total TX bytes counter from hw */
    uint32_t info_txbytes;

} edma_txlink_t;


/* look if some frame slots have been processed by hardware */
void EdmaTx_UpdateSlotsByHw(edma_txlink_t *txlink);
/* calculate the free space in hw tx buffer, in 32b words */
uint32_t EdmaTx_CalcFreeBufferSpace(edma_txlink_t *txlink);
/* Copy buffer buf of the wlen words to hardware buffer. 
 * Returns the slot index used. */
uint32_t EdmaTx_CopyToHwBuffer(edma_txlink_t *txlink, uint32_t *buf, uint32_t wlen, uint8_t seqnum);
/* Enqueue the frame prepared in buffer to hardware */
void EdmaTx_EnqueueFrameToHw(edma_txlink_t *txlink, uint32_t tag, uint32_t ctick);
/* Mark the slot in txlink as unused, move the bottom pointer */
void EdmaTx_DoMarkSlotUnused(edma_txlink_t *txlink, uint32_t tag);


/**
 * RX Link descriptor
 */
typedef struct {
    /* bottom pointer to hw RX frame buffer */
    uint32_t bottom;

    /* HW counter of RX complete frames */
    uint32_t info_rxframes;
    /* HW counter of RX starts-of-frames */
    uint32_t info_rxsofs;
    /* HW counter of RX frames that were not delivered to buffer due to overflow */
    uint32_t info_rxovf;
} edma_rxlink_t;


/* update hw state, return the length of received waiting frame in hw buffer */
uint32_t EdmaRx_CheckHw(edma_rxlink_t *rxlink);
/* copy received frame from hw buffer to buf memory */
void EdmaRx_CopyFromHwBuffer(edma_rxlink_t *rxlink, uint32_t *buf);
/* signalize to hw that current received frame is finished */
void EdmaRx_ReleaseFrameInHwBuffer(edma_rxlink_t *rxlink);


typedef struct {
    /* the next seqnum that will be used for a new output frame */
    uint8_t next_output_seqnum;
    /* the highest output seqnum that our partner has acknowledged */
    uint8_t acked_output_seqnum;
    /* the highest input seqnum that we have acknowledged to our partner */
    uint8_t acking_input_seqnum;

    /* link state descriptors */
    edma_rxlink_t rxlink;
    edma_txlink_t txlink;
} edma_t;

#endif
