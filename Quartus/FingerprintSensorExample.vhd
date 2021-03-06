-- ZFM-20 Fingerprint Sensor Example
-- Top level system file

library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.vital_primitives.all;
use work.DE2_CONSTANTS.all;

entity FingerprintSensorExample is
        port (
		-- Reset and Clock
		KEY		: in std_logic_vector (0 downto 0);
		CLOCK_50	: in std_logic;
		CLOCK_27 : in std_logic;


		-- Off Chip
		GPIO_1		: inout std_logic_vector(35 downto 0);

		-- SDRAM On Board
		DRAM_ADDR	: out DE2_SDRAM_ADDR_BUS;
		DRAM_BA_0	: out std_logic;
		DRAM_BA_1	: out std_logic;
		DRAM_CAS_N	: out std_logic;
		DRAM_CKE	: out std_logic;
		DRAM_CLK	: out std_logic;
		DRAM_CS_N	: out std_logic;
		DRAM_DQ		: inout DE2_SDRAM_DATA_BUS;
		DRAM_LDQM	: out std_logic;
		DRAM_UDQM	: out std_logic;
		DRAM_RAS_N	: out std_logic;
		DRAM_WE_N	: out std_logic;

		-- SRAM On Board
		SRAM_ADDR	: out DE2_SRAM_ADDR_BUS;
		SRAM_DQ		: inout DE2_SRAM_DATA_BUS;
		SRAM_WE_N	: out std_logic;
		SRAM_OE_N	: out std_logic;
		SRAM_UB_N	: out std_logic;
		SRAM_LB_N	: out std_logic; 
		SRAM_CE_N	: out std_logic;
		
		-- Flash memory
		FL_ADDR 		:	out std_logic_vector (21 downto 0);
		FL_CE_N 		:	out std_logic_vector (0 downto 0);
		FL_OE_N 		:	out std_logic_vector (0 downto 0);
		FL_DQ 		:	inout std_logic_vector (7 downto 0);
		FL_RST_N 	:	out std_logic_vector (0 downto 0);
		FL_WE_N 		:	out std_logic_vector (0 downto 0)
	);
end FingerprintSensorExample;


architecture structure of FingerprintSensorExample is

	component nios_system is
	port (
	         clk_clk                                 : in    std_logic                     := 'X';             -- clk
            reset_reset_n                           : in    std_logic                     := 'X';             -- reset_n             -- export

            altpll_0_c0_clk                         : out   std_logic;                                        -- clk

            serial_external_connection_rxd          : in    std_logic                     := 'X';             -- rxd
            serial_external_connection_txd          : out   std_logic;                                        -- txd
            
	         sdram_0_wire_addr                       : out   std_logic_vector(11 downto 0);                    -- addr
            sdram_0_wire_ba                         : out   std_logic_vector(1 downto 0);                     -- ba
            sdram_0_wire_cas_n                      : out   std_logic;                                        -- cas_n
            sdram_0_wire_cke                        : out   std_logic;                                        -- cke
            sdram_0_wire_cs_n                       : out   std_logic;                                        -- cs_n
            sdram_0_wire_dq                         : inout std_logic_vector(15 downto 0) := (others => 'X'); -- dq
            sdram_0_wire_dqm                        : out   std_logic_vector(1 downto 0);                     -- dqm
            sdram_0_wire_ras_n                      : out   std_logic;                                        -- ras_n
            sdram_0_wire_we_n                       : out   std_logic;                                        -- we_n
            
            tristate_conduit_bridge_0_out_generic_tristate_controller_0_tcm_read_n_out       : out   std_logic_vector(0 downto 0);                     -- generic_tristate_controller_0_tcm_read_n_out
            tristate_conduit_bridge_0_out_generic_tristate_controller_0_tcm_data_out         : inout std_logic_vector(7 downto 0)  := (others => 'X'); -- generic_tristate_controller_0_tcm_data_out
            tristate_conduit_bridge_0_out_generic_tristate_controller_0_tcm_chipselect_n_out : out   std_logic_vector(0 downto 0);                     -- generic_tristate_controller_0_tcm_chipselect_n_out
            tristate_conduit_bridge_0_out_generic_tristate_controller_0_tcm_write_n_out      : out   std_logic_vector(0 downto 0);                     -- generic_tristate_controller_0_tcm_write_n_out
            tristate_conduit_bridge_0_out_generic_tristate_controller_0_tcm_address_out      : out   std_logic_vector(21 downto 0)                     -- generic_tristate_controller_0_tcm_address_out
				
	);
    end component nios_system;

	-- signals to match provided IP core to specific SDRAM chip of our system
	signal BA	: std_logic_vector (1 downto 0);
	signal DQM	: std_logic_vector (1 downto 0);
