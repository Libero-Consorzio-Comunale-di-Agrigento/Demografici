--liquibase formatted sql
--changeset amonopoli:202512041255_3 runOnChange:true stripComments:false
create or replace function f_SAPW_catalogo_CDF
(a_cod_cdf		number
,a_matricola		number
,a_modello		varchar2
)
								   
return varchar2

IS

w_dati_cdf		varchar2(32000);

w_catalogo		varchar2(32000);

w_step			number;

cursor sel_cdf is
select *
  from cercdf
 where cod_cdf = a_cod_cdf
   and sequenza = 1
   and a_matricola is null
UNION
select * 
  from cercdf cdf
 where matricola = a_matricola
   and a_cod_cdf is null
;

begin
  for rec in sel_cdf loop
      if a_modello in ('CDF_1','CDF_2','CDF_3','CDF_4','CDF_5') then
w_step := 1;
	 w_dati_cdf	:= 'e la costituzione della convivenza di fatto'||chr(10)||
                           'fra '||rec.IL_LA_SIGNOR_A_1||' '||rec.COGNOME_1||' '||rec.NOME_1||' '||rec.NAT_OA_1||' a '||rec.COMUNE_NASCITA_1||' il '||rec.DATA_NASCITA_1||chr(10)||
                           'e '||rec.IL_LA_SIGNOR_A_2||' '||rec.COGNOME_2||' '||rec.NOME_2||' '||rec.NAT_OA_2||' '||rec.COMUNE_NASCITA_2||' il '||rec.DATA_NASCITA_2;
      end if;
  end loop;

  w_catalogo := w_dati_cdf||chr(10);

  return w_catalogo;

exception
  when others then
       w_catalogo := '';
       return w_catalogo;
end;
/
