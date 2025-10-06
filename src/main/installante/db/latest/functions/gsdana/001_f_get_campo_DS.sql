--liquibase formatted sql
--changeset amonopoli:202503171250 runOnChange:true stripComments:false
create or replace function f_get_campo_DS
(a_matricola	IN	number
,a_campo	IN	varchar2
)

RETURN varchar

IS

w_campo			varchar2(255);

w_errore			varchar2(255);
errore			exception;

begin

  begin
    select decode(upper(a_campo),
	 	 'DES_TIPO_DOCUMENTO',ddo.descrizione,
	 	 'TIPO_DOCUMENTO',str.tipo_DS,
	  	 'NUMERO',str.numero_DS,          
	  	 'DATA_EMISSIONE',str.data_emissione_DS,
	  	 'DATA_SCADENZA',str.data_scadenza_DS,
	  	 'FLAG_SCADENZA_ILLIMITATA',str.flag_scadenza_illimitata_DS,
	  	 'ENTE_EMISSIONE',str.ente_emissione_DS,
	  	 'COD_PRO_ENTE',str.cod_pro_ente_DS,
	  	 'COD_COM_ENTE',str.cod_com_ente_DS,
	  	 'NATURA_DOCUMENTO',str.natura_DS,
	  	 'MOTIVO_DOCUMENTO',str.motivo_DS
             )
      into w_campo
      from anaddo ddo, anastr str
     where ddo.cod_do (+) = str.tipo_ds
       and str.matricola  = a_matricola
    ;
  exception
    when no_data_found then
--         w_campo := 'no rows';
         raise errore;
    when too_many_rows then
--         w_campo := 'too many';
         raise errore;
    when others then
--         w_campo := SQLERRM;
         raise errore;
  end;

  RETURN w_campo;
exception
  when errore then
       w_errore := 'Errore in ricerca DS ('||SQLERRM||')';
       RETURN w_campo;
  when others then
--       w_campo := SQLERRM;
       w_errore := 'Errore ('||SQLERRM||')';
       RETURN w_campo;
end;
/
