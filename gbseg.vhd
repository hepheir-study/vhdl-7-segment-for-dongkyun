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
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY gbseg IS
    PORT (
        RSTB : IN STD_LOGIC;
        CLK_50M : IN STD_LOGIC;
        DIGIT : INOUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        SEG : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
END gbseg;

ARCHITECTURE Behavioral OF gbseg IS

    SIGNAL clk_500 : STD_LOGIC;

BEGIN
    -----------------�ڸ�����  Clock 5MHz ----------------------
    PROCESS (RSTB, CLK_50M)

        --	variable cnt : integer range 0 to 50000000;  -- ������ �� �ڸ�����
        ---	variable cnt : integer range 0 to 5000;  -- ���ÿ�
        VARIABLE cnt : INTEGER RANGE 0 TO 5000000; -- ����
    BEGIN

        IF RSTB = '0' THEN
            cnt := 0;
            clk_500 <= '0';

        ELSIF rising_edge (CLK_50M) THEN
            ---				if cnt >= 49999999 then             -- ������ �� �ڸ�����
            ---				if cnt >= 4999 then            -- ���ÿ�
            IF cnt >= 4999999 THEN -- ����

                cnt := 0;
                clk_500 <= NOT clk_500;

            ELSE
                cnt := cnt + 1;
                clk_500 <= clk_500;

            END IF;

        END IF;

    END PROCESS;
    -------------------Digit selection-------------------------

    PROCESS (RSTB, clk_500)

    BEGIN

        IF RSTB = '0' THEN
            --				DIGIT <= "1110";  -- �����ʿ��� ������
            DIGIT <= "0111"; -- ���ʿ��� ������
        ELSIF rising_edge (clk_500) THEN
            DIGIT <= DIGIT(0) & DIGIT(3 DOWNTO 1); -- ���ʿ��� ������
            --				DIGIT <=   DIGIT(2 downto 0) & DIGIT(3)  ; -- �����ʿ��� ����

        END IF;

    END PROCESS;

    -------------�� �ڸ����� ���� ����----------------------------
    --- �κ귦 ���� �ݴ��? ���׸�Ʈ�� 0�� ���� 1�� ����
    PROCESS (DIGIT)

    BEGIN

        CASE DIGIT IS
                --gfedcba
            WHEN "0111" => SEG <= "11111001"; --���� ���ʵ���Ʈ
            WHEN "1011" => SEG <= "10100100"; --2
            WHEN "1101" => SEG <= "10110000"; --3
            WHEN "1110" => SEG <= "10011001"; --4
            WHEN OTHERS => SEG <= "11111111"; --

        END CASE;

    END PROCESS;

END Behavioral;
