library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity marquesina is port(
	sensor, clock, clks: in std_logic;
	leds,audio: out std_logic_vector (1 downto 0);
	AN : out std_logic_vector(7 downto 0);
	frec: out std_logic_vector (3 downto 0);
	display: out std_logic_vector(7 downto 0));
end marquesina;

architecture Behavioral of marquesina is
	signal letras,secuencia: std_logic_vector(2 downto 0):= "001";
	signal displays: std_logic_vector(7 downto 0):= "00000000";
	signal ANS: std_logic_vector(7 downto 0):= "11101110";
	signal clk,reloj1,reloj2,reloj3,reloj4,reloj5: std_logic := '1';
	signal div: std_logic_vector (3 downto 0):= "1111";
	signal cont1,cont2,cont3,cont4,cont5: integer:= 1;
begin
display <= displays;
AN <= ANS;
clk <= clock;
frec <= div;
div(0) <= reloj2;
div(1) <= reloj3;
div(2) <= reloj4;
div(3) <= reloj5;
-------Divisor Frec. 1 Anodos--------
	process (clk) begin
		if clk'event and clk = '1' then
			if cont1 = 25000 then
				reloj1 <= not reloj1;
				cont1 <= 1;
			else
				cont1 <= cont1 + 1;
			end if;
		end if;
	end process;
-------Divisor Frec. 2 Secuencia--------
	process (clk) begin
		if clk'event and clk = '1' then
			if cont2 = 25000000 then
				reloj2 <= not reloj2;
				cont2 <= 1;
			else
				cont2 <= cont2 + 1;
			end if;
		end if;
	end process;
-------Divisor Frec. 3 Secuencia--------
	process (clk) begin
		if clk'event and clk = '1' then
			if cont3 = 12500000 then
				reloj3 <= not reloj3;
				cont3 <= 1;
			else
				cont3 <= cont3 + 1;
			end if;
		end if;
	end process;
-------Divisor Frec. 4 Secuencia--------
	process (clk) begin
		if clk'event and clk = '1' then
			if cont4 = 3125000 then
				reloj4 <= not reloj4;
				cont4 <= 1;
			else
				cont4 <= cont4 + 1;
			end if;
		end if;
	end process;
-------Divisor Frec. 5 Secuencia--------
	process (clk) begin
		if clk'event and clk = '1' then
			if cont5 = 1562500 then
				reloj5 <= not reloj5;
				cont5 <= 1;
			else
				cont5 <= cont5 + 1;
			end if;
		end if;
	end process;
---------Movimiento de Anodos---------
	process (reloj1) begin
		if reloj1'event and reloj1 = '1' then
			ANS(0) <= ANS(7);
			ANS(1) <= ANS(0);
			ANS(2) <= ANS(1);
			ANS(3) <= ANS(2);
			ANS(4) <= ANS(3);
			ANS(5) <= ANS(4);
			ANS(6) <= ANS(5);
			ANS(7) <= ANS(6);
		end if;
	end process;
--------Movimiento de Displays--------
	process(clks) begin
		if clks'event and clks = '1' then
			secuencia <= secuencia + "001";
		end if;
	end process;
----------------Main Process----------------
	process (secuencia, sensor, ANS) begin
		case secuencia is
--------------------------------------------
			when "000" =>
				if sensor = '1' then--_ _ _H
					leds <= "10";
					audio <= "00";
					case ANS(7 downto 4) is
						when "1110" => letras <= "000";--H
						when others => letras <= "110";--ESPACIO
					end case;
				else
					leds <= "01";		--_ _ _C
					audio <= "00";
					case ANS(7 downto 4) is
						when "1110" => letras <= "100";--H
						when others => letras <= "110";--ESPACIO
					end case;
				end if;
---------------------------------------------
			when "001" =>
				if sensor = '1' then--_ _HO
					leds <= "10";
					audio <= "00";
					case ANS(7 downto 4) is
						when "1110" => letras <= "001";--O
						when "1101" => letras <= "000";--H
						when others => letras <= "110";--ESPACIO
					end case;
				else
					leds <= "01";		-- _ _CI
					audio <= "00";
					case ANS(7 downto 4) is
						when "1110" => letras <= "101";--I
						when "1101" => letras <= "100";--C
						when others => letras <= "110";--ESPACIO
					end case;
				end if;
