--liquibase formatted sql
--changeset amonopoli:202410171230_3 runOnChange:true stripComments:false
create or replace function f_CERW_catalogo_DOC
		(p_matricola		number,
		 p_tipo_documento	varchar2,
		 p_id_catalogo		number)

return varchar2

IS

w_progr_doc		number;
w_dati_doc		varchar2(32000);
w_catalogo		varchar2(32000);

w_categoria_edit	varchar2(255);

cursor sel_doc is
	select *
	  from cerdoc
	 where matricola	= p_matricola
	   and (tipo_documento 	= p_tipo_documento or p_tipo_documento = 'XX')
         order by tipo_documento, progr_documento                                
        ;

begin
  w_progr_doc	:= 0;

  for rec in sel_doc loop
      w_progr_doc	:= w_progr_doc + 1;

      if p_tipo_documento||p_id_catalogo = 'XX1' then
--	 w_dati_doc	:= rec.DOCUMENTO||chr(9)||rec.CATEGORIA_EDIT||chr(9)||rec.NUMERO_EDIT||chr(9)||
--			   rec.DATA_EMISSIONE_EDIT||chr(9)||rec.DATA_SCADENZA_EDIT||chr(10)||
--			   rec.ENTE_EMISSIONE||chr(9)||rec.COMUNE_EMISSIONE_EDIT||chr(9)||rec.ESPATRIO;
	 w_dati_doc	:= rec.DOCUMENTO||' '||rec.CATEGORIA_EDIT||' '||rec.NUMERO_EDIT||' '||
			   rec.DATA_EMISSIONE_EDIT||' '||rec.DATA_SCADENZA_EDIT||' '||
			   rec.ENTE_EMISSIONE||' '||rec.COMUNE_EMISSIONE_EDIT||' '||rec.ESPATRIO;
      elsif p_tipo_documento||p_id_catalogo = 'CC1' then
   	 w_dati_doc	:= '-'||chr(9)||rec.CATEGORIA||chr(9)||rec.NUMERO;
      elsif p_tipo_documento||p_id_catalogo = 'CC2' then
  	 w_dati_doc	:= rec.NUMERO;
      elsif p_tipo_documento||p_id_catalogo = 'PT1' then
	w_dati_doc	:= 'Categoria: '||rec.CATEGORIA||chr(9)||'Numero: '||rec.NUMERO||chr(10)||
			   'Rilasciata il '||rec.DATA_SCADENZA||' da '||rec.ENTE_EMISSIONE||' di '||rec.SIGLA_PROVINCIA_EMISSIONE;
      elsif p_tipo_documento||p_id_catalogo = 'PT2' then
	w_dati_doc	:= 'N. '||rec.NUMERO;
      end if;

      if w_progr_doc = 1 then
	 w_catalogo	:= w_dati_doc;
      else
	 if p_tipo_documento||p_id_catalogo in ('CC2','PT2') then
  	    w_catalogo 	:= w_catalogo||' - '||w_dati_doc;
	 else
  	    w_catalogo 	:= w_catalogo||chr(10)||w_dati_doc;
	 end if;
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
