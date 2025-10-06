--liquibase formatted sql
--changeset amonopoli:202307061645_3 runOnChange:true stripComments:false
create or replace function f_ANSC_dati_prodotti
(a_presentazione_doc 		IN	varchar2
)

return varchar2

IS

w_testo			varchar2(4000);
w_tipo			varchar2(10);

begin
-- 1 - Dati prodotti - PR
-- 2 - Dati non prodotti perché già acquisiti - AC
-- 3 - Dati visionati - VI

  if a_presentazione_doc is null then
     goto fine;
  end if;

  begin
    select t36.id
      into w_tipo
      from anst36 t36
     where presentazione_documenti_ads = a_presentazione_doc
       and rownum = 1
    ;
  exception
    when others then
         w_tipo := '';
  end;

<< fine >>

  return w_tipo;
end;
/