begin
	
	DRAM_BA_1 <= BA(1);
	DRAM_BA_0 <= BA(0);

	DRAM_UDQM <= DQM(1);
	DRAM_LDQM <= DQM(0);
	FL_RST_N <= "1";
	
    u0 : component nios_system
        port map (
            reset_reset_n                           => KEY(0),                           		     -- reset.reset_n

            altpll_0_c0_clk                         => DRAM_CLK, 		                             --                        altpll_0_c0.clk
				
				serial_external_connection_rxd          => GPIO_1(26),				             --     GREEN    serial_external_connection.rxd
            serial_external_connection_txd          => GPIO_1(28), 				             --     WHITE                              .txd

            sdram_0_wire_addr                       => DRAM_ADDR, 		 	                     --                       sdram_0_wire.addr
            sdram_0_wire_ba                         => BA,                         			     --                                   .ba
            sdram_0_wire_cas_n                      => DRAM_CAS_N,			                     --                                   .cas_n
            sdram_0_wire_cke                        => DRAM_CKE,			                     --                                   .cke
            sdram_0_wire_cs_n                       => DRAM_CS_N,               			     --                                   .cs_n
            sdram_0_wire_dq                         => DRAM_DQ,  			                     --                                   .dq
            sdram_0_wire_dqm                        => DQM,   				                     --                                   .dqm
            sdram_0_wire_ras_n                      => DRAM_RAS_N,			                     --                                   .ras_n
            sdram_0_wire_we_n                       => DRAM_WE_N, 			                     --                                   .we_n

            clk_clk                                 => CLOCK_50,                                	     --                                clk.clk
				
            tristate_conduit_bridge_0_out_generic_tristate_controller_0_tcm_read_n_out       => FL_OE_N,       --      tristate_conduit_bridge_0_out.generic_tristate_controller_0_tcm_read_n_out
            tristate_conduit_bridge_0_out_generic_tristate_controller_0_tcm_data_out         => FL_DQ,         --                                   .generic_tristate_controller_0_tcm_data_out
            tristate_conduit_bridge_0_out_generic_tristate_controller_0_tcm_chipselect_n_out => FL_CE_N, --                                   .generic_tristate_controller_0_tcm_chipselect_n_out
            tristate_conduit_bridge_0_out_generic_tristate_controller_0_tcm_write_n_out      => FL_WE_N,      --                                   .generic_tristate_controller_0_tcm_write_n_out
            tristate_conduit_bridge_0_out_generic_tristate_controller_0_tcm_address_out      => FL_ADDR       --                                   .generic_tristate_controller_0_tcm_address_out
	);

end structure;

library ieee;

--DE2 Constants

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.vital_primitives.all;

package DE2_CONSTANTS is
	subtype DE2_LCD_DATA_BUS	is std_logic_vector(7 downto 0);
	
	subtype DE2_LED_GREEN	is std_logic_vector(7 downto 0);

	subtype DE2_SRAM_ADDR_BUS	is std_logic_vector(17 downto 0);
	subtype DE2_SRAM_DATA_BUS	is std_logic_vector(15 downto 0);

	subtype DE2_SDRAM_ADDR_BUS	is std_logic_vector(11 downto 0);
	subtype DE2_SDRAM_DATA_BUS is std_logic_vector(15 downto 0);

end DE2_CONSTANTS;

