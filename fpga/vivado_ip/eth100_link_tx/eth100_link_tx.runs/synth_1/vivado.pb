
~
Command: %s
53*	vivadotcl2P
<synth_design -top iptop_eth100_link_tx -part xc7z020clg484-12default:defaultZ4-113h px
7
Starting synth_design
149*	vivadotclZ4-321h px
�
@Attempting to get a license for feature '%s' and/or device '%s'
308*common2
	Synthesis2default:default2
xc7z0202default:defaultZ17-347h px
�
0Got license for feature '%s' and/or device '%s'
310*common2
	Synthesis2default:default2
xc7z0202default:defaultZ17-349h px
�
%s*synth2�
�Starting Synthesize : Time (s): cpu = 00:00:10 ; elapsed = 00:00:10 . Memory (MB): peak = 1085.613 ; gain = 132.801 ; free physical = 2774 ; free virtual = 6748
2default:defaulth px
�
synthesizing module '%s'638*oasys2(
iptop_eth100_link_tx2default:default2f
P/home/jara/ownCloud-pluto/elektronika/etherlink-hdl/src/iptop_eth100_link_tx.vhd2default:default2
392default:default8@Z8-638h px
g
%s*synth2R
>	Parameter FRBUF_MEMBYTE_ADDR_W bound to: 11 - type: integer 
2default:defaulth px
Z
%s*synth2E
1	Parameter IGAP_LEN bound to: 6 - type: integer 
2default:defaulth px
`
%s*synth2K
7	Parameter TXFIFO_DEPTH_W bound to: 4 - type: integer 
2default:defaulth px
b
%s*synth2M
9	Parameter FRBUF_MEM_ADDR_W bound to: 9 - type: integer 
2default:defaulth px
Z
%s*synth2E
1	Parameter IGAP_LEN bound to: 6 - type: integer 
2default:defaulth px
^
%s*synth2I
5	Parameter M1_SUPPORT_READ bound to: 1 - type: bool 
2default:defaulth px
Z
%s*synth2E
1	Parameter M1_DELAY bound to: 1 - type: integer 
2default:defaulth px
`
%s*synth2K
7	Parameter TXFIFO_DEPTH_W bound to: 4 - type: integer 
2default:defaulth px
�
Hmodule '%s' declared at '%s:%s' bound to instance '%s' of component '%s'3392*oasys2"
eth100_link_tx2default:default2^
J/home/jara/ownCloud-pluto/elektronika/etherlink-hdl/src/eth100_link_tx.vhd2default:default2
102default:default2
linktx2default:default2"
eth100_link_tx2default:default2f
P/home/jara/ownCloud-pluto/elektronika/etherlink-hdl/src/iptop_eth100_link_tx.vhd2default:default2
622default:default8@Z8-3491h px
�
synthesizing module '%s'638*oasys2"
eth100_link_tx2default:default2`
J/home/jara/ownCloud-pluto/elektronika/etherlink-hdl/src/eth100_link_tx.vhd2default:default2
462default:default8@Z8-638h px
b
%s*synth2M
9	Parameter FRBUF_MEM_ADDR_W bound to: 9 - type: integer 
2default:defaulth px
Z
%s*synth2E
1	Parameter IGAP_LEN bound to: 6 - type: integer 
2default:defaulth px
^
%s*synth2I
5	Parameter M1_SUPPORT_READ bound to: 1 - type: bool 
2default:defaulth px
Z
%s*synth2E
1	Parameter M1_DELAY bound to: 1 - type: integer 
2default:defaulth px
`
%s*synth2K
7	Parameter TXFIFO_DEPTH_W bound to: 4 - type: integer 
2default:defaulth px
�
Hmodule '%s' declared at '%s:%s' bound to instance '%s' of component '%s'3392*oasys2&
bytestream_to_rmii2default:default2b
N/home/jara/ownCloud-pluto/elektronika/etherlink-hdl/src/bytestream_to_rmii.vhd2default:default2
82default:default2
bs2rmii2default:default2&
bytestream_to_rmii2default:default2`
J/home/jara/ownCloud-pluto/elektronika/etherlink-hdl/src/eth100_link_tx.vhd2default:default2
832default:default8@Z8-3491h px
�
synthesizing module '%s'638*oasys2&
bytestream_to_rmii2default:default2d
N/home/jara/ownCloud-pluto/elektronika/etherlink-hdl/src/bytestream_to_rmii.vhd2default:default2
232default:default8@Z8-638h px
�
%done synthesizing module '%s' (%s#%s)256*oasys2&
bytestream_to_rmii2default:default2
12default:default2
12default:default2d
N/home/jara/ownCloud-pluto/elektronika/etherlink-hdl/src/bytestream_to_rmii.vhd2default:default2
232default:default8@Z8-256h px
\
%s*synth2G
3	Parameter MEM_ADDR_W bound to: 9 - type: integer 
2default:defaulth px
Z
%s*synth2E
1	Parameter IGAP_LEN bound to: 6 - type: integer 
2default:defaulth px
�
Hmodule '%s' declared at '%s:%s' bound to instance '%s' of component '%s'3392*oasys2

txlink_fsm2default:default2Z
F/home/jara/ownCloud-pluto/elektronika/etherlink-hdl/src/txlink_fsm.vhd2default:default2
102default:default2
txlnkfsm2default:default2

txlink_fsm2default:default2`
J/home/jara/ownCloud-pluto/elektronika/etherlink-hdl/src/eth100_link_tx.vhd2default:default2
962default:default8@Z8-3491h px
�
synthesizing module '%s'638*oasys2

txlink_fsm2default:default2\
F/home/jara/ownCloud-pluto/elektronika/etherlink-hdl/src/txlink_fsm.vhd2default:default2
402default:default8@Z8-638h px
\
%s*synth2G
3	Parameter MEM_ADDR_W bound to: 9 - type: integer 
2default:defaulth px
Z
%s*synth2E
1	Parameter IGAP_LEN bound to: 6 - type: integer 
2default:defaulth px
�
Hmodule '%s' declared at '%s:%s' bound to instance '%s' of component '%s'3392*oasys2
CRC2default:default2S
?/home/jara/ownCloud-pluto/elektronika/etherlink-hdl/src/crc.vhd2default:default2
302default:default2
fcs_checker2default:default2
CRC2default:default2\
F/home/jara/ownCloud-pluto/elektronika/etherlink-hdl/src/txlink_fsm.vhd2default:default2
732default:default8@Z8-3491h px
�
synthesizing module '%s'638*oasys2
CRC2default:default2U
?/home/jara/ownCloud-pluto/elektronika/etherlink-hdl/src/crc.vhd2default:default2
432default:default8@Z8-638h px
�
default block is never used226*oasys2U
?/home/jara/ownCloud-pluto/elektronika/etherlink-hdl/src/crc.vhd2default:default2
1852default:default8@Z8-226h px
�
%done synthesizing module '%s' (%s#%s)256*oasys2
CRC2default:default2
22default:default2
12default:default2U
?/home/jara/ownCloud-pluto/elektronika/etherlink-hdl/src/crc.vhd2default:default2
432default:default8@Z8-256h px
�
%done synthesizing module '%s' (%s#%s)256*oasys2

txlink_fsm2default:default2
32default:default2
12default:default2\
F/home/jara/ownCloud-pluto/elektronika/etherlink-hdl/src/txlink_fsm.vhd2default:default2
402default:default8@Z8-256h px
\
%s*synth2G
3	Parameter MEM_ADDR_W bound to: 9 - type: integer 
2default:defaulth px
]
%s*synth2H
4	Parameter MEM_DATA_W bound to: 32 - type: integer 
2default:defaulth px
^
%s*synth2I
5	Parameter M1_SUPPORT_READ bound to: 1 - type: bool 
2default:defaulth px
Z
%s*synth2E
1	Parameter M1_DELAY bound to: 1 - type: integer 
2default:defaulth px
_
%s*synth2J
6	Parameter M2_SUPPORT_WRITE bound to: 0 - type: bool 
2default:defaulth px
Z
%s*synth2E
1	Parameter M2_DELAY bound to: 2 - type: integer 
2default:defaulth px
�
Hmodule '%s' declared at '%s:%s' bound to instance '%s' of component '%s'3392*oasys2%
dp_dclk_ram_2rdwr2default:default2a
M/home/jara/ownCloud-pluto/elektronika/etherlink-hdl/src/dp_dclk_ram_2rdwr.vhd2default:default2
102default:default2
fbuf2default:default2%
dp_dclk_ram_2rdwr2default:default2`
J/home/jara/ownCloud-pluto/elektronika/etherlink-hdl/src/eth100_link_tx.vhd2default:default2
1252default:default8@Z8-3491h px
�
synthesizing module '%s'638*oasys2%
dp_dclk_ram_2rdwr2default:default2c
M/home/jara/ownCloud-pluto/elektronika/etherlink-hdl/src/dp_dclk_ram_2rdwr.vhd2default:default2
372default:default8@Z8-638h px
\
%s*synth2G
3	Parameter MEM_ADDR_W bound to: 9 - type: integer 
2default:defaulth px
]
%s*synth2H
4	Parameter MEM_DATA_W bound to: 32 - type: integer 
2default:defaulth px
^
%s*synth2I
5	Parameter M1_SUPPORT_READ bound to: 1 - type: bool 
2default:defaulth px
Z
%s*synth2E
1	Parameter M1_DELAY bound to: 1 - type: integer 
2default:defaulth px
_
%s*synth2J
6	Parameter M2_SUPPORT_WRITE bound to: 0 - type: bool 
2default:defaulth px
Z
%s*synth2E
1	Parameter M2_DELAY bound to: 2 - type: integer 
2default:defaulth px
�
&ignoring unsynthesizable construct: %s312*oasys2'
assertion statement2default:default2c
M/home/jara/ownCloud-pluto/elektronika/etherlink-hdl/src/dp_dclk_ram_2rdwr.vhd2default:default2
1372default:default8@Z8-312h px
�
&ignoring unsynthesizable construct: %s312*oasys2'
assertion statement2default:default2c
M/home/jara/ownCloud-pluto/elektronika/etherlink-hdl/src/dp_dclk_ram_2rdwr.vhd2default:default2
1382default:default8@Z8-312h px
�
%done synthesizing module '%s' (%s#%s)256*oasys2%
dp_dclk_ram_2rdwr2default:default2
42default:default2
12default:default2c
M/home/jara/ownCloud-pluto/elektronika/etherlink-hdl/src/dp_dclk_ram_2rdwr.vhd2default:default2
372default:default8@Z8-256h px
]
%s*synth2H
4	Parameter FIFO_DATA_W bound to: 9 - type: integer 
2default:defaulth px
^
%s*synth2I
5	Parameter FIFO_DEPTH_W bound to: 4 - type: integer 
2default:defaulth px
�
Hmodule '%s' declared at '%s:%s' bound to instance '%s' of component '%s'3392*oasys2

fifo_queue2default:default2Z
F/home/jara/ownCloud-pluto/elektronika/etherlink-hdl/src/fifo_queue.vhd2default:default2
92default:default2
pfqueue2default:default2

fifo_queue2default:default2`
J/home/jara/ownCloud-pluto/elektronika/etherlink-hdl/src/eth100_link_tx.vhd2default:default2
1532default:default8@Z8-3491h px
�
synthesizing module '%s'638*oasys2

fifo_queue2default:default2\
F/home/jara/ownCloud-pluto/elektronika/etherlink-hdl/src/fifo_queue.vhd2default:default2
282default:default8@Z8-638h px
]
%s*synth2H
4	Parameter FIFO_DATA_W bound to: 9 - type: integer 
2default:defaulth px
^
%s*synth2I
5	Parameter FIFO_DEPTH_W bound to: 4 - type: integer 
2default:defaulth px
�
%done synthesizing module '%s' (%s#%s)256*oasys2

fifo_queue2default:default2
52default:default2
12default:default2\
F/home/jara/ownCloud-pluto/elektronika/etherlink-hdl/src/fifo_queue.vhd2default:default2
282default:default8@Z8-256h px
X
%s*synth2C
/	Parameter DWIDTH bound to: 1 - type: integer 
2default:defaulth px
�
Hmodule '%s' declared at '%s:%s' bound to instance '%s' of component '%s'3392*oasys2"
dclk_transport2default:default2^
J/home/jara/ownCloud-pluto/elektronika/etherlink-hdl/src/dclk_transport.vhd2default:default2
92default:default2

pfdeq_dclk2default:default2"
dclk_transport2default:default2`
J/home/jara/ownCloud-pluto/elektronika/etherlink-hdl/src/eth100_link_tx.vhd2default:default2
1822default:default8@Z8-3491h px
�
synthesizing module '%s'638*oasys2"
dclk_transport2default:default2`
J/home/jara/ownCloud-pluto/elektronika/etherlink-hdl/src/dclk_transport.vhd2default:default2
262default:default8@Z8-638h px
X
%s*synth2C
/	Parameter DWIDTH bound to: 1 - type: integer 
2default:defaulth px
�
%done synthesizing module '%s' (%s#%s)256*oasys2"
dclk_transport2default:default2
62default:default2
12default:default2`
J/home/jara/ownCloud-pluto/elektronika/etherlink-hdl/src/dclk_transport.vhd2default:default2
262default:default8@Z8-256h px
X
%s*synth2C
/	Parameter DWIDTH bound to: 9 - type: integer 
2default:defaulth px
�
Hmodule '%s' declared at '%s:%s' bound to instance '%s' of component '%s'3392*oasys2"
dclk_transport2default:default2^
J/home/jara/ownCloud-pluto/elektronika/etherlink-hdl/src/dclk_transport.vhd2default:default2
92default:default2
rf_dclk2default:default2"
dclk_transport2default:default2`
J/home/jara/ownCloud-pluto/elektronika/etherlink-hdl/src/eth100_link_tx.vhd2default:default2
1962default:default8@Z8-3491h px
�
synthesizing module '%s'638*oasys22
dclk_transport__parameterized12default:default2`
J/home/jara/ownCloud-pluto/elektronika/etherlink-hdl/src/dclk_transport.vhd2default:default2
262default:default8@Z8-638h px
X
%s*synth2C
/	Parameter DWIDTH bound to: 9 - type: integer 
2default:defaulth px
�
%done synthesizing module '%s' (%s#%s)256*oasys22
dclk_transport__parameterized12default:default2
62default:default2
12default:default2`
J/home/jara/ownCloud-pluto/elektronika/etherlink-hdl/src/dclk_transport.vhd2default:default2
262default:default8@Z8-256h px
�
%done synthesizing module '%s' (%s#%s)256*oasys2"
eth100_link_tx2default:default2
72default:default2
12default:default2`
J/home/jara/ownCloud-pluto/elektronika/etherlink-hdl/src/eth100_link_tx.vhd2default:default2
462default:default8@Z8-256h px
�
%done synthesizing module '%s' (%s#%s)256*oasys2(
iptop_eth100_link_tx2default:default2
82default:default2
12default:default2f
P/home/jara/ownCloud-pluto/elektronika/etherlink-hdl/src/iptop_eth100_link_tx.vhd2default:default2
392default:default8@Z8-256h px
�
!design %s has unconnected port %s3331*oasys2(
iptop_eth100_link_tx2default:default2

m1_addr[1]2default:defaultZ8-3331h px
�
!design %s has unconnected port %s3331*oasys2(
iptop_eth100_link_tx2default:default2

m1_addr[0]2default:defaultZ8-3331h px
�
!design %s has unconnected port %s3331*oasys2(
iptop_eth100_link_tx2default:default2

mr_wdt[30]2default:defaultZ8-3331h px
�
!design %s has unconnected port %s3331*oasys2(
iptop_eth100_link_tx2default:default2

mr_wdt[29]2default:defaultZ8-3331h px
�
!design %s has unconnected port %s3331*oasys2(
iptop_eth100_link_tx2default:default2

mr_wdt[28]2default:defaultZ8-3331h px
�
!design %s has unconnected port %s3331*oasys2(
iptop_eth100_link_tx2default:default2

mr_wdt[27]2default:defaultZ8-3331h px
�
!design %s has unconnected port %s3331*oasys2(
iptop_eth100_link_tx2default:default2

mr_wdt[26]2default:defaultZ8-3331h px
�
!design %s has unconnected port %s3331*oasys2(
iptop_eth100_link_tx2default:default2

mr_wdt[25]2default:defaultZ8-3331h px
�
!design %s has unconnected port %s3331*oasys2(
iptop_eth100_link_tx2default:default2

mr_wdt[24]2default:defaultZ8-3331h px
�
!design %s has unconnected port %s3331*oasys2(
iptop_eth100_link_tx2default:default2

mr_wdt[23]2default:defaultZ8-3331h px
�
!design %s has unconnected port %s3331*oasys2(
iptop_eth100_link_tx2default:default2

mr_wdt[22]2default:defaultZ8-3331h px
�
!design %s has unconnected port %s3331*oasys2(
iptop_eth100_link_tx2default:default2

mr_wdt[21]2default:defaultZ8-3331h px
�
!design %s has unconnected port %s3331*oasys2(
iptop_eth100_link_tx2default:default2

mr_wdt[20]2default:defaultZ8-3331h px
�
!design %s has unconnected port %s3331*oasys2(
iptop_eth100_link_tx2default:default2

mr_wdt[19]2default:defaultZ8-3331h px
�
!design %s has unconnected port %s3331*oasys2(
iptop_eth100_link_tx2default:default2

mr_wdt[18]2default:defaultZ8-3331h px
�
!design %s has unconnected port %s3331*oasys2(
iptop_eth100_link_tx2default:default2

mr_wdt[17]2default:defaultZ8-3331h px
�
!design %s has unconnected port %s3331*oasys2(
iptop_eth100_link_tx2default:default2

mr_wdt[16]2default:defaultZ8-3331h px
�
!design %s has unconnected port %s3331*oasys2(
iptop_eth100_link_tx2default:default2

mr_wdt[15]2default:defaultZ8-3331h px
�
!design %s has unconnected port %s3331*oasys2(
iptop_eth100_link_tx2default:default2

mr_wdt[14]2default:defaultZ8-3331h px
�
!design %s has unconnected port %s3331*oasys2(
iptop_eth100_link_tx2default:default2

mr_wdt[13]2default:defaultZ8-3331h px
�
!design %s has unconnected port %s3331*oasys2(
iptop_eth100_link_tx2default:default2

mr_wdt[12]2default:defaultZ8-3331h px
�
!design %s has unconnected port %s3331*oasys2(
iptop_eth100_link_tx2default:default2

mr_wdt[11]2default:defaultZ8-3331h px
�
!design %s has unconnected port %s3331*oasys2(
iptop_eth100_link_tx2default:default2

mr_wdt[10]2default:defaultZ8-3331h px
�
!design %s has unconnected port %s3331*oasys2(
iptop_eth100_link_tx2default:default2
	mr_wdt[9]2default:defaultZ8-3331h px
�
%s*synth2�
�Finished Synthesize : Time (s): cpu = 00:00:12 ; elapsed = 00:00:12 . Memory (MB): peak = 1123.996 ; gain = 171.184 ; free physical = 2724 ; free virtual = 6705
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
�
%s*synth2�
�Finished Constraint Validation : Time (s): cpu = 00:00:12 ; elapsed = 00:00:13 . Memory (MB): peak = 1123.996 ; gain = 171.184 ; free physical = 2724 ; free virtual = 6705
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
S
%s*synth2>
*Start Loading Part and Timing Information
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
G
%s*synth22
Loading part: xc7z020clg484-1
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
�
%s*synth2�
�Finished Loading Part and Timing Information : Time (s): cpu = 00:00:12 ; elapsed = 00:00:13 . Memory (MB): peak = 1131.996 ; gain = 179.184 ; free physical = 2724 ; free virtual = 6705
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
S
Loading part %s157*device2#
xc7z020clg484-12default:defaultZ21-403h px
�
[ROM "%s" won't be mapped to Block RAM because address size (%s) smaller than threshold (%s)3996*oasys2
v[en]2default:default2
42default:default2
52default:defaultZ8-5544h px
�
3inferred FSM for state register '%s' in module '%s'802*oasys2 
r_reg[state]2default:default2

txlink_fsm2default:defaultZ8-802h px
�
[ROM "%s" won't be mapped to Block RAM because address size (%s) smaller than threshold (%s)3996*oasys2
v[state]2default:default2
42default:default2
52default:defaultZ8-5544h px
�
[ROM "%s" won't be mapped to Block RAM because address size (%s) smaller than threshold (%s)3996*oasys2
v[state]2default:default2
42default:default2
52default:defaultZ8-5544h px
�
[ROM "%s" won't be mapped to Block RAM because address size (%s) smaller than threshold (%s)3996*oasys2
v[state]2default:default2
42default:default2
52default:defaultZ8-5544h px
�
[ROM "%s" won't be mapped to Block RAM because address size (%s) smaller than threshold (%s)3996*oasys2
v[cnt]2default:default2
42default:default2
52default:defaultZ8-5544h px
�
[ROM "%s" won't be mapped to Block RAM because address size (%s) smaller than threshold (%s)3996*oasys2
v[cnt]2default:default2
42default:default2
52default:defaultZ8-5544h px
�
[ROM "%s" won't be mapped to Block RAM because address size (%s) smaller than threshold (%s)3996*oasys2!
v[mii_strobe]2default:default2
22default:default2
52default:defaultZ8-5544h px
�
[ROM "%s" won't be mapped to Block RAM because address size (%s) smaller than threshold (%s)3996*oasys2$
v_reg[memory][0]2default:default2
42default:default2
52default:defaultZ8-5544h px
�
[ROM "%s" won't be mapped to Block RAM because address size (%s) smaller than threshold (%s)3996*oasys2$
v_reg[memory][1]2default:default2
42default:default2
52default:defaultZ8-5544h px
�
[ROM "%s" won't be mapped to Block RAM because address size (%s) smaller than threshold (%s)3996*oasys2$
v_reg[memory][2]2default:default2
42default:default2
52default:defaultZ8-5544h px
�
[ROM "%s" won't be mapped to Block RAM because address size (%s) smaller than threshold (%s)3996*oasys2$
v_reg[memory][3]2default:default2
42default:default2
52default:defaultZ8-5544h px
�
[ROM "%s" won't be mapped to Block RAM because address size (%s) smaller than threshold (%s)3996*oasys2$
v_reg[memory][4]2default:default2
42default:default2
52default:defaultZ8-5544h px
�
[ROM "%s" won't be mapped to Block RAM because address size (%s) smaller than threshold (%s)3996*oasys2$
v_reg[memory][5]2default:default2
42default:default2
52default:defaultZ8-5544h px
�
[ROM "%s" won't be mapped to Block RAM because address size (%s) smaller than threshold (%s)3996*oasys2$
v_reg[memory][6]2default:default2
42default:default2
52default:defaultZ8-5544h px
�
[ROM "%s" won't be mapped to Block RAM because address size (%s) smaller than threshold (%s)3996*oasys2$
v_reg[memory][7]2default:default2
42default:default2
52default:defaultZ8-5544h px
�
[ROM "%s" won't be mapped to Block RAM because address size (%s) smaller than threshold (%s)3996*oasys2$
v_reg[memory][8]2default:default2
42default:default2
52default:defaultZ8-5544h px
�
[ROM "%s" won't be mapped to Block RAM because address size (%s) smaller than threshold (%s)3996*oasys2$
v_reg[memory][9]2default:default2
42default:default2
52default:defaultZ8-5544h px
�
[ROM "%s" won't be mapped to Block RAM because address size (%s) smaller than threshold (%s)3996*oasys2%
v_reg[memory][10]2default:default2
42default:default2
52default:defaultZ8-5544h px
�
[ROM "%s" won't be mapped to Block RAM because address size (%s) smaller than threshold (%s)3996*oasys2%
v_reg[memory][11]2default:default2
42default:default2
52default:defaultZ8-5544h px
�
[ROM "%s" won't be mapped to Block RAM because address size (%s) smaller than threshold (%s)3996*oasys2%
v_reg[memory][12]2default:default2
42default:default2
52default:defaultZ8-5544h px
�
[ROM "%s" won't be mapped to Block RAM because address size (%s) smaller than threshold (%s)3996*oasys2%
v_reg[memory][13]2default:default2
42default:default2
52default:defaultZ8-5544h px
�
[ROM "%s" won't be mapped to Block RAM because address size (%s) smaller than threshold (%s)3996*oasys2%
v_reg[memory][14]2default:default2
42default:default2
52default:defaultZ8-5544h px
�
[ROM "%s" won't be mapped to Block RAM because address size (%s) smaller than threshold (%s)3996*oasys2%
v_reg[memory][15]2default:default2
42default:default2
52default:defaultZ8-5544h px
z
8ROM "%s" won't be mapped to RAM because it is too sparse3998*oasys2!
v[fifo_empty]2default:defaultZ8-5546h px
s
8ROM "%s" won't be mapped to RAM because it is too sparse3998*oasys2
pf_enq2default:defaultZ8-5546h px
s
8ROM "%s" won't be mapped to RAM because it is too sparse3998*oasys2
pf_enq2default:defaultZ8-5546h px
�
%s*synth2x
d---------------------------------------------------------------------------------------------------
2default:defaulth px
�
%s*synth2t
`                   State |                     New Encoding |                Previous Encoding 
2default:defaulth px
�
%s*synth2x
d---------------------------------------------------------------------------------------------------
2default:defaulth px
�
%s*synth2s
_                    idle |                              000 |                              000
2default:defaulth px
�
%s*synth2s
_              txpreamble |                              001 |                              001
2default:defaulth px
�
%s*synth2s
_                txsfd_d5 |                              010 |                              010
2default:defaulth px
�
%s*synth2s
_                  txdata |                              011 |                              011
2default:defaulth px
�
%s*synth2s
_                   txfcs |                              100 |                              100
2default:defaulth px
�
%s*synth2s
_                    igap |                              101 |                              101
2default:defaulth px
�
%s*synth2x
d---------------------------------------------------------------------------------------------------
2default:defaulth px
�
Gencoded FSM with state register '%s' using encoding '%s' in module '%s'3353*oasys2 
r_reg[state]2default:default2

sequential2default:default2

txlink_fsm2default:defaultZ8-3354h px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
�
%s*synth2�
�Finished RTL Optimization Phase 2 : Time (s): cpu = 00:00:14 ; elapsed = 00:00:14 . Memory (MB): peak = 1166.023 ; gain = 213.211 ; free physical = 2672 ; free virtual = 6672
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
B
%s*synth2-

Report RTL Partitions: 
2default:defaulth px
T
%s*synth2?
++-+--------------+------------+----------+
2default:defaulth px
T
%s*synth2?
+| |RTL Partition |Replication |Instances |
2default:defaulth px
T
%s*synth2?
++-+--------------+------------+----------+
2default:defaulth px
T
%s*synth2?
++-+--------------+------------+----------+
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
I
%s*synth24
 Start RTL Component Statistics 
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
H
%s*synth23
Detailed RTL Component Info : 
2default:defaulth px
7
%s*synth2"
+---Adders : 
2default:defaulth px
W
%s*synth2B
.	   2 Input      9 Bit       Adders := 3     
2default:defaulth px
W
%s*synth2B
.	   3 Input      5 Bit       Adders := 1     
2default:defaulth px
W
%s*synth2B
.	   2 Input      4 Bit       Adders := 5     
2default:defaulth px
W
%s*synth2B
.	   2 Input      2 Bit       Adders := 1     
2default:defaulth px
5
%s*synth2 
+---XORs : 
2default:defaulth px
W
%s*synth2B
.	   2 Input      1 Bit         XORs := 17    
2default:defaulth px
W
%s*synth2B
.	   3 Input      1 Bit         XORs := 4     
2default:defaulth px
W
%s*synth2B
.	   4 Input      1 Bit         XORs := 3     
2default:defaulth px
W
%s*synth2B
.	   6 Input      1 Bit         XORs := 7     
2default:defaulth px
W
%s*synth2B
.	   5 Input      1 Bit         XORs := 10    
2default:defaulth px
W
%s*synth2B
.	   8 Input      1 Bit         XORs := 3     
2default:defaulth px
W
%s*synth2B
.	   9 Input      1 Bit         XORs := 2     
2default:defaulth px
W
%s*synth2B
.	   7 Input      1 Bit         XORs := 3     
2default:defaulth px
:
%s*synth2%
+---Registers : 
2default:defaulth px
W
%s*synth2B
.	               32 Bit    Registers := 6     
2default:defaulth px
W
%s*synth2B
.	                9 Bit    Registers := 24    
2default:defaulth px
W
%s*synth2B
.	                8 Bit    Registers := 4     
2default:defaulth px
W
%s*synth2B
.	                5 Bit    Registers := 1     
2default:defaulth px
W
%s*synth2B
.	                4 Bit    Registers := 4     
2default:defaulth px
W
%s*synth2B
.	                2 Bit    Registers := 1     
2default:defaulth px
W
%s*synth2B
.	                1 Bit    Registers := 27    
2default:defaulth px
5
%s*synth2 
+---RAMs : 
2default:defaulth px
W
%s*synth2B
.	              16K Bit         RAMs := 1     
2default:defaulth px
6
%s*synth2!
+---Muxes : 
2default:defaulth px
W
%s*synth2B
.	   8 Input     32 Bit        Muxes := 1     
2default:defaulth px
W
%s*synth2B
.	   2 Input     32 Bit        Muxes := 2     
2default:defaulth px
W
%s*synth2B
.	   6 Input      9 Bit        Muxes := 1     
2default:defaulth px
W
%s*synth2B
.	   2 Input      9 Bit        Muxes := 4     
2default:defaulth px
W
%s*synth2B
.	   3 Input      9 Bit        Muxes := 1     
2default:defaulth px
W
%s*synth2B
.	   2 Input      8 Bit        Muxes := 3     
2default:defaulth px
W
%s*synth2B
.	   8 Input      8 Bit        Muxes := 1     
2default:defaulth px
W
%s*synth2B
.	   4 Input      8 Bit        Muxes := 1     
2default:defaulth px
W
%s*synth2B
.	   6 Input      8 Bit        Muxes := 1     
2default:defaulth px
W
%s*synth2B
.	   2 Input      4 Bit        Muxes := 3     
2default:defaulth px
W
%s*synth2B
.	   6 Input      4 Bit        Muxes := 1     
2default:defaulth px
W
%s*synth2B
.	   6 Input      3 Bit        Muxes := 1     
2default:defaulth px
W
%s*synth2B
.	   2 Input      2 Bit        Muxes := 2     
2default:defaulth px
W
%s*synth2B
.	   5 Input      2 Bit        Muxes := 1     
2default:defaulth px
W
%s*synth2B
.	   6 Input      2 Bit        Muxes := 1     
2default:defaulth px
W
%s*synth2B
.	   2 Input      1 Bit        Muxes := 36    
2default:defaulth px
W
%s*synth2B
.	   8 Input      1 Bit        Muxes := 1     
2default:defaulth px
W
%s*synth2B
.	   4 Input      1 Bit        Muxes := 1     
2default:defaulth px
W
%s*synth2B
.	   6 Input      1 Bit        Muxes := 11    
2default:defaulth px
W
%s*synth2B
.	   3 Input      1 Bit        Muxes := 2     
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
L
%s*synth27
#Finished RTL Component Statistics 
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
V
%s*synth2A
-Start RTL Hierarchical Component Statistics 
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
L
%s*synth27
#Hierarchical RTL Component report 
2default:defaulth px
F
%s*synth21
Module iptop_eth100_link_tx 
2default:defaulth px
H
%s*synth23
Detailed RTL Component Info : 
2default:defaulth px
7
%s*synth2"
+---Adders : 
2default:defaulth px
W
%s*synth2B
.	   2 Input      9 Bit       Adders := 1     
2default:defaulth px
:
%s*synth2%
+---Registers : 
2default:defaulth px
W
%s*synth2B
.	               32 Bit    Registers := 1     
2default:defaulth px
W
%s*synth2B
.	                9 Bit    Registers := 2     
2default:defaulth px
W
%s*synth2B
.	                8 Bit    Registers := 1     
2default:defaulth px
W
%s*synth2B
.	                1 Bit    Registers := 3     
2default:defaulth px
6
%s*synth2!
+---Muxes : 
2default:defaulth px
W
%s*synth2B
.	   2 Input     32 Bit        Muxes := 2     
2default:defaulth px
W
%s*synth2B
.	   2 Input      9 Bit        Muxes := 2     
2default:defaulth px
W
%s*synth2B
.	   3 Input      9 Bit        Muxes := 1     
2default:defaulth px
W
%s*synth2B
.	   2 Input      1 Bit        Muxes := 5     
2default:defaulth px
W
%s*synth2B
.	   3 Input      1 Bit        Muxes := 1     
2default:defaulth px
D
%s*synth2/
Module bytestream_to_rmii 
2default:defaulth px
H
%s*synth23
Detailed RTL Component Info : 
2default:defaulth px
:
%s*synth2%
+---Registers : 
2default:defaulth px
W
%s*synth2B
.	                8 Bit    Registers := 1     
2default:defaulth px
W
%s*synth2B
.	                4 Bit    Registers := 1     
2default:defaulth px
W
%s*synth2B
.	                1 Bit    Registers := 1     
2default:defaulth px
6
%s*synth2!
+---Muxes : 
2default:defaulth px
W
%s*synth2B
.	   2 Input      8 Bit        Muxes := 2     
2default:defaulth px
W
%s*synth2B
.	   2 Input      4 Bit        Muxes := 2     
2default:defaulth px
W
%s*synth2B
.	   2 Input      1 Bit        Muxes := 4     
2default:defaulth px
5
%s*synth2 
Module CRC 
2default:defaulth px
H
%s*synth23
Detailed RTL Component Info : 
2default:defaulth px
5
%s*synth2 
+---XORs : 
2default:defaulth px
W
%s*synth2B
.	   2 Input      1 Bit         XORs := 17    
2default:defaulth px
W
%s*synth2B
.	   3 Input      1 Bit         XORs := 4     
2default:defaulth px
W
%s*synth2B
.	   4 Input      1 Bit         XORs := 3     
2default:defaulth px
W
%s*synth2B
.	   6 Input      1 Bit         XORs := 7     
2default:defaulth px
W
%s*synth2B
.	   5 Input      1 Bit         XORs := 10    
2default:defaulth px
W
%s*synth2B
.	   8 Input      1 Bit         XORs := 3     
2default:defaulth px
W
%s*synth2B
.	   9 Input      1 Bit         XORs := 2     
2default:defaulth px
W
%s*synth2B
.	   7 Input      1 Bit         XORs := 3     
2default:defaulth px
:
%s*synth2%
+---Registers : 
2default:defaulth px
W
%s*synth2B
.	               32 Bit    Registers := 1     
2default:defaulth px
W
%s*synth2B
.	                8 Bit    Registers := 1     
2default:defaulth px
W
%s*synth2B
.	                1 Bit    Registers := 1     
2default:defaulth px
6
%s*synth2!
+---Muxes : 
2default:defaulth px
W
%s*synth2B
.	   8 Input     32 Bit        Muxes := 1     
2default:defaulth px
W
%s*synth2B
.	   8 Input      8 Bit        Muxes := 1     
2default:defaulth px
W
%s*synth2B
.	   8 Input      1 Bit        Muxes := 1     
2default:defaulth px
<
%s*synth2'
Module txlink_fsm 
2default:defaulth px
H
%s*synth23
Detailed RTL Component Info : 
2default:defaulth px
7
%s*synth2"
+---Adders : 
2default:defaulth px
W
%s*synth2B
.	   2 Input      9 Bit       Adders := 2     
2default:defaulth px
W
%s*synth2B
.	   2 Input      4 Bit       Adders := 2     
2default:defaulth px
W
%s*synth2B
.	   2 Input      2 Bit       Adders := 1     
2default:defaulth px
:
%s*synth2%
+---Registers : 
2default:defaulth px
W
%s*synth2B
.	                9 Bit    Registers := 2     
2default:defaulth px
W
%s*synth2B
.	                8 Bit    Registers := 1     
2default:defaulth px
W
%s*synth2B
.	                4 Bit    Registers := 1     
2default:defaulth px
W
%s*synth2B
.	                2 Bit    Registers := 1     
2default:defaulth px
W
%s*synth2B
.	                1 Bit    Registers := 7     
2default:defaulth px
6
%s*synth2!
+---Muxes : 
2default:defaulth px
W
%s*synth2B
.	   6 Input      9 Bit        Muxes := 1     
2default:defaulth px
W
%s*synth2B
.	   2 Input      8 Bit        Muxes := 1     
2default:defaulth px
W
%s*synth2B
.	   4 Input      8 Bit        Muxes := 1     
2default:defaulth px
W
%s*synth2B
.	   6 Input      8 Bit        Muxes := 1     
2default:defaulth px
W
%s*synth2B
.	   2 Input      4 Bit        Muxes := 1     
2default:defaulth px
W
%s*synth2B
.	   6 Input      4 Bit        Muxes := 1     
2default:defaulth px
W
%s*synth2B
.	   6 Input      3 Bit        Muxes := 1     
2default:defaulth px
W
%s*synth2B
.	   2 Input      2 Bit        Muxes := 2     
2default:defaulth px
W
%s*synth2B
.	   5 Input      2 Bit        Muxes := 1     
2default:defaulth px
W
%s*synth2B
.	   6 Input      2 Bit        Muxes := 1     
2default:defaulth px
W
%s*synth2B
.	   2 Input      1 Bit        Muxes := 9     
2default:defaulth px
W
%s*synth2B
.	   4 Input      1 Bit        Muxes := 1     
2default:defaulth px
W
%s*synth2B
.	   6 Input      1 Bit        Muxes := 11    
2default:defaulth px
C
%s*synth2.
Module dp_dclk_ram_2rdwr 
2default:defaulth px
H
%s*synth23
Detailed RTL Component Info : 
2default:defaulth px
:
%s*synth2%
+---Registers : 
2default:defaulth px
W
%s*synth2B
.	               32 Bit    Registers := 2     
2default:defaulth px
W
%s*synth2B
.	                1 Bit    Registers := 1     
2default:defaulth px
5
%s*synth2 
+---RAMs : 
2default:defaulth px
W
%s*synth2B
.	              16K Bit         RAMs := 1     
2default:defaulth px
<
%s*synth2'
Module fifo_queue 
2default:defaulth px
H
%s*synth23
Detailed RTL Component Info : 
2default:defaulth px
7
%s*synth2"
+---Adders : 
2default:defaulth px
W
%s*synth2B
.	   3 Input      5 Bit       Adders := 1     
2default:defaulth px
W
%s*synth2B
.	   2 Input      4 Bit       Adders := 3     
2default:defaulth px
:
%s*synth2%
+---Registers : 
2default:defaulth px
W
%s*synth2B
.	                9 Bit    Registers := 17    
2default:defaulth px
W
%s*synth2B
.	                5 Bit    Registers := 1     
2default:defaulth px
W
%s*synth2B
.	                4 Bit    Registers := 2     
2default:defaulth px
W
%s*synth2B
.	                1 Bit    Registers := 2     
2default:defaulth px
6
%s*synth2!
+---Muxes : 
2default:defaulth px
W
%s*synth2B
.	   2 Input      9 Bit        Muxes := 2     
2default:defaulth px
W
%s*synth2B
.	   3 Input      1 Bit        Muxes := 1     
2default:defaulth px
W
%s*synth2B
.	   2 Input      1 Bit        Muxes := 16    
2default:defaulth px
@
%s*synth2+
Module dclk_transport 
2default:defaulth px
H
%s*synth23
Detailed RTL Component Info : 
2default:defaulth px
:
%s*synth2%
+---Registers : 
2default:defaulth px
W
%s*synth2B
.	                1 Bit    Registers := 5     
2default:defaulth px
6
%s*synth2!
+---Muxes : 
2default:defaulth px
W
%s*synth2B
.	   2 Input      1 Bit        Muxes := 1     
2default:defaulth px
P
%s*synth2;
'Module dclk_transport__parameterized1 
2default:defaulth px
H
%s*synth23
Detailed RTL Component Info : 
2default:defaulth px
:
%s*synth2%
+---Registers : 
2default:defaulth px
W
%s*synth2B
.	                9 Bit    Registers := 2     
2default:defaulth px
W
%s*synth2B
.	                1 Bit    Registers := 3     
2default:defaulth px
6
%s*synth2!
+---Muxes : 
2default:defaulth px
W
%s*synth2B
.	   2 Input      1 Bit        Muxes := 1     
2default:defaulth px
@
%s*synth2+
Module eth100_link_tx 
2default:defaulth px
H
%s*synth23
Detailed RTL Component Info : 
2default:defaulth px
:
%s*synth2%
+---Registers : 
2default:defaulth px
W
%s*synth2B
.	               32 Bit    Registers := 2     
2default:defaulth px
W
%s*synth2B
.	                9 Bit    Registers := 1     
2default:defaulth px
W
%s*synth2B
.	                1 Bit    Registers := 4     
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
X
%s*synth2C
/Finished RTL Hierarchical Component Statistics
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
E
%s*synth20
Start Part Resource Summary
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
�
%s*synth2k
WPart Resources:
DSPs: 220 (col length:60)
BRAMs: 280 (col length: RAMB18 60 RAMB36 30)
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
H
%s*synth23
Finished Part Resource Summary
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
�
%s*synth2�
�Start Parallel Synthesis Optimization  : Time (s): cpu = 00:00:18 ; elapsed = 00:00:18 . Memory (MB): peak = 1238.031 ; gain = 285.219 ; free physical = 2605 ; free virtual = 6607
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
K
%s*synth26
"Start Cross Boundary Optimization
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
s
8ROM "%s" won't be mapped to RAM because it is too sparse3998*oasys2
pf_enq2default:defaultZ8-5546h px
s
8ROM "%s" won't be mapped to RAM because it is too sparse3998*oasys2
pf_enq2default:defaultZ8-5546h px
�
!design %s has unconnected port %s3331*oasys2(
iptop_eth100_link_tx2default:default2

m1_addr[1]2default:defaultZ8-3331h px
�
!design %s has unconnected port %s3331*oasys2(
iptop_eth100_link_tx2default:default2

m1_addr[0]2default:defaultZ8-3331h px
�
!design %s has unconnected port %s3331*oasys2(
iptop_eth100_link_tx2default:default2

mr_wdt[30]2default:defaultZ8-3331h px
�
!design %s has unconnected port %s3331*oasys2(
iptop_eth100_link_tx2default:default2

mr_wdt[29]2default:defaultZ8-3331h px
�
!design %s has unconnected port %s3331*oasys2(
iptop_eth100_link_tx2default:default2

mr_wdt[28]2default:defaultZ8-3331h px
�
!design %s has unconnected port %s3331*oasys2(
iptop_eth100_link_tx2default:default2

mr_wdt[27]2default:defaultZ8-3331h px
�
!design %s has unconnected port %s3331*oasys2(
iptop_eth100_link_tx2default:default2

mr_wdt[26]2default:defaultZ8-3331h px
�
!design %s has unconnected port %s3331*oasys2(
iptop_eth100_link_tx2default:default2

mr_wdt[25]2default:defaultZ8-3331h px
�
!design %s has unconnected port %s3331*oasys2(
iptop_eth100_link_tx2default:default2

mr_wdt[24]2default:defaultZ8-3331h px
�
!design %s has unconnected port %s3331*oasys2(
iptop_eth100_link_tx2default:default2

mr_wdt[23]2default:defaultZ8-3331h px
�
!design %s has unconnected port %s3331*oasys2(
iptop_eth100_link_tx2default:default2

mr_wdt[22]2default:defaultZ8-3331h px
�
!design %s has unconnected port %s3331*oasys2(
iptop_eth100_link_tx2default:default2

mr_wdt[21]2default:defaultZ8-3331h px
�
!design %s has unconnected port %s3331*oasys2(
iptop_eth100_link_tx2default:default2

mr_wdt[20]2default:defaultZ8-3331h px
�
!design %s has unconnected port %s3331*oasys2(
iptop_eth100_link_tx2default:default2

mr_wdt[19]2default:defaultZ8-3331h px
�
!design %s has unconnected port %s3331*oasys2(
iptop_eth100_link_tx2default:default2

mr_wdt[18]2default:defaultZ8-3331h px
�
!design %s has unconnected port %s3331*oasys2(
iptop_eth100_link_tx2default:default2

mr_wdt[17]2default:defaultZ8-3331h px
�
!design %s has unconnected port %s3331*oasys2(
iptop_eth100_link_tx2default:default2

mr_wdt[16]2default:defaultZ8-3331h px
�
!design %s has unconnected port %s3331*oasys2(
iptop_eth100_link_tx2default:default2

mr_wdt[15]2default:defaultZ8-3331h px
�
!design %s has unconnected port %s3331*oasys2(
iptop_eth100_link_tx2default:default2

mr_wdt[14]2default:defaultZ8-3331h px
�
!design %s has unconnected port %s3331*oasys2(
iptop_eth100_link_tx2default:default2

mr_wdt[13]2default:defaultZ8-3331h px
�
!design %s has unconnected port %s3331*oasys2(
iptop_eth100_link_tx2default:default2

mr_wdt[12]2default:defaultZ8-3331h px
�
!design %s has unconnected port %s3331*oasys2(
iptop_eth100_link_tx2default:default2

mr_wdt[11]2default:defaultZ8-3331h px
�
!design %s has unconnected port %s3331*oasys2(
iptop_eth100_link_tx2default:default2

mr_wdt[10]2default:defaultZ8-3331h px
�
!design %s has unconnected port %s3331*oasys2(
iptop_eth100_link_tx2default:default2
	mr_wdt[9]2default:defaultZ8-3331h px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
�
%s*synth2�
�Finished Cross Boundary Optimization : Time (s): cpu = 00:00:19 ; elapsed = 00:00:19 . Memory (MB): peak = 1246.031 ; gain = 293.219 ; free physical = 2598 ; free virtual = 6600
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
�
%s*synth2�
�Finished Parallel Reinference  : Time (s): cpu = 00:00:19 ; elapsed = 00:00:19 . Memory (MB): peak = 1246.031 ; gain = 293.219 ; free physical = 2598 ; free virtual = 6600
2default:defaulth px
B
%s*synth2-

Report RTL Partitions: 
2default:defaulth px
T
%s*synth2?
++-+--------------+------------+----------+
2default:defaulth px
T
%s*synth2?
+| |RTL Partition |Replication |Instances |
2default:defaulth px
T
%s*synth2?
++-+--------------+------------+----------+
2default:defaulth px
T
%s*synth2?
++-+--------------+------------+----------+
2default:defaulth px
�
%s*synth2�
�---------------------------------------------------------------------------------
Start ROM, RAM, DSP and Shift Register Reporting
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
5
%s*synth2 

Block RAM:
2default:defaulth px
�
%s*synth2�
�+---------------------+------------------------+------------------------+---+---+------------------------+---+---+--------------+--------+--------+--------------------------------+
2default:defaulth px
�
%s*synth2�
�|Module Name          | RTL Object             | PORT A (Depth x Width) | W | R | PORT B (Depth x Width) | W | R | OUT_REG      | RAMB18 | RAMB36 | Hierarchical Name              | 
2default:defaulth px
�
%s*synth2�
�+---------------------+------------------------+------------------------+---+---+------------------------+---+---+--------------+--------+--------+--------------------------------+
2default:defaulth px
�
%s*synth2�
�|iptop_eth100_link_tx | linktx/fbuf/memory_reg | 512 x 32(READ_FIRST)   | W | R | 512 x 32(WRITE_FIRST)  |   | R | Port A and B | 0      | 1      | iptop_eth100_link_tx/extram__2 | 
2default:defaulth px
�
%s*synth2�
�+---------------------+------------------------+------------------------+---+---+------------------------+---+---+--------------+--------+--------+--------------------------------+

2default:defaulth px
�
%s*synth2�
�Note: The table above shows the Block RAMs at the current stage of the synthesis flow. Some Block RAMs may be reimplemented as non Block RAM primitives later in the synthesis flow. Multiple instantiated Block RAMs are reported only once. "Hierarchical Name" reflects the Block RAM name as it appears in the hierarchical module and only part of it is displayed.
2default:defaulth px
�
%s*synth2�
�---------------------------------------------------------------------------------
Finished ROM, RAM, DSP and Shift Register Reporting
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
A
%s*synth2,
Start Area Optimization
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
�
"merging instance '%s' (%s) to '%s'3436*oasys29
%\linktx/pfqueue/r_reg[fifo_level][4] 2default:default2
FDR2default:default25
!\linktx/pfqueue/r_reg[fifo_full] 2default:defaultZ8-3886h px
�
ESequential element (%s) is unused and will be removed from module %s.3332*oasys21
\linktx/bs2rmii/r_reg[dv][0] 2default:default2(
iptop_eth100_link_tx2default:defaultZ8-3332h px
�
ESequential element (%s) is unused and will be removed from module %s.3332*oasys29
%\linktx/pfqueue/r_reg[fifo_level][4] 2default:default2(
iptop_eth100_link_tx2default:defaultZ8-3332h px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
�
%s*synth2�
�Finished Area Optimization : Time (s): cpu = 00:00:21 ; elapsed = 00:00:21 . Memory (MB): peak = 1274.664 ; gain = 321.852 ; free physical = 2566 ; free virtual = 6568
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
�
%s*synth2�
�Finished Parallel Area Optimization  : Time (s): cpu = 00:00:21 ; elapsed = 00:00:21 . Memory (MB): peak = 1274.664 ; gain = 321.852 ; free physical = 2566 ; free virtual = 6568
2default:defaulth px
B
%s*synth2-

Report RTL Partitions: 
2default:defaulth px
T
%s*synth2?
++-+--------------+------------+----------+
2default:defaulth px
T
%s*synth2?
+| |RTL Partition |Replication |Instances |
2default:defaulth px
T
%s*synth2?
++-+--------------+------------+----------+
2default:defaulth px
T
%s*synth2?
++-+--------------+------------+----------+
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
C
%s*synth2.
Start Timing Optimization
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
�
%s*synth2�
�Finished Timing Optimization : Time (s): cpu = 00:00:21 ; elapsed = 00:00:21 . Memory (MB): peak = 1274.664 ; gain = 321.852 ; free physical = 2566 ; free virtual = 6568
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
�
%s*synth2�
�Finished Parallel Timing Optimization  : Time (s): cpu = 00:00:21 ; elapsed = 00:00:21 . Memory (MB): peak = 1274.664 ; gain = 321.852 ; free physical = 2566 ; free virtual = 6568
2default:defaulth px
B
%s*synth2-

Report RTL Partitions: 
2default:defaulth px
T
%s*synth2?
++-+--------------+------------+----------+
2default:defaulth px
T
%s*synth2?
+| |RTL Partition |Replication |Instances |
2default:defaulth px
T
%s*synth2?
++-+--------------+------------+----------+
2default:defaulth px
T
%s*synth2?
++-+--------------+------------+----------+
2default:defaulth px
�
%s*synth2�
�Finished Parallel Synthesis Optimization  : Time (s): cpu = 00:00:21 ; elapsed = 00:00:21 . Memory (MB): peak = 1274.664 ; gain = 321.852 ; free physical = 2566 ; free virtual = 6568
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
B
%s*synth2-
Start Technology Mapping
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
�
�The timing for the instance %s (implemented as a block RAM) might be sub-optimal as no optional output register could be merged into the block ram. Providing additional output register may help in improving timing.
3630*oasys2,
\linktx/fbuf/memory_reg 2default:defaultZ8-4480h px
�
�The timing for the instance %s (implemented as a block RAM) might be sub-optimal as no optional output register could be merged into the block ram. Providing additional output register may help in improving timing.
3630*oasys2,
\linktx/fbuf/memory_reg 2default:defaultZ8-4480h px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
�
%s*synth2�
�Finished Technology Mapping : Time (s): cpu = 00:00:21 ; elapsed = 00:00:21 . Memory (MB): peak = 1282.672 ; gain = 329.859 ; free physical = 2563 ; free virtual = 6565
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
B
%s*synth2-

Report RTL Partitions: 
2default:defaulth px
T
%s*synth2?
++-+--------------+------------+----------+
2default:defaulth px
T
%s*synth2?
+| |RTL Partition |Replication |Instances |
2default:defaulth px
T
%s*synth2?
++-+--------------+------------+----------+
2default:defaulth px
T
%s*synth2?
++-+--------------+------------+----------+
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
<
%s*synth2'
Start IO Insertion
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
N
%s*synth29
%Start Flattening Before IO Insertion
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
Q
%s*synth2<
(Finished Flattening Before IO Insertion
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
E
%s*synth20
Start Final Netlist Cleanup
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
H
%s*synth23
Finished Final Netlist Cleanup
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
�
%s*synth2�
�Finished IO Insertion : Time (s): cpu = 00:00:22 ; elapsed = 00:00:22 . Memory (MB): peak = 1282.672 ; gain = 329.859 ; free physical = 2563 ; free virtual = 6565
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
A
%s*synth2,

Report Check Netlist: 
2default:defaulth px
r
%s*synth2]
I+------+------------------+-------+---------+-------+------------------+
2default:defaulth px
r
%s*synth2]
I|      |Item              |Errors |Warnings |Status |Description       |
2default:defaulth px
r
%s*synth2]
I+------+------------------+-------+---------+-------+------------------+
2default:defaulth px
r
%s*synth2]
I|1     |multi_driven_nets |      0|        0|Passed |Multi driven nets |
2default:defaulth px
r
%s*synth2]
I+------+------------------+-------+---------+-------+------------------+
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
L
%s*synth27
#Start Renaming Generated Instances
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
�
%s*synth2�
�Finished Renaming Generated Instances : Time (s): cpu = 00:00:22 ; elapsed = 00:00:22 . Memory (MB): peak = 1282.672 ; gain = 329.859 ; free physical = 2563 ; free virtual = 6565
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
B
%s*synth2-

Report RTL Partitions: 
2default:defaulth px
T
%s*synth2?
++-+--------------+------------+----------+
2default:defaulth px
T
%s*synth2?
+| |RTL Partition |Replication |Instances |
2default:defaulth px
T
%s*synth2?
++-+--------------+------------+----------+
2default:defaulth px
T
%s*synth2?
++-+--------------+------------+----------+
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
I
%s*synth24
 Start Rebuilding User Hierarchy
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
�
%s*synth2�
�Finished Rebuilding User Hierarchy : Time (s): cpu = 00:00:22 ; elapsed = 00:00:22 . Memory (MB): peak = 1282.672 ; gain = 329.859 ; free physical = 2563 ; free virtual = 6565
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
H
%s*synth23
Start Renaming Generated Ports
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
�
%s*synth2�
�Finished Renaming Generated Ports : Time (s): cpu = 00:00:22 ; elapsed = 00:00:22 . Memory (MB): peak = 1282.672 ; gain = 329.859 ; free physical = 2563 ; free virtual = 6565
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
J
%s*synth25
!Start Handling Custom Attributes
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
�
%s*synth2�
�Finished Handling Custom Attributes : Time (s): cpu = 00:00:22 ; elapsed = 00:00:22 . Memory (MB): peak = 1282.672 ; gain = 329.859 ; free physical = 2563 ; free virtual = 6565
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
G
%s*synth22
Start Renaming Generated Nets
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
�
%s*synth2�
�Finished Renaming Generated Nets : Time (s): cpu = 00:00:22 ; elapsed = 00:00:22 . Memory (MB): peak = 1282.672 ; gain = 329.859 ; free physical = 2563 ; free virtual = 6565
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
H
%s*synth23
Start Writing Synthesis Report
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
>
%s*synth2)

Report BlackBoxes: 
2default:defaulth px
G
%s*synth22
+-+--------------+----------+
2default:defaulth px
G
%s*synth22
| |BlackBox name |Instances |
2default:defaulth px
G
%s*synth22
+-+--------------+----------+
2default:defaulth px
G
%s*synth22
+-+--------------+----------+
2default:defaulth px
>
%s*synth2)

Report Cell Usage: 
2default:defaulth px
C
%s*synth2.
+------+---------+------+
2default:defaulth px
C
%s*synth2.
|      |Cell     |Count |
2default:defaulth px
C
%s*synth2.
+------+---------+------+
2default:defaulth px
C
%s*synth2.
|1     |BUFG     |     2|
2default:defaulth px
C
%s*synth2.
|2     |CARRY4   |    19|
2default:defaulth px
C
%s*synth2.
|3     |LUT1     |    67|
2default:defaulth px
C
%s*synth2.
|4     |LUT2     |    35|
2default:defaulth px
C
%s*synth2.
|5     |LUT3     |    53|
2default:defaulth px
C
%s*synth2.
|6     |LUT4     |    63|
2default:defaulth px
C
%s*synth2.
|7     |LUT5     |    67|
2default:defaulth px
C
%s*synth2.
|8     |LUT6     |   150|
2default:defaulth px
C
%s*synth2.
|9     |RAMB36E1 |     1|
2default:defaulth px
C
%s*synth2.
|10    |FDRE     |   530|
2default:defaulth px
C
%s*synth2.
|11    |IBUF     |    66|
2default:defaulth px
C
%s*synth2.
|12    |OBUF     |    67|
2default:defaulth px
C
%s*synth2.
+------+---------+------+
2default:defaulth px
B
%s*synth2-

Report Instance Areas: 
2default:defaulth px
l
%s*synth2W
C+------+------------------+-------------------------------+------+
2default:defaulth px
l
%s*synth2W
C|      |Instance          |Module                         |Cells |
2default:defaulth px
l
%s*synth2W
C+------+------------------+-------------------------------+------+
2default:defaulth px
l
%s*synth2W
C|1     |top               |                               |  1120|
2default:defaulth px
l
%s*synth2W
C|2     |  linktx          |eth100_link_tx                 |   880|
2default:defaulth px
l
%s*synth2W
C|3     |    bs2rmii       |bytestream_to_rmii             |    21|
2default:defaulth px
l
%s*synth2W
C|4     |    fbuf          |dp_dclk_ram_2rdwr              |    51|
2default:defaulth px
l
%s*synth2W
C|5     |    pfdeq_dclk    |dclk_transport                 |     5|
2default:defaulth px
l
%s*synth2W
C|6     |    pfqueue       |fifo_queue                     |   275|
2default:defaulth px
l
%s*synth2W
C|7     |    rf_dclk       |dclk_transport__parameterized1 |    36|
2default:defaulth px
l
%s*synth2W
C|8     |    txlnkfsm      |txlink_fsm                     |   240|
2default:defaulth px
l
%s*synth2W
C|9     |      fcs_checker |CRC                            |   128|
2default:defaulth px
l
%s*synth2W
C+------+------------------+-------------------------------+------+
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
�
%s*synth2�
�Finished Writing Synthesis Report : Time (s): cpu = 00:00:22 ; elapsed = 00:00:22 . Memory (MB): peak = 1282.672 ; gain = 329.859 ; free physical = 2563 ; free virtual = 6565
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
p
%s*synth2[
GSynthesis finished with 0 errors, 0 critical warnings and 52 warnings.
2default:defaulth px
�
%s*synth2�
�Synthesis Optimization Runtime : Time (s): cpu = 00:00:20 ; elapsed = 00:00:19 . Memory (MB): peak = 1282.672 ; gain = 238.059 ; free physical = 2563 ; free virtual = 6565
2default:defaulth px
�
%s*synth2�
�Synthesis Optimization Complete : Time (s): cpu = 00:00:22 ; elapsed = 00:00:22 . Memory (MB): peak = 1282.672 ; gain = 329.859 ; free physical = 2563 ; free virtual = 6565
2default:defaulth px
?
 Translating synthesized netlist
350*projectZ1-571h px
c
-Analyzing %s Unisim elements for replacement
17*netlist2
862default:defaultZ29-17h px
g
2Unisim Transformation completed in %s CPU seconds
28*netlist2
02default:defaultZ29-28h px
H
)Preparing netlist for logic optimization
349*projectZ1-570h px
r
)Pushed %s inverter(s) to %s load pin(s).
98*opt2
02default:default2
02default:defaultZ31-138h px
{
!Unisim Transformation Summary:
%s111*project29
%No Unisim elements were transformed.
2default:defaultZ1-111h px
R
Releasing license: %s
83*common2
	Synthesis2default:defaultZ17-83h px
�
G%s Infos, %s Warnings, %s Critical Warnings and %s Errors encountered.
28*	vivadotcl2
692default:default2
522default:default2
02default:default2
02default:defaultZ4-41h px
[
%s completed successfully
29*	vivadotcl2 
synth_design2default:defaultZ4-42h px
�
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2"
synth_design: 2default:default2
00:00:222default:default2
00:00:222default:default2
1362.6842default:default2
338.6522default:default2
24882default:default2
65032default:defaultZ17-722h px
�
�report_utilization: Time (s): cpu = 00:00:00.04 ; elapsed = 00:00:00.09 . Memory (MB): peak = 1394.703 ; gain = 0.000 ; free physical = 2486 ; free virtual = 6502
*commonh px
}
Exiting %s at %s...
206*common2
Vivado2default:default2,
Thu Dec 24 13:33:53 20152default:defaultZ17-206h px