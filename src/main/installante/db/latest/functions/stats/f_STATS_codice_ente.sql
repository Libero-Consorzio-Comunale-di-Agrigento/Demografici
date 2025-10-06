--liquibase formatted sql
--changeset amonopoli:202411191550_0 runOnChange:true stripComments:false
create or replace function f_STATS_codice_ente

return varchar2

IS

w_esiste_FINM	number := 0;
w_ente		varchar2(255);

begin
  begin
    select a.codice_amministrazione codice
      into w_ente
      from arccom m, so4_amministrazioni a
     where (m.cod_provincia,m.cod_comune) = (select pro_cliente, com_cliente from menuditta)
       and a.codice_amministrazione = 'C_'||m.codice_catasto
       and a.ente                   = 'SI'
    ;
  exception
    when others then
         w_ente := '';
  end;

  if w_ente is null then
     w_ente := 'FINM';

  elsif w_ente = 'C_A757' then
     begin
       select 1 into w_esiste_FINM
         from so4_amministrazioni
        where ente = 'SI'
          and codice_amministrazione = 'FINM'
       ;
     exception
       when others then
            w_esiste_FINM := 0;
     end;

     if w_esiste_FINM = 1 then
        w_ente := 'FINM';
     end if;
  end if;

  return w_ente;

end;
/
