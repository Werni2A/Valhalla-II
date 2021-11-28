library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

-- 8 bit counter

entity COUNTER is
  port (
    CLK : in    std_logic;
    RST : in    std_logic; -- Low active reset
    CTR : out   std_logic_vector(7 downto 0)
  );
end entity COUNTER;

architecture BEHAVIOUR of COUNTER is

begin

  COUNT : process (clk, rst) is

    variable tmp : unsigned(7 downto 0) := (others => '0');

  begin

    if (rst = '0') then
      tmp := (others => '0');
    elsif rising_edge(clk) then
      tmp := tmp + 1;
    end if;

    ctr <= std_logic_vector(tmp);

  end process COUNT;

end architecture BEHAVIOUR;
