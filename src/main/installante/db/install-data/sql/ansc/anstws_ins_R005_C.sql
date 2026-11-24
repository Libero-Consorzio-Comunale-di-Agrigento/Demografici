--liquibase formatted sql
--changeset amonopoli:202601131650_2 runOnChange:true stripComments:false
insert into anstws
       (ID, SERVIZIO, DESCRIZIONE, URL, 
        FLAG_ATTRIBUTO_JWS, FLAG_AUTOMATICO, FLAG_ALLEGATI, FLAG_RIPETIZIONE, FLAG_VERIFICA, FLAG_DOWNLOAD_ALLEGATO, VERSION,
        FLAG_OBBLIGATORIO, FLAG_OTP_FIRMA, FLAG_CONSULTAZIONE_SOG, FLAG_CONSULTAZIONE_SOG_PRE, FLAG_CONSULTAZIONE_EVE, FLAG_CONSULTAZIONE_EVE_POST,
        FLAG_NOTIFICA_RICERCA, FLAG_NOTIFICA_CONFERMA, FLAG_ANNOTAZIONI, FLAG_DEFAULT,
        FLAG_VISIBILE,
        FLAG_NOTIFICA_RIFIUTO, FLAG_INVIO_MAIL_FIRMA, FLAG_ANNULLA_LINK_FIRMA,
        FLAG_VALIDAZIONE, FLAG_FIRMA_CARTACEA,
        FLAG_POOLING_PRESA_VISIONE, FLAG_CONSULTAZIONE_PV_POST,
        FLAG_CERTIFICATO_SEMPLICE, FLAG_ESTRATTO_RIASSUNTO, FLAG_ESTRATTO_INTEGRALE,
        FLAG_ATTESTAZIONE,
        TAB_COMUNICAZIONE,
        FLAG_CERTIFICAZIONE,
        FLAG_CONSULTAZIONE_SOG_PAR,
        FLAG_ALERT_ATTO_RETTIFICATO)
select 'R005_C',
       'R005',
       'Consultazione ANSC - Soggetto',
       'https://anscservicepre.anpr.interno.it/services/service/ricerca/consultazione/ansc/soggetto/1',
       'S',
       '',
       '',
       'S',
       '',
       '',
       0,
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       'S',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       'S',
       ''
  from dual
 where not exists (select 1 from anstws b
                    where b.id = 'R005_C'
                  )
/
update anstws
   set url                         = 'https://anscservicepre.anpr.interno.it/services/service/ricerca/consultazione/ansc/soggetto/1',
       flag_attributo_jws          = 'S',
       flag_automatico             = '',
       flag_allegati               = '',
       flag_ripetizione            = 'S',
       flag_verifica               = '',
       flag_download_allegato      = '',
       version                     = nvl(version,0),
       flag_obbligatorio           = '',
       flag_otp_firma              = '',
       flag_consultazione_sog      = '',
       flag_consultazione_sog_pre  = '',
       flag_consultazione_eve      = '',
       flag_consultazione_eve_post = '',
       flag_notifica_ricerca       = '',
       flag_notifica_conferma      = '',
       flag_annotazioni            = '',
       flag_default                = '',
       flag_visibile               = 'S',
       flag_notifica_rifiuto       = '',
       flag_invio_mail_firma       = '',
       flag_annulla_link_firma     = '',
       flag_validazione            = '',
       flag_firma_cartacea         = '',
       flag_pooling_presa_visione  = '',
       flag_consultazione_pv_post  = '',
       flag_certificato_semplice   = '',
       flag_estratto_riassunto     = '',
       flag_estratto_integrale     = '',
       flag_attestazione           = '',
       tab_comunicazione           = '',
       flag_certificazione         = '',
       flag_consultazione_sog_par  = 'S',
       flag_alert_atto_rettificato = ''
 where id = 'R005_C'
/
update anstws
   set url = replace(url,'https://anscservicepre.anpr.interno.it','https://anscservice.anpr.interno.it')
 where exists (select 'x' from ansinp
                where parametro = 'AMBIENTE'
                  and valore    = 'PROD')
/
