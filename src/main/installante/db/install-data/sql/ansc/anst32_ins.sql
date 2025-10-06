--liquibase formatted sql
--changeset amonopoli:202303271035_2 runOnChange:true stripComments:false
insert into anst32 (ID, DESCRIZIONE)
select 0, 'Nulla da segnalare'
  from dual
 where not exists (select 1 from anst32
                    where id = 0)
/
insert into anst32 (ID, DESCRIZIONE)
select 1, 'Sordomuto che sa leggere e scrivere'
  from dual
 where not exists (select 1 from anst32
                    where id = 1)
/
insert into anst32 (ID, DESCRIZIONE)
select 2, 'Sordomuto che sa leggere ma non sa scrivere'
  from dual
 where not exists (select 1 from anst32
                    where id = 2)
/

insert into anst32 (ID, DESCRIZIONE)
select 3, 'Sordomuto che sa leggere ma non può scrivere'
  from dual
 where not exists (select 1 from anst32
                    where id = 3)
/
insert into anst32 (ID, DESCRIZIONE)
select 4, 'Sordomuto che non sa né leggere né scrivere'
  from dual
 where not exists (select 1 from anst32
                    where id = 4)
/
insert into anst32 (ID, DESCRIZIONE)
select 5, 'Persona che non conosce la lingua italiana'
  from dual
 where not exists (select 1 from anst32
                    where id = 5)
/
insert into anst32 (ID, DESCRIZIONE)
select 6, 'Sordo ma non muto che sa leggere'
  from dual
 where not exists (select 1 from anst32
                    where id = 6)
/
insert into anst32 (ID, DESCRIZIONE)
select 7, 'Sordo ma non muto che non sa leggere'
  from dual
 where not exists (select 1 from anst32
                    where id = 7)
/
insert into anst32 (ID, DESCRIZIONE)
select 8, 'Muto ma non sordo che sa scrivere'
  from dual
 where not exists (select 1 from anst32
                    where id = 8)
/
insert into anst32 (ID, DESCRIZIONE)
select 9, 'Muto ma non sordo che non sa scrivere'
  from dual
 where not exists (select 1 from anst32
                    where id = 9)
/
insert into anst32 (ID, DESCRIZIONE)
select 10, 'Muto ma non sordo che non può scrivere'
  from dual
 where not exists (select 1 from anst32
                    where id = 10)
/
update anst32
   set dataInizioValidita = '2000-01-01 00:00:00.0',
       dataFineValidita   = '9999-12-31 00:00:00.0',
       ordinamento        = id
 where ordinamento is null
/