---------------------------------------------
			when "010" =>
				if sensor = '1' then--_HOL
					leds <= "10";
					audio <= "00";
					case ANS(7 downto 4) is
						when "1110" => letras <= "010";--L
						when "1101" => letras <= "001";--O
						when "1011" => letras <= "000";--H
						when others => letras <= "110";--ESPACIO
					end case;
				else
					leds <= "01";		--_CIA
					audio <= "00";
					case ANS(7 downto 4) is
						when "1110" => letras <= "011";--A
						when "1101" => letras <= "101";--I
						when "1011" => letras <= "100";--C
						when others => letras <= "110";--ESPACIO
					end case;
				end if;
---------------------------------------------
			when "011" =>
				if sensor = '1' then--HOLA
					leds <= "10";
					audio <= "10";
					case ANS(7 downto 4) is
						when "1110" => letras <= "011";--A
						when "1101" => letras <= "010";--L
						when "1011" => letras <= "001";--O
						when "0111" => letras <= "000";--H
						when others => letras <= "110";--ESPACIO
					end case;
				else
					leds <= "01";		--CIAO
					audio <= "01";
					case ANS(7 downto 4) is
						when "1110" => letras <= "001";--O
						when "1101" => letras <= "011";--A
						when "1011" => letras <= "101";--I
						when "0111" => letras <= "100";--C
						when others => letras <= "110";--ESPACIO
					end case;
				end if;
---------------------------------------------
			when "100" =>
				if sensor = '1' then--OLA_
					leds <= "10";
					audio <= "00";
					case ANS(7 downto 4) is
						when "1101" => letras <= "011";--A
						when "1011" => letras <= "010";--L
						when "0111" => letras <= "001";--O
						when others => letras <= "110";--ESPACIO
					end case;
				else
					leds <= "01";		--IAO_
					audio <= "00";
					case ANS(7 downto 4) is
						when "1101" => letras <= "001";--O
						when "1011" => letras <= "011";--A
						when "0111" => letras <= "101";--I
						when others => letras <= "110";--ESPACIO
					end case;
				end if;
---------------------------------------------
			when "101" =>
				if sensor = '1' then--LA_ _
					leds <= "10";
					audio <= "00";
					case ANS(7 downto 4) is
						when "1011" => letras <= "011";--A
						when "0111" => letras <= "010";--L
						when others => letras <= "110";--ESPACIO
					end case;
				else
					leds <= "01";		--AO_ _
					audio <= "00";
					case ANS(7 downto 4) is
						when "1011" => letras <= "001";--O
						when "0111" => letras <= "011";--A
						when others => letras <= "110";--ESPACIO
					end case;
				end if;
---------------------------------------------
			when "110" =>
				if sensor = '1' then--A_ _ _
					leds <= "10";
					audio <= "00";
					case ANS(7 downto 4) is
						when "0111" => letras <= "011";--A
						when others => letras <= "110";--ESPACIO
					end case;
				else
					leds <= "01";		--O_ _ _
					audio <= "00";
					case ANS(7 downto 4) is
						when "0111" => letras <= "001";--O
						when others => letras <= "110";--ESPACIO
					end case;
				end if;
---------------------------------------------
			when "111" => 
				audio <= "00";
				letras <= "110";
				if sensor = '1' then--_ _ _ _
					leds <= "10";
				else
					leds <= "01";		--_ _ _ _
				end if;
---------------------------------------------
			when others => letras <= "111"; audio <= "00";
		end case;
	end process;
---------Letras en el display---------
	process (letras) begin
		case letras is
			when "000" => displays <= "10010001";--H
			when "001" => displays <= "00000011";--O
			when "010" => displays <= "11100011";--L
			when "011" => displays <= "00010001";--A
			when "100" => displays <= "01100011";--C
			when "101" => displays <= "10011111";--I
			when "110" => displays <= "11111111";--Espacio
			when "111" => displays <= "00000000";--ERROR
			when others => displays <= "00000000";
		end case;
	end process;
end Behavioral;

