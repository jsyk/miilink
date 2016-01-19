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
-- Filename:        rmii_rx_fixed.vhd
--
-- Version:         v1.01.a
-- Description:     Top level of RMII(reduced media independent interface)
--
------------------------------------------------------------------------------
------------------------------------------------------------------------------
-- Naming Conventions:
--      active low signals:                     "*_n"
--      clock signals:                          "clk", "clk_div#", "clk_#x"
--      reset signals:                          "rst", "rst_n"
--      generics:                               "C_*"
--      user defined types:                     "*_TYPE"
--      state machine next state:               "*_ns"
--      state machine current state:            "*_cs"
--      combinatorial signals:                  "*_cmb"
--      pipelined or register delay signals:    "*_d#"
--      counter signals:                        "*cnt*"
--      clock enable signals:                   "*_ce"
--      internal version of output port         "*_i"
--      device pins:                            "*_pin"
--      ports:                                  - Names begin with Uppercase
--      processes:                              "*_PROCESS"
--      component instantiations:               "<ENTITY_>I_<#|FUNC>
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

------------------------------------------------------------------------------
-- Include comments indicating reasons why packages are being used
-- Don't use ".all" - indicate which parts of the packages are used in the
-- "use" statement
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- include library containing the entities you're configuring
------------------------------------------------------------------------------

library mii_to_rmii_v2_0_8;
use mii_to_rmii_v2_0_8.all;


------------------------------------------------------------------------------
-- Port Declaration
------------------------------------------------------------------------------
-- Definition of Generics:
--          C_GEN1          -- description of generic, if description doesn't
--                          -- fit align with first part of description
--          C_GEN2          -- description of generic
--
-- Definition of Ports:
--          Port_name1      -- description of port, indicate source or
--          Port_name2      -- destination description of port
--
------------------------------------------------------------------------------

entity rmii_rx_fixed is
    generic (
            C_RESET_ACTIVE    :  std_logic     :=  '0';
            C_SPEED_100       :  std_logic     :=  '1'
            );

    port    (
            Rx_speed_100      : in    std_logic;
            ------------------  System Signals  ---------------------
            Sync_rst_n        : in    std_logic;
            Ref_Clk           : in    std_logic;
            ------------------  MII <--> RMII  ----------------------
            Rmii2Mac_rx_clk   : out   std_logic;
            Rmii2Mac_crs      : out   std_logic;
            Rmii2Mac_rx_dv    : out   std_logic;
            Rmii2Mac_rx_er    : out   std_logic;
            Rmii2Mac_rxd      : out   std_logic_vector(3  downto  0);
            ------------------  RMII <--> PHY  ----------------------
            Phy2Rmii_crs_dv   : in    std_logic;
            Phy2Rmii_rx_er    : in    std_logic;
            Phy2Rmii_rxd      : in    std_logic_vector(1  downto  0)
            );
end rmii_rx_fixed;

------------------------------------------------------------------------------
-- Configurations
------------------------------------------------------------------------------
-- No Configurations

------------------------------------------------------------------------------
-- Architecture
------------------------------------------------------------------------------

architecture simulation of rmii_rx_fixed is

attribute DowngradeIPIdentifiedWarnings: string;

attribute DowngradeIPIdentifiedWarnings of simulation : architecture is "yes";

------------------------------------------------------------------------------
-- Constant Declarations
------------------------------------------------------------------------------
-- Note that global constants and parameters (such as RESET_ACTIVE, default
-- values for address and data --widths, initialization values, etc.) should
-- be collected into a global package or include file.
-- Constants are all uppercase.
-- Constants or parameters should be used for all numeric values except for
-- single "0" or "1" values.
-- Constants should also be used when denoting a bit location within a
-- register. If no constants are required, simply state this in a comment
-- below the file section separation comments.
------------------------------------------------------------------------------

-- No Constants

------------------------------------------------------------------------------
-- Signal and Type Declarations
------------------------------------------------------------------------------

-- No Signal or Types

------------------------------------------------------------------------------
-- Component Declarations
------------------------------------------------------------------------------

-- No Components

begin

------------------------------------------------------------------------------
--
-- Conditional Generate for FIXED speed throughput of 10 Mb/s
--
------------------------------------------------------------------------------

