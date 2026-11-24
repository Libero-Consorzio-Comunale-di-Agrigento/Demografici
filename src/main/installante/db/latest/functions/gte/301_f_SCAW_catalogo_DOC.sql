--liquibase formatted sql
--changeset amonopoli:202605110855_2 runOnChange:true stripComments:false
create or replace function f_SCAW_catalogo_DOC
(p_matricola		number
,p_tipo_documento	varchar2
,p_ente			number
,p_id_catalogo		number)

return varchar2

IS

w_progr_doc		number;
w_dati_doc		varchar2(32000);
w_catalogo		varchar2(32000);

w_categoria_edit	varchar2(255);

cursor sel_doc is
select *
  from cerwdo doc
 where flag_stranieri       is null
   and matricola	    = p_matricola
   and p_tipo_documento     = 'XX'
UNION 
select *
  from cerwdo doc
 where flag_stranieri       is not null
   and flag_nazionalita_ita is null
   and progr_documento      = 1
   and matricola	    = p_matricola
   and p_tipo_documento     = 'XX'
UNION 
select *
  from cerwdo doc
 where flag_identita        is not null
   and matricola	    = p_matricola
   and p_tipo_documento     = 'CI'
UNION 
select *
  from cerwdo doc
 where flag_stranieri       is not null
   and matricola	    = p_matricola
   and p_tipo_documento     = 'PS'
UNION 
select *
  from cerwdo doc
 where cod_en               = nvl(p_ente,cod_en)
   and cod_do               = p_tipo_documento
   and matricola	    = p_matricola
   and p_tipo_documento     in ('LP','PT','CC')
UNION 
-- solo x SCAW il DOC_PT estrae sia patenti che carte di circolazione
select *
  from cerwdo doc
 where cod_do               in ('PT','CC')
   and matricola	    = p_matricola
   and p_tipo_documento     = 'PTCC'
 order by 2, 3
;

begin
  w_progr_doc	:= 0;

  for rec in sel_doc loop
      w_progr_doc	:= w_progr_doc + 1;

      if p_tipo_documento||p_id_catalogo in ('XX1','PTCC1','CI1') then
	 w_dati_doc	:= rec.TIPO_DOCUMENTO||' N. '||rec.NUMERO||' '||rec.CATEGORIA||' '||
			   rec.DATA_EMISSIONE||' '||rec.DES_ENTE_EMISSIONE||' '||rec.DES_COM_EMISSIONE||' '||
                           rec.ESPATRIO||' '||rec.DATA_SCADENZA;
      elsif p_tipo_documento||p_id_catalogo = 'PS1' then
	 w_dati_doc	:= 'Titolare di '||rec.TIPO_DOCUMENTO||' N. '||rec.NUMERO||' '||
			   rec.DATA_EMISSIONE||' '||rec.DATA_SCADENZA||chr(10)||
                           'Rilasciato dalla Questura di '||rec.DES_QUESTURA;

      elsif p_tipo_documento||p_id_catalogo = 'LP1' then
   	 w_dati_doc	:= 'Titolare di Pensione N. '||rec.NUMERO||' '||rec.CATEGORIA||' '||rec.DATA_EMISSIONE;

      elsif p_tipo_documento||p_id_catalogo = 'CC1' then
   	 w_dati_doc	:= '- '||rec.CATEGORIA||chr(9)||rec.NUMERO;

      elsif p_tipo_documento||p_id_catalogo = 'CC2' then
  	 w_dati_doc	:= rec.NUMERO;

      elsif p_tipo_documento||p_id_catalogo = 'PT1' then
	w_dati_doc	:= 'Categoria: '||rec.CATEGORIA||chr(9)||'Numero: '||rec.NUMERO||chr(10)||
			   'Rilasciata il '||rec.DATA_SCADENZA||' da '||rec.DES_ENTE_EMISSIONE||' di '||rec.SIGLA_PRO_EMISSIONE;

      elsif p_tipo_documento||p_id_catalogo = 'PT2' then
	w_dati_doc	:= 'N. '||rec.NUMERO;
      end if;

      if w_progr_doc = 1 then
	 w_catalogo	:= w_dati_doc;
      else
	 if p_tipo_documento||p_id_catalogo in ('CC2','PT2') then
  	    w_catalogo 	:= w_catalogo||' - '||w_dati_doc;
	 else
  	    w_catalogo 	:= w_catalogo||chr(10)||chr(10)||w_dati_doc;
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
