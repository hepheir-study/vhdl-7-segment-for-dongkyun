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
        DIGIT : INOUT STD_LOGIC_VECTOR(3 DOWNTO 0); -- 8 슬라이드에 보면, DIGIT이 7 세그먼트를 선택하는 신호인 것으로 추측할 수 있다.
        SEG : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
END gbseg;

ARCHITECTURE Behavioral OF gbseg IS

    SIGNAL clk_500 : STD_LOGIC;

BEGIN
    -----------------자리 선택 Clock Generator : Clock 5MHz ----------------------
    -- https://m.blog.naver.com/pcs874/60102113193

    --    process 다음에 괄호안에 (clk,rst) 두개의 신호이름이 들어가 있습니다.
    --    이것은 sensitivity입니다. 감지 하는 것 이라고 생각하면 됩니다.
    --    그러니까 신호가 변하는 지를 보고 있다가 신호가 변하면
    --    프로세스 문 안으로 들어와서 실행을 한다는 의미입니다.

    PROCESS (RSTB, CLK_50M)

        -- 카운터 프로세스다.

        -- slide has this comment
        -- 5000000 50M/5M=10HZ and 10HZ/2=5 HZ

        --	variable cnt : integer range 0 to 50000000;  -- 占쏙옙占쏙옙占쏙옙 占쏙옙 占쌘몌옙占쏙옙占쏙옙
        ---	variable cnt : integer range 0 to 5000;  -- 占쏙옙占시울옙
        VARIABLE cnt : INTEGER RANGE 0 TO 5000000; -- 50M/50K=1KHZ and 1KHZ/2=500 HZ
    BEGIN

        IF RSTB = '0' THEN
            cnt := 0;           -- variable 인 경우에는 := 를 사용함
            clk_500 <= '0';     -- signal 인 경우에는 <= 를 사용함

        ELSIF rising_edge (CLK_50M) THEN
            ---				if cnt >= 49999999 then             -- 占쏙옙占쏙옙占쏙옙 占쏙옙 占쌘몌옙占쏙옙占쏙옙
            ---				if cnt >= 4999 then            -- 占쏙옙占시울옙
            IF cnt >= 4999999 THEN -- 정상동작시

                cnt := 0;
                clk_500 <= NOT clk_500; -- 완전 변했어 비트 반전급.. -> 87번 줄의 PROCESS 가 감지해.
                    -- 10HZ 의 갱신률, 1초에 10번 falling / rising edge 를 교차하고 있는, Digit Selection을 하고있는 것. 100ms

            ELSE
                cnt := cnt + 1;
                clk_500 <= clk_500; -- 사실은 변하지 않은..

            END IF;

        END IF;

    END PROCESS;
    -------------------Digit selection-------------------------

    PROCESS (RSTB, clk_500) -- 87번 줄 , yaw는 0.1초에 한 번 호출된다.

    BEGIN

        IF RSTB = '0' THEN -- 만약 최초 실행이다,
            --				DIGIT <= "1110";  -- 占쏙옙占쏙옙占십울옙占쏙옙 占쏙옙占쏙옙占쏙옙
            DIGIT <= "0111"; -- 맨 왼쪽 자리 선택. 맨 왼쪽부터 봐보자.
        ELSIF rising_edge (clk_500) THEN -- 라이징과 펄링에지중 라이즈만 보기 때문에 10/2 -> 5Hz 가 되어버림
            DIGIT <= DIGIT(0) & DIGIT(3 DOWNTO 1); -- 선택 자리 이동 : -> 로 로테이션 0111 -> 1011 -> 1101
            --				DIGIT <=   DIGIT(2 downto 0) & DIGIT(3)  ; -- 占쏙옙占쏙옙占십울옙占쏙옙 占쏙옙占쏙옙
            -- 0.2 초에 한번씩 세그먼트를 왼쪽에서 오른쪽으로 바꾸며 선택함.
        END IF;

    END PROCESS;

    ------------- 각 자리마다 숫자 표시 ----------------------------
    PROCESS (DIGIT)

    BEGIN

        CASE DIGIT IS
            -- Acitve low ***
                                -- .gfedcba  <- 7 세그먼트
            WHEN "0111" => SEG <= "11111001"; --1 [1][ ][ ][ ]
            WHEN "1011" => SEG <= "10100100"; --2 [ ][2][ ][ ]
            WHEN "1101" => SEG <= "10110000"; --3 [ ][ ][3][ ]
            WHEN "1110" => SEG <= "10011001"; --4 [ ][ ][ ][4]
            WHEN OTHERS => SEG <= "11111111"; --  [1][2][3][4]

        END CASE;

    END PROCESS;

--==========================================================
END Behavioral;
