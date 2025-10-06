--liquibase formatted sql
--changeset amonopoli:202302241155 runOnChange:true stripComments:false
create or replace view civxpmo_v_zk as
select
-- dati_comune
       m.codice_catasto sede_comune,
-- dati_referente
       f_valore_inp('XPMO_COGN',1,70,'X','') cognome_referente,
       f_valore_inp('XPMO_NOME',1,70,'X','') nome_referente,
-- dati_richiesta
       f_valore_inp('XPMO_PROG',1,9,'9','') numero_richiesta,
       f_valore_inp('XPMO_DATA',1,2,'9','') data_richiesta_gg,
       f_valore_inp('XPMO_DATA',4,2,'9','') data_richiesta_mm,
       f_valore_inp('XPMO_DATA',7,4,'9','') data_richiesta_aaaa,
-- dati_anagrafici
       substr(mor.cognome_nome,1,instr(mor.cognome_nome,'/')-1) pers_cognome,
       substr(mor.cognome_nome,instr(mor.cognome_nome,'/')+1) pers_nome,
       mor.sesso,
       decode(a0.descrizione,'',a.codice_catasto,
         decode(a.cod_provincia,
           701,decode(sign(a.cod_comune-500),1,a.codice_catasto),
           702,decode(sign(a.cod_comune-500),1,a.codice_catasto),
           703,decode(sign(a.cod_comune-500),1,a.codice_catasto))) codi_luogo_nascita,
       decode(a0.descrizione,'','Z000',
         decode(a.cod_provincia,
           701,decode(sign(a.cod_comune-500),1,'Z000',a0.codice_catasto),
           702,decode(sign(a.cod_comune-500),1,'Z000',a0.codice_catasto),
           703,decode(sign(a.cod_comune-500),1,'Z000',a0.codice_catasto),
               a0.codice_catasto)) codi_stato_estero_nas,
       decode(a0.descrizione,'','',
         decode(a.cod_provincia,
           701,decode(sign(a.cod_comune-500),1,'',a.descrizione),
           702,decode(sign(a.cod_comune-500),1,'',a.descrizione),
           703,decode(sign(a.cod_comune-500),1,'',a.descrizione),
               a.descrizione)) desc_comune_estero,
       to_char(to_date(mor.data_nas,'j'),'dd') data_nascita_gg,
       to_char(to_date(mor.data_nas,'j'),'mm') data_nascita_mm,
       to_char(to_date(mor.data_nas,'j'),'yyyy') data_nascita_aaaa,
       mor.cod_fiscale codi_fiscale,
       translate(mor.paternita,'/',' ') pers_paternita,
-- dati_decesso
       decode(b0.descrizione,'',b.codice_catasto,
         decode(b.cod_provincia,
           701,decode(sign(b.cod_comune-500),1,b.codice_catasto),
           702,decode(sign(b.cod_comune-500),1,b.codice_catasto),
           703,decode(sign(b.cod_comune-500),1,b.codice_catasto))) codi_luogo_morte,
       decode(b0.descrizione,'','Z000',
         decode(b.cod_provincia,
           701,decode(sign(b.cod_comune-500),1,'Z000',b0.codice_catasto),
           702,decode(sign(b.cod_comune-500),1,'Z000',b0.codice_catasto),
           703,decode(sign(b.cod_comune-500),1,'Z000',b0.codice_catasto),
               b0.codice_catasto)) codi_stato_estero_morte,
       decode(b0.descrizione,'','',
         decode(b.cod_provincia,
           701,decode(sign(b.cod_comune-500),1,'',b.descrizione),
           702,decode(sign(b.cod_comune-500),1,'',b.descrizione),
           703,decode(sign(b.cod_comune-500),1,'',b.descrizione),
               b.descrizione)) desc_comune_estero_morte,
       mor.atto||decode(mor.parte,1,'I',2,'II')||mor.serie nume_atto_morte,
       to_char(to_date(mor.data_mor,'j'),'dd') data_morte_gg,
       to_char(to_date(mor.data_mor,'j'),'mm') data_morte_mm,
       to_char(to_date(mor.data_mor,'j'),'yyyy') data_morte_aaaa,
       m.codice_catasto codi_luogo_atto_morte,
       to_number(null) anno_prot_decesso,
       to_number(null) nume_prot_decesso,
-- campi per ricerca
       mor.ufficio ufficio_ric,
       mor.anno anno_ric,
       mor.parte parte_ric,
       mor.serie serie_ric,
       mor.atto atto_ric,
       mor.cognome cognome_ric,
       mor.nome nome_ric,
       trunc(mor.d_data_reg) d_data_reg_ric
  FROM arccom m, arccom a, arccom a0, arccom b, arccom b0,
       civmor mor
 WHERE (m.cod_provincia,m.cod_comune)  = (select pro_cliente, com_cliente from menuditta)
   and a.cod_provincia  (+) = cod_pro_nas
   and a.cod_comune     (+) = cod_com_nas
   and a0.cod_provincia (+) = cod_pro_nas
   and a0.cod_Comune    (+) = 0
   and b.cod_provincia  (+) = cod_pro_mor
   and b.cod_comune     (+) = cod_com_mor
   and b0.cod_provincia (+) = cod_pro_mor
   and b0.cod_Comune    (+) = 0
   and mor.cod_rec                 = 0
   and mor.natura                  = 'O'
   and mor.anno             in (to_char(to_date(data_reg,'j'),'yyyy'),to_char(to_date(data_reg,'j'),'yyyy')-1)
--   and data_nas between to_number(to_char(add_months(sysdate,-972),'j'))-1 and  to_number(to_char(add_months(sysdate,-168),'j')) /*da 14 a 81-un giorno anni*/
   and data_nas between to_number(to_char(add_months(sysdate,-1212),'j'))-1 and  to_number(to_char(add_months(sysdate,-168),'j')) /*da 14 a 101-un giorno anni*/
/
comment on table civxpmo_v_zk is 'Stato Civile - Dati per Estrazione Casellario Giudiziario (view)'
/

