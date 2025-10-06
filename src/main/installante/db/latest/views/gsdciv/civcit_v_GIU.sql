--liquibase formatted sql
--changeset amonopoli:202310201500 runAlways:true runOnChange:true stripComments:false
create or replace view civcit_v_GIU
AS
select cit.*
     , decode(cta.sigla,'GIU','DAQ','R18','AS1') sigla_categoria
     , decode(ana.id_atto,'',rec.matricola_1,ana.matricola_1) matricola_1
     , decode(ana.id_atto,'',rec.matricola_2,ana.matricola_2) matricola_2
     , decode(cta.sigla,'GIU','Giuramento','R18','Richiesta') tipo_recupero
  from civana ana
     , civana_recupero rec
     , civcta cta
     , civdta dta
     , civcit_v cit
 where rec.id_atto  (+)        = cit.id_atto
   and ana.id_atto  (+)        = cit.id_atto
   and cta.sigla               in ('GIU','R18')
   and cta.id                  = dta.id_civcta
   and dta.id                  = cit.id_civdta
   and not exists (select 'x' 
                     from civcta c
                        , civdta t
                        , civcit_v v
                    where c.sigla               in ('DAQ','AS1')
                      and c.id                  = t.id_civcta
                      and t.id                  = v.id_civdta
                      and v.data_cit            >= cit.data_cit
                      and v.cognome_nome        = cit.cognome_nome
                      and v.sesso               = cit.sesso
                      and v.data_nas		= cit.data_nas)
UNION
select cit.*
     , 'DAQ' sigla_categoria
     , decode(ana.id_atto,'',rec.matricola_1,ana.matricola_1) matricola_1
     , decode(ana.id_atto,'',rec.matricola_2,ana.matricola_2) matricola_2
     , 'Dichiarazione' tipo_recupero
  from civana ana
     , civana_recupero rec
     , civcta cta
     , civdta dta
     , civcit_v cit
 where rec.id_atto  (+)        = cit.id_atto
   and ana.id_atto  (+)        = cit.id_atto
   and cta.sigla               = 'DAQ'
   and cta.id                  = dta.id_civcta
   and dta.id                  = cit.id_civdta
   and cit.tipo_richiesta      = 'DIC'
   and not exists (select 'x' 
                     from civcta c
                        , civdta t
                        , civcit_v v
                    where c.sigla               = 'DAQ'
                      and c.id                  = t.id_civcta
                      and t.id                  = v.id_civdta
                      and v.tipo_richiesta      = 'TRA'
                      and v.data_cit            >= cit.data_cit
                      and v.cognome_nome        = cit.cognome_nome
                      and v.sesso               = cit.sesso
                      and v.data_nas		= cit.data_nas)
/
comment on table civcit_v_GIU is 'Stato Civile - Atti di Giuramento / Richiesta per funzione di recupero in fase di inserimento Acquisto'
/
