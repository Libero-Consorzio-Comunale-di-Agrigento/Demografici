--liquibase formatted sql
--changeset amonopoli:202501081505 runOnChange:true stripComments:false
create or replace view elex34d_v as
select
-- cognome
        substr(ele.cognome_nome,1,instr(ele.cognome_nome,'/')-1) cognome,
-- nome
        substr(ele.cognome_nome,instr(ele.cognome_nome,'/')+1) nome,
-- cod_fisc
        cod_fiscale cod_fisc,
-- cod_fisc_validato
        decode(cf_calcolato,null,'Vero','Falso') cod_fisc_validato,
-- possesso_ele_attivo
        decode(ele.stato,'E','Vero','Falso') possesso_ele_attivo,
-- sesso
        ana.sesso,
-- data_nascita
        to_char(to_date(data_nas,'j'),'dd/mm/yyyy') data_nascita,
-- giorno_nascita
        to_char(to_date(data_nas,'j'),'dd') data_nascita_gg,
-- mese_nascita
        to_char(to_date(data_nas,'j'),'mm') data_nascita_mm,
-- anno_nascita
        to_char(to_date(data_nas,'j'),'yyyy') data_nascita_yyyy,
-- dati_comune_nascita
-- cod_istat_comune_nascita
        decode(sign(199 - a.cod_provincia),
             1, lpad(cod_pro_nas,3,'0')||lpad(cod_com_nas,3,'0'),
             0, lpad(cod_pro_nas,3,'0')||lpad(cod_com_nas,3,'0'),'') cod_istat_comune_nascita,
-- descr_com_nascita
        decode(sign(199 - a.cod_provincia),
             1, a.descrizione,
             0, a.descrizione,'') descr_com_nascita,
-- sigla_prov_nascita
        decode(sign(199 - a.cod_provincia),
             1,a.sigla_provincia ,
             0, a.sigla_provincia ,'') sigla_prov_nascita,
-- dati_stato_nascita
-- cod_istat_comune_nascita
        decode(sign(199 - a.cod_provincia),
             1, '',
             0, '',lpad(cod_pro_nas,3,'0')) cod_istat_stato_nascita,
-- descr_stato_nascita
        decode(sign(199 - a.cod_provincia),
             1, '',
             0, '',a0.descrizione) descr_stato_nascita,
-- descr_com_estero_nascita
        decode(sign(199 - a.cod_provincia),
             1, '',
             0, '',a.descrizione) descr_com_estero_nascita,
-- atto_di nascita
-- cod_istat_comune_trascrizione
        lpad(cod_pro_atto_nas,3,'0')||lpad(cod_com_atto_nas,3,'0') cod_istat_com_trascrizione,
-- anno
        anno_atto_nas,
-- numero
        atto_nas,
-- parte
        decode(atto_nas,null,'',decode(parte_nas,1,'I','II')) parte_nas,
-- serie
        serie_nas,
-- stato_civile
        decode(stato_civile,'CN','2','1') stato_civile,
-- data_cancellazione_liste_elettorali (da form)
        to_char(to_date(ltrim( substr(parametri,14,7),'0'),'j'),'dd') data_canc_gg,
        to_char(to_date(ltrim( substr(parametri,14,7),'0'),'j'),'mm') data_canc_mm,
        to_char(to_date(ltrim( substr(parametri,14,7),'0'),'j'),'yyyy') data_canc_yyyy,
-- numero_tessera_elettorale
        nvl(tee.tessera,0) numero_tessera_elettorale,
-- tessera_elettorale_consegnata
        decode(tee.tessera,null,'Falso',decode(tee.flag_giacenza,'S','Falso','Vero'))     tessera_elettorale_consegnata ,
-- cod_istat_comune_di_emigrazione
        lpad(m.cod_provincia,3,'0')||lpad(m.cod_comune,3,'0') cod_istat_com_emigrazione,
