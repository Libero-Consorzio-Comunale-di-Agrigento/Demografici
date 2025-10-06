--liquibase formatted sql
--changeset snocca:202405021205_4 runOnChange:true stripComments:false
delete cerctc
 where id in (9,10)
/
insert into cerctc (ID, SIGLA, DESCRIZIONE, SEQUENZA, VERSION, COMPETENZA, COMPETENZA_AN_SC, ID_PER_MODALITA_RILASCIO)
select 1, 'ANA', 'ANAGRAFE', 10, 0, 'AN', 'AN', 1
  from dual
 where not exists (select 1 from cerctc c2
                    where c2.id = 1
                    )
/
insert into cerctc (ID, SIGLA, DESCRIZIONE, SEQUENZA, VERSION, COMPETENZA, COMPETENZA_AN_SC, ID_PER_MODALITA_RILASCIO)
select 2, 'CIV', 'STATO CIVILE', 20, 0, 'SC', 'SC', 2
  from dual
 where not exists (select 1 from cerctc c2
                    where c2.id = 2
                   )
/
insert into cerctc (ID, SIGLA, DESCRIZIONE, SEQUENZA, VERSION, COMPETENZA, COMPETENZA_AN_SC, ID_PER_MODALITA_RILASCIO)
select 3, 'ELE', 'ELETTORALE', 30, 0, 'EL', 'AN', 3
  from dual
 where not exists (select 1 from cerctc c2
                    where c2.id = 3
                  )
/
insert into cerctc (ID, SIGLA, DESCRIZIONE, SEQUENZA, VERSION, COMPETENZA, COMPETENZA_AN_SC, ID_PER_MODALITA_RILASCIO)
select 4, 'LEV', 'LEVA E RUOLI MATRICOLARI', 40, 0, 'LM', 'AN', 4
  from dual
 where not exists (select 1 from cerctc c2
                    where c2.id = 4
                  )
/
insert into cerctc (ID, SIGLA, DESCRIZIONE, SEQUENZA, VERSION, COMPETENZA, COMPETENZA_AN_SC, ID_PER_MODALITA_RILASCIO)
select 5, 'DIC', 'DICHIARAZIONI SOSTITUTIVE', 50, 0, 'AN', 'AN', 1
  from dual
 where not exists (select 1 from cerctc c2
                    where c2.id = 5
                  )
/
insert into cerctc (ID, SIGLA, DESCRIZIONE, SEQUENZA, VERSION, COMPETENZA, COMPETENZA_AN_SC, ID_PER_MODALITA_RILASCIO)
select 6, 'VARIE-ANA', 'DOCUMENTI VARI ANAGRAFE', 60, 0, 'AN', 'AN', 6
  from dual
 where not exists (select 1 from cerctc c2
                      where c2.id = 6
                    )
/
insert into cerctc (ID, SIGLA, DESCRIZIONE, SEQUENZA, VERSION, COMPETENZA, COMPETENZA_AN_SC, ID_PER_MODALITA_RILASCIO)
select 7, 'VARIE-CIV', 'DOCUMENTI VARI STATO CIVILE', 70, 0, 'SC', 'SC', 7
  from dual
 where not exists (select 1 from cerctc c2
                      where c2.id = 7
                    )
/
insert into cerctc (ID, SIGLA, DESCRIZIONE, SEQUENZA, VERSION, COMPETENZA, COMPETENZA_AN_SC, ID_PER_MODALITA_RILASCIO)
select 8, 'CDI-CIE', 'CARTE DI IDENTITA''', 15, 0, 'AN', 'AN', 8
  from dual
 where not exists (select 1 from cerctc c2
                      where c2.id = 8
                    )
/
update cerctc
   set sigla                    = 'ANA', 
       descrizione              = 'ANAGRAFE',
       competenza               = 'AN',
       competenza_AN_SC         = 'AN',
       id_per_modalita_rilascio = 1
 where id = 1
/
update cerctc
   set sigla                    = 'CIV', 
       descrizione              = 'STATO CIVILE',
       competenza               = 'SC',
       competenza_AN_SC         = 'SC',
       id_per_modalita_rilascio = 2
 where id = 2
/
update cerctc
   set sigla                    = 'ELE', 
       descrizione              = 'ELETTORALE',
       competenza               = 'EL',
       competenza_AN_SC         = 'AN',
       id_per_modalita_rilascio = 3
 where id = 3
/
update cerctc
   set sigla                    = 'LEV', 
       descrizione              = 'LEVA E RUOLI MATRICOLARI',
       competenza               = 'LM',
       competenza_AN_SC         = 'AN',
       id_per_modalita_rilascio = 4
 where id = 4
/
update cerctc
   set sigla                    = 'DIC', 
       descrizione              = 'DICHIARAZIONI SOSTITUTIVE',
       competenza               = 'AN',
       competenza_AN_SC         = 'AN',
       id_per_modalita_rilascio = 1
 where id = 5
/
update cerctc
   set sigla                    = 'VARIE-ANA', 
       descrizione              = 'DOCUMENTI VARI ANAGRAFE',
       competenza               = 'AN',
       competenza_AN_SC         = 'AN',
       id_per_modalita_rilascio = 6
 where id = 6
/
update cerctc
   set sigla                    = 'VARIE-CIV', 
       descrizione              = 'DOCUMENTI VARI STATO CIVILE',
       competenza               = 'SC',
       competenza_AN_SC         = 'SC',
       id_per_modalita_rilascio = 7
 where id = 7
/
update cerctc
   set sigla                    = 'CDI-CIE', 
       descrizione              = 'CARTE DI IDENTITA''',
       competenza               = 'AN',
       competenza_AN_SC         = 'AN',
       id_per_modalita_rilascio = 8
 where id = 8
/
