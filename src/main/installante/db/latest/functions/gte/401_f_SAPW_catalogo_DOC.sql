--liquibase formatted sql
--changeset amonopoli:202512041255_2 runOnChange:true stripComments:false
create or replace function f_SAPW_catalogo_DOC
(p_matricola		number
,p_tipo_documento	varchar2
,p_modello		varchar2)

return varchar2

IS

w_progr_doc		number;
w_dati_doc		varchar2(32000);
w_catalogo		varchar2(32000);

w_step			number;

cursor sel_doc is
select *
  from cerwdo doc
 where cod_do               = p_tipo_documento
   and matricola	    = p_matricola
   and p_tipo_documento     in ('PT','CC')
UNION
select p_MATRICOLA MATRICOLA, 
       'XX' COD_DO, 
       to_number(null) PROGR_DOCUMENTO, 
       to_char(null) FLAG_IDENTITA, 
       to_char(null) FLAG_STRANIERI, 
       to_char(null) FLAG_NAZIONALITA_ITA, 
       to_number(null) COD_EN, 
       to_char(null) TIPO_DOCUMENTO, 
       to_char(null) DES_ENTE_EMISSIONE, 
       to_char(null) DATA_EMISSIONE, 
       to_char(null) DES_COM_EMISSIONE, 
       to_char(null) SIGLA_PRO_EMISSIONE, 
       to_char(null) CATEGORIA, 
       '-' NUMERO, 
       to_char(null) ESPATRIO, 
       to_char(null) DATA_SCADENZA, 
       to_char(null) DES_QUESTURA
  from dual
 where p_tipo_documento in ('PT','CC')
   and not exists (select 'x' from cerwdo doc
                    where matricola = p_matricola
                      and cod_do    = p_tipo_documento)
;

begin
  w_progr_doc	:= 0;

  for rec in sel_doc loop
      w_progr_doc	:= w_progr_doc + 1;

      if p_modello = 'DOC_CC_1' then
w_step := 1;
   	 w_dati_doc	:= '- '||rec.CATEGORIA||chr(9)||rec.NUMERO;

      elsif p_modello = 'DOC_CC_2' then
w_step := 2;
  	 w_dati_doc	:= rec.NUMERO;

      elsif p_modello = 'DOC_PT_1' then
w_step := 3;
	w_dati_doc	:= 'Categoria: '||rec.CATEGORIA||chr(9)||'Numero: '||rec.NUMERO||chr(10)||
			   'Rilasciata il '||rec.DATA_SCADENZA||' da '||rec.DES_ENTE_EMISSIONE||' di '||rec.SIGLA_PRO_EMISSIONE;

      elsif p_modello = 'DOC_PT_2' then
w_step := 4;
	w_dati_doc	:= 'N. '||rec.NUMERO;
      end if;

      if w_progr_doc = 1 then
w_step := 5;
	 w_catalogo	:= w_dati_doc;
      else
	 if p_modello in ('DOC_CC_2','DOC_PT_2') then
w_step := 6;
  	    w_catalogo 	:= w_catalogo||' - '||w_dati_doc;
	 else
w_step := 7;
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
--       w_catalogo := w_progr_doc||'.'||w_step||' - '||SQLERRM;
       return w_catalogo;
end;
/
