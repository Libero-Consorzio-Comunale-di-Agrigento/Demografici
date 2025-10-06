--liquibase formatted sql
--changeset amonopoli:202502241025 runOnChange:true stripComments:false
create or replace view anamsg
	(matricola, sequenza, messaggio, dettaglio,
         flag_avviso, flag_cer, flag_sfa, flag_cdi, flag_ana, flag_ele)
AS
-- 
-- SEQ  MESSAGGIO
--  -1  ATTENZIONE! Esistono comunicazioni ANPR non inviate
--  -1  ATTENZIONE! Individuo NON presente in ANPR
--   0  A.N.S.C. - Individuo con atto digitale (nascita - ...)
--   0  Individuo presente nello Schedario della Popolazione Temporanea
--   1  Individuo sospeso dalla certificazione anagrafica
--   2  Esistono componenti sospesi nella famiglia dell'individuo
--   3  Individuo In Attesa di ... (Cambio Abitazione / Iscrizione / ...)
--   3  Nucleo interessato da ... (Cambio Abitazione / Iscrzione / ...)
--   4  Individuo Straniero con <DOCUMENTO_SOGGIORNO> scaduto
--   4  Individuo Straniero senza Documento di Soggiorno
--   5  Individuo con Documento di Identita'' ancora valido
--   6  Individuo con eta'' compresa tra 3 e 18 anni
--   7  Individuo con eta'' compresa tra 0 e 3 anni
--  96  Convivenza di Fatto con XXX (matr. ...)
--  97  Nucleo Coabitante con XXX (cod.fam. ...)
--  98  Individuo con stato civile Non Conosciuto
--  99  Individuo con NOTE [Elettore / Liste Aggiunge / Scrutatore] compilate
--  99  Vota fuori sede per le elezioni del ... (rif. AEFS)
--  99  Vota in Italia per le elezioni del ... (rif. AOVI)
--  99  Rubrica Nascita - Atto di Nascita del Comune di... (rif. ARNA)
--  99  Individuo Non Residente - Domiciliato nel comune (rif. CANR)
-- 
--      03/07/2018 (AM) f_MSG_individuo_straniero: passaggio parametro flag_cie = 'S' x trattare solo DS scaduti o assenti
--      31/03/2020 (AM) f_MSG_individuo_straniero: passaggio parametro flag_cie = 'X' x trattare solo DS scaduti o assenti + RP validi
--      03/05/2024 (AM) controllo Opzione di Voto (AOVI) e Elettore Fuori Sede (AEFS)
--      24/02/2025 (AM) controllo Rubrica Nascite  (ARNA)
--
select msg_v.matricola,
       msg_v.sequenza,
       msg_v.messaggio,
       msg_v.dettaglio,
       msg_v.flag_avviso,
       msg_v.flag_cer,
       msg_v.flag_sfa,
       msg_v.flag_cdi,
       msg_v.flag_ana,
       msg_v.flag_ele
  from (
-- msg_anpr
        select ana.matricola, 
               -1 sequenza,
               f_MSG_anpr(ana.matricola,ana.fascia,ana.cod_fam) messaggio,
               to_char(null) dettaglio, 
               'S' flag_avviso, 
               'S' flag_cer, 
               '' flag_sfa, 
               'S' flag_cdi, 
               'S' flag_ana,
               'S' flag_ele
          from anaana ana
--         where ana.fascia in (1,3)
        UNION ALL
-- msg_ansc
        select ana.matricola, 
               0 sequenza,
               'A.N.S.C. - '||'Soggetto con atto digitale ('||
                  rtrim(
                    decode(ana.atto_nas_digitale,'','','nascita - ')||
                    decode(ana.atto_mat_digitale,'','','matrimonio/unione civile - ')||
                    decode(ana.atto_ved_digitale,'','','vedovanza - ')||
                    decode(ana.atto_div_digitale,'','','divorzio/cessazione/scioglimento - ')||
                    decode(ana.atto_mor_digitale,'','','morte'),' - ')||
                  ')' messaggio,         
               to_char(null) dettaglio, 
               'S' flag_avviso, 
               'S' flag_cer, 
               '' flag_sfa, 
               'S' flag_cdi, 
               'S' flag_ana,
               'S' flag_ele
          from anaana ana
         where ana.atto_nas_digitale||ana.atto_mat_digitale||ana.atto_div_digitale||ana.atto_ved_digitale||ana.atto_mor_digitale is not null
        UNION ALL
-- msg_individuo_sospeso
        select ana.matricola, 
               1 sequenza,
               'Individuo sospeso dalla certificazione anagrafica' messaggio,
               'Motivo: '||dms.descrizione dettaglio, 
               dms.flag_avviso, 
               'S' flag_cer, 
               decode(ana.sospensione,f_valore_inp('IAPR_SIND',1,2,'9',''),'','S') flag_sfa, 
               'S' flag_cdi, 
               'S' flag_ana,
               to_char(null) flag_ele
          from cerdms dms, anaana ana
         where dms.cod_ms  =      ana.sospensione
        UNION ALL
-- msg_componenti_sospesi
        select ana_v.matricola, 2,
               rtrim(substr(ana_v.msg_componenti_sospesi,2,58)),
               rtrim(ltrim(translate(substr(ana_v.msg_componenti_sospesi,59),'()','  '))),
               rtrim(substr(ana_v.msg_componenti_sospesi,1,1)),
               '', 'S', to_char(null), 'S', to_char(null)
          from (select ana.matricola, f_msg_componenti_sospesi(ana.matricola) msg_componenti_sospesi
                  from anaana ana) ana_v
        UNION ALL
-- msg_pratica_in_corso
        select ana.matricola, 3,
               f_msg_pratica_in_corso(ana.matricola,'M'),
               rtrim(ltrim(translate(f_msg_pratica_in_corso(ana.matricola,'D'),'()','  '))),
               'S' flag_avviso, 
               'S' flag_cer, 
               '' flag_sfa, 
               'S' flag_cdi, 
               'S' flag_ana, 
               to_char(null) flag_ele
          from anaana ana
        UNION ALL
-- msg_individuo_straniero
        select str.matricola, 4,
               f_msg_individuo_straniero(str.matricola,'X'),
               decode(str.numero_ds,'','',
                 str.tipo_ds||
                 ' N. '||str.numero_ds||
                 ' del '||to_char(to_date(str.data_emissione_ds,'j'),'dd/mm/yyyy')||
                 ' - scadenza '||
                 decode(str.flag_scadenza_illimitata_ds,'S','illimitata',
                   to_char(to_date(str.data_scadenza_ds,'j'),'dd/mm/yyyy'))),
               'S', 'S', 
               to_char(null), 'S', 
               'S', to_char(null)
          from anastr str 
        UNION ALL
-- msg_DI_valido
        select wdi.matricola, 5, 'Individuo con Documento di Identita'' ancora valido',
               wdi.tipo_di||
               ' N. '||wdi.numero_di||
               ' del '||to_char(to_date(wdi.data_emissione_di,'j'),'dd/mm/yyyy')||
               ' - scadenza '||to_char(to_date(wdi.data_scadenza_di,'j'),'dd/mm/yyyy'),
               'S', to_char(null), to_char(null), 'S', to_char(null), to_char(null)
          from anawdi wdi
         where to_char(sysdate,'j') between wdi.data_emissione_di and wdi.data_scadenza_di        
        UNION ALL
-- msg_eta_compresa_3_18
        select ana.matricola, 6,
               'Individuo con eta'' compresa tra 3 e 18 anni',
               'Scadenza Carta di Identita'': 5 anni',
               'S', to_char(null), to_char(null), 'S', to_char(null), to_char(null)
          from anaana ana
         where ana.data_nas > to_char(add_months(sysdate,-216),'j')
           and ana.data_nas <= to_char(add_months(sysdate,-36),'j')
        UNION ALL
-- msg_eta_compresa_0_3
        select ana.matricola, 7,
               'Individuo con eta'' compresa tra 0 e 3 anni',
               'Scadenza Carta di Identita'': 3 anni',
               'S', to_char(null), to_char(null), 'S', to_char(null), to_char(null)
          from anaana ana
         where ana.data_nas > to_char(add_months(sysdate,-36),'j')
           and ana.data_nas <= to_char(trunc(sysdate),'j')
        UNION ALL
-- msg_convivenza_di_fatto
        select cdf.matricola, 
               96 sequenza,
               'Convivenza di Fatto con '||ana_cv.cognome_nome||' (matr. '||cdf.matricola_cv||')' messaggio,
               'dal '||to_char(to_date(cdf.data_inizio,'j'),'dd/mm/yyyy')||
                 ' Pratica N. '||cdf.pratica_inizio||'/'||cdf.anno_pratica_inizio dettaglio, 
               'S', 
               'S' flag_cer, 
               'S' flag_sfa, 
               'S' flag_cdi, 
               'S' flag_ana, 
               to_char(null)
          from anaana ana_cv, anacdf cdf
         where ana_cv.matricola (+) = cdf.matricola_Cv
           and cdf.data_fine        is null
           and cdf.data_inizio      is not null
           and nvl(cdf.stato_cdf,'D') in ('D','I')
        UNION ALL
-- msg_famigia_coabitante
        select ana.matricola, 
               97 sequenza,
               'Nucleo Coabitante'||
               decode(nvl(fam_rif.convivenza,fam_rif.intestatario),'','',
                 ' con '||nvl(fam_rif.convivenza,fam_rif.intestatario))||
                 ' (Cod.Fam. '||nco.cod_fam_rif||')' messaggio,
               nco.note dettaglio, 
               'S', 
               'S' flag_cer, 
               'S' flag_sfa, 
               'S' flag_cdi, 
               'S' flag_ana, 
               to_char(null)
          from anaana ana, anafam fam_rif, ananco nco
         where ana.cod_fam	   = nco.cod_fam
           and ana.fascia          = nco.fascia
           and fam_rif.cod_fam (+) = nco.cod_fam_rif
           and fam_rif.fascia  (+) = nco.fascia
           and nco.fascia          = 1
           and nco.flag_coabitante is not null
        UNION ALL
-- msg_stato_civile
        select ana.matricola, 98,
               'Individuo con stato civile '||dsc.descrizione,
               to_char(null),
               'S', 'S', 
               to_char(null), 'S', 
               to_char(null), to_char(null)
          from anadsc dsc, anaana ana
         where dsc.cod_sc	= ana.stato_civile
           and dsc.sesso	= ana.sesso
           and ana.stato_civile	in ('NC')
        UNION ALL
-- msg_note_compilate - CERW
        select ana.matricola, 99,
               'Individuo con NOTE compilate',
               ana.note,
               'S', 'S', 
               to_char(null), 'S', 
               to_char(null), to_char(null)
          from anaana ana
         where note is not null
           and f_valore_inp('CERW_NOTE',1,1,'X','S') = 'S'
        UNION ALL
-- msg_note_compilate - VANA
        select ana.matricola, 99,
               'Individuo con NOTE compilate',
               ana.note,
               'S', to_char(null), 
               to_char(null), to_char(null), 
               'S', to_char(null)
          from anaana ana
         where note is not null
           and f_valore_inp('VANA_NOTE',1,1,'X','S') = 'S'
        UNION ALL
-- msg_note_compilate - VELE
        select ele.matricola, 99,
               'Individuo con NOTE Elettore compilate',
               ele.note,
               to_char(null), to_char(null), 
               to_char(null), to_char(null), 
               to_char(null), 'S' 
          from eleana ele
         where note is not null
           and f_valore_inp('VELE_NOTE',1,1,'X','S') = 'S'
        UNION ALL
        select ela.matricola, 99,
               'Individuo con NOTE Liste Aggiunte compilate',
               ela.note,
               to_char(null), to_char(null), 
               to_char(null), to_char(null), 
               to_char(null), 'S' 
          from eleela ela
         where note is not null
           and f_valore_inp('VELE_NOTE',1,1,'X','S') = 'S'
        UNION ALL
        select scr.matricola, 99,
               'Individuo con NOTE Scrutatore compilate',
               scr.note,
               to_char(null), to_char(null), 
               to_char(null), to_char(null), 
               to_char(null), 'S' 
          from eleasc scr
         where note is not null
           and f_valore_inp('VELE_NOTE',1,1,'X','S') = 'S'
        UNION ALL
        select pse.matricola, 99,
               'Individuo con NOTE Presidente di Seggio compilate',
               pse.note,
               to_char(null), to_char(null), 
               to_char(null), to_char(null), 
               to_char(null), 'S' 
          from eleaps pse
         where note is not null
           and f_valore_inp('VELE_NOTE',1,1,'X','S') = 'S'
        UNION ALL
        select ele.matricola, 99,
               'Vota fuori sede per le elezioni del '||to_char(to_date(dce.data_elezioni,'j'),'dd/mm/yyyy'),
               'Comune di Voto: '||c.descrizione||' ('||c.sigla_provincia||')',
               to_char(null), to_char(null), 
               to_char(null), to_char(null), 
               to_char(null), 'S' flag_ele
          from arccom c, eledce dce, eleefs efs, eleana ele
         where c.cod_provincia    = efs.cod_pro_voto
           and c.cod_comune       = efs.cod_Com_voto
           and dce.data_elezioni  >= to_char(sysdate,'j')
           and dce.anno_elezioni  = efs.anno_elezioni
           and dce.progr_elezioni = efs.progr_elezioni
           and efs.matricola      = ele.matricola
           and ele.stato          = 'E'
        UNION ALL
        select ele.matricola, 99,
               'Vota in Italia per le elezioni del '||to_char(to_date(dce.data_elezioni,'j'),'dd/mm/yyyy'),
               to_char(null),
               to_char(null), to_char(null), 
               to_char(null), to_char(null), 
               to_char(null), 'S' flag_ele
          from eledce dce, eleovi ovi, eleana ele
         where dce.data_elezioni  >= to_char(sysdate,'j')
           and dce.anno_elezioni  = ovi.anno_elezioni
           and dce.progr_elezioni = ovi.progr_elezioni
           and ovi.matricola      = ele.matricola
           and ele.stato          = 'E'
        UNION ALL
-- msg_schedario_popolazione_temporanea
        select spt.matricola, 0,
               'Individuo presente nello Schedario della Popolazione Temporanea',
                 'Domicilio: '||descrizione||' ('||sigla_provincia||') '||
                 ' - '||decode(cod_via,null,domicilio_temp,substr(denom_uff,1,30)||civico_esterno_temp||civico_interno_temp)||
                 ' ('||decode(data_iscrizione,null,null,'dal '||to_char(to_date(data_iscrizione,'j'),'dd/mm/yyyy'))||
   	         decode(data_cancellazione,null,null,' al '||to_char(to_date(data_cancellazione,'j'),'dd/mm/yyyy'))||')',
               'S', 'S', 
               to_char(null), 'S', 
               'S', to_char(null)
          from arccom a, anaspt spt, arcvie vie
         where a.cod_provincia (+) = spt.cod_pro_temp
   	   and a.cod_comune    (+) = spt.cod_com_temp
   	   and vie.cod_via     (+) = spt.cod_via_temp 
   	   and (spt.data_cancellazione is null or spt.data_cancellazione >= to_char(sysdate,'j'))
        UNION ALL
-- msg_rubrica_nascita
        select ana.matricola,
               99,
               'Rubrica Nascite',
               'Atto di Nascita del Comune di '||
                 f_comune_al(rna.cod_pro_atto_nas,rna.cod_com_atto_nas,rna.data_nas)||' '||
                 f_provincia_stato_al(rna.cod_pro_atto_nas,rna.cod_com_atto_nas,'','S','S',rna.data_nas)||
                 ' - N.'||rna.atto_nas||' '||rna.parte_nas||rna.serie_nas||' / '||rna.anno_atto_nas,
               'S',
               'S',
               to_char(null),
               to_char(null),
               to_char(null),
               to_char(null)
          from anaana ana, civrna rna
         where ana.cognome_nome = rna.cognome_nome
           and ana.sesso        = nvl(rna.sesso,ana.sesso)
           and ana.data_nas     = rna.data_nas
        UNION ALL
-- msg_non_residente_domiciliato_nel_comune
        select ana.matricola,
               99,
               'Individuo Non Residente - Domiciliato nel Comune',
               'Indirizzo: '||denom_uff||fam.civico_esterno||fam.civico_interno,
               'S' flag_avviso,
               'S' flag_cer,
               to_char(null) flag_sfa,
               to_char(null) flag_cdi,
               'S' flag_ana,
               'S' flag_ele
          from arcvie vie, anafam fam, anaana ana
         where vie.cod_via = fam.cod_via
           and fam.fascia  = ana.fascia
           and fam.cod_fam = ana.cod_fam
           and ana.fascia  = 6 
        ) msg_v
 where msg_v.messaggio is not null
/
comment on table anamsg is 'Anagrafe - Messaggi Individuo (view)'
/
