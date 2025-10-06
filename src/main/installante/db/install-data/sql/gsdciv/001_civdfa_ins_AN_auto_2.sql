--liquibase formatted sql
--changeset amonopoli:202503121545_1 runOnChange:true stripComments:false
update civdfa
   set formula = '170-NO-AN'
 where formula = '170-AN'
   and not exists (select 1 from civdfa where formula = '170-NO-AN')
/
insert into civdfa (TIPO_ATTO, FORMULA, TIPO_ANNOTAZIONE, DESCRIZIONE_1, DESCRIZIONE_2, DESCRIZIONE_3, FLAG_NUOVO_ORDINAMENTO, FLAG_PROVENIENZA, DESCRIZIONE, GENERE, FLAG_SECRETATO, FLAG_ISTAT)
select 4, '170-AN', 'M', 
       'ANNOTAZIONE DELLA SENTENZA DELLA CORTE DI APPELLO CHE', 
       'DICHIARA EFFICACE NELLO STATO LA PRONUNCIA STRANIERA', 
       'DI NULLITA'' O DI SCIOGLIMENTO DEL MATRIMONIO', 
       'S', null, 
       'ANNOTAZIONE DELLA SENTENZA DELLA CORTE DI APPELLO CHE DICHIARA EFFICACE NELLO STATO LA PRONUNCIA STRANIERA DI NULLITA'' O DI SCIOGLIMENTO DEL MATRIMONIO', 
       null, null, null
  from dual
 where not exists (select 1 from civdfa b
                    where b.formula = '170-AN')
/
