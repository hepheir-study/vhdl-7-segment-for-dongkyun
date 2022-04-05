LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY segkey IS
    PORT (
        CLK_50M : IN STD_LOGIC;
        RSTB : IN STD_LOGIC;
        KEY0 : IN STD_LOGIC;
        DIGIT : INOUT STD_LOGIC_VECTOR (3 DOWNTO 0);
        SEG : OUT STD_LOGIC_VECTOR (6 DOWNTO 0));
END segkey;

ARCHITECTURE Behavioral OF segkey IS

    SIGNAL clk_cnt : INTEGER RANGE 0 TO 50000000;-- 분주를 위한 카운터의 클럭

    SIGNAL one, ten : INTEGER RANGE 0 TO 9; -- 첫번째, 두번째

    -- signal hundred :integer range 0 to 9; -- 첫번째, 두번째

    SIGNAL out_one, out_ten : STD_LOGIC_VECTOR (6 DOWNTO 0);--7새그먼트로 뽑아내기

    SIGNAL com_count : INTEGER RANGE 0 TO 3;--com 단자로 뽑아내기위한 카운터

    SIGNAL clk_500, db_pushbuttons_previous, db_pushbuttons : STD_LOGIC;
BEGIN
    PROCESS (RSTB, CLK_50M)

        --	variable cnt : integer range 0 to 50000000;  -- 느리게 한 자리수씩
        VARIABLE cnt : INTEGER RANGE 0 TO 5000; -- 동시에
        ---    variable cnt : integer range 0 to 5000000;  -- 기준
    BEGIN

        IF RSTB = '0' THEN
            cnt := 0;
            clk_500 <= '0';

        ELSIF rising_edge (CLK_50M) THEN
            ---				if cnt >= 49999999 then             -- 느리게 한 자리수씩
            ---				if cnt >= 4999 then            -- 동시에
            IF cnt >= 4999 THEN -- 기준

                cnt := 0;
                clk_500 <= NOT clk_500;

            ELSE
                cnt := cnt + 1;
                clk_500 <= clk_500;

            END IF;

        END IF;

    END PROCESS;
    -------------------Digit selection-------------------------

    -- 첫번째자리 시작
    PROCESS (KEY0, clk_500, RSTB, one, ten, db_pushbuttons)
    BEGIN
        IF RSTB = '0' THEN
            one <= 0;
            ten <= 0;
            db_pushbuttons_previous <= '0';
        ELSIF rising_edge(clk_500) THEN
            --		db_pushbuttons <= KEY0 ;

            --      if db_pushbuttons = '1' and db_pushbuttons_previous = '0' then --rising edge detect
            IF KEY0 = '1' AND db_pushbuttons_previous <= '0' THEN
                db_pushbuttons_previous <= '1';
                IF one = 9 AND ten = 9 THEN
                    one <= 0;
                    ten <= 0;
                ELSIF one = 9 THEN
                    one <= 0;
                    ten <= ten + 1;
                ELSE
                    one <= one + 1;
                    --					   end if;
                END IF;
            ELSIF KEY0 = '0' THEN
                db_pushbuttons_previous <= '0';
            END IF;
        END IF;
        --		 end if;
    END PROCESS;
    --    if RSTB = '0' then
    --     ten <= 0;
    --    else
    --  if KEY0 = '1' then
    --          if one = 9 then
    --  if ten = 9 then
    --   ten <= 0;
    --  else
    --            ten <= ten + 1;
    --        end if;
    -- end if;
    --     end if;
    --     end if;
    --end process;
    --첫번째 출력
    PROCESS (one)
    BEGIN
        CASE one IS
            WHEN 0 => out_one <= "1000000";
            WHEN 1 => out_one <= "1111001";
            WHEN 2 => out_one <= "0100100";
            WHEN 3 => out_one <= "0110000";
            WHEN 4 => out_one <= "0011001";
            WHEN 5 => out_one <= "0010010";

            WHEN 6 => out_one <= "0000010";
            WHEN 7 => out_one <= "1011000";
            WHEN 8 => out_one <= "0000000";
            WHEN 9 => out_one <= "0011000";

                --  when others => out_one <= "1111111";
        END CASE;
    END PROCESS;

    PROCESS (ten)
    BEGIN
        CASE ten IS

            WHEN 0 => out_ten <= "1000000";
            WHEN 1 => out_ten <= "1111001";
            WHEN 2 => out_ten <= "0100100";
            WHEN 3 => out_ten <= "0110000";
            WHEN 4 => out_ten <= "0011001";
            WHEN 5 => out_ten <= "0010010";

            WHEN 6 => out_ten <= "0000010";
            WHEN 7 => out_ten <= "1011000";
            WHEN 8 => out_ten <= "0000000";

            WHEN 9 => out_ten <= "0011000";

                --  when others => out_ten <= "1111111";

        END CASE;
    END PROCESS;

    --process(RSTB,clk_500) --com_분주
    --begin
    --if RSTB ='0' then
    --  com_count<=0;
    -- else
    --  if clk_500'event and clk_500 = '1' then
    --   if com_count = 2 then
    --    com_count <=0;
    --   else
    --    com_count <= com_count+1;
    --   end if;
    --  end if;
    -- end if;
    ---end process;

    PROCESS (RSTB, clk_500)

    BEGIN

        IF RSTB = '0' THEN
            DIGIT <= "1110";
        ELSIF rising_edge (clk_500) THEN

            DIGIT <= DIGIT(2 DOWNTO 0) & DIGIT(3);

        END IF;

    END PROCESS;

    PROCESS (DIGIT, out_one)

    BEGIN
        CASE DIGIT IS
                --gfedcba
            WHEN "1110" => SEG <= out_one;
            WHEN "1101" => SEG <= out_ten;
                --				when "1011" => SEG <= out_hundred;
                --				when "0111" =>  SEG <= "1111111";
            WHEN OTHERS => SEG <= "1111111"; --
        END CASE;
    END PROCESS;

    -- com 과 SEG 단자 뽑아내기
    -- process (com_count,out_one,out_ten,out_hundred)
    --  begin
    -- case com_count is
    --  when 0=>  SEG <= out_one;
    --  when 1=> SEG <= out_ten;
    --  when 2=> SEG <= out_hundred;
    --  when others=> SEG<="1111111";
    -- end case;
    -- end process;
    --process (com_count)
    -- begin
    --case com_count is
    --  when 0=>   DIGIT <= "1110";
    -- when 1=>  DIGIT <= "1101";
    --  when 2=>  DIGIT <= "1011";
    --  when others=> DIGIT<= "1111";
    --end case;
    -- end process;
END Behavioral;
