--liquibase formatted sql
--changeset amonopoli:202605110855_4 runOnChange:true stripComments:false
create or replace function f_SCAW_catalogo_AUC
(p_matricola		number
,p_id_catalogo		number)

return varchar2

IS

w_progr_auc		number;
w_dati_auc		varchar2(32000);
w_catalogo		varchar2(32000);

cursor sel_auc is
select *
  from anawuc wuc
 where wuc.matricola	= p_matricola
 ORDER BY wuc.cognome_nome_mor
;

begin
  w_progr_auc	:= 0;

  for rec in sel_auc loop
      w_progr_auc	:= w_progr_auc + 1;

      w_dati_auc	:= rec.COGNOME_NOME_MOR||chr(9)||rec.SESSO_MOR||chr(10)||
			   rec.DATA_NAS_MOR||' '||rec.COMUNE_NASCITA_MOR||chr(10)||
			   rec.DATA_MOR||' '||rec.COMUNE_MOR||' '||rec.ATTO_MOR_EDIT||' '||rec.COMUNE_ATTO_MOR;

      if rec.data_cremazione is not null then
         w_dati_auc     := w_dati_auc||chr(10)||
			   rec.DATA_CREMAZIONE;
      end if;
  
      if rec.data_affidamento is not null then
         w_dati_auc     := w_dati_auc||chr(10)||
			   rec.DATA_AFFIDAMENTO;
      end if;
  
      if rec.note is not null then
         w_dati_auc     := w_dati_auc||chr(10)||
			   rec.NOTE;
      end if;

      if w_progr_auc = 1 then
	 w_catalogo	:= 'Dati Affidamento Urne Cinerarie:'||chr(10)||
                           w_dati_auc;
      else
	 w_catalogo 	:= w_catalogo||chr(10)||chr(10)||w_dati_auc;
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
