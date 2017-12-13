library ieee;
use ieee.std_logic_1164.all;

-- IPN - ESCOM
-- Arquitectura de Computadoras
-- ww ww ww - 3CM9
-- ww.com/arquitectura

-- Entidad
entity eww is
  port(
    entrada1_or: in std_logic;
    entrada2_or: in std_logic;
    salida_or: out std_logic);
end;

-- Arquitectura
architecture aww of eww is
  begin
    salida_or <= entrada1_or OR entrada2_or;
end aww;