-- cod_istat_comune_destinatario
        lpad(cod_pro_eve,3,'0')||lpad(cod_com_eve,3,'0') cod_istat_comune_destinatario,
-- data_documento(da form)
        to_char(to_date(ltrim( substr(parametri,7,7),'0'),'j'),'dd') data_doc_gg,
        to_char(to_date(ltrim( substr(parametri,7,7),'0'),'j'),'mm') data_doc_mm,
        to_char(to_date( ltrim( substr(parametri,7,7),'0'),'j'),'yyyy') data_doc_yyyy,
-- cod_pro_eve
        cod_pro_eve,
-- cod_com_eve
        cod_com_eve,
-- des_com_eve
        c.descrizione des_com_eve,
-- sigla_pro_eve
        c.sigla_provincia,
-- indirizzo_mail
        f_IPA_indirizzo_mail(cod_pro_eve,cod_com_eve,'ELE') indirizzo_mail,
-- matricola
	    ele.matricola,
        decode( ltrim( substr(parametri,6,1),' '),'C',c.descrizione) ord1,
        decode( ltrim( substr(parametri,6,1),' '),'C',decode(mov.motivo,14,1,13,1,0)) ord2,
        ele.sesso ord3,
        ele.cognome_nome ord4,
		lpad(pro_cliente,3,'0')||lpad(com_cliente,3,'0') cod_utente,
-- nome_file
		lpad(c.cod_provincia,3,'0')||lpad(c.cod_comune,3,'0')||
        lpad(pro_cliente,3,'0')||lpad(com_cliente,3,'0')||
        to_char(to_date( ltrim( substr(parametri,7,7),'0'),'j'),'ddmmyyyy') nome_file,
		ltrim( substr(parametri,3,2),' ') revisione,
		ltrim(substr(parametri,29,4),'0') anno_revisione,
		ltrim(substr(parametri,33,2),'0') progr_revisione
   from tabrep, menuditta,
        arccom a0,arccom a,arccom b,arccom c, arccom m, eletee tee, anaana ana,eledmo dmo,
        eleana ele,elemov mov
  where a0.cod_provincia (+) = cod_pro_nas
    and a0.cod_comune    (+) = 0
    and a.cod_provincia (+) = cod_pro_nas
    and a.cod_comune    (+) = cod_com_nas
    and b.cod_provincia (+) = cod_pro_atto_nas
    and b.cod_comune    (+) = cod_com_atto_nas
    and c.cod_provincia (+) = cod_pro_eve
    and c.cod_comune    (+) = cod_com_eve
    and m.cod_provincia (+) = pro_cliente
    and m.cod_comune 	(+) = com_cliente
    and cod_pro_eve is not null
    and cod_pro_eve         < 199
    and dmo.cod_mo (+) = mov.motivo
    and tee.matricola (+) = ele.matricola
    and tee.progressivo (+) = 1
    and ana.matricola       = ele.matricola
    and ele.matricola       = mov.matricola
    and mov.sospensione     is null
    and mov.motivo          in (select motivo
                                  from eledmt
                                 where tabulato =  ltrim( substr(parametri,1,2),'0'))
    and mov.revisione =  ltrim( substr(parametri,3,2),' ')
    and ltrim( substr(parametri,5,1),' ')  is null
	and nvl(substr(parametri,28,1),'N') = 'N'
    AND chiave                      = 'X34D'
    AND terminale                   = nvl(userenv('terminal'),'ELEX34D')
UNION
----- da STORICO revisioni
select
-- cognome
        substr(ele.cognome_nome,1,instr(ele.cognome_nome,'/')-1) cognome,
-- nome
        substr(ele.cognome_nome,instr(ele.cognome_nome,'/')+1) nome,
-- cod_fisc
        ana.cod_fiscale cod_fisc,
-- cod_fisc_validato
        decode(ana.cf_calcolato,null,'Vero','Falso') cod_fisc_validato,
-- possesso_ele_attivo
        'Vero' possesso_ele_attivo,
