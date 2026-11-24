--liquibase formatted sql
--changeset amonopoli:202510311115_1 runOnChange:true stripComments:false
create or replace function f_GSD_codice_ente

return varchar2

IS

w_ente    varchar2(255);

begin
  begin
    select 'C_'||m.codice_catasto
      into w_ente
      from arccom m
     where (m.cod_provincia,m.cod_comune) = (select pro_cliente, com_cliente from menuditta)
    ;
  exception
    when others then
         w_ente := '';
  end;

  if w_ente is null then
     w_ente := 'FINM';
  end if;

  return w_ente;

end;
/
