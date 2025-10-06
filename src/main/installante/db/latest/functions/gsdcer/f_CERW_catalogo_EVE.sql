--liquibase formatted sql
--changeset amonopoli:202410171230_5 runOnChange:true stripComments:false
create or replace function f_CERW_catalogo_EVE
		(p_matricola		number,
		 p_id_catalogo		number)

return varchar2

IS

w_progr_eve		number;
w_dati_eve		varchar2(32000);
w_catalogo		varchar2(32000);

cursor sel_eve is
	select *
	  from cerwev
	 where matricola	= p_matricola
         order by sequenza                    
        ;

begin
  w_progr_eve	:= 0;

  for rec in sel_eve loop
      w_progr_eve	:= w_progr_eve + 1;

      if rec.tipo_variazione is null then
         w_dati_eve := rec.RIGA_EVENTO_ANAGRAFE;
      else
         w_dati_eve := rec.RIGA_EVENTO_ANAGRAFE||chr(10)||rec.TIPO_VARIAZIONE;
      end if;

      if w_progr_eve = 1 then
	 w_catalogo	:= w_dati_eve;
      else
--	 w_catalogo := w_catalogo||chr(10)||chr(10)||w_dati_eve;
	 w_catalogo := w_catalogo||chr(10)||w_dati_eve;
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
