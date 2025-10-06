--liquibase formatted sql
--changeset amonopoli:202405271420_1 runOnChange:true stripComments:false
create or replace view istedd4_v
       (data_reg, data_mor, d_data_reg, d_data_mor, riga)
AS
select mor.data_reg, 
       nvl(mor.data_mor,mor.data_reg),
       mor.d_data_reg, 
       nvl(mor.d_data_mor,mor.d_data_reg),
-- numero_atto_morte
	lpad(nvl(md4.atto,0),5,'0')||-- a1_5, 
-- parte_atto_morte, serie_atto_morte
       decode(md4.parte,1,'1 ',2,decode(md4.serie,'B','21','C','22','20'),'0')||--  a6_7, 
-- circoscrizione
       '00'||-- a8_9, 
-- comune_morte
       lpad(nvl(mor.cod_com_mor,000),3,'0')||--  a10_12, 
-- provinci_morte
       lpad(nvl(mor.cod_pro_mor,888),3,'0')||--  a13_15, 
-- numero_scheda
       lpad(nvl(md4.numero_scheda,'0'),4,'0')||--  a16_19, 
-- sesso
       decode(mor.sesso,'M','1','F','2','0')||--  a20, 
-- data_morte
       nvl(to_char(to_date(mor.data_mor,'j'),'dd'),'00')||--  a21_22, 
       nvl(to_char(to_date(mor.data_mor,'j'),'mm'),'00')||--  a23_24, 
       nvl(to_char(to_date(mor.data_mor,'j'),'yyyy'),'0000')||--  a25_28, 
-- data_nascita
       nvl(to_char(to_date(mor.data_nas,'j'),'dd'),'00')||--  a29_30, 
       nvl(to_char(to_date(mor.data_nas,'j'),'mm'),'00')||--  a31_32, 
       nvl(to_char(to_date(mor.data_nas,'j'),'yyyy'),'0000')||--  a33_36, 
-- luogo_nascita
       decode(lpad(nvl(mor.cod_com_nas,0),3,'0')||lpad(nvl(mor.cod_pro_nas,0),3,'0'), 
              lpad(nvl(mor.cod_com_mor,0),3,'0')||lpad(nvl(mor.cod_pro_mor,0),3,'0'), 
              '1'||lpad(nvl(mor.cod_com_nas,0),3,'0')||lpad(nvl(mor.cod_pro_nas,0),3,'0'), 
              '000000','2000888', 
              decode(sign(nvl(mor.cod_pro_nas,0)-199), 
                     -1,'2'||lpad(nvl(mor.cod_com_nas,000),3,'0')||lpad(nvl(mor.cod_pro_nas,888),3,'0'), 
                      '3000'||lpad(nvl(mor.cod_pro_nas,777),3,'0')))||--  a37_43, 
-- eta
       decode(mor.data_nas,null,lpad(nvl(mor.anni,0),3,'0'),
	 lpad(nvl(
	 decode(sign(TO_CHAR(to_date(mor.data_mor,'j'),'mmdd') - TO_CHAR(to_date(mor.data_nas,'j'),'mmdd')),
         	 -1,TO_CHAR(to_date(mor.data_mor,'j'),'YYYY') - TO_CHAR(to_date(mor.data_nas,'j'),'YYYY') -1,
            	    TO_CHAR(to_date(mor.data_mor,'j'),'YYYY') - TO_CHAR(to_date(mor.data_nas,'j'),'YYYY')),0),3,'0'))||--  a44_46,
       '4'||--  a47,
-- stato_civile, dati_coniuge
       decode(nvl(mor.stato_civile,'00'),'00','0        ',
              'CE','1        ',
	      'NU','1        ',
              'CN',decode(flag_separato,'S','5','2')||lpad(nvl(anno_nas_cn,0),4,'0')||lpad(nvl(anno_mat,0),4,'0'),
              'VE','3        ',
              'DV','4        ',
              'GC','4        ',
              'UC','5        ',
              'VU','6        ',
              'GU','7        ',
                   '0        ')||--  a48_56,
-- luogo_residenza
       decode(lpad(nvl(mor.cod_com_res,0),3,'0')||lpad(nvl(mor.cod_pro_res,0),3,'0'), 
              lpad(nvl(mor.cod_com_mor,0),3,'0')||lpad(nvl(mor.cod_pro_mor,0),3,'0'), 
              '1      ', 
              '000000','2000888', 
              decode(sign(nvl(mor.cod_pro_res,0)-199), 
                     -1,'2'||lpad(nvl(mor.cod_com_res,000),3,'0')||lpad(nvl(mor.cod_pro_res,888),3,'0'), 
                      '3000'||lpad(nvl(mor.cod_pro_res,777),3,'0')))||--  a57_63,
-- grado_istruzione
       nvl(to_char(md4.grado_istruzione),' ')||--  a64, 
-- condizione_professionale
       nvl(to_char(md4.condizione_prof),' ')||--  a65, 
-- posizione_profess
       decode(md4.condizione_prof,1,nvl(to_char(md4.posizione_prof),' '),' ')||--  a66,
-- ramo_attivita
       decode(md4.condizione_prof,1,nvl(to_char(md4.attivita_prof),' '),' ')||--  a67,
-- cittadinanza
       decode(nazionalita_ita,1,'1000',2,'2000','3'||lpad(to_char(nvl(dci.ist_ci,777)),3,'0000'))||--  a68_71,
-- codice_individuale
       lpad(nvl(mor.cod_fiscale,' '),16,' ') riga
  from civmor mor,anadci dci, istmd4 md4
 where dci.cod_ci  (+) = md4.nazionalita 
   and nvl(md4.serie,' ') = nvl(mor.serie,' ') 
   and md4.parte      = mor.parte 
   and md4.atto       = mor.atto 
   and md4.anno       = mor.anno 
   and md4.ufficio    = mor.ufficio 
   and md4.flag_completo is not null
   and mor.cod_rec	in (0,3)
/
comment on table istedd4_v is 'ISTAT - Modello D.4 - Dati'
/
