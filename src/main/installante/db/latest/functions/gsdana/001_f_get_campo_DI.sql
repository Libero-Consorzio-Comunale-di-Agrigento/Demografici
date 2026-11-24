--liquibase formatted sql
--changeset amonopoli:202503061630_0 runOnChange:true stripComments:false
create or replace function F_GET_CAMPO_DI
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
	 	 'DES_TIPO_DOCUMENTO', ddo.descrizione,
	 	 'TIPO_DOCUMENTO', wdi.tipo_DI,
	  	 'NUMERO', wdi.numero_DI,          
	  	 'DATA_EMISSIONE', wdi.data_emissione_DI,
	  	 'DATA_SCADENZA', wdi.data_scadenza_DI,
	  	 'FLAG_SCADENZA_ILLIMITATA', wdi.flag_scadenza_illimitata_DI,
	  	 'ENTE_EMISSIONE', wdi.ente_emissione_DI,
	  	 'COD_PRO_ENTE', wdi.cod_pro_ente_DI,
	  	 'COD_COM_ENTE', wdi.cod_com_ente_DI,
	  	 'DES_COM_ENTE', f_comune_al(wdi.cod_pro_ente_DI,wdi.cod_com_ente_DI,''),
	  	 'SIGLA_PRO_ENTE', f_provincia_stato_al(wdi.cod_pro_ente_DI,wdi.cod_com_ente_DI,'','S','',''),
	  	 'NATURA_DOCUMENTO', wdi.natura_DI,
	  	 'MOTIVO_DOCUMENTO', wdi.motivo_DI,
		 'VAL_ESPATRIO', wdi.val_espatrio_DI
             )
      into w_campo
      from anaddo ddo, anawdi wdi
     where ddo.cod_do (+) = wdi.tipo_di
       and wdi.matricola  = a_matricola
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
       w_errore := 'Errore in ricerca DI ('||SQLERRM||')';
       RETURN w_campo;
  when others then
--       w_campo := SQLERRM;
       w_errore := 'Errore ('||SQLERRM||')';
       RETURN w_campo;
end;
/
