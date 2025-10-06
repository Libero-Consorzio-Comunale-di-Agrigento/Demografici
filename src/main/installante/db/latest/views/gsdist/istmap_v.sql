--liquibase formatted sql
--changeset amonopoli:202503211248_1 runOnChange:true stripComments:false
create or replace view istmap_v
       (cod_modello, anno_pratica, pratica, anno_dic, numero_dic, sequenza, data_definizione, riga)
AS
select 'APR4_TESTATA_I', 
       ap4.anno_pratica, 
       ap4.pratica, 
       ap4.anno_dic, 
       ap4.numero_dic, 
       1,
       ap4.data_definizione,
-- PROGRESSIVO_QUEST
-- MESE_DI_RIFERIMENTO
       ltrim(to_char(to_date(ap4.data_definizione,'j'),'mm'),'0')||';'||
-- ANNO_DI_RIFERIMENTO
       to_char(to_date(ap4.data_definizione,'j'),'yyyy')||';'||
-- NUMERO_PERSONE
       apm_v.totale||';'||
-- TIPO_PRATICA
       decode(ap4.provvedimento,1,'1',2,'2',3,'3',4,'4')||';'||
-- NUM_PRATICA_ISCRIZIONE
       nvl(ap4.pratica,ap4.numero_dic)||';'||
-- ISCRIZIONE_CONTEGGIO
       nvl(ap4.conteggio,1)||';'||
-- NUM_PRATICA_CANCELLAZIONE
       decode(ap4.provvedimento,1,ap4.pratica_canc)||';'||
-- CANCELLAZIONE_CONTEGGIO
       decode(ap4.provvedimento,1,nvl(ap4.conteggio_canc,nvl(ap4.conteggio,1)))||';'||
-- COD_PROVINCIA_CANCELLAZIONE
       decode(provvedimento,1,lpad(nvl(cod_pro_eve,0),3,'0'))||';'|| 
-- CODICE_COMUNE_CANCELLAZIONE
       decode(provvedimento,1,lpad(nvl(cod_com_eve,0),3,'0'))||';'|| 
-- PROVVEDIMENTO_ISCRIZIONE
	 ap4.provvedimento||';'||
-- COD_STATO_ESTERO_PROV
       decode(ap4.provvedimento,2,ap4.cod_stato)||';'||
-- PROVV_CANCELLAZIONE
       ''||';'|| 
-- COD_STATO_ESTERO_DEST
       ''||';'|| 
-- DATA_COMUNIC_PRATICA
       to_char(to_date(ap4.data_definizione,'j'),'dd/mm/yyyy')||';'||
-- FAMIGLIA_CONVIVENZA
       decode(ap4.famiglia_convivenza,'F','1','C','2')||';'||
-- DATA_DECORR_ISCRIZIONE
       to_char(to_date(nvl(ap4.data_decorrenza,ap4.data_pratica),'j'),'dd/mm/yyyy')||';'|| 
-- DATA_DECORR_CANCELL
       ''||';'||
-- NUOVO_INDIRIZZO_RES
       vie.denom_uff||ap4.civico_esterno||ap4.civico_interno||';' riga
  from arcvie vie, anaap4 ap4, 
       (select apm.anno_dic, apm.numero_dic, count(*) totale
          from anaapm apm
         where apm.annullamento 	is null
           and apm.flag_soggetto	= 'S'
         group by apm.anno_dic, apm.numero_dic) apm_v
 where exists (select 1
                 from anatpr tpr
                where tpr.anno_pratica 		= ap4.anno_dic
                  and tpr.pratica      		= ap4.numero_dic
                  and tpr.flag_perfezionamento 	= 'S'
                  and tpr.anagrafe		 	= 'RES'
                  and tpr.tipo_evento   	 	= 'I')
   and vie.cod_via (+)	    = ap4.cod_via
   and apm_v.anno_dic	    = ap4.anno_dic
   and apm_v.numero_dic	    = ap4.numero_dic
   and ap4.anno_dic         is not null
   and ap4.numero_dic       is not null
   and ap4.anno_pratica     is not null
   and ap4.pratica          is not null
