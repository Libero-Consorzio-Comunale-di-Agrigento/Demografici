--liquibase formatted sql
--changeset amonopoli:202410311030_2 runOnChange:true stripComments:false
insert into cerdtr
       (ID, DESCRIZIONE, SEQUENZA, CODICE_ANPR, FLAG_VISIBILE, FLAG_RICHIEDENTE, FLAG_AUTORITA)
select 1,
       'Istanza di Parte',
       '10',
       '2',
       'S',
       '',
       ''
  from dual
 where not exists (select 1 from cerdtr b
                    where b.id = 1
                  )
/
insert into cerdtr
       (ID, DESCRIZIONE, SEQUENZA, CODICE_ANPR, FLAG_VISIBILE, FLAG_RICHIEDENTE, FLAG_AUTORITA)
select 2,
       'Altro Richiedente',
       '20',
       '1',
       'S',
       'S',
       ''
  from dual
 where not exists (select 1 from cerdtr b
                    where b.id = 2
                  )
/
insert into cerdtr
       (ID, DESCRIZIONE, SEQUENZA, CODICE_ANPR, FLAG_VISIBILE, FLAG_RICHIEDENTE, FLAG_AUTORITA)
select 3,
       'Istanza d''Ufficio',
       '30',
       '1',
       'S',
       '',
       ''
  from dual
 where not exists (select 1 from cerdtr b
                    where b.id = 3
                  )
/
insert into cerdtr
       (ID, DESCRIZIONE, SEQUENZA, CODICE_ANPR, FLAG_VISIBILE, FLAG_RICHIEDENTE, FLAG_AUTORITA)
select 4,
       'Altro Ente / Autorità',
       '40',
       '3',
       '',
       '',
       'S'
  from dual
 where not exists (select 1 from cerdtr b
                    where b.id = 4
                  )
/
update cerdtr
   set descrizione        = 'Istanza di Parte',
       sequenza           = '10',
       codice_anpr        = '2',
       flag_visibile      = 'S',
       flag_richiedente   = '',
       flag_autorita      = ''
 where id = 1
/
update cerdtr
   set descrizione        = 'Altro Richiedente',
       sequenza           = '20',
       codice_anpr        = '1',
       flag_visibile      = 'S',
       flag_richiedente   = 'S',
       flag_autorita      = ''
 where id = 2
/
update cerdtr
   set descrizione        = 'Istanza d''Ufficio',
       sequenza           = '30',
       codice_anpr        = '1',
       flag_visibile      = 'S',
       flag_richiedente   = '',
       flag_autorita      = ''
 where id = 3
/
update cerdtr
   set descrizione        = 'Altro Ente / Autorità',
       sequenza           = '40',
       codice_anpr        = '3',
       flag_visibile      = '',
       flag_richiedente   = '',
       flag_autorita      = 'S'
 where id = 4
/
