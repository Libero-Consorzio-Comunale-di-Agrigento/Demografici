--liquibase formatted sql
--changeset amonopoli:202501290915 runOnChange:true stripComments:false
create or replace function f_ANSC_tipo_modifica_mat
(a_tipo_divorzio_ads IN varchar2
)

return varchar2

IS


w_return  varchar2(255);

begin
--
-- ANST54
-- 1 - Annullamento                         
-- 2 - Scioglimento                         
-- 3 - Pronunciamento della separazione
-- 4 - Omologazione della separazione       
--
-- TIPO_DIVORZIO_ADS
-- 'A' - Altro        ==> blank
-- 'C' - Cessazione   ==> 1 - Annullamento 
-- 'S' - Scioglimento ==> 2 - Scioglimento
-- 'X' - Separazione  ==> 3 - Pronunciamento della separazione
--

  if a_tipo_divorzio_ads = 'A' then
     w_return := '';
  elsif a_tipo_divorzio_ads = 'C' then
     w_return := '1';
  elsif a_tipo_divorzio_ads = 'S' then
     w_return := '2';
  elsif a_tipo_divorzio_ads = 'X' then
     w_return := '3';
  end if;


  return w_return;

end;
/
