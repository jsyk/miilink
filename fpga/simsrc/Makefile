
SRC=../src

#picocom

.SUFFIXES: .vhd

%.o: ../src/%.vhd
	ghdl -a $<

%.o: %.vhd
	ghdl -a $<

#etherlink_pkg.o: $(SRC)/etherlink_pkg.vhd
#fifo_queue.o: etherlink_pkg.o $(SRC)/fifo_queue.vhd
#dp_dclk_ram_wr_rdwr.o: $(SRC)/dp_dclk_ram_wr_rdwr.vhd

txlink_fsm.o: $(SRC)/txlink_fsm.vhd etherlink_pkg.o
eth100_link_rx.o: $(SRC)/eth100_link_rx.vhd etherlink_pkg.o dp_dclk_ram_wr_rdwr.o fifo_queue.o rmii_to_bytestream.o rxlink_fsm.o rxlink_cbuf_ctrl.o dclk_transport.o
eth100_link_tx.o: $(SRC)/eth100_link_tx.vhd etherlink_pkg.o dp_dclk_ram_2rdwr.o fifo_queue.o bytestream_to_rmii.o txlink_fsm.o dclk_transport.o

tb_fifo_queue.o: etherlink_pkg.o tb_fifo_queue.vhd fifo_queue.o
tb_rmii_to_bytestream.o: etherlink_pkg.o  tb_rmii_to_bytestream.vhd rmii_to_bytestream.o
tb_rxlink_cbuf_ctrl.o: tb_rxlink_cbuf_ctrl.vhd  etherlink_pkg.o   rxlink_cbuf_ctrl.o
tb_rxlink_fsm.o: tb_rxlink_fsm.vhd etherlink_pkg.o   rxlink_fsm.o crc.o
tb_eth100_link_rx.o: etherlink_pkg.o tb_eth100_link_rx.vhd eth100_link_rx.o
tb_dp_dclk_ram_wr_rdwr.o:  etherlink_pkg.o dp_dclk_ram_wr_rdwr.o tb_dp_dclk_ram_wr_rdwr.vhd
tb_crc.o: etherlink_pkg.o crc.o tb_crc.vhd
tb_txlink_fsm.o: etherlink_pkg.o crc.o txlink_fsm.o tb_txlink_fsm.vhd bytestream_to_rmii.o rmii_to_bytestream.o
tb_eth100_link_tx.o: etherlink_pkg.o eth100_link_tx.o tb_eth100_link_tx.vhd

tb_fifo_queue: tb_fifo_queue.o
	ghdl -e tb_fifo_queue

tb_rmii_to_bytestream: tb_rmii_to_bytestream.o
	ghdl -e tb_rmii_to_bytestream

tb_rxlink_cbuf_ctrl: tb_rxlink_cbuf_ctrl.o
	ghdl -e tb_rxlink_cbuf_ctrl

tb_rxlink_fsm: tb_rxlink_fsm.o
	ghdl -e tb_rxlink_fsm

tb_eth100_link_rx: tb_eth100_link_rx.o
	ghdl -e tb_eth100_link_rx

tb_dp_dclk_ram_wr_rdwr: tb_dp_dclk_ram_wr_rdwr.o
	ghdl -e tb_dp_dclk_ram_wr_rdwr

tb_crc: tb_crc.o
	ghdl -e tb_crc

tb_txlink_fsm: tb_txlink_fsm.o
	ghdl -e tb_txlink_fsm

tb_eth100_link_tx: tb_eth100_link_tx.o
	ghdl -e tb_eth100_link_tx

tb_loopback: tb_loopback.o loopback.o
	ghdl -e tb_loopback

clean:
	rm -f *.o
