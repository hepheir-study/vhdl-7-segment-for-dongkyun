----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:    13:09:25 02/01/2021
-- Design Name:
-- Module Name:    gbseg - Behavioral
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
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity gbseg is
    Port ( RSTB : in std_logic;
           CLK_50M : in std_logic;
           DIGIT : inout std_logic_vector(3 downto 0);
           SEG : out std_logic_vector(7 downto 0));
end gbseg;

architecture Behavioral of gbseg is

signal clk_500 : std_logic;

begin
-----------------�ڸ�����  Clock 5MHz ----------------------
	process(RSTB,CLK_50M)

--	variable cnt : integer range 0 to 50000000;  -- ������ �� �ڸ�����
---	variable cnt : integer range 0 to 5000;  -- ���ÿ�
    variable cnt : integer range 0 to 5000000;  -- ����
		begin

			if RSTB = '0' then
				cnt := 0;
				clk_500 <= '0';

			elsif rising_edge (CLK_50M) then
---				if cnt >= 49999999 then             -- ������ �� �ڸ�����
---				if cnt >= 4999 then            -- ���ÿ�
				if cnt >= 4999999 then            -- ����

					cnt := 0;
					clk_500 <= not clk_500;

				else
					cnt := cnt + 1;
					clk_500 <= clk_500;

				end if;

			end if;

		end process;
-------------------Digit selection-------------------------

	process(RSTB,clk_500)

		begin

			if RSTB = '0' then
--				DIGIT <= "1110";  -- �����ʿ��� ������
			DIGIT <= "0111";  -- ���ʿ��� ������
			elsif rising_edge (clk_500) then
				DIGIT <=   DIGIT(0) & DIGIT(3 downto 1)   ; -- ���ʿ��� ������
--				DIGIT <=   DIGIT(2 downto 0) & DIGIT(3)  ; -- �����ʿ��� ����

			end if;

		end process;

-------------�� �ڸ����� ���� ����----------------------------
--- �κ귦 ���� �ݴ��? ���׸�Ʈ�� 0�� ���� 1�� ����
	process(DIGIT)

		begin

			case DIGIT is
							              --gfedcba
				when "0111" => SEG <= "11111001";  --���� ���ʵ���Ʈ
				when "1011" => SEG <= "10100100";  --2
				when "1101" => SEG <= "10110000";  --3
				when "1110" => SEG <= "10011001";  --4
				when others   => SEG <= "11111111";  --

			end case;

		end process;

end Behavioral;