UNION
--
-- soggetti in modelli apr di iscrizione
--
select 'APR4_PERSONE_I', 
       ap4.anno_pratica, 
       ap4.pratica, 
       ap4.anno_dic, 
       ap4.numero_dic, 
       nvl(apm.numero_ordine,0),
       ap4.data_definizione,
-- PROGRESSIVO_QUEST
-- ID_MODULO
	 apm.numero_ordine||';'||
-- CODICE_FISCALE
	 ana.cod_fiscale||';'||
-- DATA_NASCITA
	 to_char(to_date(ana.data_nas,'j'),'dd/mm/yyyy')||';'||
-- COD_PROV_NASCITA
	 decode(a0.descrizione,'',lpad(nvl(ana.cod_pro_nas,0),3,'0'),
	   decode(ana.cod_pro_nas,
	     701,decode(sign(ana.cod_com_nas-499),1,lpad(nvl(ana.cod_pro_nas,0),3,'0')),
	     702,decode(sign(ana.cod_com_nas-700),1,lpad(nvl(ana.cod_pro_nas,0),3,'0')),
	     703,decode(sign(ana.cod_com_nas-700),1,lpad(nvl(ana.cod_pro_nas,0),3,'0'))))||';'||
-- COD_COMUNE_NASCITA
	 decode(a0.descrizione,'',lpad(nvl(ana.cod_com_nas,0),3,'0'),
	   decode(ana.cod_pro_nas,
	     701,decode(sign(ana.cod_com_nas-499),1,lpad(nvl(ana.cod_com_nas,0),3,'0')),
	     702,decode(sign(ana.cod_com_nas-700),1,lpad(nvl(ana.cod_com_nas,0),3,'0')),
	     703,decode(sign(ana.cod_com_nas-700),1,lpad(nvl(ana.cod_com_nas,0),3,'0'))))||';'||
-- COD_STATO_ESTERO_NASCITA
	 decode(a0.descrizione,'','',
	   decode(ana.cod_pro_nas,
	     701,decode(sign(ana.cod_com_nas-499),1,'',ana.cod_pro_nas),
	     702,decode(sign(ana.cod_com_nas-700),1,'',ana.cod_pro_nas),
	     703,decode(sign(ana.cod_com_nas-700),1,'',ana.cod_pro_nas),
		   ana.cod_pro_nas))||';'||
-- SESSO
	 decode(ana.sesso,'M','1','F','2')||';'||
-- STATO_CIVILE
	 decode(mov.stato_civile,'CE','1','NU','1','CN','2','UC','2','VE','3','VU','3','DV','4','GC','4','GU','4')||';'||
-- CITTADINANZA_ITALIANA
	 decode(ana.nazionalita,'I','1','2')||';'||
-- CITTADINANZA_STRANIERA
	 decode(ana.nazionalita,'I','',dci.ist_ci)||';'||
-- PROFESSIONE_SE_OCCUPATO
 	 decode(apm.ist_np,'',ana.posizione_prof)||';'||
-- CONDIZIONE_NON_PROFESSIONALE
	 apm.ist_np||';'||
-- TITOLO_STUDIO
	 apm.ist_ts||';'||
-- RELAZIONE_PARENTELA
       ltrim(apm.ist_rp,'0')||';' riga
  from arccom a0, anadci dci, 
       anamov mov, anaana ana, anaap4 ap4, anaapm apm 
 where dci.cod_ci         (+) = ana.nazionalita 
   and a0.cod_provincia   (+) = ana.cod_pro_nas
   and a0.cod_comune      (+) = 0
   and mov.anno_pratica       = ap4.anno_dic
   and mov.pratica            = nvl(ap4.pratica,ap4.numero_dic)
   and mov.cod_mov            = 1
   and mov.cod_eve            != 17
   and mov.matricola	      = apm.matricola
   and ana.matricola          = apm.matricola 
   and apm.annullamento       is null 
   and apm.flag_soggetto	= 'S'
   and apm.anno_dic		= ap4.anno_dic
   and apm.numero_dic		= ap4.numero_dic
