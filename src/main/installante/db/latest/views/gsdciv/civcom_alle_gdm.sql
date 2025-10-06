--liquibase formatted sql
--changeset amonopoli:202303151320_1 runOnChange:true stripComments:false
create or replace view CIVCOM_ALLE_GDM
AS
select ca.ID                     
     , ca.ID_COM                 
     , ca.ALLEGATO_CLOB          
     , gof.testoocr ALLEGATO_BLOB          
     , ca.NOME_ALLEGATO          
     , ca.FLAG_DA_FIRMARE        
     , ca.FLAG_WS_FIRMA          
     , ca.NOTE_WS_FIRMA          
     , ca.D_DATA_REG             
     , ca.TERMINALISTA           
     , ca.FLAG_PRINCIPALE        
     , ca.ID_OGGETTO_FILE_GDM
  from gdm_oggetti_file gof
     , civcom_alle ca
 where gof.id_oggetto_file = ca.id_oggetto_file_gdm
/
comment on table civcom_alle_gdm is 'Stato Civile - Allegati per Comunicazioni salvati su GDM (view)'
/
