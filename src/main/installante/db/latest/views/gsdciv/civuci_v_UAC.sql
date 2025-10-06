--liquibase formatted sql
--changeset amonopoli:202312221355 runAlways:true runOnChange:true stripComments:false
create or replace view civuci_v_UAC
AS
select uci.*
     , decode(ana.id_atto,'',rec.matricola_1,ana.matricola_1) matricola_1
     , decode(ana.id_atto,'',rec.matricola_2,ana.matricola_2) matricola_2
  from civana ana
     , civana_recupero rec
     , civcta cta
     , civdta dta
     , civuci_v uci
 where rec.id_atto  (+)        = uci.id_atto
   and ana.id_atto  (+)        = uci.id_atto
   and nvl(cta.sigla,'UAC')    = 'UAC'
   and cta.id       (+)        = dta.id_civcta
   and dta.id       (+)        = uci.id_civdta
   and uci.data_mat            between to_char(sysdate,'j')-nvl(to_number(rtrim(f_valore_inp('ADIV_GG_AC',1,3,'9',''))),60) and to_char(sysdate,'j')
   and uci.flag_divorzio       is not null
   and uci.parte               = 2
   and not exists (select 'x' 
                     from civcta c
                        , civdta t
                        , civuci_v m
                    where nvl(c.sigla,'UAC')    != 'UAC'
                      and c.id       (+)        = t.id_civcta
                      and t.id       (+)        = m.id_civdta
                      and m.data_mat            > uci.data_mat
                      and m.flag_divorzio       is not null
                      and m.parte               = 2
                      and m.cognome_nome_M      = uci.cognome_nome_m
                      and m.data_nas_m          = uci.data_nas_m
                      and m.cognome_nome_f      = uci.cognome_nome_F
                      and m.data_nas_f          = uci.data_nas_f)
/
comment on table civuci_v_UAC is 'Stato Civile - Accordi di Scioglimento UCI per funzione di recupero in fase di inserimento Conferma'
/
