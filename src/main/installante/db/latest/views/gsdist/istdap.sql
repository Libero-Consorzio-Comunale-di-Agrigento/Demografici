--liquibase formatted sql
--changeset amonopoli:202503211242_1 runOnChange:true stripComments:false
create or replace view ISTDAP
	(archivio, punto, 
         matricola, anno_pratica, pratica,
         sesso, data_reg)
AS
-- 1. Iscritti - da Altri Comuni
-- 2. Iscritti - dall'Estero
-- 3. Iscritti - per Ricomparsa
-- 4. Iscritti - per Altri Motivi
select 'AP4', ap4.provvedimento,
       apm.matricola, ap4.anno_pratica, ap4.pratica,
       apm.sesso, ap4.data_definizione
  from anaapm apm, anaap4 ap4
 where apm.anno_dic		= ap4.anno_dic
   and apm.numero_dic		= ap4.numero_dic
   and apm.annullamento		is null
   and apm.flag_soggetto	= 'S'
   and ap4.provvedimento	in (1,2,3,4)
   and exists (select 1
                 from anatpr
                where anno_pratica 		= ap4.anno_pratica
                  and pratica      		= ap4.pratica
                  and flag_perfezionamento 	= 'S'
                  and anagrafe			= 'RES'
                  and tipo_evento               = 'I')
   and ap4.anno_dic 		is not null
   and ap4.numero_dic 		is not null
   and ap4.anno_pratica 	is not null
   and ap4.pratica 		is not null
UNION
-- 1. Cancellati - per l'Estero
-- 2. Cancellati - per Irreperibilita al Censimento
-- 3. Cancellati - per Irreperibilita Accertata
-- 4. Cancellati - per Altri Motivi
select 'CP4', cp4.provvedimento,
       cpm.matricola, cp4.anno_pratica, cp4.pratica,
       cpm.sesso, cp4.data_definizione
  from anacpm cpm, anacp4 cp4
 where cpm.anno_dic		= cp4.anno_dic
   and cpm.numero_dic		= cp4.numero_dic
   and cpm.annullamento		is null
   and cpm.flag_soggetto	= 'S'
   and (cp4.provvedimento = 1 and cp4.cod_stato is not null 
        or cp4.provvedimento in (2,3,4))
   and exists (select 1
                 from anatpr
                where anno_pratica 		= cp4.anno_pratica
                  and pratica      		= cp4.pratica
                  and flag_perfezionamento 	= 'S'
                  and anagrafe			= 'RES'
                  and tipo_evento   		= 'C')
   and cp4.anno_dic 		is not null
   and cp4.numero_dic 		is not null
   and cp4.anno_pratica 	is not null
   and cp4.pratica 		is not null
UNION
-- 5. Iscrizioni - per Ripristino Anagrafico
select 'CP4', cp4.provvedimento,
       cpm.matricola, cp4.anno_pratica, cp4.pratica,
       cpm.sesso, cp4.data_ripristino
  from anacpm cpm, anacp4 cp4
 where cpm.anno_dic		= cp4.anno_dic
   and cpm.numero_dic		= cp4.numero_dic
   and cpm.flag_ripristino	= 'S'
   and cp4.provvedimento	= 5
   and cp4.anno_dic 		is not null
   and cp4.numero_dic 		is not null
   and cp4.anno_pratica 	is not null
   and cp4.pratica 		is not null
/
comment on table ISTDAP is 'ISTAT - Dati per Compilazione Modello APR/4 (view)'
/
