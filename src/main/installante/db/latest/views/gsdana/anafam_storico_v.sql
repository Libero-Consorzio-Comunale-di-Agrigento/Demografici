--liquibase formatted sql
--changeset amonopoli:202502261540_2 runAlways:true runOnChange:true stripComments:false
create or replace view anafam_storico_v
AS
select fam.FASCIA
     , fam.COD_FAM                
     , fam.TIPO_FAM               
     , fam.COD_VIA                
     , fam.NUM_CIV                
     , fam.SUFFISSO               
     , fam.INTERNO                
     , to_char(null) VIA_AIRE               
     , to_number(null) COD_PRO_AIRE           
     , to_number(null) COD_COM_AIRE           
     , fam.CONVIVENZA             
     , fam.INTESTATARIO           
     , to_char(null) VIA_RES                
     , to_number(null) COD_PRO_RES            
     , to_number(null) COD_COM_RES            
     , fam.SCALA                  
     , fam.PIANO                  
     , to_char(null) ZIPCODE                
     , fam.PROGR_ELIMINAZIONE     
     , to_char(null) PROVINCIA_CONTEA       
     , to_char(null) PRESSO                 
     , fam.ID_DOCUMENTO_GDM       
     , fam.SUB_INTERNO            
     , fam.CIVICO_ESTERNO         
     , fam.CIVICO_INTERNO
     , fam.TIPO_CONVIVENZA        
     , fam.DATA_ISTITUZIONE       
     , fam.MATRICOLA_INTESTATARIO
     , fam.DATA_INTESTATARIO      
     , fam.D_DATA_ISTITUZIONE
     , fam.D_DATA_INTESTATARIO      
     , fam.COGNOME_INTESTATARIO
     , fam.NOME_INTESTATARIO
     , fam.COD_FAM_UNIQUE
     , fam.FLAG_METRICO   
     , fam.PROGR_SNC      
     , fam.FLAG_LETTERA   
     , fam.FLAG_ESPONENTE
     , fam.FLAG_NUI       
     , fam.NUI            
     , fam.COLORE         
     , fam.CORTE          
     , fam.INTERNO2       
     , fam.SUB_INTERNO2   
     , fam.SECONDARIO     
     , fam.SCALA_ESTERNA  
--
     , decode(fam.fascia, 1, 'RES', 2, 'RES', 3, 'AIR', 4, 'AIR', 6, 'NRE') anagrafe
     , to_number(null) matricola_CF
     , to_char(null) flag_esiste_CC
--
     , to_char(null) des_com_aire
     , to_char(null) sigla_pro_aire
     , to_char(null) des_com_res
     , to_char(null) sigla_pro_res
--
     , to_char(null) des_stato_interno
     , to_char(null) des_intestatario_interno
--
     , to_char(null) cod_consolato_aire
     , to_char(null) sede_consolato_aire
--
     , to_char(null) id_famiglia_anpr
     , nvl(fam.d_data_istituzione,trunc(sysdate)) d_data_inizio_res
     , trunc(sysdate) d_data_fine_res
     , nvl(fam.d_data_intestatario,trunc(sysdate)) d_data_inizio_fam
     , trunc(sysdate) d_data_fine_fam
  from anafam fam
 where tipo_fam = 1