RX_10_MBPS : if (C_SPEED_100 = '0') generate

    --------------------------------------------------------------------------
    -- Signal and Type Declarations
    --------------------------------------------------------------------------


    type   F_LDR_TYPE  is  (
                            IDLE,
                            RXD_DIB0_0,
                            RXD_DIB0_1,
                            RXD_DIB0_2,
                            RXD_DIB0_3,
                            RXD_DIB0_4,
                            RXD_DIB0_5,
                            RXD_DIB0_6,
                            RXD_DIB0_7,
                            RXD_DIB0_8,
                            RXD_DIB0_9,
                            RXD_DIB1_0,
                            RXD_DIB1_1,
                            RXD_DIB1_2,
                            RXD_DIB1_3,
                            RXD_DIB1_4,
                            RXD_DIB1_5,
                            RXD_DIB1_6,
                            RXD_DIB1_7,
                            RXD_DIB1_8,
                            RXD_DIB1_9
                           );

    type   F_UNLDR_TYPE is (
                            RX_CLK_L0,
                            RX_CLK_L1,
                            RX_CLK_L2,
                            RX_CLK_L3,
                            RX_CLK_L4,
                            RX_CLK_L5,
                            RX_CLK_L6,
                            RX_CLK_L7,
                            RX_CLK_L8,
                            RX_CLK_L9,
                            RX_CLK_H0,
                            RX_CLK_H1,
                            RX_CLK_H2,
                            RX_CLK_H3,
                            RX_CLK_H4,
                            RX_CLK_H5,
                            RX_CLK_H6,
                            RX_CLK_H7,
                            RX_CLK_H8,
                            RX_CLK_H9
                           );

    signal  fifo_ldr_cs               :  F_LDR_TYPE;
    signal  fifo_ldr_ns               :  F_LDR_TYPE;

    signal  fifo_unldr_cs             :  F_UNLDR_TYPE;
    signal  fifo_unldr_ns             :  F_UNLDR_TYPE;

    signal  rmii2Mac_crs_i            :  std_logic;
    signal  rmii2Mac_rx_er_i          :  std_logic;

    signal  rx_begin_packet           :  std_logic_vector(1 downto 0);
    signal  rx_beg_of_packet          :  std_logic;
    signal  rx_end_packet             :  std_logic_vector(1 downto 0);
    signal  rx_end_of_packet          :  std_logic;

    signal  phy2Rmii_crs_dv_sr        :  std_logic_vector(22 downto 0);

    signal  rx_out_mux_sel            :  std_logic;
    signal  rx_out_reg_en             :  std_logic;

    signal  phy2Rmii_rxd_d1           :  std_logic_vector(3 downto 0);

    signal  fIFO_Reset                :  std_logic;
    signal  fIFO_Write                :  std_logic;
    signal  fIFO_Data_In              :  std_logic_vector(4 downto 0);
    signal  fIFO_Read                 :  std_logic;
    signal  fIFO_Data_Out             :  std_logic_vector(4 downto 0);
    signal  fIFO_Data_Exists          :  std_logic;
    signal  fifo_din_dv               :  std_logic;

    signal  rxd_smpl_dibit            :  std_logic;

    begin

    --------------------------------------------------------------------------
    -- Component Instaniations
    --------------------------------------------------------------------------

    SRL_FIFO_I_1 : entity mii_to_rmii_v2_0_8.srl_fifo(IMP)
        generic map (
                     C_DATA_BITS  =>  5,
                     C_DEPTH      =>  16
                    )

        port map    (
                     Clk          =>  Ref_Clk,           -- in
                     Reset        =>  fIFO_Reset,        -- in
                     FIFO_Write   =>  fIFO_Write,        -- in
                     Data_In      =>  fIFO_Data_In,      -- in
                     FIFO_Read    =>  fIFO_Read,         -- out
                     Data_Out     =>  fIFO_Data_Out,     -- out
                     FIFO_Full    =>  open,              -- out
                     Data_Exists  =>  fIFO_Data_Exists,  -- out
                     Addr         =>  open
                    );

    --------------------------------------------------------------------------
    --  FIFO_RESET_PROCESS
    --------------------------------------------------------------------------

    FIFO_RESET_PROCESS : process ( sync_rst_n )
    begin
        if (sync_rst_n = C_RESET_ACTIVE) then
            fIFO_Reset <= '1';
        else
            fIFO_Reset <= '0';
        end if;
    end process;

    --------------------------------------------------------------------------
    -- Concurrent Signal Assignments
    --------------------------------------------------------------------------

    Rmii2Mac_crs      <= rmii2Mac_crs_i;
    rx_beg_of_packet  <= rx_begin_packet(0) and not rx_begin_packet(1);
    rx_end_of_packet  <= rx_end_packet(0)   and not rx_end_packet(1);
    fIFO_Data_In      <= fifo_din_dv & phy2Rmii_rxd_d1;

    --------------------------------------------------------------------------
    -- RX_CARRY_SENSE_PROCESS
    --------------------------------------------------------------------------

    RX_CARRY_SENSE_PROCESS : process ( Ref_Clk )
    begin
        if (Ref_Clk'event and Ref_Clk = '1') then
            if (Sync_rst_n = '0') then
                rmii2Mac_crs_i <= '0';
            else
                rmii2Mac_crs_i <= ( phy2Rmii_crs_dv_sr(1) and rmii2Mac_crs_i ) or
                                   (phy2Rmii_crs_dv_sr(1) and not
                                    phy2Rmii_crs_dv_sr(21) );
            end if;
        end if;
    end process;

    --------------------------------------------------------------------------
    -- RMII_CRS_DV_PIPELINE_PROCESS
    --------------------------------------------------------------------------

    RMII_CRS_DV_PIPELINE_PROCESS : process ( Ref_Clk )
    begin
        if (Ref_Clk'event and Ref_Clk = '1') then
            if (Sync_rst_n = '0') then
                phy2Rmii_crs_dv_sr <= (others => '0');
            else
                phy2Rmii_crs_dv_sr <= phy2Rmii_crs_dv_sr(21 downto 0) &
                                      Phy2Rmii_crs_dv;
            end if;
        end if;
    end process;

    --------------------------------------------------------------------------
    -- FIFO_DIN_DV_PROCESS
    --------------------------------------------------------------------------

    FIFO_DIN_DV_PROCESS : process ( Ref_Clk )
    begin
        if (Ref_Clk'event and Ref_Clk = '1') then
            if ( Sync_rst_n = '0' ) then
                fifo_din_dv  <= '0';
            elsif ( rx_beg_of_packet = '1' ) then
                fifo_din_dv  <= '1';
            elsif ( rx_end_of_packet = '1' ) then
                fifo_din_dv  <= '0';
            end if;
        end if;
    end process;

    --------------------------------------------------------------------------
    -- RX_IN_REG_PROCESS
    --------------------------------------------------------------------------

    RX_IN_REG_PROCESS : process ( Ref_Clk )
    begin
        if (Ref_Clk'event and Ref_Clk = '1') then
            if (sync_rst_n = C_RESET_ACTIVE) then
                phy2Rmii_rxd_d1  <= (others => '0');
            elsif (rxd_smpl_dibit = '1') then
                phy2Rmii_rxd_d1(1 downto 0) <= phy2Rmii_rxd_d1(3 downto 2);
                phy2Rmii_rxd_d1(3 downto 2) <= Phy2Rmii_rxd;
            end if;
       end if;
    end process;

    --------------------------------------------------------------------------
    -- RX_BEGIN_OF_PACKET_PROCESS
    --------------------------------------------------------------------------

    RX_BEGIN_OF_PACKET_PROCESS : process ( Ref_Clk )
    begin
        if (Ref_Clk'event and Ref_Clk = '1') then
            if (( Sync_rst_n = '0' ) or ( rx_end_of_packet = '1' )) then
                rx_begin_packet  <= "00";
            else
                rx_begin_packet(1)  <= rx_begin_packet(0);
                if ( ( Phy2Rmii_crs_dv  = '1'  ) and
                     ( Phy2Rmii_rxd     = "01" ) and
                     ( rx_beg_of_packet = '0'  ) ) then

                     rx_begin_packet(0)  <= '1';

                end if;
            end if;
        end if;
    end process;

    --------------------------------------------------------------------------
    -- RX_END_OF_PACKET_PROCESS
    --------------------------------------------------------------------------

    RX_END_OF_PACKET_PROCESS : process ( Ref_Clk )
    begin
        if (Ref_Clk'event and Ref_Clk = '1') then
            if (( Sync_rst_n = '0' ) or ( rx_beg_of_packet = '1' )) then
                rx_end_packet   <= "00";
            else
                rx_end_packet(1)  <= rx_end_packet(0);
                if ( ( phy2Rmii_crs_dv_sr(9) = '0' ) and
                     ( phy2Rmii_crs_dv = '0' ) and
                     ( rx_end_of_packet   = '0' ) ) then

                     rx_end_packet(0)  <= '1';

                end if;
            end if;
        end if;
    end process;

    --------------------------------------------------------------------------
    -- RX_ERROR_PROCESS
    --------------------------------------------------------------------------

    RX_ERROR_PROCESS : process ( Ref_Clk )
    begin
        if (Ref_Clk'event and Ref_Clk = '1') then
            if (Sync_rst_n = '0') then
                rmii2Mac_rx_er_i  <= '0';
            else
                rmii2Mac_rx_er_i  <= Phy2Rmii_rx_er;
            end if;
        end if;
    end process;

    --------------------------------------------------------------------------
    -- RX_OUT_REG_PROCESS
    --------------------------------------------------------------------------

    RX_OUT_REG_PROCESS : process ( Ref_Clk )
    begin
        if (Ref_Clk'event and Ref_Clk = '1') then
            if (sync_rst_n = C_RESET_ACTIVE) then
                Rmii2Mac_rx_er  <=  '0';
                Rmii2Mac_rx_dv  <=  '0';
                Rmii2Mac_rxd    <= (others => '0');
            elsif (rx_out_reg_en = '1') then
                if (rx_out_mux_sel = '1') then
                    Rmii2Mac_rx_er <= rmii2Mac_rx_er_i;
                    Rmii2Mac_rx_dv <= fIFO_Data_Out(4);
                    Rmii2Mac_rxd   <= fIFO_Data_Out(3 downto 0);
                else
                    Rmii2Mac_rx_er <= rmii2Mac_rx_er_i;
                    Rmii2Mac_rx_dv <= '0';
                    Rmii2Mac_rxd   <= (others => '0');
                end if;
            end if;
        end if;
    end process;

    --------------------------------------------------------------------------
    -- STATE_MACHS_SYNC_PROCESS
    --------------------------------------------------------------------------

    STATE_MACHS_SYNC_PROCESS : process ( Ref_Clk )
    begin
        if (Ref_Clk'event and Ref_Clk = '1') then
            if (sync_rst_n = C_RESET_ACTIVE) then
                fifo_ldr_cs   <= IDLE;
                fifo_unldr_cs <= RX_CLK_L0;
            else
                fifo_ldr_cs   <= fifo_ldr_ns;
                fifo_unldr_cs <= fifo_unldr_ns;
            end if;
        end if;
    end process;

    --------------------------------------------------------------------------
    -- FIFO_LOADER_NEXT_STATE_PROCESS
    --------------------------------------------------------------------------

    FIFO_LOADER_NEXT_STATE_PROCESS : process (
                                             fifo_ldr_cs,
                                             fifo_din_dv
                                             )

    begin
        case fifo_ldr_cs is

           when IDLE =>
               if (fifo_din_dv = '1') then
                   fifo_ldr_ns <= RXD_DIB0_0;
               else
                   fifo_ldr_ns <= IDLE;
               end if;
               rxd_smpl_dibit <= '0';
               fIFO_Write     <= '0';

           when RXD_DIB0_0 =>
               fifo_ldr_ns    <= RXD_DIB0_1;
               rxd_smpl_dibit <= '0';
               fIFO_Write     <= '0';

           when RXD_DIB0_1 =>
               fifo_ldr_ns    <= RXD_DIB0_2;
               rxd_smpl_dibit <= '0';
               fIFO_Write     <= '0';

           when RXD_DIB0_2 =>
               fifo_ldr_ns    <= RXD_DIB0_3;
               rxd_smpl_dibit <= '0';
               fIFO_Write     <= '0';

           when RXD_DIB0_3 =>
               fifo_ldr_ns    <= RXD_DIB0_4;
               rxd_smpl_dibit <= '1';
               fIFO_Write     <= '0';

           when RXD_DIB0_4 =>
               fifo_ldr_ns    <= RXD_DIB0_5;
               rxd_smpl_dibit <= '0';
               fIFO_Write     <= '0';

           when RXD_DIB0_5 =>
               fifo_ldr_ns    <= RXD_DIB0_6;
               rxd_smpl_dibit <= '0';
               fIFO_Write     <= '0';

           when RXD_DIB0_6 =>
               fifo_ldr_ns    <= RXD_DIB0_7;
               rxd_smpl_dibit <= '0';
               fIFO_Write     <= '0';

           when RXD_DIB0_7 =>
               fifo_ldr_ns    <= RXD_DIB0_8;
               rxd_smpl_dibit <= '0';
               fIFO_Write     <= '0';

           when RXD_DIB0_8 =>
               fifo_ldr_ns    <= RXD_DIB0_9;
               rxd_smpl_dibit <= '0';
               fIFO_Write     <= '0';

           when RXD_DIB0_9 =>
               fifo_ldr_ns    <= RXD_DIB1_0;
               rxd_smpl_dibit <= '0';
               fIFO_Write     <= '0';

           when RXD_DIB1_0 =>
               fifo_ldr_ns    <= RXD_DIB1_1;
               rxd_smpl_dibit <= '0';
               fIFO_Write     <= '0';

           when RXD_DIB1_1 =>
               fifo_ldr_ns    <= RXD_DIB1_2;
               rxd_smpl_dibit <= '0';
               fIFO_Write     <= '0';

           when RXD_DIB1_2 =>
               fifo_ldr_ns    <= RXD_DIB1_3;
               rxd_smpl_dibit <= '0';
               fIFO_Write     <= '0';

           when RXD_DIB1_3 =>
               fifo_ldr_ns    <= RXD_DIB1_4;
               rxd_smpl_dibit <= '1';
               fIFO_Write     <= '0';

           when RXD_DIB1_4 =>
               fifo_ldr_ns    <= RXD_DIB1_5;
               rxd_smpl_dibit <= '0';
               fIFO_Write     <= '0';

           when RXD_DIB1_5 =>
               fifo_ldr_ns    <= RXD_DIB1_6;
               rxd_smpl_dibit <= '0';
               fIFO_Write     <= '0';

           when RXD_DIB1_6 =>
               fifo_ldr_ns    <= RXD_DIB1_7;
               rxd_smpl_dibit <= '0';
               fIFO_Write     <= '0';

           when RXD_DIB1_7 =>
               fifo_ldr_ns    <= RXD_DIB1_8;
               rxd_smpl_dibit <= '0';
               fIFO_Write     <= '0';

           when RXD_DIB1_8 =>
               fifo_ldr_ns    <= RXD_DIB1_9;
               rxd_smpl_dibit <= '0';
               fIFO_Write     <= '0';

           when RXD_DIB1_9 =>
               if (fifo_din_dv = '1') then
                   fifo_ldr_ns <= RXD_DIB0_0;
               else
                   fifo_ldr_ns <= IDLE;
               end if;
               rxd_smpl_dibit <= '0';
               fIFO_Write     <= '1';

        end case;
    end process;

    --------------------------------------------------------------------------
    -- FIFO_UNLOADER_NEXT_STATE_PROCESS
    --------------------------------------------------------------------------

    FIFO_UNLOADER_NEXT_STATE_PROCESS : process (
                                                fifo_unldr_cs,
                                                fIFO_Data_Exists
                                               )

    begin
        case fifo_unldr_cs is

            when RX_CLK_L0 =>
                fifo_unldr_ns   <= RX_CLK_L1;
                Rmii2Mac_rx_clk <= '0';
                rx_out_reg_en   <= '0';
                fIFO_Read       <= '0';
                rx_out_mux_sel  <= '0';

            when RX_CLK_L1 =>
                fifo_unldr_ns   <= RX_CLK_L2;
                Rmii2Mac_rx_clk <= '0';
                rx_out_reg_en   <= '0';
                fIFO_Read       <= '0';
                rx_out_mux_sel  <= '0';

            when RX_CLK_L2 =>
                fifo_unldr_ns   <= RX_CLK_L3;
                Rmii2Mac_rx_clk <= '0';
                rx_out_reg_en   <= '0';
                fIFO_Read       <= '0';
                rx_out_mux_sel  <= '0';

            when RX_CLK_L3 =>
                fifo_unldr_ns   <= RX_CLK_L4;
                Rmii2Mac_rx_clk <= '0';
                rx_out_reg_en   <= '0';
                fIFO_Read       <= '0';
                rx_out_mux_sel  <= '0';

            when RX_CLK_L4 =>
                fifo_unldr_ns   <= RX_CLK_L5;
                Rmii2Mac_rx_clk <= '0';
                rx_out_reg_en   <= '0';
                fIFO_Read       <= '0';
                rx_out_mux_sel  <= '0';

            when RX_CLK_L5 =>
                fifo_unldr_ns   <= RX_CLK_L6;
                Rmii2Mac_rx_clk <= '0';
                rx_out_reg_en   <= '0';
                fIFO_Read       <= '0';
                rx_out_mux_sel  <= '0';

            when RX_CLK_L6 =>
                fifo_unldr_ns   <= RX_CLK_L7;
                Rmii2Mac_rx_clk <= '0';
                rx_out_reg_en   <= '0';
                fIFO_Read       <= '0';
                rx_out_mux_sel  <= '0';

            when RX_CLK_L7 =>
                fifo_unldr_ns   <= RX_CLK_L8;
                Rmii2Mac_rx_clk <= '0';
                rx_out_reg_en   <= '0';
                fIFO_Read       <= '0';
                rx_out_mux_sel  <= '0';

            when RX_CLK_L8 =>
                fifo_unldr_ns   <= RX_CLK_L9;
                Rmii2Mac_rx_clk <= '0';
                rx_out_reg_en   <= '0';
                fIFO_Read       <= '0';
                rx_out_mux_sel  <= '0';

            when RX_CLK_L9 =>
                fifo_unldr_ns   <= RX_CLK_H0;
                Rmii2Mac_rx_clk <= '0';
                rx_out_reg_en   <= '0';
                fIFO_Read       <= '0';
                rx_out_mux_sel  <= '0';

            when RX_CLK_H0 =>
                fifo_unldr_ns   <= RX_CLK_H1;
                Rmii2Mac_rx_clk <= '1';
                rx_out_reg_en   <= '0';
                fIFO_Read       <= '0';
                rx_out_mux_sel  <= '0';

            when RX_CLK_H1 =>
                fifo_unldr_ns   <= RX_CLK_H2;
                Rmii2Mac_rx_clk <= '1';
                rx_out_reg_en   <= '0';
                fIFO_Read       <= '0';
                rx_out_mux_sel  <= '0';

            when RX_CLK_H2 =>
                fifo_unldr_ns   <= RX_CLK_H3;
                Rmii2Mac_rx_clk <= '1';
                rx_out_reg_en   <= '0';
                fIFO_Read       <= '0';
                rx_out_mux_sel  <= '0';

            when RX_CLK_H3 =>
                fifo_unldr_ns   <= RX_CLK_H4;
                Rmii2Mac_rx_clk <= '1';
                rx_out_reg_en   <= '0';
                fIFO_Read       <= '0';
                rx_out_mux_sel  <= '0';

            when RX_CLK_H4 =>
                fifo_unldr_ns   <= RX_CLK_H5;
                Rmii2Mac_rx_clk <= '1';
                rx_out_reg_en   <= '0';
                fIFO_Read       <= '0';
                rx_out_mux_sel  <= '0';

            when RX_CLK_H5 =>
                fifo_unldr_ns   <= RX_CLK_H6;
                Rmii2Mac_rx_clk <= '1';
                rx_out_reg_en   <= '0';
                fIFO_Read       <= '0';
                rx_out_mux_sel  <= '0';

            when RX_CLK_H6 =>
                fifo_unldr_ns   <= RX_CLK_H7;
                Rmii2Mac_rx_clk <= '1';
                rx_out_reg_en   <= '0';
                fIFO_Read       <= '0';
                rx_out_mux_sel  <= '0';

            when RX_CLK_H7 =>
                fifo_unldr_ns   <= RX_CLK_H8;
                Rmii2Mac_rx_clk <= '1';
                rx_out_reg_en   <= '0';
                fIFO_Read       <= fIFO_Data_Exists;
                rx_out_mux_sel  <= '0';

            when RX_CLK_H8 =>
                fifo_unldr_ns   <= RX_CLK_H9;
                Rmii2Mac_rx_clk <= '1';
                rx_out_reg_en   <= '0';
                fIFO_Read       <= '0';
                rx_out_mux_sel  <= '0';

            when RX_CLK_H9 =>
                fifo_unldr_ns   <= RX_CLK_L0;
                Rmii2Mac_rx_clk <= '1';
                rx_out_reg_en   <= '1';
                fIFO_Read       <= '0';
                rx_out_mux_sel  <= '1';

        end case;
    end process;

end generate;

------------------------------------------------------------------------------
--
-- Conditional Generate for FIXED speed throughput of 100 Mb/s
--
------------------------------------------------------------------------------

RX_100_MBPS : if (C_SPEED_100 = '1') generate

    --------------------------------------------------------------------------
    -- Signal and Type Declarations
    --------------------------------------------------------------------------
    
    type   F_LDR_TYPE  is (
                           IDLE_NO_WR,
                           RX_NO_WR,
                           RX_WR
                           );
    
    signal  fifo_ldr_cs         :  F_LDR_TYPE;
    signal  fifo_ldr_ns         :  F_LDR_TYPE;
    
    type   FLSHR_TYPE  is (
                           FLSHR_IDLE_L,
                           FLSHR_IDLE_H,
                           RX100_CLK_L,
                           RX100_CLK_H
                           );
    
    signal  fifo_flshr_cs       :  FLSHR_TYPE;
    signal  fifo_flshr_ns       :  FLSHR_TYPE;
    
    signal  rmii2Mac_crs_i      :  std_logic;
    signal  rmii2Mac_rx_er_d3   :  std_logic;
    signal  rmii2Mac_rx_er_d2   :  std_logic;
    signal  rmii2Mac_rx_er_d1   :  std_logic;
    
    signal  rx_begin_packet     :  std_logic_vector(1 downto 0);
    signal  rx_beg_of_packet    :  std_logic;
    signal  rx_end_packet       :  std_logic_vector(1 downto 0);
    signal  rx_end_of_packet    :  std_logic;
    
    signal  phy2Rmii_crs_dv_d4  :  std_logic;
    signal  phy2Rmii_crs_dv_d3  :  std_logic;
    signal  phy2Rmii_crs_dv_d2  :  std_logic;
    signal  phy2Rmii_crs_dv_d1  :  std_logic;
    
    signal  rx_out_mux_sel      :  std_logic;
    signal  rx_out_reg_en       :  std_logic;
    
    signal  phy2Rmii_rxd_d3     :  std_logic_vector(3 downto 0);
    signal  phy2Rmii_rxd_d2     :  std_logic_vector(3 downto 0);
    signal  phy2Rmii_rxd_d1     :  std_logic_vector(3 downto 0);
    
    signal  fIFO_Reset          :  std_logic;
    signal  fIFO_Write          :  std_logic;
    signal  fIFO_Data_In        :  std_logic_vector(4 downto 0);
    signal  fIFO_Read           :  std_logic;
    signal  fIFO_Data_Out       :  std_logic_vector(4 downto 0);
    signal  fIFO_Full           :  std_logic;
    signal  fIFO_Data_Exists    :  std_logic;
    signal  fifo_din_dv         :  std_logic;
    
    --CR#618005
    attribute shreg_extract : string;
    attribute shreg_extract of phy2Rmii_crs_dv_d1  : signal is "no";
    attribute shreg_extract of phy2Rmii_rxd_d1     : signal is "no";
    attribute shreg_extract of rmii2Mac_rx_er_d1   : signal is "no";
    --------------------------------------------------------------------------
    -- Component Declarations
    --------------------------------------------------------------------------
    
    component srl_fifo
        generic (
                 C_DATA_BITS  :  natural  :=  8;
                 C_DEPTH      :  natural  :=  16
                );
    
        port    (
                 Clk          :  in   std_logic;
                 Reset        :  in   std_logic;
                 FIFO_Write   :  in   std_logic;
                 Data_In      :  in   std_logic_vector(0 to C_DATA_BITS-1);
                 FIFO_Read    :  in   std_logic;
                 Data_Out     :  out  std_logic_vector(0 to C_DATA_BITS-1);
                 FIFO_Full    :  out  std_logic;
                 Data_Exists  :  out  std_logic;
                 Addr         :  out  std_logic_vector(0 to 3)
                );
    end component;
    
    begin
    
    --------------------------------------------------------------------------
    -- Component Instaniations
    --------------------------------------------------------------------------
    
    I_SRL_FIFO : srl_fifo
        generic map (
                     C_DATA_BITS  =>  5,
                     C_DEPTH      =>  16
                    )
    
        port map    (
                     Clk          =>  Ref_Clk,
                     Reset        =>  fIFO_Reset,
                     FIFO_Write   =>  fIFO_Write,
                     Data_In      =>  fIFO_Data_In,
                     FIFO_Read    =>  fIFO_Read,
                     Data_Out     =>  fIFO_Data_Out,
                     FIFO_Full    =>  fIFO_Full,
                     Data_Exists  =>  fIFO_Data_Exists,
                     Addr         =>  open
                    );
    
    --------------------------------------------------------------------------
    -- Concurrent Signal Assignments
    --------------------------------------------------------------------------
    
    Rmii2Mac_crs      <= rmii2Mac_crs_i;
    rx_beg_of_packet  <= rx_begin_packet(0) and not rx_begin_packet(1);
    rx_end_of_packet  <= rx_end_packet(0)   and not rx_end_packet(1);
    fIFO_Reset        <= not sync_rst_n;
    fIFO_Data_In      <= fifo_din_dv & phy2Rmii_rxd_d3;
    
    --------------------------------------------------------------------------
    -- RX_CARRY_SENSE_PROCESS
    --------------------------------------------------------------------------
    
    RX_CARRY_SENSE_PROCESS : process ( Ref_Clk )
    begin
        if (Ref_Clk'event and Ref_Clk = '1') then
            if (Sync_rst_n = '0') then
                rmii2Mac_crs_i <=  '0';
            else
                rmii2Mac_crs_i <= ( Phy2Rmii_crs_dv_d2 and rmii2Mac_crs_i ) or
                                  ( Phy2Rmii_crs_dv_d2 and not phy2Rmii_crs_dv_d4 );
            end if;
        end if;
    end process;
    
    --------------------------------------------------------------------------
    -- RMII_CRS_DV_PIPELINE_PROCESS
    --------------------------------------------------------------------------
    
    RMII_CRS_DV_PIPELINE_PROCESS : process ( Ref_Clk )
    begin
        if (Ref_Clk'event and Ref_Clk = '1') then
            if (Sync_rst_n = '0') then
                phy2Rmii_crs_dv_d4  <=  '0';
                phy2Rmii_crs_dv_d3  <=  '0';
                phy2Rmii_crs_dv_d2  <=  '0';
                phy2Rmii_crs_dv_d1  <=  '0';
            else
                phy2Rmii_crs_dv_d4  <=  phy2Rmii_crs_dv_d3;
                phy2Rmii_crs_dv_d3  <=  phy2Rmii_crs_dv_d2;
                phy2Rmii_crs_dv_d2  <=  phy2Rmii_crs_dv_d1;
                phy2Rmii_crs_dv_d1  <=  Phy2Rmii_crs_dv;
            end if;
        end if;
    end process;
    
    --------------------------------------------------------------------------
    -- FIFO_DIN_DV_PROCESS
    --------------------------------------------------------------------------
    
    FIFO_DIN_DV_PROCESS : process ( Ref_Clk )
    begin
        if (Ref_Clk'event and Ref_Clk = '1') then
            if ( Sync_rst_n = '0' ) then
                fifo_din_dv  <=  '0';
            elsif ( rx_beg_of_packet = '1') then
                fifo_din_dv  <=  '1';
            elsif ( ( Phy2Rmii_crs_dv_d2 = '0' ) and 
                    ( phy2Rmii_crs_dv_d3 = '0' ) ) then
                fifo_din_dv  <=  '0';
            end if;
        end if;
    end process;
    
    --------------------------------------------------------------------------
    -- RX_IN_REG_PROCESS
    --------------------------------------------------------------------------
    
    RX_IN_REG_PROCESS : process ( Ref_Clk )
    begin
        if (Ref_Clk'event and Ref_Clk = '1') then
            if (sync_rst_n = C_RESET_ACTIVE) then
                phy2Rmii_rxd_d3  <=  (others => '0');
                phy2Rmii_rxd_d2  <=  (others => '0');
                phy2Rmii_rxd_d1  <=  (others => '0');
            else
                phy2Rmii_rxd_d3             <=  phy2Rmii_rxd_d2;
                phy2Rmii_rxd_d2             <=  phy2Rmii_rxd_d1;
                phy2Rmii_rxd_d1(1 downto 0) <=  phy2Rmii_rxd_d1(3 downto 2);
                phy2Rmii_rxd_d1(3 downto 2) <=  Phy2Rmii_rxd;
            end if;
       end if;
    end process;
    
    --------------------------------------------------------------------------
    -- RX_BEGIN_OF_PACKET_PROCESS
    --------------------------------------------------------------------------
    
    RX_BEGIN_OF_PACKET_PROCESS : process ( Ref_Clk )
    begin
        if (Ref_Clk'event and Ref_Clk = '1') then
            if (( Sync_rst_n = '0' ) or ( rx_end_of_packet = '1' )) then
                rx_begin_packet  <= "00";
            else
                rx_begin_packet(1)  <=  rx_begin_packet(0);
    
                if ( ( Phy2Rmii_crs_dv_d2  = '1'  ) and
                     ( Phy2Rmii_rxd_d2(3 downto 2) = "01" ) and
                     ( rx_beg_of_packet    = '0'  ) ) then
    
                     rx_begin_packet(0)  <=  '1';
    
                end if;
    
            end if;
        end if;
    end process;
    
    --------------------------------------------------------------------------
    -- RX_END_OF_PACKET_PROCESS
    --------------------------------------------------------------------------
    
    RX_END_OF_PACKET_PROCESS : process ( Ref_Clk )
    begin
        if (Ref_Clk'event and Ref_Clk = '1') then
            if (( Sync_rst_n = '0' ) or ( rx_beg_of_packet = '1' )) then
                rx_end_packet   <= "00";
            else
                rx_end_packet(1)  <=  rx_end_packet(0);
    
                if ( ( Phy2Rmii_crs_dv_d2 = '0' ) and 
                     ( phy2Rmii_crs_dv_d3 = '0' ) and
                     ( rx_end_of_packet   = '0' ) ) then
    
                     rx_end_packet(0)  <=  '1';
    
                end if;
            end if;
        end if;
    end process;
    
    --------------------------------------------------------------------------
    -- RX_ERROR_PROCESS
    --------------------------------------------------------------------------
    
    RX_ERROR_PROCESS : process ( Ref_Clk )
    begin
        if (Ref_Clk'event and Ref_Clk = '1') then
            if (Sync_rst_n = '0') then
                rmii2Mac_rx_er_d3  <=  '0';
                rmii2Mac_rx_er_d2  <=  '0';
                rmii2Mac_rx_er_d1  <=  '0';
            else
                rmii2Mac_rx_er_d3  <=  rmii2Mac_rx_er_d2;
                rmii2Mac_rx_er_d2  <=  rmii2Mac_rx_er_d1;
                rmii2Mac_rx_er_d1  <=  Phy2Rmii_rx_er;
            end if;
        end if;
    end process;
    
    --------------------------------------------------------------------------
    -- RX_OUT_REG_PROCESS
    --------------------------------------------------------------------------
    
    RX_OUT_REG_PROCESS : process ( Ref_Clk )
    begin
        if (Ref_Clk'event and Ref_Clk = '1') then
            if (sync_rst_n = C_RESET_ACTIVE) then
                Rmii2Mac_rx_er  <=   '0';
                Rmii2Mac_rx_dv  <=   '0';
                Rmii2Mac_rxd    <=  (others => '0');
            elsif (rx_out_reg_en = '1') then
                if ( rx_out_mux_sel = '1' ) then
                    Rmii2Mac_rx_er  <=  rmii2Mac_rx_er_d3;
                    Rmii2Mac_rx_dv  <=  '1';
                    Rmii2Mac_rxd    <=  fIFO_Data_Out(3 downto 0);
                else
                   Rmii2Mac_rx_er  <=  '0';
                   Rmii2Mac_rx_dv  <=  '0';
                   Rmii2Mac_rxd    <=  (others => '0');
                end if;
            end if;
        end if;
    end process;
    
    --------------------------------------------------------------------------
    -- STATE_MACHS_SYNC_PROCESS
    --------------------------------------------------------------------------
    
    STATE_MACHS_SYNC_PROCESS : process ( Ref_Clk )
    begin
        if (Ref_Clk'event and Ref_Clk = '1') then
            if (sync_rst_n = C_RESET_ACTIVE) then
                fifo_ldr_cs    <=  IDLE_NO_WR;
                fifo_flshr_cs  <=  FLSHR_IDLE_L;
            else
                fifo_ldr_cs    <=  fifo_ldr_ns;
                fifo_flshr_cs  <=  fifo_flshr_ns;
            end if;
        end if;
    end process;
    
    --------------------------------------------------------------------------
    -- FIFO_LOADER_NEXT_STATE_PROCESS
    --------------------------------------------------------------------------
    
    FIFO_LOADER_NEXT_STATE_PROCESS : process (
                                             fifo_ldr_cs,
                                             rx_beg_of_packet,
                                             rx_end_of_packet
                                             )
    
    begin
        case fifo_ldr_cs is
    
           when IDLE_NO_WR  =>
               if (rx_beg_of_packet = '1') then
                   fifo_ldr_ns  <=  RX_WR;
               else
                   fifo_ldr_ns  <=  IDLE_NO_WR;
               end if;
               fIFO_Write    <= '0';
    
           when RX_NO_WR  =>
               if (rx_end_of_packet = '1') then
                   fifo_ldr_ns  <=  IDLE_NO_WR;
               else
                   fifo_ldr_ns  <=  RX_WR;
               end if;
               fIFO_Write    <= '0';
    
           when RX_WR  =>
               if (rx_end_of_packet = '1') then
                   fifo_ldr_ns  <=  IDLE_NO_WR;
                   fIFO_Write   <= '0';
               else
                   fifo_ldr_ns  <=  RX_NO_WR;
                   fIFO_Write   <= '1';
               end if;
    
        end case;
    end process;
    
    --------------------------------------------------------------------------
    -- FIFO_FLUSHER_NEXT_STATE_PROCESS
    --------------------------------------------------------------------------
    
    FIFO_FLUSHER_NEXT_STATE_PROCESS : process (
                                              fifo_flshr_cs,
                                              fIFO_Data_Exists
                                              )
    
    begin
        case fifo_flshr_cs is
    
           when FLSHR_IDLE_L  =>
               if (fIFO_Data_Exists = '1') then
                   fifo_flshr_ns   <=  RX100_CLK_H;
               else
                   fifo_flshr_ns   <=  FLSHR_IDLE_H;
               end if;
               Rmii2Mac_rx_clk  <=  '0';
               rx_out_reg_en    <=  '0';
               fIFO_Read        <=  '0';
               rx_out_mux_sel   <=  '0';
    
           when FLSHR_IDLE_H  =>
               if (fIFO_Data_Exists = '1') then
                   fifo_flshr_ns   <=  RX100_CLK_L;
               else
                   fifo_flshr_ns   <=  FLSHR_IDLE_L;
               end if;
               Rmii2Mac_rx_clk  <=  '1';
               rx_out_reg_en    <=  '1';
               fIFO_Read        <=  '0';
               rx_out_mux_sel   <=  '0';
    
           when RX100_CLK_L  =>
               if (fIFO_Data_Exists = '0') then
                   fifo_flshr_ns   <=  FLSHR_IDLE_H;
               else
                   fifo_flshr_ns   <=  RX100_CLK_H;
               end if;
               Rmii2Mac_rx_clk  <=  '0';
               rx_out_reg_en    <=  '0';
               fIFO_Read        <=  '0';
               rx_out_mux_sel   <=  '1';
    
           when RX100_CLK_H  =>
               if (fIFO_Data_Exists = '0') then
                   fifo_flshr_ns   <=  FLSHR_IDLE_L;
               else
                   fifo_flshr_ns   <=  RX100_CLK_L;
               end if;
               Rmii2Mac_rx_clk  <=  '1';
               rx_out_reg_en    <=  '1';
               fIFO_Read        <=  '1';
               rx_out_mux_sel   <=  '1';
    
        end case;
    end process;

end generate;

end simulation;