UNION
--
-- modelli apr di cancellazione (no ripristini)
--
select 'APR4_TESTATA_C', 
       cp4.anno_pratica, 
       cp4.pratica, 
       cp4.anno_dic, 
       cp4.numero_dic, 
       2,
       cp4.data_definizione,
-- PROGRESSIVO_QUEST
-- MESE_DI_RIFERIMENTO
       to_char(to_date(cp4.data_definizione,'j'),'mm')||';'||
-- ANNO_DI_RIFERIMENTO
       to_char(to_date(cp4.data_definizione,'j'),'yyyy')||';'||
-- NUMERO_PERSONE
       cpm_v.totale||';'||
-- TIPO_PRATICA
       decode(cp4.provvedimento,1,'5',2,'6',3,'7',4,'8',5,'9')||';'||
-- NUM_PRATICA_ISCRIZIONE
       ''||';'||
-- ISCRIZIONE_CONTEGGIO
       ''||';'||
-- NUM_PRATICA_CANCELLAZIONE
       nvl(cp4.pratica,cp4.numero_dic)||';'||
-- CANCELLAZIONE_CONTEGGIO
       decode(cp4.provvedimento,2,2,nvl(cp4.conteggio,1))||';'||
-- COD_PROVINCIA_CANCELLAZIONE
       lpad(m.pro_cliente,3,'0')||';'||
-- CODICE_COMUNE_CANCELLAZIONE
       lpad(m.com_cliente,3,'0')||';'|| 
-- PROVVEDIMENTO_ISCRIZIONE
       ''||';'||
-- COD_STATO_ESTERO_PROV
       ''||';'||
-- PROVV_CANCELLAZIONE
       cp4.provvedimento||';'|| 
-- COD_STATO_ESTERO_DEST
       decode(cp4.provvedimento,1,cp4.cod_stato)||';'|| 
-- DATA_COMUNIC_PRATICA
       to_char(to_date(cp4.data_definizione,'j'),'dd/mm/yyyy')||';'||
-- FAMIGLIA_CONVIVENZA
       ''||';'||
-- DATA_DECORR_ISCRIZIONE
       ''||';'|| 
-- DATA_DECORR_CANCELL
       to_char(to_date(nvl(cp4.data_decorrenza,cp4.data_pratica),'j'),'dd/mm/yyyy')||';'||
-- NUOVO_INDIRIZZO_RES
       ''||';' riga
  from menuditta m, anacp4 cp4, 
       (select cpm.anno_dic, cpm.numero_dic, count(*) totale
          from anacpm cpm
         where cpm.flag_soggetto	= 'S'
           and cpm.annullamento	is null
         group by cpm.anno_dic, cpm.numero_dic) cpm_v
 where exists (select 1
                 from anatpr
                where anno_pratica 		 = cp4.anno_dic
                  and pratica      		 = cp4.pratica
                  and flag_perfezionamento = 'S'
	            and anagrafe		 = 'RES'
                  and tipo_evento 		 = 'C')
   and cpm_v.totale		> 0
   and cpm_v.anno_dic		= cp4.anno_dic
   and cpm_v.numero_dic		= cp4.numero_dic
   and ((cp4.provvedimento = 1 and cp4.cod_stato is not null) or
          (cp4.provvedimento in (2,3,4)))
   and cp4.anno_dic 		is not null
   and cp4.numero_dic 		is not null
   and cp4.anno_pratica 	is not null
   and cp4.pratica 		is not null