UNION
select fam.FASCIA
     , fam.COD_FAM                
     , fam.TIPO_FAM               
     , eve_11.COD_VIA                
     , eve_11.NUM_CIV                
     , eve_11.SUFFISSO               
     , eve_11.INTERNO                
     , to_char(null) VIA_AIRE               
     , to_number(null) COD_PRO_AIRE           
     , to_number(null) COD_COM_AIRE           
     , fam.CONVIVENZA             
     , eve_10.cognome_nome INTESTATARIO           
     , to_char(null) VIA_RES                
     , to_number(null) COD_PRO_RES            
     , to_number(null) COD_COM_RES            
     , eve_11.SCALA                  
     , eve_11.PIANO                  
     , to_char(null) ZIPCODE                
     , fam.PROGR_ELIMINAZIONE     
     , to_char(null) PROVINCIA_CONTEA       
     , to_char(null) PRESSO                 
     , fam.ID_DOCUMENTO_GDM       
     , eve_11.SUB_INTERNO            
     , eve_11.CIVICO_ESTERNO         
     , eve_11.CIVICO_INTERNO
     , to_number(null) TIPO_CONVIVENZA        
     , to_number(null) DATA_ISTITUZIONE       
     , to_number(null) MATRICOLA_INTESTATARIO
     , to_number(null) DATA_INTESTATARIO      
     , to_date(null) D_DATA_ISTITUZIONE
     , to_date(null) D_DATA_INTESTATARIO      
     , f_cognome(eve_10.cognome_nome) COGNOME_INTESTATARIO
     , f_nome(eve_10.cognome_nome) NOME_INTESTATARIO
     , fam.cod_fam_unique COD_FAM_UNIQUE
     , to_char(null) --eve.FLAG_METRICO   
     , to_char(null) --eve.PROGR_SNC      
     , to_char(null) --eve.FLAG_LETTERA   
     , to_char(null) --eve.FLAG_ESPONENTE
     , to_char(null) --eve.FLAG_NUI       
     , to_char(null) --eve.NUI            
     , to_char(null) --eve.COLORE         
     , to_char(null) --eve.CORTE          
     , to_number(null) --eve.INTERNO2       
     , to_char(null) --eve.SUB_INTERNO2   
     , to_char(null) --eve.SECONDARIO     
     , to_char(null) --eve.SCALA_ESTERNA  
--
     , decode(fam.fascia, 1, 'RES', 2, 'RES', 3, 'AIR', 4, 'AIR', 6, 'NRE') anagrafe
     , eve_10.matricola matricola_CF
     , to_char(null) flag_esiste_CC
--
     , to_char(null) des_com_aire
     , to_char(null) sigla_pro_aire
     , to_char(null) des_com_res
     , to_char(null) sigla_pro_res
--
     , to_char(null) des_stato_interno
     , to_char(null) des_intestatario_interno
--
     , to_char(null) cod_consolato_aire
     , to_char(null) sede_consolato_aire
--
     , to_char(null) id_famiglia_anpr
     , to_date(eve_11.data_inizio_res,'j') d_data_inizio_res
     , to_date(eve_11.data_fine_res,'j') d_data_fine_res
     , to_date(eve_10.data_inizio_fam,'j') d_data_inizio_fam
     , to_date(eve_10.data_fine_fam,'j') d_data_fine_fam
  from (select ana.matricola, ana.fascia, ana.cognome_nome, ana.cod_fam,
               ana.data_inizio_fam data_inizio_fam,
               to_number(to_char(sysdate,'j')) data_fine_fam,
               ana.cod_fam_unique
          from anaana ana
         where ana.rapporto_par = 'CF'
           and fascia + 0       = 1
        union
        select ana.matricola, ana.fascia, ana.cognome_nome, eve.cod_fam,
               eve.data_inizio data_inizio_fam,
               eve.data_eve data_fine_fam,
               eve.cod_fam_unique
          from anaana ana, anaeve eve
         where ana.matricola    = eve.matricola
           and eve.rapporto_par = 'CF'
           and eve.cod_mov      = 10) eve_10
     , (select ana.matricola,
               fam.cod_via, fam.num_civ, fam.suffisso, fam.interno, fam.sub_interno, fam.scala, fam.piano,
               fam.civico_esterno, fam.civico_interno,
               ana.data_inizio_res data_inizio_res,
               to_number(to_char(sysdate,'j')) data_fine_res
          from anaana ana, anafam fam
         where fam.cod_fam_unique   = ana.cod_fam_unique
           and ana.fascia + 0       = 1
        union
        select ana.matricola,
               eve.cod_via, eve.num_civ, eve.suffisso, eve.interno, eve.sub_interno, eve.scala, eve.piano,
               eve.civico_esterno, eve.civico_interno,
               eve.data_inizio data_inizio_res,
               eve.data_eve data_fine_res
          from anaana ana, anaeve eve
         where ana.matricola    = eve.matricola
           and eve.cod_mov      = 11) eve_11
     , anafam fam
 where fam.cod_fam_unique = eve_10.cod_fam_unique
   and eve_10.matricola   = eve_11.matricola
/
comment on table anafam_storico_v is 'Anagrafe - Storico Famiglie / Indirizzi (view)'
/
