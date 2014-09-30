----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:27:26 09/25/2014 
-- Design Name: 
-- Module Name:    seq_det - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.ALL;

entity seq_det is
port( 
	x, b1, b2,reset,ck: in std_logic;
	z: out std_logic;
	led: out std_logic_vector(3 downto 0)
);
end seq_det;

architecture beh of seq_det is
type my_state is (s0, s1, s2, s3, s4);
signal n_s : my_state; -- n_s reads next state
type debounce_state is (rdy, pulse, not_rdy);
signal d_n_s : debounce_state;
signal EN,temp0,temp1,temp2 : std_logic; -- generated by single-step process
begin

process(ck) -- single-step process
begin
if ck'event and ck='1' then
 case d_n_s is
	when rdy => 
		en <= '0';
		if b1='1' then d_n_s <= pulse; end if;
	when pulse => 
		en <= '1';
		d_n_s <= not_rdy;
	when not_rdy => 
		en <='0';
		if b2='1' then d_n_s <= rdy; end if;
 end case;
end if;
end process;

process(reset,en) -- sequence detector 
begin
if en'event and en = '1' then
temp0 <= x;
temp1 <= temp0;
temp2 <= temp1;
led(0) <= x;
led(1) <= temp0;
led(2) <= temp1;
led(3) <= temp2;
	if reset = '1' then n_s <= s0; else 
	--requires the reset button to be held down when
	--the b1 is pressed. non-intuitive, 
	--but that's as the assignment was written
	case n_s is
		when s0 => 
		z <= '0'; 
			if x = '1' then
				n_s <= s1;
			else 
				n_s <= s0;
			end if;
		when s1 =>
		z <= '0'; 
			if x = '1' then
				n_s <= s2;
			else 
				n_s <= s0;
			end if;
		when s2 =>
		z <= '0'; 
			if x = '1' then
				n_s <= s2;
			else 
				n_s <= s3;
			end if;
		when s3 =>
		z <= '0'; 
			if x = '1' then
				n_s <= s4;
				z <= '1'; 
			else 
				n_s <= s0;
			end if;
		when s4 =>
			z <= '0'; 
			if x = '1' then
				n_s <= s2;
			else 
				n_s <= s0;
			end if;
	end case;
	end if;
	end if;
end process;
end beh;