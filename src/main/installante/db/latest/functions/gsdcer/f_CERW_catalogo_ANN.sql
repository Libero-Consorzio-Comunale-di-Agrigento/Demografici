--liquibase formatted sql
--changeset amonopoli:202410171230_1 runOnChange:true stripComments:false
create or replace function f_CERW_catalogo_ANN
		(p_tipo_atto		number,
		 p_ufficio		number,
	 	 p_anno			number,
		 p_atto			number,
		 p_parte		number,
		 p_serie		varchar2,
		 p_id_catalogo		number)

return varchar2

IS

w_progr_ann		number;
w_dati_ann		varchar2(32000);
w_catalogo		varchar2(32000);

cursor sel_ann is
	select *
	  from cerann
	 where tipo_atto	= p_tipo_atto
	   and nvl(ufficio,0)	= nvl(p_ufficio,0)
	   and nvl(anno,0)	= nvl(p_anno,0)
	   and atto		= p_atto
	   and nvl(parte,0)	= nvl(p_parte,0)
	   and nvl(serie,' ')	= nvl(p_serie,' ')
         order by sequenza                    
        ;

begin
  w_progr_ann	:= 0;

  for rec in sel_ann loop
      w_progr_ann	:= w_progr_ann + 1;

      w_dati_ann	:= rec.TESTO_ANNOTAZIONE;

      if w_progr_ann = 1 then
	 w_catalogo	:= 'Annotazioni:'||chr(10)||chr(10)||w_dati_ann;
      else
	 w_catalogo 	:= w_catalogo||chr(10)||chr(10)||w_dati_ann;
      end if;
  end loop; 

  if w_catalogo is null then
     w_catalogo	:= 'Non esistono Annotazioni';
  end if; 

  w_catalogo := w_catalogo||chr(10);

  return w_catalogo;

exception
  when others then
       w_catalogo := 'Non esistono Annotazioni';
       return w_catalogo;
end;
/
