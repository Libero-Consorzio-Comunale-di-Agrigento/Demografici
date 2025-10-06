--liquibase formatted sql
--changeset amonopoli:202503211246_1 runOnChange:true stripComments:false
create or replace view ISTEDP4_V
       (data_reg, d_data_reg,
        matricola, cod_via, num_civ, suffisso,
        dati_1, sezione_cens, dati_2)
as
select mov.data_reg,
       to_date(mov.data_reg,'j'),
       mov.matricola,
       mov.cod_via, 
       mov.num_civ,
       mov.suffisso,
-- PROGRESSIVO_QUEST
--       rownum||';'||
-- MESE_RIFERIMENTO
       to_char(to_date(mov.data_reg,'j'),'mm')||';'||
-- ANNO_RIFERIMENTO
       to_char(to_date(mov.data_reg,'j'),'yyyy')||';'||
-- COGNOME_INTESTATARIO
       decode(mov.rapporto_par,'IC','CONVIVENZA',
         substr(substr(mov.intestatario,1,instr(mov.intestatario,'/')-1),1,50))||';'||
-- NOME_INTESTATARIO
       decode(mov.rapporto_par,'IC','CONVIVENZA',
         substr(substr(mov.intestatario,instr(mov.intestatario,'/')+1),1,50))||';'||
-- NR_COMPONENTI_FAMIGLIA
       to_char(nvl(mp4.num_componenti,0))||';'||
-- NR_COMPONENTI_MINORENNI
       to_char(nvl(mp4.num_componenti_minori,0))||';'||
-- INDIRIZZO
       substr(nvl(vie.denom_uff,' '),1,50)||';'||
-- NR_CIVICO
       substr(to_char(mov.num_civ)||decode(mov.suffisso,'','','/'||mov.suffisso),1,10)||';'||
-- CAP
       lpad(nvl(f_cap(mov.cod_via,mov.num_civ,mov.suffisso),a.cap),5,'0'),
-- NR_SEZIONE_CENSIMENTO
       MP4.SEZIONE_CENS,
-- COGNOME_NATO
       substr(substr(ana.cognome_nome,1,instr(ana.cognome_nome,'/')-1),1,50)||';'||
-- NOME_NATO
       substr(substr(ana.cognome_nome,instr(ana.cognome_nome,'/')+1),1,50)||';'||
-- PROV_NASCITA_NATO
       decode(n0.descrizione,'',lpad(ana.cod_pro_nas,3,'0'))||';'||
-- COM_NASCITA_NATO
       decode(n0.descrizione,'',lpad(ana.cod_com_nas,3,'0'))||';'||
-- EST_NASCITA_NATO
       decode(n0.descrizione,'','',lpad(ana.cod_pro_nas,3,'0'))||';'||
-- DATA_NASCITA
       to_char(to_date(ana.data_nas,'j'),'dd/mm/yyyy')||';'||
-- SESSO_NATO
       decode(ana.sesso,'M','1','2')||';'||
-- CITTAD_NATO
       decode(ana.nazionalita,'I','1','2')||';'||
-- CITTAD_EST_NATO
       decode(ana.nazionalita,'I','',nvl(to_char(dci.ist_ci),'998'))||';'||
-- DATA_ISCRIZ_NASCITA
       to_char(to_date(mov.data_reg,'j'),'dd/mm/yyyy')||';'||
-- COGNOME_MADRE
       substr(substr(ana.maternita,1,instr(ana.maternita,'/')-1),1,50)||';'||
-- NOME_MADRE
       substr(substr(ana.maternita,instr(ana.maternita,'/')+1),1,50)||';'||
-- DATA_NASCITA_MADRE
       to_char(to_date(mp4.data_nas_mat,'j'),'dd/mm/yyyy')||';'||
-- STATO_CIVILE_MADRE
       nvl(decode(mp4.stato_civile_mat,'NU','1','CN','2','VE','3','GC','4','DV','4','UC','6','VU','7','GU','8','9'),'9')||';'||
-- CITTAD_MADRE
       decode(mp4.nazionalita_mat,'I','1','2')||';'||
-- CITTAD_EST_MADRE
       decode(mp4.nazionalita_mat,'I','',nvl(to_char(dci_m.ist_ci),'998'))||';'||
-- COD_FISC_MADRE
       mp4.cod_fiscale_mat||';'||
-- COGNOME_PADRE
       substr(
         decode(ana.paternita,'','',
           decode(instr(ana.paternita,'/'),0,
             substr(ana.cognome_nome,1,instr(ana.cognome_nome,'/')-1),
             substr(ana.paternita,1,instr(ana.paternita,'/')-1)))
         ,1,50)||';'||
-- NOME_PADRE
       substr(
         decode(ana.paternita,'','',
           decode(instr(ana.paternita,'/'),0,
             ana.paternita,
             substr(ana.paternita,instr(ana.paternita,'/')+1)))
         ,1,50)||';'||
-- DATA_NASCITA_PADRE
       to_char(to_date(mp4.data_nas_pat,'j'),'dd/mm/yyyy')||';'||
-- STATO_CIVILE_PADRE
       nvl(decode(mp4.stato_civile_mat,'CE','1','CN','2','VE','3','GC','4','DV','4','UC','6','VU','7','GU','8','9 '),'9')||';'||
-- CITTAD_PADRE
       decode(mp4.nazionalita_pat,'I','1','2')||';'||
-- CITTAD_EST_PADRE
       decode(mp4.nazionalita_pat,'I','',nvl(to_char(dci_p.ist_ci),'998'))||';'||
-- COD_FISC_PADRE
       mp4.cod_fiscale_pat||';'||
-- TIPO_RESIDENZA
       decode(fam.tipo_fam,'','1','2')||';'||
-- CODICE_FAMIGLIA
       decode(fam.tipo_fam,'',mov.cod_fam)||';'||
-- CODICE_CONVIVENZA
       decode(fam.tipo_fam,'','',mov.cod_fam)
  from arccom a, arccom n0, arcvie vie, 
       anadci dci, anadci dci_m, anadci dci_p,
       anafam fam, anaana ana, anamov mov, istmp4 mp4
 where (a.cod_provincia,a.cod_comune) = (select pro_cliente, com_cliente from menuditta)
   and vie.cod_via 	(+) 	= mov.cod_via
   and dci.cod_ci  	(+) 	= ana.nazionalita
   and dci_m.cod_ci  	(+) 	= mp4.nazionalita_mat
   and dci_p.cod_ci  	(+) 	= mp4.nazionalita_pat       
   and n0.cod_provincia	(+)	= ana.cod_pro_nas
   and n0.cod_comune	(+)	= 0
   and fam.cod_fam              = mov.cod_fam
   and fam.fascia               in (1,2)
   and ana.matricola 		= mov.matricola
   and mov.cod_mov 		= 1 
   and mov.cod_eve 		= 1 
   and mp4.flag_completo        is not null
   and mov.matricola 		= mp4.matricola
/
comment on table ISTEDP4_V is 'ISTAT - Modello P.4 - Dati'
/