-- sesso
        ana.sesso,
-- data_nascita
        to_char(to_date(ana.data_nas,'j'),'dd/mm/yyyy') data_nascita,
-- giorno_nascita
        to_char(to_date(ana.data_nas,'j'),'dd') data_nascita_gg,
-- mese_nascita
        to_char(to_date(ana.data_nas,'j'),'mm') data_nascita_mm,
-- anno_nascita
        to_char(to_date(ana.data_nas,'j'),'yyyy') data_nascita_yyyy,
-- dati_comune_nascita
-- cod_istat_comune_nascita
        decode(sign(199 - a.cod_provincia),
             1, lpad(ana.cod_pro_nas,3,'0')||lpad(ana.cod_com_nas,3,'0'),
             0, lpad(ana.cod_pro_nas,3,'0')||lpad(ana.cod_com_nas,3,'0'),'') cod_istat_comune_nascita,
-- descr_com_nascita
        decode(sign(199 - a.cod_provincia),
             1, a.descrizione,
             0, a.descrizione,'') descr_com_nascita,
-- sigla_prov_nascita
        decode(sign(199 - a.cod_provincia),
             1,a.sigla_provincia ,
             0, a.sigla_provincia ,'') sigla_prov_nascita,
-- dati_stato_nascita
-- cod_istat_comune_nascita
        decode(sign(199 - a.cod_provincia),
             1, '',
             0, '',lpad(ana.cod_pro_nas,3,'0')) cod_istat_stato_nascita,
-- descr_stato_nascita
        decode(sign(199 - a.cod_provincia),
             1, '',
             0, '',a0.descrizione) descr_stato_nascita,
-- descr_com_estero_nascita
        decode(sign(199 - a.cod_provincia),
             1, '',
             0, '',a.descrizione) descr_com_estero_nascita,
-- atto_di nascita
-- cod_istat_comune_trascrizione
        lpad(ana.cod_pro_atto_nas,3,'0')||lpad(ana.cod_com_atto_nas,3,'0') cod_istat_com_trascrizione,
-- anno
        ana.anno_atto_nas,
-- numero
        ana.atto_nas,
-- parte
        decode(ana.atto_nas,null,'',decode(ana.parte_nas,1,'I','II')) parte_nas,
-- serie
        ana.serie_nas,
-- stato_civile
        decode(ana.stato_civile,'CN','2','1') stato_civile,
-- data_cancellazione_liste_elettorali (da form)
        to_char(to_date(dsr.data_verbale,'j'),'dd') data_canc_gg,
        to_char(to_date(dsr.data_verbale,'j'),'mm') data_canc_mm,
        to_char(to_date(dsr.data_verbale,'j'),'yyyy') data_canc_yyyy,
-- numero_tessera_elettorale
        tee.tessera numero_tessera_elettorale,
-- tessera_elettorale_consegnata
        decode(tee.tessera,null,'Falso',decode(tee.flag_giacenza,'S','Falso','Vero'))     tessera_elettorale_consegnata ,
-- cod_istat_comune_di_emigrazione
        lpad(m.cod_provincia,3,'0')||lpad(m.cod_comune,3,'0') cod_istat_com_emigrazione,
-- cod_istat_comune_destinatario
        lpad(eve_v.cod_pro_eve,3,'0')||lpad(eve_v.cod_com_eve,3,'0') cod_istat_comune_destinatario,
-- data_documento(da form)
        to_char(to_date(ltrim( substr(parametri,7,7),'0'),'j'),'dd') data_doc_gg,
        to_char(to_date(ltrim( substr(parametri,7,7),'0'),'j'),'mm') data_doc_mm,
        to_char(to_date( ltrim( substr(parametri,7,7),'0'),'j'),'yyyy') data_doc_yyyy,
-- cod_pro_eve
        eve_v.cod_pro_eve,
-- cod_com_eve
        eve_v.cod_com_eve,
-- des_com_eve
        c.descrizione des_com_eve,
