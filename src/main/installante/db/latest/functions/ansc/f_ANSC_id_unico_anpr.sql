--liquibase formatted sql
--changeset amonopoli:202409301440 runOnChange:true stripComments:false
create or replace function f_ANSC_id_unico_anpr 
(a_matricola		IN	number
,a_cod_fiscale		IN	varchar2
)

return varchar2

IS

w_ambiente_ansc		varchar2(255);
w_ambiente_anpr		varchar2(255);

w_comune_cliente	varchar2(255);

w_id_unico		varchar2(255);

begin
  if a_matricola||a_cod_fiscale is not null then
     w_ambiente_ansc	:= rtrim(f_ANSC_valore_inp('AMBIENTE',1,10,'X','S'));
     w_ambiente_anpr	:= rtrim(f_ANPR_valore_inp('TIPO_INVIO',1,10,'X','S'));
     w_comune_cliente	:= f_get_comune_cliente('COD_COMUNE');

     if nvl(w_ambiente_ansc,'PROD') = 'PRE' then
        if w_ambiente_anpr = 'TEST' then
           w_id_unico := f_ANPR_id_unico(a_matricola,'');
        elsif w_comune_cliente = '023089' and a_matricola iN (31985,31986,31987,31988) then	-- VALEGGIO SUL MINCIO
           w_id_unico := f_ANPR_id_unico(a_matricola,'');
        elsif w_comune_cliente = '037054' and a_matricola iN (691043,691044,691045,691046) then	-- SAN LAZZARO DI SAVENA
           w_id_unico := f_ANPR_id_unico(a_matricola,'');
        else
           w_id_unico := to_char(null);
        end if;
     else
        w_id_unico := f_ANPR_id_unico(a_matricola,'');
     end if;
  end if;

  return w_id_unico;
end;
/
