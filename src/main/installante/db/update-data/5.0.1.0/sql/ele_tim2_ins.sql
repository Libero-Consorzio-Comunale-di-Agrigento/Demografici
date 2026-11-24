--liquibase formatted sql
--changeset amonopoli:202603101515_2 runOnChange:true stripComments:false
delete eletim b
 where tipo_lista = 'SEZ'
   and tipo_tim   = 1
   and progr_tim  = 3
   and descrizione_tim = 'Autentica Blocco Liste (Estratto)'
/
insert into eletim 
       (TIPO_LISTA, TIPO_TIM, PROGR_TIM, DESCRIZIONE_TIM, TESTO_TIM, FLAG_DEFAULT, FLAG_DEFAULT_CODE, 
        FLAG_INTESTAZIONE, FLAG_FIRME, FLAG_DEFAULT_ESTRATTO)
select 
-- tipo_lista
       'SEZ', 
-- tipo_tim
       1, 
-- progr_tim
       3, 
-- descrizioen_tim
       'Autentica Blocco Liste (Estratto)', 
-- testo_tim
       'Alla data del <data_blocco_liste> il presente estratto della lista sezionale n. <sezione> comprende numero <tot_votanti> <elettori_elettrici> per le elezioni del <data_elezioni>.'||chr(10)||chr(10)||
       '<solo_comune>, li <data_oggi>', 
-- flag_default 
       null, 
-- flag_dfault_code
       null, 
-- flag_intestatzione
       'S', 
-- flag_firme
       'S', 
-- flag_default_estratto
       'S'
  from dual
 where not exists (select 1 from eletim b
                    where tipo_lista = 'SEZ'
                      and tipo_tim   = 1
                      and progr_tim  = 3
                      and descrizione_tim = 'Autentica Blocco Liste (Estratto)')
/
