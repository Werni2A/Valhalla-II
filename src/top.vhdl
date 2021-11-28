library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity TOP is
  port (
    CLK  : in    std_logic; -- 12 MHz
    LED0 : out   std_logic;
    LED1 : out   std_logic;
    LED2 : out   std_logic;
    LED3 : out   std_logic;
    LED4 : out   std_logic;
    LED5 : out   std_logic;
    LED6 : out   std_logic;
    LED7 : out   std_logic
  );
end entity TOP;

architecture BEHAVIOUR of TOP is

  component COUNTER is
    port (
      CLK : in    std_logic;
      RST : in    std_logic;
      CTR : out   std_logic_vector(7 downto 0)
    );
  end component;

  signal led : std_logic_vector(7 downto 0) := (others => '0');

  signal clk_500_mhz : std_logic := '0';

begin

  LED0 <= led(0);
  LED1 <= led(1);
  LED2 <= led(2);
  LED3 <= led(3);
  LED4 <= led(4);
  LED5 <= led(5);
  LED6 <= led(6);
  LED7 <= led(7);

  -- Generate 500 mHz clock
  PRESCALER : process (clk) is

    variable timer : unsigned(23 downto 0) := (others => '0');

  begin

    if rising_edge(clk) then
      timer := timer + 1;

      if (timer = 3000000) then
        timer := (others => '0');
        clk_500_mhz <= not clk_500_mhz;
      end if;
    end if;

  end process PRESCALER;

  COUNTER_INST : component COUNTER
    port map (
      CLK => clk_500_mhz,
      RST => '1',
      CTR => led
    );

end architecture BEHAVIOUR;