-- sigla_pro_eve
        c.sigla_provincia,
-- indirizzo_mail
        f_IPA_indirizzo_mail(eve_v.cod_pro_eve,eve_v.cod_com_eve,'ELE') indirizzo_mail,
-- matricola
      ele.matricola,
        c.descrizione ord1,
        decode(sto.motivo,14,1,13,1,0) ord2,
        ele.sesso ord3,
        ele.cognome_nome ord4,
    lpad(m.cod_provincia,3,'0')||lpad(m.cod_comune,3,'0') cod_utente,
-- nome_file
    lpad(c.cod_provincia,3,'0')||lpad(c.cod_comune,3,'0')||
    lpad(m.cod_provincia,3,'0')||lpad(m.cod_comune,3,'0')||
    to_char(to_date( ltrim( substr(parametri,7,7),'0'),'j'),'ddmmyyyy') nome_file,
	ltrim( substr(parametri,3,2),' ') revisione,
	ltrim(substr(parametri,29,4),'0') anno_revisione,
	ltrim(substr(parametri,33,2),'0') progr_revisione
   from (select eve.matricola, eve.cod_mov, eve.cod_eve, eve.data_eve, eve.cod_pro_eve, eve.cod_com_eve
           from anaeve eve
         UNION
         select mov.matricola, mov.cod_mov, mov.cod_eve, mov.data_eve, mov.cod_pro_eve, mov.cod_com_eve
           from anamov mov
          where mov.cod_mov = 2
            and mov.cod_eve = 62) eve_v,
        tabrep,
        arccom a0, arccom a, arccom b, arccom c, arccom m,
        anaana ana,
        eletee tee, eleana ele, elesto sto, eledsr dsr
  where (m.cod_provincia, m.cod_comune) =
        (select pro_cliente, com_cliente from menuditta)
    and a0.cod_provincia (+)     = ana.cod_pro_nas
    and a0.cod_comune    (+)     = 0
    and a.cod_provincia  (+)     = ana.cod_pro_nas
    and a.cod_comune     (+)     = ana.cod_com_nas
    and b.cod_provincia  (+)     = ana.cod_pro_atto_nas
    and b.cod_comune     (+)     = ana.cod_com_atto_nas
    and tee.matricola      (+)     = ele.matricola
    and tee.progressivo  (+)     = 1
--
    and c.cod_provincia  (+)     = eve_v.cod_pro_eve
    and c.cod_comune     (+)     = eve_v.cod_com_eve
    and eve_v.cod_pro_eve          is not null
    and eve_v.cod_pro_eve          < 199
    and eve_v.matricola           = ana.matricola
    and ((eve_v.cod_mov = ana.fascia and eve_v.cod_eve = ana.stato and eve_v.data_eve = ana.data_ult_eve and sto.motivo != 31)
         or 
         (eve_v.cod_mov = 2 and eve_v.cod_eve = 62 and eve_v.data_eve between ana.data_ult_eve and dsr.data_verbale and sto.motivo = 31)
         ) 
--
    and ana.matricola           = ele.matricola
    and ele.matricola           = sto.matricola
    and sto.motivo              in (select motivo
                                      from eledmt
                                     where tabulato = ltrim( substr(parametri,1,2),'0'))
    and sto.progr_revisione     = dsr.progr_revisione
    and sto.revisione             = dsr.revisione
    and sto.anno_revisione      = dsr.anno
    and dsr.anno        = ltrim(substr(parametri,29,4),'0')
    and dsr.revisione        = upper(ltrim( substr(parametri,3,2),' '))
    and dsr.progr_revisione    = ltrim(substr(parametri,33,2),'0')
    and substr(parametri,28,1) = 'S'
    AND chiave                      = 'X34D'
    AND terminale                   = nvl(userenv('terminal'),'ELEX34D')
/
comment on table elex34d_v is 'Elettorale - Dati per estrazione Modelli 3-4D XML (view)'
/