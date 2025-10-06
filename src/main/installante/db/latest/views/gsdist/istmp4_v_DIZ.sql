--liquibase formatted sql
--changeset amonopoli:202304061144_1 runOnChange:true stripComments:false
create or replace view istmp4_v_DIZ
       (cod_archivio, des_archivio, codice_istat, descrizione, codice_ads, da_anno, a_anno, anno_rif)
as
-- 'SCM', 'Stato civile M'
select 'SCM', 'Stato civile'         , 1, 'Celibe'                                             , 'CE', 1800, 9999, 2011 from dual UNION
select 'SCM', 'Stato civile'         , 2, 'Coniugato'                                          , 'CN', 1800, 9999, 2011 from dual UNION
select 'SCM', 'Stato civile'         , 3, 'Vedovo'                                             , 'VE', 1800, 9999, 2011 from dual UNION
select 'SCM', 'Stato civile'         , 4, 'Divorziato'                                         , 'DV', 1800, 9999, 2011 from dual UNION
select 'SCM', 'Stato civile'         , 4, 'Gia'' coniugato'                                    , 'GC', 1800, 9999, 2011 from dual UNION
-- 'SCF', 'Stato civile F'
select 'SCF', 'Stato civile'         , 1, 'Nubile'                                             , 'NU', 1800, 9999, 2011 from dual UNION
select 'SCF', 'Stato civile'         , 2, 'Coniugata'                                          , 'CN', 1800, 9999, 2011 from dual UNION
select 'SCF', 'Stato civile'         , 3, 'Vedova'                                             , 'VE', 1800, 9999, 2011 from dual UNION
select 'SCF', 'Stato civile'         , 4, 'Divorziata'                                         , 'DV', 1800, 9999, 2011 from dual UNION
select 'SCF', 'Stato civile'         , 4, 'Gia'' coniugata'                                    , 'GC', 1800, 9999, 2011 from dual 
/
comment on table istmp4_v_DIZ is 'ISTAT - Modello P.4 - Codifiche'
/
