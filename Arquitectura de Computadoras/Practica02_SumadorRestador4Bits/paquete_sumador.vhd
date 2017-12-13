library ieee;
use ieee.std_logic_1164.all;

-- IPN - ESCOM
-- Arquitectura de Computadoras
-- ww ww ww - 3CM9
-- ww.com/arquitectura

package pack_sum is

  component eTopSumCompleto is
    port(
      acarreoI_tsc: in std_logic;
      entrada1_tsc: in std_logic;
      entrada2_tsc: in std_logic;
      resultado_tsc: out std_logic;
      acarreoO_tsc: out std_logic);
  end component;

  component eXnor
    port(
      entrada1_xnor: in std_logic;
      entrada2_xnor: in std_logic;
      salida_xnor: out std_logic);
  end component;

  component eAnd
    port(
      entrada1_and: in std_logic;
      entrada2_and: in std_logic;
      salida_and: out std_logic);
  end component;

  component eXor
    port(
      entrada1_xor: in std_logic;
      entrada2_xor: in std_logic;
      salida_xor: out std_logic);
  end component;

end pack_sum;
