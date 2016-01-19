-----------------------------------------------------------------------
    -- (c) Copyright 1984 - 2012 Xilinx, Inc. All rights reserved.
    --
    -- This file contains confidential and proprietary information
    -- of Xilinx, Inc. and is protected under U.S. and
    -- international copyright and other intellectual property
    -- laws.
    --
    -- DISCLAIMER
    -- This disclaimer is not a license and does not grant any
    -- rights to the materials distributed herewith. Except as
    -- otherwise provided in a valid license issued to you by
    -- Xilinx, and to the maximum extent permitted by applicable
    -- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
    -- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
    -- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
    -- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
    -- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
    -- (2) Xilinx shall not be liable (whether in contract or tort,
    -- including negligence, or under any other theory of
    -- liability) for any loss or damage of any kind or nature
    -- related to, arising under or in connection with these
    -- materials, including for any direct, or any indirect,
    -- special, incidental, or consequential loss or damage
    -- (including loss of data, profits, goodwill, or any type of
    -- loss or damage suffered as a result of any action brought
    -- by a third party) even if such damage or loss was
    -- reasonably foreseeable or Xilinx had been advised of the
    -- possibility of the same.
    --
    -- CRITICAL APPLICATIONS
    -- Xilinx products are not designed or intended to be fail-
    -- safe, or for use in any application requiring fail-safe
    -- performance, such as life-support or safety devices or
    -- systems, Class III medical devices, nuclear facilities,
    -- applications related to the deployment of airbags, or any
    -- other applications that could lead to death, personal
    -- injury, or severe property or environmental damage
    -- (individually and collectively, "Critical
    -- Applications"). Customer assumes the sole risk and
    -- liability of any use of Xilinx products in Critical
    -- Applications, subject only to applicable laws and
    -- regulations governing limitations on product liability.
    --
    -- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
    -- PART OF THIS FILE AT ALL TIMES.
-----------------------------------------------------------------------
-- Filename:        rx_fifo_loader.vhd
--
-- Version:         v1.01.a
-- Description:     This module
--
------------------------------------------------------------------------------
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library mii_to_rmii_v2_0_8;

------------------------------------------------------------------------------
-- Port Declaration
------------------------------------------------------------------------------

entity rx_fifo_loader is
    generic (
            C_RESET_ACTIVE    :  std_logic
            );

    port    (
            Sync_rst_n        :  in   std_logic;
            Ref_Clk           :  in   std_logic;
            Phy2Rmii_crs_dv   :  in   std_logic;
            Phy2Rmii_rx_er    :  in   std_logic;
            Phy2Rmii_rxd      :  in   std_logic_vector(1  downto  0);
            Rx_fifo_wr_en     :  out  std_logic;
            Rx_10             :  out  std_logic;
            Rx_100            :  out  std_logic;
            Rx_data           :  out  std_logic_vector(7  downto  0);
            Rx_error          :  out  std_logic;
            Rx_data_valid     :  out  std_logic;
            Rx_cary_sense     :  out  std_logic;
            Rx_end_of_packet  :  out  std_logic
            );
end rx_fifo_loader;

------------------------------------------------------------------------------
-- Definition of Generics:
--
-- Definition of Ports:
--
------------------------------------------------------------------------------

architecture simulation of rx_fifo_loader is

attribute DowngradeIPIdentifiedWarnings: string;

attribute DowngradeIPIdentifiedWarnings of simulation : architecture is "yes";

type   STATES_TYPE  is (
                       IPG,
                       PREAMBLE,
                       PREAMBLE_10,
                       RX100,
                       RX10
                       );

signal  present_state        :  STATES_TYPE;
signal  next_state           :  STATES_TYPE;
signal  rx_cary_sense_i      :  std_logic;
signal  rx_data_valid_i      :  std_logic;
signal  rx_end_of_packet_i   :  std_logic;
signal  repeated_data_cnt    :  integer   range  0  to  63;
signal  phy2rmii_rxd_d1      :  std_logic_vector(1  downto  0);
signal  phy2rmii_rxd_d2      :  std_logic_vector(1  downto  0);
signal  phy2Rmii_crs_dv_sr   :  std_logic_vector(22 downto 0);
signal  dibit_cnt            :  std_logic_vector(3  downto  0);
signal  sample_rxd_cnt       :  std_logic_vector(4  downto  0);
signal  sample_rxd           :  std_logic;
signal  rxd_is_idle          :  std_logic;
signal  rxd_is_preamble      :  std_logic;
signal  rxd_is_preamble10    :  std_logic;
signal  rxd_10_i             :  std_logic;
signal  rxd_100_i            :  std_logic;

begin

------------------------------------------------------------------------------
-- RMII_CRS_DV_PIPELINE_PROCESS
------------------------------------------------------------------------------

--RMII_CRS_DV_PIPELINE_PROCESS : process ( Ref_Clk )
--begin
--    if (Ref_Clk'event and Ref_Clk = '1') then
--        if (Sync_rst_n = '0') then
--            phy2Rmii_crs_dv_sr <= (others => '0');
--        else
--            phy2Rmii_crs_dv_sr <= phy2Rmii_crs_dv_sr(21 downto 0) &
--                                  Phy2Rmii_crs_dv;
--        end if;
--    end if;
--end process;

------------------------------------------------------------------------------
-- RX_CARRY_SENSE_DATA_VALID_END_OF_PACKET_PROCESS
------------------------------------------------------------------------------
-- Include comments about the function of the process
------------------------------------------------------------------------------

RX_CARRY_SENSE_DATA_VALID_END_OF_PACKET_PROCESS : process ( Ref_Clk )
begin
    if (Ref_Clk'event and Ref_Clk = '1') then
        if (Sync_rst_n = '0') then
            Rx_error            <=  '0';
            Rx_cary_sense       <=  '0';
            rx_cary_sense_i     <=  '0';
            rx_end_of_packet_i  <=  '0';
            Rx_data_valid       <=  '0';
            phy2Rmii_crs_dv_sr  <= (others => '0');
        else
            Rx_error            <=  Phy2Rmii_rx_er;
            Rx_cary_sense       <=  rx_cary_sense_i;
            Rx_data_valid       <=  rx_data_valid_i;
            rx_end_of_packet_i  <=  (rxd_100_i and not Phy2Rmii_crs_dv and not phy2Rmii_crs_dv_sr(0)) or
                                    (rxd_10_i  and not Phy2Rmii_crs_dv and not phy2Rmii_crs_dv_sr(9));
                                     
            rx_cary_sense_i     <=  (Phy2Rmii_crs_dv and rx_cary_sense_i) or 
                                    (Phy2Rmii_crs_dv and not rxd_10_i and not 
                                     phy2Rmii_crs_dv_sr(0) and not phy2Rmii_crs_dv_sr(1)) or
                                    (Phy2Rmii_crs_dv and not rxd_100_i and not
                                     phy2Rmii_crs_dv_sr(0) and not phy2Rmii_crs_dv_sr(11));
                                     
            phy2Rmii_crs_dv_sr  <=  phy2Rmii_crs_dv_sr(21 downto 0) & Phy2Rmii_crs_dv;
        end if;

        if (Sync_rst_n = '0') then
            rx_data_valid_i <=  '0';
        elsif (rx_data_valid_i = '0') then
            rx_data_valid_i <= Phy2Rmii_crs_dv  or  phy2Rmii_crs_dv_sr(0);
        elsif (rx_data_valid_i = '1') then
            rx_data_valid_i <= not rx_end_of_packet_i;
        end if;
    end if;
end process;

Rx_end_of_packet <= rx_end_of_packet_i;

---------------------------------------------------------------------------
-- RXD_PIPELINE_DELAY_PROCESS
---------------------------------------------------------------------------

RXD_PIPELINE_DELAY_PROCESS : process ( Ref_Clk )
begin
    if (Ref_Clk'event and Ref_Clk = '1') then

        if (Sync_rst_n = C_RESET_ACTIVE) then
            phy2rmii_rxd_d2  <=  (others => '0');
            phy2rmii_rxd_d1  <=  (others => '0');
        else
            phy2rmii_rxd_d2  <=  phy2rmii_rxd_d1;
            phy2rmii_rxd_d1  <=  Phy2Rmii_rxd;
        end if;

    end if;
end process;

---------------------------------------------------------------------------
-- REPEATED_DATA_CNT_PROCESS
---------------------------------------------------------------------------

REPEATED_DATA_CNT_PROCESS : process ( Ref_Clk )
begin
    if (Ref_Clk'event and Ref_Clk = '1') then
        if (Sync_rst_n = C_RESET_ACTIVE) then
            repeated_data_cnt  <=  0;
        elsif (phy2rmii_rxd_d1 = Phy2Rmii_rxd) then
            if (repeated_data_cnt = 63) then
                repeated_data_cnt  <=  63;
            else
                repeated_data_cnt  <=  repeated_data_cnt + 1;
            end if;
        else
            repeated_data_cnt  <=  0;
        end if;
    end if;
end process;

---------------------------------------------------------------------------
-- SAMPLE_RXD_CNT_PROCESS
---------------------------------------------------------------------------

SAMPLE_RXD_CNT_PROCESS : process ( Ref_Clk )
begin
    if (Ref_Clk'event and Ref_Clk = '1') then
        if (Sync_rst_n = C_RESET_ACTIVE) then
            sample_rxd_cnt  <=  "00000";
            sample_rxd      <=  '0';
        elsif (rxd_10_i = '1') then
            if (sample_rxd_cnt =  "00000") then
                sample_rxd  <=  '1';
            else
                sample_rxd  <=  '0';
            end if;
            sample_rxd_cnt  <=  sample_rxd_cnt(3 downto 0) & not sample_rxd_cnt(4);
        elsif (rxd_is_preamble10 = '1') then
            sample_rxd_cnt  <=  "10000";
        else
            sample_rxd_cnt  <=  "00001";
            sample_rxd      <=  '1';
        end if;
    end if;
end process;

---------------------------------------------------------------------------
-- DIBIT_CNT_PROCESS
---------------------------------------------------------------------------

DIBIT_CNT_PROCESS : process ( Ref_Clk )
begin
    if (Ref_Clk'event and Ref_Clk = '1') then

        if ((Sync_rst_n = '0') or (rxd_is_idle = '1')) then
            dibit_cnt  <=  "0001";
        elsif (rxd_is_preamble10 = '1') then
            dibit_cnt  <=  "0100";
        elsif ((sample_rxd = '1') and (rxd_is_idle = '0')) then
            dibit_cnt  <=  dibit_cnt(2 downto 0) & (dibit_cnt(3));
        end if;

    end if;
end process;

---------------------------------------------------------------------------
-- DIBIT_TO_BYTE_MAPPING_PROCESS
---------------------------------------------------------------------------

DIBIT_TO_BYTE_MAPPING_PROCESS : process ( Ref_Clk )
begin
    if (Ref_Clk'event and Ref_Clk = '1') then

        if (Sync_rst_n = C_RESET_ACTIVE) then
            Rx_data     <=  (others => '0');
        elsif (dibit_cnt(0) = '1') then
            Rx_data(0)  <=  phy2rmii_rxd_d2(0);
            Rx_data(1)  <=  phy2rmii_rxd_d2(1);
        elsif (dibit_cnt(1) = '1') then
            Rx_data(2)  <=  phy2rmii_rxd_d2(0);
            Rx_data(3)  <=  phy2rmii_rxd_d2(1);
        elsif (dibit_cnt(2) = '1') then
            Rx_data(4)  <=  phy2rmii_rxd_d2(0);
            Rx_data(5)  <=  phy2rmii_rxd_d2(1);
        elsif (dibit_cnt(3) = '1') then
            Rx_data(6)  <=  phy2rmii_rxd_d2(0);
            Rx_data(7)  <=  phy2rmii_rxd_d2(1);
        end if;

    end if;
end process;

---------------------------------------------------------------------------
-- WR_FIFO_EN_PROCESS
---------------------------------------------------------------------------

WR_FIFO_EN_PROCESS : process ( Ref_Clk )
begin
    if (Ref_Clk'event and Ref_Clk = '1') then

        if (Sync_rst_n = '0') then
            Rx_fifo_wr_en  <=  '0';
        elsif ((sample_rxd = '1') and (dibit_cnt(3) = '1') and (rxd_is_idle = '0') and
	                                        (rxd_is_preamble10 = '0')) then
            Rx_fifo_wr_en  <=  '1';
        else
            Rx_fifo_wr_en  <=  '0';
        end if;

    end if;
end process;

------------------------------------------------------------------------------
-- State Machine SYNC_PROCESS
------------------------------------------------------------------------------
-- Include comments about the function of the process
------------------------------------------------------------------------------

SYNC_PROCESS : process ( Ref_Clk )
begin
    if (Ref_Clk'event and Ref_Clk = '1') then

        if (sync_rst_n = C_RESET_ACTIVE) then
            present_state  <=  IPG;
        else
            present_state  <=  next_state;
        end if;

        case next_state is

           when IPG  =>
               rxd_is_idle        <=  '1';
               rxd_is_preamble    <=  '0';
               rxd_is_preamble10  <=  '0';
               rxd_100_i          <=  '0';
               rxd_10_i           <=  '0';

           when PREAMBLE =>
               rxd_is_idle        <=  '0';
               rxd_is_preamble    <=  '1';
               rxd_is_preamble10  <=  '0';
               rxd_100_i          <=  '0';
               rxd_10_i           <=  '0';

           when PREAMBLE_10 =>
               rxd_is_idle        <=  '0';
               rxd_is_preamble    <=  '0';
               rxd_is_preamble10  <=  '1';
               rxd_100_i          <=  '0';
               rxd_10_i           <=  '0';

           when RX100 =>
               rxd_is_idle        <=  '0';
               rxd_is_preamble    <=  '0';
               rxd_is_preamble10  <=  '0';
               rxd_100_i          <=  '1';
               rxd_10_i           <=  '0';

           when RX10 =>
               rxd_is_idle        <=  '0';
               rxd_is_preamble    <=  '0';
               rxd_is_preamble10  <=  '0';
               rxd_100_i          <=  '0';
               rxd_10_i           <=  '1';

        end case;
    end if;
end process;

------------------------------------------------------------------------------
-- State Machine NEXT_STATE_PROCESS
------------------------------------------------------------------------------

NEXT_STATE_PROCESS : process (
                             present_state,
                             repeated_data_cnt,
                             phy2rmii_rxd_d1,
                             Phy2Rmii_rxd,
                             Phy2Rmii_crs_dv,
                             rx_data_valid_i
                             )

begin
    case present_state is

       when IPG  =>
           if ((Phy2Rmii_crs_dv = '1') and (Phy2Rmii_rxd = "01") and (phy2rmii_rxd_d1 = "01")) then
               next_state  <=  PREAMBLE;
           else
               next_state  <=  IPG;
           end if;

       when PREAMBLE  =>
           if ((Phy2Rmii_crs_dv = '1') and (repeated_data_cnt < 31) and (Phy2Rmii_rxd = "11")) then
               next_state  <=  RX100;
           elsif ((Phy2Rmii_crs_dv = '1') and (repeated_data_cnt > 30) and (phy2rmii_rxd_d1 = "01")) then
               next_state  <=  PREAMBLE_10;
           else
               next_state  <=  PREAMBLE;
           end if;

       when PREAMBLE_10  =>
           if ((Phy2Rmii_crs_dv = '1') and (Phy2Rmii_rxd = "11")) then
               next_state  <=  RX10;
           else
               next_state  <=  PREAMBLE_10;
           end if;

       when RX100  =>
           if (rx_data_valid_i = '0')then
               next_state  <=  IPG;
           else
               next_state  <=  RX100;
           end if;

       when RX10  =>
           if (rx_data_valid_i = '0') then
               next_state  <=  IPG;
           else
               next_state  <=  RX10;
           end if;

    end case;
end process;

------------------------------------------------------------------------------
-- Concurrent Signal Assignments
------------------------------------------------------------------------------

RX_10   <=  rxd_10_i;
RX_100  <=  rxd_100_i;

end simulation;
