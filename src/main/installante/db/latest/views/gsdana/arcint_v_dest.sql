--liquibase formatted sql
--changeset amonopoli:202606111200 runAlways:true runOnChange:true stripComments:false
create or replace view arcint_v_dest as
select 'FAM_INT' archivio,
       fam.cod_fam_unique id,
       fam.cod_via,
       fam.num_civ,
       fam.suffisso,
       fam.scala,
       fam.piano,
       fam.interno,
       fam.sub_interno,
       fam.cod_fam,
       fam.cod_fam_unique,
       f_stato_interno(fam.cod_via,fam.num_civ,fam.suffisso,int.interno,int.sub_interno,fam.scala,fam.cod_fam,fam.piano) stato_interno,
       f_intestatario_interno(fam.cod_via,fam.num_civ,fam.suffisso,int.interno,int.sub_interno,fam.scala,fam.cod_fam,fam.piano) intestatario_interno,
       fam.tipo_fam,
       decode(fam.tipo_fam,1,'C','F') famiglia_convivenza,
       fam.convivenza,
       fam.intestatario,
       fam.cognome_intestatario,
       fam.nome_intestatario,
       int.cod_ecografico,
       fam.civico_esterno,
       fam.civico_interno,
       int.SEZIONE_CATASTO,
       int.FOGLIO_CATASTO,
       int.NUMERO_CATASTO,
       int.SUBALTERNO_CATASTO,
       fam.FLAG_METRICO,
       fam.PROGR_SNC,
       fam.FLAG_LETTERA,
       fam.FLAG_ESPONENTE,
       fam.SCALA_ESTERNA,
       fam.COLORE,
       fam.CORTE,
       fam.INTERNO2,
       fam.SUB_INTERNO2,
       fam.SECONDARIO,
       fam.NUI,
       fam.FLAG_NUI  from arcvie vie, anafam fam, arcint int
 where vie.cod_via                = fam.cod_via
   and int.flag_cessato           is null
   and int.cod_via                = fam.cod_via
   and int.num_civ                = fam.num_civ
   and nvl(int.tipo_immobile,'A') = 'A'
   and nvl(int.suffisso ,' ')     = nvl(fam.suffisso,' ')
   and nvl(int.scala,' ')         = nvl(fam.scala,' ')
   and nvl(int.piano,' ')         = nvl(fam.piano,' ')
   and nvl(int.interno,0)         = nvl(fam.interno,0)
   and nvl(int.sub_interno,' ')   = nvl(fam.sub_interno,' ')
   and fam.fascia + 0 = 1
UNION
select 'INT_NO_FAM' archivio,
       'INT'||lpad(int.id,7,'0') id,
       int.cod_via,
       int.num_civ,
       int.suffisso,
       int.scala,
       int.piano,
       int.interno,
       int.sub_interno,
       to_number(null) cod_fam,
       to_char(null) cod_fam,
       f_stato_interno(int.cod_via,num_civ,suffisso,interno,sub_interno,scala,null,piano) stato,
       f_intestatario_interno(int.cod_via,num_civ,suffisso,interno,sub_interno,scala,null,piano) intestatario,
       to_number(null) tipo_fam,
       to_char(null) famiglia_convivenza,
       to_char(null) convivenza,
       to_char(null) intestatario,
       to_char(null) cognome_intestatario,
       to_char(null) nome_intestatario,
       int.cod_ecografico,
       f_civico_esterno(int.cod_via,int.num_civ,int.suffisso,int.scala,int.piano,int.interno,int.sub_interno) civico_esterno,
       f_civico_interno(int.cod_via,int.num_civ,int.suffisso,int.scala,int.piano,int.interno,int.sub_interno) civico_interno,
       int.SEZIONE_CATASTO,
       int.FOGLIO_CATASTO,
       int.NUMERO_CATASTO,
       int.SUBALTERNO_CATASTO,
       to_char(null) FLAG_METRICO,
       to_char(null) PROGR_SNC,
       to_char(null) FLAG_LETTERA,
       to_char(null) FLAG_ESPONENTE,
       to_char(null) SCALA_ESTERNA,
       to_char(null) COLORE,
       to_char(null) CORTE,
       to_number(null) INTERNO2,
       to_char(null) SUB_INTERNO2,
       to_char(null) SECONDARIO,
       to_char(null) NUI,
       to_char(null) FLAG_NUI
  from arcvie vie, arcint int
 where vie.cod_via                = int.cod_via
   and nvl(int.tipo_immobile,'A') = 'A'
   and not exists (select 1
                     from anafam fam
                    where fam.cod_via              = int.cod_via
                      and fam.num_civ              = int.num_civ
                      and fam.fascia + 0           = 1
                      and nvl(fam.suffisso,' ')    = nvl(int.suffisso,' ')
                      and nvl(fam.scala,' ')       = nvl(int.scala,' ')
                      and nvl(fam.piano,' ')       = nvl(int.piano,' ')
                      and nvl(fam.interno,0)       = nvl(int.interno,0)
                      and nvl(fam.sub_interno,' ') = nvl(int.sub_interno,' '))
   and int.flag_cessato is null
UNION
select 'FAM_NO_INT' archivio,
       fam.cod_fam_unique id,
       fam.cod_via,
       fam.num_civ,
       fam.suffisso,
       fam.scala,
       fam.piano,
       fam.interno,
       fam.sub_interno,
       fam.cod_fam,
       fam.cod_fam_unique,
       f_stato_interno(fam.cod_via,fam.num_civ,fam.suffisso,fam.interno,fam.sub_interno,fam.scala,fam.cod_fam,fam.piano) stato,
       f_intestatario_interno(fam.cod_via,fam.num_civ,fam.suffisso,fam.interno,fam.sub_interno,fam.scala,fam.cod_fam,fam.piano) intestatario,
       fam.tipo_fam,
       decode(fam.tipo_fam,1,'C','F') famiglia_convivenza,
       fam.convivenza,
       fam.intestatario,
       fam.cognome_intestatario,
       fam.nome_intestatario,
       to_char(null) cod_ecografico,
       fam.civico_esterno,
       fam.civico_interno,
       to_char(null) SEZIONE_CATASTO,
       to_char(null) FOGLIO_CATASTO,
       to_char(null) NUMERO_CATASTO,
       to_char(null) SUBALTERNO_CATASTO,
       fam.FLAG_METRICO,
       fam.PROGR_SNC,
       fam.FLAG_LETTERA,
       fam.FLAG_ESPONENTE,
       fam.SCALA_ESTERNA,
       fam.COLORE,
       fam.CORTE,
       fam.INTERNO2,
       fam.SUB_INTERNO2,
       fam.SECONDARIO,
       fam.NUI,
       fam.FLAG_NUI
  from anafam fam
 where fascia + 0    = 1
   and not exists (select 1
                     from arcint int1
                    where int1.cod_via                = fam.cod_via
                      and int1.num_civ                = fam.num_civ
                      and nvl(int1.tipo_immobile,'A') = 'A'
                      and nvl(int1.suffisso,' ')      = nvl(fam.suffisso,' ')
                      and nvl(int1.scala,' ')         = nvl(fam.scala,' ')
                      and nvl(int1.piano,' ')         = nvl(fam.piano,' ')
                      and nvl(int1.interno,0)         = nvl(fam.interno,0)
                      and nvl(int1.sub_interno,' ')   = nvl(fam.sub_interno,' ')
                      and int1.flag_cessato           is null)
/
COMMENT ON TABLE ARCINT_v_dest IS 'Anagrafe - Interni per Indirizzo di Destinazione (view)'
/
