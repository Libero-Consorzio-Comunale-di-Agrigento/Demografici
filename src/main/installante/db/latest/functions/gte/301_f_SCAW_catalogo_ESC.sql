--liquibase formatted sql
--changeset amonopoli:202605110855_3 runOnChange:true stripComments:false
create or replace function f_SCAW_catalogo_ESC
(p_matricola		number
,p_id_catalogo		number)

return varchar2

IS

w_progr_esc		number;
w_dati_esc		varchar2(32000);
w_catalogo		varchar2(32000);

cursor sel_esc is
select *
  from CERESC
 where matricola	= p_matricola
 order by ord1                    
;

begin
  w_progr_esc	:= 0;

  for rec in sel_esc loop
      w_progr_esc	:= w_progr_esc + 1;

      w_dati_esc	:= rec.DATI_ESC;
      if rec.dati_esc_atto is not null then
         w_dati_esc     := w_dati_esc||chr(10)||
			   chr(9)||rec.DATI_ESC_ATTO;
      end if;

      if w_progr_esc = 1 then
	 w_catalogo	:= w_dati_esc;
      else
	 w_catalogo 	:= w_catalogo||chr(10)||chr(10)||w_dati_esc;
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
