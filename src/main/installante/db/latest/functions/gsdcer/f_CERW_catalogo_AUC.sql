--liquibase formatted sql
--changeset amonopoli:202410171230_2 runOnChange:true stripComments:false
create or replace function f_CERW_catalogo_AUC
		(p_matricola		number,
		 p_id_catalogo		number)

return varchar2

IS

w_progr_auc		number;
w_dati_auc		varchar2(32000);
w_catalogo		varchar2(32000);

cursor sel_auc is
	select *
	  from anawuc
	 where matricola	= p_matricola
         order by cognome_nome_mor
        ;

begin
  w_progr_auc	:= 0;

  for rec in sel_auc loop
      w_progr_auc	:= w_progr_auc + 1;

      w_dati_auc	:= rec.COGNOME_NOME_MOR||' '||rec.SESSO_MOR||chr(10)||
			   'Dati di Nascita'||chr(9)||':'||chr(9)||rec.DATA_NAS_MOR||' '||rec.COMUNE_NASCITA_MOR||chr(10)||
			   'Dati di Morte'||chr(9)||':'||chr(9)||rec.DATA_MOR||' '||rec.COMUNE_MOR||chr(10)||
			   chr(9)||chr(9)||rec.ATTO_MOR_EDIT||chr(9)||rec.COMUNE_ATTO_MOR||chr(10)||
			   'Data Cremazione'||chr(9)||':'||chr(9)||rec.DATA_CREMAZIONE||chr(10)||
			   'Data Affidamento'||chr(9)||':'||chr(9)||rec.DATA_AFFIDAMENTO||chr(10)||
			   rec.NOTE;

      if w_progr_auc = 1 then
	 w_catalogo	:= w_dati_auc;
      else
	 w_catalogo 	:= w_catalogo||chr(10)||chr(10)||w_dati_auc;
      end if;
  end loop;

  if w_catalogo is null then
     w_catalogo	:= 'Nessuno';
  end if; 

  w_catalogo := w_catalogo||chr(10);

  return w_catalogo;

exception
  when others then
       w_catalogo := 'Nessuno';
       return w_catalogo;
end;
/
