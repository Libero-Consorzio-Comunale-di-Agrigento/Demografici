--liquibase formatted sql
--changeset amonopoli:202503211226_2 runOnChange:true stripComments:false
CREATE OR REPLACE package body ISTEDP2 is
PROCEDURE MAIN   (prenotazione  IN number,
                  PASSO          IN number) is
p_prenotazione number;
p_passo        number;
P_pagina 	   number :=1;
P_riga   	   number :=0;
cursor sel_dati is
select substr(f_regione(nvl(a.cod_provincia,0)),1,2)||--  n1,
       substr(parametri,1,4)||--  n2,
       '13'||--  n3,
       lpad(to_char(nvl(a.cod_provincia,0)),3,'0')||--  n4,
       lpad(to_char(nvl(a.cod_comune,0)),3,'0')||--  n5,
       lpad(decode(nvl(substr(parametri,5,6),0),0,resid_m,                               
                      substr(parametri,5,6) + nvl(mov_1_m,0) - nvl(mov_2_3_m,0))
       - nvl(mov_1_m,0) + nvl(mov_2_3_m,0),7,'0')||--  n6,
       lpad(decode(nvl(substr(parametri,11,6),0),0,resid_f,                               
                      substr(parametri,11,6) + nvl(mov_1_f,0) - nvl(mov_2_3_f,0))
       - nvl(mov_1_f,0) + nvl(mov_2_3_f,0),7,'0')||--  n7,
       lpad(nati_or_m,5,'0')||--  n8,
       lpad(nati_or_f,5,'0')||--  n9,
       lpad(nati_tr_m,5,'0')||--  n10,
       lpad(nati_tr_f,5,'0')||--  n11,
       lpad(nati_est_m,5,'0')||--  n12,
       lpad(nati_est_f,5,'0')||--  n13,
       lpad(morti_or_m,5,'0')||--  n14,
       lpad(morti_or_f,5,'0')||--  n15,
       lpad(morti_tr_m,5,'0')||--  n16,
       lpad(morti_tr_f,5,'0')||--  n17,
       lpad(morti_est_m,5,'0')||--  n18,
       lpad(morti_est_f,5,'0')||--  n19,
       lpad((nvl(nati_or_m,0) + nvl(nati_tr_m,0) + nvl(nati_est_m,0) -        
              nvl(morti_or_m,0) - nvl(morti_tr_m,0) - nvl(morti_est_m,0)),5,'0')||--  n20,
       lpad((nvl(nati_or_f,0) + nvl(nati_tr_f,0) + nvl(nati_est_f,0) -        
              nvl(morti_or_f,0) - nvl(morti_tr_f,0) - nvl(morti_est_f,0)),5,'0')||--  n21,
       lpad(iscr_m,5,'0')||--  n22,
       lpad(iscr_f,5,'0')||--  n23,
       lpad(iscr_est_m,5,'0')||--  n24,
       lpad(iscr_est_f,5,'0')||--  n25,
       lpad(nvl(iscr_altri_m,0) + nvl(to_number(ltrim(substr(parametri,30,6),'0')),0),5,'0')||-- n26,
       lpad(nvl(iscr_altri_f,0) + nvl(to_number(ltrim(substr(parametri,36,6),'0')),0),5,'0')||--  n27,
       lpad(canc_m,5,'0')||--  n28,
       lpad(canc_f,5,'0')||--  n29,
       lpad(canc_est_m,5,'0')||--  n30,
       lpad(canc_est_f,5,'0')||--  n31,
       lpad(nvl(canc_altri_m,0)+nvl(to_number(ltrim(substr(parametri,42,6),'0')),0),5,'0')||--  n32,
       lpad(nvl(canc_altri_f,0)+nvl(to_number(ltrim(substr(parametri,48,6),'0')),0),5,'0')||--  n33,
       lpad((nvl(iscr_m,0) + nvl(iscr_est_m,0) + nvl(iscr_altri_m,0) +
             nvl(to_number(ltrim(substr(parametri,30,6),'0')),0) -        
               nvl(canc_m,0) - nvl(canc_est_m,0) - nvl(canc_altri_m,0) - 
               nvl(to_number(ltrim(substr(parametri,42,6),'0')),0)),5,'0')||--  n34,
       lpad((nvl(iscr_f,0) + nvl(iscr_est_f,0) + nvl(iscr_altri_f,0) +
             nvl(to_number(ltrim(substr(parametri,36,6),'0')),0) -        
               nvl(canc_f,0) - nvl(canc_est_f,0) - nvl(canc_altri_f,0)-
               nvl(to_number(ltrim(substr(parametri,48,6),'0')),0)),5,'0')||--  n35,
       lpad((nvl(nati_or_m,0) + nvl(nati_tr_m,0) + nvl(nati_est_m,0) -        
              nvl(morti_or_m,0) - nvl(morti_tr_m,0) - nvl(morti_est_m,0)) +
       (nvl(iscr_m,0) + nvl(iscr_est_m,0) + nvl(iscr_altri_m,0) + 
           nvl(to_number(ltrim(substr(parametri,30,6),'0')),0) -        
               nvl(canc_m,0) - nvl(canc_est_m,0) - nvl(canc_altri_m,0) -
               nvl(to_number(ltrim(substr(parametri,42,6),'0')),0)),5,'0')||--  n36,
       lpad((nvl(nati_or_f,0) + nvl(nati_tr_f,0) + nvl(nati_est_f,0) -        
              nvl(morti_or_f,0) - nvl(morti_tr_f,0) - nvl(morti_est_f,0)) +
       (nvl(iscr_f,0) + nvl(iscr_est_f,0) + nvl(iscr_altri_f,0) +
        nvl(to_number(ltrim(substr(parametri,36,6),'0')),0) -        
               nvl(canc_f,0) - nvl(canc_est_f,0) - nvl(canc_altri_f,0)-
               nvl(to_number(ltrim(substr(parametri,48,6),'0')),0)),5,'0')||--  n37,
       '       '||--  n38,
       '       '||--  n39,
       lpad((decode(nvl(substr(parametri,5,6),0),0,resid_m,                               
                      substr(parametri,5,6) + nvl(mov_1_m,0) - nvl(mov_2_3_m,0))
       - nvl(mov_1_m,0) + nvl(mov_2_3_m,0)+
       (nvl(nati_or_m,0) + nvl(nati_tr_m,0) + nvl(nati_est_m,0) -        
              nvl(morti_or_m,0) - nvl(morti_tr_m,0) - nvl(morti_est_m,0)) +
       (nvl(iscr_m,0) + nvl(iscr_est_m,0) + nvl(iscr_altri_m,0) +
        nvl(to_number(ltrim(substr(parametri,30,6),'0')),0) -        
               nvl(canc_m,0) - nvl(canc_est_m,0) - nvl(canc_altri_m,0) -
               nvl(to_number(ltrim(substr(parametri,42,6),'0')),0))),7,'0')||--  n40,
       lpad((decode(nvl(substr(parametri,11,6),0),0,resid_f,                               
                      substr(parametri,11,6) + nvl(mov_1_f,0) - nvl(mov_2_3_f,0))
       - nvl(mov_1_f,0) + nvl(mov_2_3_f,0) +
       (nvl(nati_or_f,0) + nvl(nati_tr_f,0) + nvl(nati_est_f,0) -        
              nvl(morti_or_f,0) - nvl(morti_tr_f,0) - nvl(morti_est_f,0)) +
       (nvl(iscr_f,0) + nvl(iscr_est_f,0) + nvl(iscr_altri_f,0) +
        nvl(to_number(ltrim(substr(parametri,36,6),'0')),0) -        
               nvl(canc_f,0) - nvl(canc_est_f,0) - nvl(canc_altri_f,0)-
               nvl(to_number(ltrim(substr(parametri,48,6),'0')),0) )),7,'0')||--  n41,
       lpad(' ',7,' ')||--  n42,
       lpad(' ',7,' ')||--  n43,
       lpad(' ',7,' ')||--  n44,
       lpad(' ',7,' ')||--  n45,
       lpad(' ',7,' ')||--  n46,
       lpad(' ',7,' ')||--  n47,
       lpad(decode(nvl(substr(parametri,17,6),0),0,nvl(famiglie,0)-nvl(nuove_fam,0) + nvl(fam_chiuse,0),
            substr(parametri,17,6) + nvl(nuove_fam_1,0) - nvl(fam_chiuse_1,0)),7,'0')||--  n48,
       lpad(decode(nvl(substr(parametri,23,6),0),0,nvl(convivenze,0) - nvl(nuove_conv,0) + nvl(conv_chiuse,0),
            substr(parametri,23,6) + nvl(nuove_conv_1,0) - nvl(conv_chiuse_1,0)),5,'0')||--  n49,
       '1' RIGA
   from arccom a, tabrep,
       (select count(decode(sesso,'M','M','')) resid_m,                                 
               count(decode(sesso,'F','F','')) resid_f                                
          from anaana,tabrep                                                           
         where fascia + 0 = 1                                                   
           and stato      != 17
           and substr(parametri,29,1) != 'S'
           and chiave = 'EDP2'                                                  
           and terminale = nvl(userenv('terminal'),'ISTEDP2')
       ) sel_resid,
      (select count(decode(sesso,'M','M','')) canc_m,                                 
               count(decode(sesso,'F','F','')) canc_f                                  
          from anamov mov, anadce dce, tabrep                                                           
         where data_reg between to_char(to_date('01/01/'||substr(parametri,1,4),'dd/mm/yyyy'),'j') and to_char(to_date('31/12/'||substr(parametri,1,4),'dd/mm/yyyy'),'j')                                 
           and mov.cod_mov               = dce.cod_mov
           and mov.cod_eve               = dce.cod_eve
            and nvl(mov.cod_variazione,' ') = nvl(dce.cod_variazione,' ')
           and mov.no_conteggio         is null
           and dce.tipo_evento         = 'C'
           and dce.tipo_evento_istat         = 'M'
            and dce.flag_istat               = 'S'
           and dce.anagrafe               = 'RES'
           and nvl(mov.cod_pro_eve,0)      < 199                                        
           and chiave = 'EDP2'                                                  
           and terminale = nvl(userenv('terminal'),'ISTEDP2')
       ) sel_canc,
       (select count(decode(sesso,'M','M','')) canc_altri_m,                                 
               count(decode(sesso,'F','F','')) canc_altri_f                                
          from anadce dce, anamov mov, tabrep                                                           
         where data_reg between to_char(to_date('01/01/'||substr(parametri,1,4),'dd/mm/yyyy'),'j') and to_char(to_date('31/12/'||substr(parametri,1,4),'dd/mm/yyyy'),'j')                                 
           and mov.cod_mov               = dce.cod_mov
            and mov.cod_eve               = dce.cod_eve
            and nvl(mov.cod_variazione,' ') = nvl(dce.cod_variazione,' ')
           and mov.no_conteggio         is null
           and dce.tipo_evento_istat       in ('I','A')
           and dce.tipo_evento             = 'C'
           and dce.flag_istat              = 'S'
           and dce.anagrafe                = 'RES'                                         
           and chiave = 'EDP2'                                                  
           and terminale = nvl(userenv('terminal'),'ISTEDP2')
       ) sel_canc_altri,
      (select count(decode(sesso,'M','M','')) canc_est_m,                                 
               count(decode(sesso,'F','F','')) canc_est_f                                  
          from anadce dce, anamov mov,tabrep                                                           
         where data_reg between to_char(to_date('01/01/'||substr(parametri,1,4),'dd/mm/yyyy'),'j') and to_char(to_date('31/12/'||substr(parametri,1,4),'dd/mm/yyyy'),'j')                                 
           and mov.cod_mov               = dce.cod_mov
           and mov.cod_eve               = dce.cod_eve
            and nvl(mov.cod_variazione,' ') = nvl(dce.cod_variazione,' ')
           and mov.no_conteggio         is null
           and dce.tipo_evento              = 'C'
           and dce.tipo_evento_istat       = 'M'
           and dce.flag_istat                 = 'S'
           and dce.anagrafe                 = 'RES'
           and nvl(mov.cod_pro_eve,0)      >= 199       
           and chiave = 'EDP2'                                                  
           and terminale = nvl(userenv('terminal'),'ISTEDP2')
       ) sel_canc_est,
       (select count(*) convivenze                      
          from anafam, tabrep                                                           
         where tipo_fam = 1                                                     
           and fascia + 0 = 1                                                   
           /*and exists (select 'x'                                               
                         from anaana                                            
                        where anafam.fascia  = anaana.fascia                    
                          and anafam.cod_fam = anaana.cod_fam
                          and stato          != 17)                  */
         --and substr(parametri,29,1) != 'S'                                                           
           and chiave = 'EDP2'                                                  
           and terminale = nvl(userenv('terminal'),'ISTEDP2')
       ) sel_convivenze,
      (select count(*) conv_chiuse                                                        
          from anamov,tabrep                                                           
         where (cod_mov = 2 or (cod_mov = 3 and cod_eve = 52)                   
                            or (cod_mov = 10 and cod_eve = 92))                 
           and nucleo_partenza = 1 
            and no_conteggio         is null                                             
           and decode(cod_eve,52,rapporto_par_prec,92,rapporto_par_prec,rapporto_par) in ('IC','CC')                          
           and data_reg between to_char(to_date('31/12/'||substr(parametri,1,4),'dd/mm/yyyy'),'j') and to_char(sysdate,'j')                             
          and chiave = 'EDP2'                                                  
           and terminale = nvl(userenv('terminal'),'ISTEDP2')
       ) sel_con_chiuse,
       (select count(*) conv_chiuse_1                                                         
          from anamov,tabrep                                                          
         where (cod_mov = 2 or (cod_mov = 3 and cod_eve = 52)                   
                            or (cod_mov = 10 and cod_eve = 92))      
           and no_conteggio         is null           
           and nucleo_partenza = 1                                              
           and decode(cod_eve,52,rapporto_par_prec,92,rapporto_par_prec,rapporto_par) in ('IC','CC')                              
           and data_reg between to_char(to_date('01/01/'||substr(parametri,1,4),'dd/mm/yyyy'),'j') and to_char(to_date('31/12/'||substr(parametri,1,4),'dd/mm/yyyy'),'j')                                 
           and chiave = 'EDP2'                                                  
           and terminale = nvl(userenv('terminal'),'ISTEDP2')
      ) sel_conv_chiuse_1,
      (select count(*) famiglie                        
          from anafam, tabrep                                                           
         where tipo_fam is null                                                 
           and fascia + 0 = 1                                                   
           and exists (select 'x'                                               
                         from anaana                                            
                        where anafam.fascia  = anaana.fascia                    
                          and anafam.cod_fam = anaana.cod_fam
                          and stato          != 17)                  
        --and substr(parametri,29,1) != 'S'                                                           
           and chiave = 'EDP2'                                                  
           and terminale = nvl(userenv('terminal'),'ISTEDP2')
      ) sel_famiglie,
      (select count(*) fam_chiuse                                                       
          from anamov, tabrep                                                          
         where (cod_mov = 2 or (cod_mov = 3 and cod_eve = 52)                   
                            or (cod_mov = 10 and cod_eve = 92))                 
           and nucleo_partenza = 1      
            and no_conteggio         is null                                        
           and decode(cod_eve,52,rapporto_par_prec,92,rapporto_par_prec,rapporto_par) = 'CF'                              
           and data_reg between to_char(to_date('31/12/'||substr(parametri,1,4),'dd/mm/yyyy'),'j') + 1 and to_char(sysdate,'j')                         
           and chiave = 'EDP2'                                                  
           and terminale = nvl(userenv('terminal'),'ISTEDP2')
      ) sel_fam_chiuse,
      (select count(*) fam_chiuse_1                                                         
          from anamov, tabrep                                                           
         where (cod_mov = 2 or (cod_mov = 3 and cod_eve = 52)                   
                            or (cod_mov = 10 and cod_eve = 92))                 
           and nucleo_partenza = 1 
            and no_conteggio         is null                                             
           and decode(cod_eve,52,rapporto_par_prec,92,rapporto_par_prec,rapporto_par) = 'CF'                                  
           and data_reg between to_char(to_date('01/01/'||substr(parametri,1,4),'dd/mm/yyyy'),'j') and to_char(to_date('31/12/'||substr(parametri,1,4),'dd/mm/yyyy'),'j')                                 
           and chiave = 'EDP2'                                                  
           and terminale = nvl(userenv('terminal'),'ISTEDP2')
     ) sel_fam_chiuse_1,
     ( select count(decode(sesso,'M','M','')) iscr_m,                                 
               count(decode(sesso,'F','F','')) iscr_f                                  
          from anadce dce, anamov mov, tabrep                                                          
         where data_reg between to_char(to_date('01/01/'||substr(parametri,1,4),'dd/mm/yyyy'),'j') and to_char(to_date('31/12/'||substr(parametri,1,4),'dd/mm/yyyy'),'j')                                
           and mov.cod_mov               = dce.cod_mov
           and mov.cod_eve               = dce.cod_eve
            and nvl(mov.cod_variazione,' ') = nvl(dce.cod_variazione,' ')
           and mov.no_conteggio         is null
           and dce.tipo_evento_istat       = 'M'
           and dce.tipo_evento              = 'I'
           and dce.flag_istat                 = 'S'
           and dce.anagrafe                 = 'RES'
           and nvl(mov.cod_pro_eve,0)      < 199                                                            
           and chiave = 'EDP2'                                                  
           and terminale = nvl(userenv('terminal'),'ISTEDP2')
     ) sel_iscr,
     (select count(decode(sesso,'M','M','')) iscr_altri_m,                               
               count(decode(sesso,'F','F','')) iscr_altri_f                                 
          from anadce dce, anamov mov, tabrep                                                           
         where data_reg between to_char(to_date('01/01/'||substr(parametri,1,4),'dd/mm/yyyy'),'j') and to_char(to_date('31/12/'||substr(parametri,1,4),'dd/mm/yyyy'),'j')                                 
           and mov.cod_mov              = dce.cod_mov
           and mov.cod_eve               = dce.cod_eve
           and nvl(mov.cod_variazione,' ') = nvl(dce.cod_variazione,' ')
           and mov.no_conteggio         is null
           and dce.tipo_evento_istat       in ('I','A')
           and dce.tipo_evento             = 'I'
           and dce.flag_istat              = 'S'
           and dce.anagrafe                = 'RES'                   
           and chiave = 'EDP2'                                                  
           and terminale = nvl(userenv('terminal'),'ISTEDP2')
      ) sel_iscr_altri,
      (select count(decode(sesso,'M','M','')) iscr_est_m,                                 
               count(decode(sesso,'F','F','')) iscr_est_f                              
          from anadce dce, anamov mov, tabrep                                                           
         where data_reg between to_char(to_date('01/01/'||substr(parametri,1,4),'dd/mm/yyyy'),'j') and to_char(to_date('31/12/'||substr(parametri,1,4),'dd/mm/yyyy'),'j')                                 
           and mov.cod_mov               = dce.cod_mov
           and mov.cod_eve                = dce.cod_eve
             and nvl(mov.cod_variazione,' ') = nvl(dce.cod_variazione,' ')
           and mov.no_conteggio         is null
           and dce.tipo_evento_istat       = 'M'
           and dce.tipo_evento              = 'I'
           and dce.flag_istat                 = 'S'
           and dce.anagrafe                 = 'RES'
           and nvl(mov.cod_pro_eve,0)      >= 199                       
           and chiave = 'EDP2'                                                  
           and terminale = nvl(userenv('terminal'),'ISTEDP2')
      ) sel_iscr_est,
      ( select count(decode(sesso,'M','M','')) morti_est_m,                                 
               count(decode(sesso,'F','F','')) morti_est_f                               
          from anadce dce, anamov mov,tabrep                                                           
         where data_reg between to_char(to_date('01/01/'||substr(parametri,1,4),'dd/mm/yyyy'),'j') and to_char(to_date('31/12/'||substr(parametri,1,4),'dd/mm/yyyy'),'j')                                 
           and mov.cod_mov               = dce.cod_mov
              and mov.cod_eve               = dce.cod_eve
            and nvl(mov.cod_variazione,' ') = nvl(dce.cod_variazione,' ')
           and mov.no_conteggio         is null
           and dce.tipo_evento_istat       = 'N'
           and dce.tipo_evento             = 'C'
           and dce.flag_istat              = 'S'
           and dce.anagrafe                = 'RES'
           and mov.cod_pro_mor             >= 199
           and chiave = 'EDP2'                                                  
           and terminale = nvl(userenv('terminal'),'ISTEDP2')
      ) sel_morti_est,
      (select count(decode(sesso,'M','M','')) morti_or_m,                                 
               count(decode(sesso,'F','F','')) morti_or_f                              
          from anadce dce, anamov mov, menuditta,tabrep                                                           
         where data_reg between to_char(to_date('01/01/'||substr(parametri,1,4),'dd/mm/yyyy'),'j') and to_char(to_date('31/12/'||substr(parametri,1,4),'dd/mm/yyyy'),'j')                                 
           and mov.cod_mov               = dce.cod_mov
              and mov.cod_eve               = dce.cod_eve
            and nvl(mov.cod_variazione,' ') = nvl(dce.cod_variazione,' ')
           and mov.no_conteggio         is null
           and dce.tipo_evento_istat       = 'N'
           and dce.tipo_evento             = 'C'
           and dce.flag_istat              = 'S'
           and dce.anagrafe                = 'RES'                                            
           and cod_pro_mor = pro_cliente                                        
           and cod_com_mor = com_cliente
           and chiave = 'EDP2'                                                  
           and terminale = nvl(userenv('terminal'),'ISTEDP2')
       ) sel_morti_or,
       (select count(decode(sesso,'M','M','')) morti_tr_m,                                 
               count(decode(sesso,'F','F','')) morti_tr_f                                 
          from anadce dce, anamov mov,menuditta,tabrep                                                           
         where data_reg between to_char(to_date('01/01/'||substr(parametri,1,4),'dd/mm/yyyy'),'j') and to_char(to_date('31/12/'||substr(parametri,1,4),'dd/mm/yyyy'),'j')                                 
           and mov.cod_mov               = dce.cod_mov
              and mov.cod_eve               = dce.cod_eve
            and nvl(mov.cod_variazione,' ') = nvl(dce.cod_variazione,' ')
           and mov.no_conteggio         is null
           and dce.tipo_evento_istat       = 'N'
           and dce.tipo_evento             = 'C'
           and dce.flag_istat              = 'S'
           and dce.anagrafe                = 'RES'
           and cod_pro_mor                 < 199                                      
           and (cod_pro_mor != pro_cliente or                                   
                cod_com_mor != com_cliente) 
           and chiave = 'EDP2'                                                  
           and terminale = nvl(userenv('terminal'),'ISTEDP2')
     ) sel_morti_tr,
     (select count(decode(sesso,'M','M','')) mov_1_m,                                 
               count(decode(sesso,'F','F','')) mov_1_f                               
          from anadce dce, anamov mov,tabrep                                                           
         where mov.cod_mov               = dce.cod_mov
            and mov.cod_eve               = dce.cod_eve
           and nvl(mov.cod_variazione,' ') = nvl(dce.cod_variazione,' ')
           and mov.no_conteggio         is null
           and dce.tipo_evento             = 'I'
           and dce.flag_istat              = 'S'
           and dce.anagrafe                = 'RES'                                              
           and data_reg between to_char(to_date('01/01/'||substr(parametri,1,4),'dd/mm/yyyy'),'j') and to_char(sysdate,'j')
           and chiave = 'EDP2'                                                  
           and terminale = nvl(userenv('terminal'),'ISTEDP2')
      ) m2,
     (select count(decode(sesso,'M','M',''))  mov_1_m_bis,                                 
               count(decode(sesso,'F','F','')) mov_1_f_bis                              
          from anadce dce, anamov mov, tabrep                                                          
         where mov.cod_mov               = dce.cod_mov
              and mov.cod_eve               = dce.cod_eve
            and nvl(mov.cod_variazione,' ') = nvl(dce.cod_variazione,' ')
           and mov.no_conteggio         is null
           and dce.tipo_evento             = 'I'
           and dce.flag_istat              = 'S'
           and dce.anagrafe                = 'RES'                                                   
           and data_reg between to_char(to_date('31/12/'||substr(parametri,1,4),'dd/mm/yyyy'),'j') + 1 and to_char(sysdate,'j')  
           and chiave = 'EDP2'                                                  
           and terminale = nvl(userenv('terminal'),'ISTEDP2')
       ) m3,
       (select count(decode(sesso,'M','M','')) mov_2_3_m,                                 
               count(decode(sesso,'F','F','')) mov_2_3_f                                
          from anadce dce, anamov mov, tabrep                                                           
         where mov.cod_mov               = dce.cod_mov
           and mov.cod_eve                 = dce.cod_eve
           and nvl(mov.cod_variazione,' ') = nvl(dce.cod_variazione,' ')
           and mov.no_conteggio         is null
           and dce.tipo_evento             = 'C'
           and dce.flag_istat              = 'S'
           and dce.anagrafe                = 'RES'                              
           and data_reg between to_char(to_date('01/01/'||substr(parametri,1,4),'dd/mm/yyyy'),'j') and to_char(sysdate,'j')
           and chiave = 'EDP2'                                                  
           and terminale = nvl(userenv('terminal'),'ISTEDP2')
        ) m4,
        (select count(decode(sesso,'M','M','')) mov_2_3_m_bis,                                 
               count(decode(sesso,'F','F','')) mov_2_3_f_bis                               
          from anadce dce, anamov mov, tabrep                                                           
         where mov.cod_mov                 = dce.cod_mov
           and mov.cod_eve                 = dce.cod_eve
           and nvl(mov.cod_variazione,' ') = nvl(dce.cod_variazione,' ')
           and mov.no_conteggio         is null
           and dce.tipo_evento             = 'C'
           and dce.flag_istat              = 'S'
           and dce.anagrafe                = 'RES'                      
           and data_reg between to_char(to_date('31/12/'||substr(parametri,1,4),'dd/mm/yyyy'),'j') + 1 and to_char(sysdate,'j')  
           and chiave = 'EDP2'                                                  
           and terminale = nvl(userenv('terminal'),'ISTEDP2')
      ) m5,
      (select count(decode(sesso,'M','M','')) nati_est_m,                                 
               count(decode(sesso,'F','F','')) nati_est_f                                
          from anadce dce, anamov mov, tabrep                                                          
         where data_reg between to_char(to_date('01/01/'||substr(parametri,1,4),'dd/mm/yyyy'),'j') and to_char(to_date('31/12/'||substr(parametri,1,4),'dd/mm/yyyy'),'j')                                 
           and mov.cod_mov               = dce.cod_mov
           and mov.cod_eve               = dce.cod_eve
            and nvl(mov.cod_variazione,' ') = nvl(dce.cod_variazione,' ')
           and mov.no_conteggio         is null 
           and dce.tipo_evento_istat         = 'N'
           and dce.tipo_evento         = 'I'
            and dce.flag_istat               = 'S'
           and dce.anagrafe               = 'RES'
           and cod_pro_nas                 >= 199
           and chiave = 'EDP2'                                                  
           and terminale = nvl(userenv('terminal'),'ISTEDP2')
      ) m6,
      (select count(decode(sesso,'M','M','')) nati_or_m,                                 
               count(decode(sesso,'F','F','')) nati_or_f                               
          from anadce dce, anamov mov,tabrep,menuditta                                                           
         where data_reg between to_char(to_date('01/01/'||substr(parametri,1,4),'dd/mm/yyyy'),'j') and to_char(to_date('31/12/'||substr(parametri,1,4),'dd/mm/yyyy'),'j')                                 
           and mov.cod_mov               = dce.cod_mov
           and mov.cod_eve               = dce.cod_eve
             and nvl(mov.cod_variazione,' ') = nvl(dce.cod_variazione,' ')
           and mov.no_conteggio         is null
           and dce.tipo_evento_istat         = 'N'
           and dce.tipo_evento         = 'I'
            and dce.flag_istat               = 'S'
           and dce.anagrafe               = 'RES'                                         
           and cod_pro_nas = pro_cliente                                        
           and cod_com_nas = com_cliente                       
           and chiave = 'EDP2'                                                  
           and terminale = nvl(userenv('terminal'),'ISTEDP2')
      ) m7,
      (select count(decode(sesso,'M','M','')) nati_tr_m,                                 
               count(decode(sesso,'F','F','')) nati_tr_f                               
          from anadce dce, anamov mov,tabrep,menuditta                                                           
         where data_reg between to_char(to_date('01/01/'||substr(parametri,1,4),'dd/mm/yyyy'),'j') and to_char(to_date('31/12/'||substr(parametri,1,4),'dd/mm/yyyy'),'j')                                 
           and mov.cod_mov               = dce.cod_mov
           and mov.cod_eve               = dce.cod_eve
            and nvl(mov.cod_variazione,' ') = nvl(dce.cod_variazione,' ')
           and mov.no_conteggio         is null
           and dce.tipo_evento_istat         = 'N'
           and dce.tipo_evento         = 'I'
            and dce.flag_istat               = 'S'
           and dce.anagrafe               = 'RES'
           and mov.cod_pro_nas             < 199                                        
           and (cod_pro_nas != pro_cliente or                                   
                cod_com_nas != com_cliente)                                     
           and chiave = 'EDP2'                                                  
           and terminale = nvl(userenv('terminal'),'ISTEDP2')
       ) m8,
       (select count(*)  nuove_conv                                                       
          from anamov ,tabrep                                                          
         where (cod_mov = 1 or (cod_mov = 10 and cod_eve = 92))           
           and no_conteggio         is null      
           and nucleo_arrivo = 1                                                
           and rapporto_par  = 'CC'                                             
           and data_reg between to_char(to_date('31/12/'||substr(parametri,1,4),'dd/mm/yyyy'),'j') + 1 and to_char(sysdate,'j')
           and chiave = 'EDP2'                                                  
           and terminale = nvl(userenv('terminal'),'ISTEDP2')
      ) m9,
      (select count(*)  nuove_fam                                                        
          from anamov,tabrep                                                           
         where (cod_mov = 1 or (cod_mov = 10 and cod_eve = 92))                 
           and nucleo_arrivo = 1 
           and no_conteggio         is null                                               
           and rapporto_par  = 'CF'                                             
           and data_reg between to_char(to_date('31/12/'||substr(parametri,1,4),'dd/mm/yyyy'),'j') + 1 and to_char(sysdate,'j') 
           and chiave = 'EDP2'                                                  
           and terminale = nvl(userenv('terminal'),'ISTEDP2')
       ) m10,
       (select count(*) nuove_fam_1                                                        
          from anamov,tabrep                                                         
         where (cod_mov = 1 or (cod_mov = 10 and cod_eve = 92))                 
           and nucleo_arrivo = 1   
           and no_conteggio         is null                                             
           and rapporto_par  = 'CF'                                             
           and data_reg between to_char(to_date('01/01/'||substr(parametri,1,4),'dd/mm/yyyy'),'j') and 
                                to_char(to_date('31/12/'||substr(parametri,1,4),'dd/mm/yyyy'),'j')
           and chiave = 'EDP2'                                                  
           and terminale = nvl(userenv('terminal'),'ISTEDP2')
      ) m11,
      (select count(*)     nuove_conv_1                                                    
          from anamov,tabrep                                                          
         where (cod_mov = 1 or (cod_mov = 10 and cod_eve = 92))                 
           and nucleo_arrivo = 1    
           and no_conteggio         is null                                            
           and rapporto_par  = 'CC'                                             
           and data_reg between to_char(to_date('01/01/'||substr(parametri,1,4),'dd/mm/yyyy'),'j') and 
                                to_char(to_date('31/12/'||substr(parametri,1,4),'dd/mm/yyyy'),'j')
           and chiave = 'EDP2'                                                  
           and terminale = nvl(userenv('terminal'),'ISTEDP2')
       ) m12
 where (a.cod_provincia,a.cod_comune) =
             (select pro_cliente, com_cliente
                from menuditta)
   and chiave = 'EDP2'
   and terminale = nvl(userenv('terminal'),'ISTEDP2')
