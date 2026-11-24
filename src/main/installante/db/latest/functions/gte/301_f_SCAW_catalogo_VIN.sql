--liquibase formatted sql
--changeset amonopoli:202605110855_5 runOnChange:true stripComments:false
create or replace function f_SCAW_catalogo_VIN
(p_matricola		number
,p_id_catalogo		number)

return varchar2

IS

w_progr_vin		number;
w_dati_vin		varchar2(32000);
w_catalogo		varchar2(32000);

cursor sel_vin is
SELECT dtv.descrizione des_tipo_vaccinazione,
       DECODE(vin.anno_vacc,
         'S','00/'||TO_CHAR(TO_DATE(vin.data_vaccinazione,'j'),'mm/yyyy'),
             TO_CHAR(TO_DATE(vin.data_vaccinazione,'j'),'dd/mm/yyyy')) data_vaccinazione,
       vin.note note
  FROM ANADTV dtv,ANAVIN vin
 WHERE dtv.cod_tv       = vin.tipo_vaccinazione
   AND matricola        = p_matricola
 ORDER BY vin.tipo_vaccinazione, vin.progr_vaccinazione
;

begin
  w_progr_vin	:= 0;

  for rec in sel_vin loop
      w_progr_vin	:= w_progr_vin + 1; 

      w_dati_vin	:= rec.DATA_VACCINAZIONE||' - '||rec.DES_TIPO_VACCINAZIONE;

      if w_progr_vin = 1 then
	 w_catalogo	:= 'Vaccinazioni: '||chr(10)||
                           w_dati_vin;
      else
	 w_catalogo 	:= w_catalogo||chr(10)||w_dati_vin;
      end if;
  end loop;

  if w_catalogo is null then
     w_catalogo	:= '';
  end if; 

  w_catalogo := w_catalogo||chr(10);

  return w_catalogo;

exception
  when others then
       w_catalogo := '';
       return w_catalogo;
end;
/
