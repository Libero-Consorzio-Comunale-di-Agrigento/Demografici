--liquibase formatted sql
--changeset amonopoli:202503311640 runOnChange:true stripComments:false
create or replace view gsdcom_prot
as
select 'CIV' modulo_rif
     , 'CIVCOM' archivio_rif
     , com_p.id id_rif
     , com_p.id id_com
     , decode(com_p.oggetto,'',f_PROT_oggetto('CIVCOM',com_p.id), com_p.oggetto) oggetto
     , f_PROT_oggetto('CIVCOM',com_p.id,'INFO') oggetto_info
--     , com_p.INDICE_CLOB            
     , com_p.NOME_INDICE            
     , com_p.ANNO_PROTOCOLLO        
     , com_p.NUMERO_PROTOCOLLO
     , com_p.DATA_PROTOCOLLO        
     , com_p.FLAG_WS_PROT           
     , com_p.NOTE_WS_PROT           
     , f_PROT_flag_destinatari('CIVCOM',com_p.id) flag_destinatari
     , (select count(*) from civcom_dest where id_com = com_p.id) count_destinatari
     , f_PROT_flag_mail('CIVCOM',com_p.id) flag_mail
     , f_PROT_flag_allegati('CIVCOM',com_p.id) flag_allegati
     , (select count(*) from civcom_alle where id_com = com_p.id) count_allegati
     , (select count(*) from civcom_alle where id_com = com_p.id and flag_da_firmare is not null) count_allegati_da_firmare
     , (select count(*) from civcom_alle where id_com = com_p.id and flag_ws_firma is not null) count_allegati_firmati
     , to_char(com_p.d_data_reg,'dd/mm/yyyy') data_reg
     , to_char(com_p.d_data_reg,'hh24:mi:ss') ore_minuti_reg
     , com_p.terminalista
  from civcom_prot com_p
UNION
select 'ANA' modulo_rif
     , 'ANACOM' archivio_rif
     , com_p.id id_rif
     , com_p.id id_com
     , f_PROT_oggetto('ANACOM',com_p.id) oggetto
     , f_PROT_oggetto('ANACOM',com_p.id,'INFO') oggetto_info
--     , com_p.INDICE_CLOB            
     , com_p.NOME_INDICE            
     , com_p.ANNO_PROTOCOLLO        
     , com_p.NUMERO_PROTOCOLLO
     , com_p.DATA_PROTOCOLLO        
     , com_p.FLAG_WS_PROT           
     , com_p.NOTE_WS_PROT           
     , f_PROT_flag_destinatari('ANACOM',com_p.id) flag_destinatari
     , (select count(*) from anacom_dest where id_com = com_p.id) count_destinatari
     , f_PROT_flag_mail('ANACOM',com_p.id) flag_mail
     , f_PROT_flag_allegati('ANACOM',com_p.id) flag_allegati
     , (select count(*) from anacom_alle where id_com = com_p.id) count_allegati
     , (select count(*) from anacom_alle where id_com = com_p.id and flag_da_firmare is not null) count_allegati_da_firmare
     , (select count(*) from anacom_alle where id_com = com_p.id and flag_ws_firma is not null) count_allegati_firmati
     , to_char(com_p.d_data_reg,'dd/mm/yyyy') data_reg
     , to_char(com_p.d_data_reg,'hh24:mi:ss') ore_minuti_reg
     , com_p.terminalista
  from anacom_prot com_p
UNION
select 'LEV' modulo_rif
     , 'LEVCOM' archivio_rif
     , com_p.id id_rif
     , com_p.id id_com
     , f_PROT_oggetto('LEVCOM',com_p.id) oggetto
     , f_PROT_oggetto('LEVCOM',com_p.id,'INFO') oggetto_info
--     , com_p.INDICE_CLOB            
     , com_p.NOME_INDICE            
     , com_p.ANNO_PROTOCOLLO        
     , com_p.NUMERO_PROTOCOLLO
     , com_p.DATA_PROTOCOLLO        
     , com_p.FLAG_WS_PROT           
     , com_p.NOTE_WS_PROT           
     , f_PROT_flag_destinatari('LEVCOM',com_p.id) flag_destinatari
     , (select count(*) from levcom_dest where id_com = com_p.id) count_destinatari
     , f_PROT_flag_mail('LEVCOM',com_p.id) flag_mail
     , f_PROT_flag_allegati('LEVCOM',com_p.id) flag_allegati
     , (select count(*) from levcom_alle where id_com = com_p.id) count_allegati
     , (select count(*) from levcom_alle where id_com = com_p.id and flag_da_firmare is not null) count_allegati_da_firmare
     , (select count(*) from levcom_alle where id_com = com_p.id and flag_ws_firma is not null) count_allegati_firmati
     , to_char(com_p.d_data_reg,'dd/mm/yyyy') data_reg
     , to_char(com_p.d_data_reg,'hh24:mi:ss') ore_minuti_reg
     , com_p.terminalista
  from levcom_prot com_p
UNION
select 'ELE' modulo_rif
     , 'ELECOM' archivio_rif
     , com_p.id id_rif
     , com_p.id id_com
     , f_PROT_oggetto('ELECOM',com_p.id) oggetto
     , f_PROT_oggetto('ELECOM',com_p.id,'INFO') oggetto_info
--     , com_p.INDICE_CLOB            
     , com_p.NOME_INDICE            
     , com_p.ANNO_PROTOCOLLO        
     , com_p.NUMERO_PROTOCOLLO
     , com_p.DATA_PROTOCOLLO        
     , com_p.FLAG_WS_PROT           
     , com_p.NOTE_WS_PROT           
     , f_PROT_flag_destinatari('ELECOM',com_p.id) flag_destinatari
     , (select count(*) from elecom_dest where id_com = com_p.id) count_destinatari
     , f_PROT_flag_mail('ELECOM',com_p.id) flag_mail
     , f_PROT_flag_allegati('ELECOM',com_p.id) flag_allegati
     , (select count(*) from elecom_alle where id_com = com_p.id) count_allegati
     , (select count(*) from elecom_alle where id_com = com_p.id and flag_da_firmare is not null) count_allegati_da_firmare
     , (select count(*) from elecom_alle where id_com = com_p.id and flag_ws_firma is not null) count_allegati_firmati
     , to_char(com_p.d_data_reg,'dd/mm/yyyy') data_reg
     , to_char(com_p.d_data_reg,'hh24:mi:ss') ore_minuti_reg
     , com_p.terminalista
  from elecom_prot com_p
/
comment on table gsdcom_prot is 'Comunicazioni GSD da Protocollare'
/