;
BEGIN
p_prenotazione := prenotazione;
p_passo        := passo;
declare 
codice_istat varchar2(10);
begin
  begin
   select lpad(pro_cliente,3,'0')||lpad(com_cliente,3,'0')
     into codice_istat
     from menuditta;
  exception
    when others then
      codice_istat := '';
  end;

begin
  update a_selezioni
     set valore_default = 'istatel\'||codice_istat||'_P2_'||to_char(sysdate,'yymmdd')||'.txt'
   where parametro 	= 'TXTFILE'
     and voce_menu	= 'ISTEDP2'
  ;
end;
commit;
end;
for dati in sel_dati loop
  begin
           P_riga   := P_riga   + 1;
           insert into a_appoggio_stampe
           values ( p_prenotazione
                  , p_passo
                  , P_pagina
                  , P_riga
                  , dati.riga
                  )
           ;
	end;
end loop;
commit;
END MAIN;
FUNCTION VERSIONE  RETURN varchar2 IS
/******************************************************************************
 NOME:        VERSIONE
 DESCRIZIONE: Restituisce la versione e la data di distribuzione del package.
 PARAMETRI:   --
 RITORNA:     stringa varchar2 contenente versione e data.
 NOTE:        Il secondo numero della versione corrisponde alla revisione
              del package.
******************************************************************************/
BEGIN
   RETURN 'V1.0 del 29/07/2003';
END VERSIONE;
END ISTEDP2;
/