UNION
--
-- modelli apr di ripristino scheda anagrafica
--
select 'APR4_TESTATA_C', 
       cp4.anno_pratica, 
       cp4.pratica, 
       cp4.anno_dic, 
       cp4.numero_dic, 
       2,
       cp4.data_ripristino,
-- PROGRESSIVO_QUEST
-- MESE_DI_RIFERIMENTO
       to_char(to_date(cp4.data_ripristino,'j'),'mm')||';'||
-- ANNO_DI_RIFERIMENTO
       to_char(to_date(cp4.data_ripristino,'j'),'yyyy')||';'||
-- NUMERO_PERSONE
       cpm_v.totale||';'||
-- TIPO_PRATICA
       decode(cp4.provvedimento,1,'5',2,'6',3,'7',4,'8',5,'9')||';'||
-- NUM_PRATICA_ISCRIZIONE
       ''||';'||
-- ISCRIZIONE_CONTEGGIO
       ''||';'||
-- NUM_PRATICA_CANCELLAZIONE
       nvl(cp4.pratica,cp4.numero_dic)||';'||
-- CANCELLAZIONE_CONTEGGIO
       nvl(cp4.conteggio,1)||';'||
-- COD_PROVINCIA_CANCELLAZIONE
       lpad(m.pro_cliente,3,'0')||';'||
-- CODICE_COMUNE_CANCELLAZIONE
       lpad(m.com_cliente,3,'0')||';'|| 
-- PROVVEDIMENTO_ISCRIZIONE
       ''||';'||
-- COD_STATO_ESTERO_PROV
       ''||';'||
-- PROVV_CANCELLAZIONE
       cp4.provvedimento||';'|| 
-- COD_STATO_ESTERO_DEST
       ''||';'|| 
-- DATA_COMUNIC_PRATICA
       to_char(to_date(cp4.data_ripristino,'j'),'dd/mm/yyyy')||';'||
-- FAMIGLIA_CONVIVENZA
       ''||';'||
-- DATA_DECORR_ISCRIZIONE
       ''||';'|| 
-- DATA_DECORR_CANCELL
       to_char(to_date(nvl(cp4.data_decorrenza,cp4.data_pratica),'j'),'dd/mm/yyyy')||';'||
-- NUOVO_INDIRIZZO_RES
       ''||';' riga
  from menuditta m, anacp4 cp4, 
       (select cpm.anno_dic, cpm.numero_dic, count(*) totale
          from anacpm cpm
         where cpm.flag_ripristino	= 'S'
         group by cpm.anno_dic, cpm.numero_dic) cpm_v
 where exists (select 1
                 from anatpr
                where anno_pratica 		 = cp4.anno_dic
                  and pratica      		 = cp4.pratica
                  and flag_perfezionamento||flag_annullamento = 'S'
	            and anagrafe		 = 'RES'
                  and tipo_evento 		 = 'C')
   and cpm_v.totale		> 0
   and cpm_v.anno_dic		= cp4.anno_dic
   and cpm_v.numero_dic		= cp4.numero_dic
   and cp4.provvedimento	= 5
   and cp4.anno_dic 		is not null
   and cp4.numero_dic 		is not null
   and cp4.anno_pratica 	is not null
   and cp4.pratica 		is not null
UNION
--
-- soggetti in modelli apr di cancellazione
--
select 'APR4_PERSONE_C',
       cp4.anno_pratica, 
       cp4.pratica, 
       cp4.anno_dic, 
       cp4.numero_dic, 
       nvl(cpm.numero_ordine,0),
       decode(cp4.provvedimento,5,cp4.data_ripristino,cp4.data_definizione),
-- PROGRESSIVO_QUEST
-- ID_MODULO
	 cpm.numero_ordine||';'||
-- CODICE_FISCALE
	 ana.cod_fiscale||';'||
-- DATA_NASCITA
	 to_char(to_date(ana.data_nas,'j'),'dd/mm/yyyy')||';'||
