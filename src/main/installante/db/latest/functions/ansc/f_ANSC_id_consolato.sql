--liquibase formatted sql
--changeset ftravaglini:202308081643 runOnChange:true stripComments:false
create or replace function f_ANSC_id_consolato
(a_cod_pro				in number
,a_cod_com				in number
,a_descrizione			in varchar2
)

return varchar2

IS

w_descrizione   varchar2(255);
w_return	varchar2(255);

begin
  if a_cod_pro||a_cod_com is not null then
    w_descrizione := nvl(f_comune_al(a_cod_pro,a_cod_com,''),upper(a_descrizione));
  else
    w_descrizione := upper(a_descrizione);
  end if;
  
  begin
  select id into w_return
    from anst97
   where descrizione in (w_descrizione,translate(w_descrizione,' ','-'),translate(w_descrizione,'-',' '))
   ;
  exception
    when others then
         w_return := '';
  end;
  
  return w_return;
end;
/