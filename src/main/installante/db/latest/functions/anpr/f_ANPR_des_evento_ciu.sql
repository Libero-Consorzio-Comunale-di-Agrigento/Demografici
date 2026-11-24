--liquibase formatted sql
--changeset amonopoli:202606171530 runOnChange:true stripComments:false
create or replace function f_ANPR_des_evento_ciu
(a_archivio_rif		IN	varchar2
,a_servizio 		IN	varchar2
,a_tipo_operazione	IN	varchar2
,a_cod_mov		IN 	number
,a_cod_eve		IN	number
,a_cod_variazione	IN	varchar2
,a_tipo_documento	IN	varchar2
,a_numero_documento	IN	varchar2
,a_sospensione		IN	number
)

return varchar2

IS

w_anagrafe		varchar2(255);
w_tipo_evento		varchar2(255);

w_descrizione 		varchar2(255);

begin
  if a_archivio_rif like 'MOV%' then
     if a_archivio_rif = 'MOV' then
        w_anagrafe    := f_ANPR_anagrafe_ciu(a_cod_mov,a_cod_eve);

        if a_servizio = '1014' then
           w_tipo_evento := f_ANPR_tipo_evento_ciu(a_cod_mov,a_cod_eve,'S');
           if a_tipo_operazione = 'I' then
              w_descrizione := 'APERTURA PROC.: '||w_anagrafe||'-'||w_tipo_evento;
           elsif a_tipo_operazione = 'C' then
              w_descrizione := 'CHIUSURA PROC.: '||w_anagrafe||'-'||w_tipo_evento;
           elsif a_tipo_operazione = 'R' then
              w_descrizione := 'RIGETTO PROC.: '||w_anagrafe||'-'||w_tipo_evento;
           else
              w_descrizione := 'GESTIONE PROC.: '||w_anagrafe||'-'||w_tipo_evento;
           end if;
        else
           w_tipo_evento := f_ANPR_tipo_evento_ciu(a_cod_mov,a_cod_eve);
           w_descrizione := f_get_campo_DCE(w_anagrafe,w_tipo_evento,a_cod_mov,a_cod_eve,a_cod_variazione,'DESCRIZIONE');
        end if;

     elsif a_archivio_rif = ('MOV_RP') then
        w_descrizione := 'CONFERMA RAPPORTO PARENTELA';
     end if;


  elsif a_archivio_rif like 'DOC%' then
     if a_archivio_rif = 'DOC_CDF' then
        w_descrizione := 'CDF - Contratto di Convivenza';

     else
        w_descrizione := a_tipo_documento||' N.'||a_numero_documento;
     end if;

  elsif a_archivio_rif like 'CDF%' then
     if a_archivio_rif = 'CDF_I' then
        w_descrizione := 'ISTITUZIONE CdF';
     elsif a_archivio_rif = 'CDF_F' then 
        w_descrizione := 'CESSAZIONE CdF';
     end if;

  elsif a_archivio_rif like 'MSI%' then
     w_descrizione := 'SOSP. '||a_sospensione;

  elsif a_archivio_rif like 'SFD%' then
     w_descrizione := 'SENZA FISSA DIMORA';
  
  elsif a_archivio_rif like 'ELE%' then
     w_descrizione := 'LISTE ELETTORALI';
     if a_archivio_rif like '%_CAR' then
        w_descrizione := w_descrizione||' (PRIMO CARICAMENTO)';
     end if;

  elsif a_archivio_rif = 'PSE' then
     w_descrizione := 'CERTIFICABILITA'' ELETTORALE';

  elsif a_archivio_rif = 'DSE' then
     w_descrizione := 'SEZIONI ELETTORALI';

  elsif a_archivio_rif like 'ELA%' then
     w_descrizione := 'LISTE AGGIUNTE';
     if a_archivio_rif like '%_CAR' then
        w_descrizione := w_descrizione||' (PRIMO CARICAMENTO)';
     end if;
 
  elsif a_archivio_rif like 'LEV%' then
     w_descrizione := 'LISTE DI LEVA';

  elsif a_archivio_rif like 'FAM%' then
     if a_servizio||a_tipo_operazione = '1010V' then
        w_descrizione := 'CREAZIONE CONVIVENZA';
     elsif a_servizio||a_tipo_operazione = '2009V' then
        w_descrizione := 'CHIUSURA CONVIVENZA';
     elsif a_servizio||a_tipo_operazione = '5001C' then
        w_descrizione := 'SPECIE / DENOMINAZIONE';
     elsif a_servizio||a_tipo_operazione = '5001V' then
        w_descrizione := 'INTESTATARIO';
     elsif a_servizio||a_tipo_operazione = '5001R' then
        w_descrizione := 'SBLOCCO CERTIFICABILITA SFA';
     end if;

  elsif a_archivio_rif like 'VIE%' then
     if length(a_archivio_rif) = 5 then
        begin
          select upper(descrizione) into w_descrizione
            from anpt46
           where codice = substr(a_archivio_rif,5,1)
             and rownum = 1
          ;
        exception
          when others then
               w_descrizione := 'RETTIFICA INDIRIZZO';
        end;
     elsif a_archivio_rif = 'VIE' then
        w_descrizione := 'REVISIONE ONOMASTICA STRADALE';
     end if;

  elsif a_archivio_rif like 'SUB%' then
     if a_archivio_rif = 'SUB_I' then
        w_descrizione := 'DATI ISCRIZIONE';
     elsif a_archivio_rif = 'SUB_R' then
        w_descrizione := 'DECORRENZA RESIDENZA';
     elsif a_archivio_rif = 'SUB_F' then
        w_descrizione := 'DECORRENZA FAMIGLIA'; 
     elsif a_archivio_rif = 'SUB_U' then
        w_descrizione := 'DATA ULTIMO AGGIORNAMENTO';
     elsif a_archivio_rif = 'SUB_P' then
        w_descrizione := 'DATA PRIMA ISCRIZIONE';
     end if;

  elsif a_archivio_rif like 'APR%' then
     if a_archivio_rif = 'APR' then
        w_descrizione := 'TUTTI DATI A.P.R.';
     end if;

  elsif a_archivio_rif like 'AIR%' then
     if a_archivio_rif = 'AIR' then
        w_descrizione := 'TUTTI DATI A.I.R.E.';
     elsif a_archivio_rif = 'AIR_M' then 
        w_descrizione := 'MATRIMONIO A.I.R.E.';
     end if;
  end if;

  if w_descrizione is null then
     w_descrizione := 'archivio_rif '||a_archivio_rif;
  end if;

  return w_descrizione;
end;
/
