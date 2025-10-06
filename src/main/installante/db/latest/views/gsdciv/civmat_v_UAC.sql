--liquibase formatted sql
--changeset amonopoli:202504221620 runAlways:true stripComments:false
create or replace view civmat_v_UAC
AS
select mat.*
     , 'M' sesso_m
     , 'F' sesso_f
     , decode(ana.id_atto,'',rec.matricola_1,ana.matricola_1) matricola_1
     , decode(ana.id_atto,'',rec.matricola_2,ana.matricola_2) matricola_2
  from civana ana
     , civana_recupero rec
     , civcta cta
     , civdta dta
     , civmat_v mat
 where rec.id_atto  (+)        = mat.id_atto
   and ana.id_atto  (+)        = mat.id_atto
   and nvl(cta.sigla,'UAC')    = 'UAC'
   and cta.id       (+)        = dta.id_civcta
   and dta.id       (+)        = mat.id_civdta
   and mat.data_mat            between to_char(sysdate,'j')-nvl(to_number(rtrim(f_valore_inp('ADIV_GG_AC',1,3,'9',''))),60) and to_char(sysdate,'j')
   and mat.flag_divorzio       is not null
   and mat.parte               = 2
   and mat.serie               = 'C'
   and not exists (select 'x' 
                     from civcta c
                        , civdta t
                        , civmat_v m
                    where nvl(c.sigla,'UAC')    != 'UAC'
                      and c.id       (+)        = t.id_civcta
                      and t.id       (+)        = m.id_civdta
                      and m.data_mat            > mat.data_mat
                      and m.flag_divorzio       is not null
                      and m.parte               = 2
                      and m.serie               = 'C'
                      and m.cognome_nome_M      = mat.cognome_nome_m
                      and m.data_nas_m		= mat.data_nas_m
                      and m.cognome_nome_f	= mat.cognome_nome_F
                      and m.data_nas_f          = mat.data_nas_f)
/
comment on table civmat_v_UAC is 'Stato Civile - Accordi di Scioglimento/Cessazione MAT per funzione di recupero in fase di inserimento Conferma'
/
