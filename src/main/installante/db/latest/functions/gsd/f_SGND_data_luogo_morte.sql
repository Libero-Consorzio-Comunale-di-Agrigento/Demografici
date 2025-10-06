--liquibase formatted sql
--changeset amonopoli:202309041645 runAlways:true runOnChange:true stripComments:false
create or replace function f_SGND_data_luogo_morte
(a_campo_c3		IN	varchar2
,a_campo_c4		IN	varchar2
,a_testo_ann		IN	varchar2
)

return varchar2

IS

w_testo_ann		varchar2(4000);
w_pos_data		number;
w_pos_luogo		number;

w_data_mor		varchar2(255);
w_luogo_mor		varchar2(255);

w_dati_mor		varchar2(4000);

begin
  if rtrim(a_campo_c3)||rtrim(a_campo_c4) is not null then
     w_data_mor  := rtrim(a_campo_c4);
     w_luogo_mor := rtrim(a_campo_c3);

  elsif rtrim(a_testo_ann) is not null then
     w_testo_ann := translate(a_testo_ann,'0123456789','9999999999');
     if w_testo_ann like '%99/99/9999%' then
        w_pos_data  := instr(w_testo_ann,'99/99/9999');
        w_data_mor  := substr(a_testo_ann,w_pos_data,10);
        w_testo_ann := rtrim(substr(w_testo_ann,1,w_pos_data-4));
        if upper(w_testo_ann) like '%DECEDUTO IN%' then
           w_pos_luogo := instr(upper(w_testo_ann),'DECEDUTO IN')+11;
        elsif upper(w_testo_ann) like '%MORTO IN%' then
           w_pos_luogo := instr(upper(w_testo_ann),'MORTO IN')+8;
        else
           w_pos_luogo := 0;
        end if;
        if w_pos_luogo > 0 then
           w_luogo_mor := ltrim(rtrim(substr(w_testo_ann,w_pos_luogo)));
        end if;
     end if;
  end if;

  w_dati_mor := w_data_mor||' a '||w_luogo_mor;

  return w_dati_mor;
end;
/