-- COD_PROV_NASCITA
	 decode(a0.descrizione,'',lpad(nvl(ana.cod_pro_nas,0),3,'0'),
	   decode(ana.cod_pro_nas,
	     701,decode(sign(ana.cod_com_nas-499),1,lpad(nvl(ana.cod_pro_nas,0),3,'0')),
	     702,decode(sign(ana.cod_com_nas-700),1,lpad(nvl(ana.cod_pro_nas,0),3,'0')),
	     703,decode(sign(ana.cod_com_nas-700),1,lpad(nvl(ana.cod_pro_nas,0),3,'0'))))||';'||
-- COD_COMUNE_NASCITA
	 decode(a0.descrizione,'',lpad(nvl(ana.cod_com_nas,0),3,'0'),
	   decode(ana.cod_pro_nas,
	     701,decode(sign(ana.cod_com_nas-499),1,lpad(nvl(ana.cod_com_nas,0),3,'0')),
	     702,decode(sign(ana.cod_com_nas-700),1,lpad(nvl(ana.cod_com_nas,0),3,'0')),
	     703,decode(sign(ana.cod_com_nas-700),1,lpad(nvl(ana.cod_com_nas,0),3,'0'))))||';'||
-- COD_STATO_ESTERO_NASCITA
	 decode(a0.descrizione,'','',
	   decode(ana.cod_pro_nas,
	     701,decode(sign(ana.cod_com_nas-499),1,'',ana.cod_pro_nas),
	     702,decode(sign(ana.cod_com_nas-700),1,'',ana.cod_pro_nas),
	     703,decode(sign(ana.cod_com_nas-700),1,'',ana.cod_pro_nas),
		   ana.cod_pro_nas))||';'||
-- SESSO
	 decode(ana.sesso,'M','1','F','2')||';'||
-- STATO_CIVILE
	 decode(mov.stato_civile,'CE','1','NU','1','CN','2','UC','2','VE','3','VU','3','DV','4','GC','4','GU','4')||';'||
-- CITTADINANZA_ITALIANA
	 decode(ana.nazionalita,'I','1','2')||';'||
-- CITTADINANZA_STRANIERA
	 decode(ana.nazionalita,'I','',dci.ist_ci)||';'||
-- PROFESSIONE_SE_OCCUPATO
 	 decode(cpm.ist_np,'',ana.posizione_prof)||';'||
-- CONDIZIONE_NON_PROFESSIONALE
	 cpm.ist_np||';'||
-- TITOLO_STUDIO
	 cpm.ist_ts||';'||
-- RELAZIONE_PARENTELA
       ltrim(cpm.ist_rp,'0')||';' riga
  from arccom a0, anadci dci, 
       anamov mov, anaana ana, anacp4 cp4, anacpm cpm 
 where dci.cod_ci         (+) = ana.nazionalita
   and a0.cod_provincia	  (+) = ana.cod_pro_nas
   and a0.cod_comune      (+) = 0 
   and mov.anno_pratica       = cp4.anno_dic
   and mov.pratica            = nvl(cp4.pratica,cp4.anno_dic)
   and mov.cod_mov            in (2,3)
   and mov.matricola	      = cpm.matricola
   and ana.matricola          = cpm.matricola 
   and ((cp4.provvedimento in (1,2,3,4) and cpm.flag_soggetto = 'S' and cpm.annullamento is null)
        or (cp4.provvedimento = 5 and cpm.flag_ripristino = 'S'))
   and cpm.anno_dic		= cp4.anno_dic
   and cpm.numero_dic		= cp4.numero_dic
   and ((cp4.provvedimento = 1 and cp4.cod_stato is not null) 
        or (cp4.provvedimento in (2,3,4,5)))
   and cp4.anno_dic 		is not null
   and cp4.numero_dic 		is not null
   and cp4.anno_pratica 	is not null
   and cp4.pratica 		is not null
 order by 1,2,3,4,5
/
comment on table ISTMAP_V is 'ISTAT - Dati per Compilazione Modello APR/4 (view)'
/
