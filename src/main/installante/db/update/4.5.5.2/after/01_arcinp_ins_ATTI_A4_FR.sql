--liquibase formatted sql
--changeset snocca:202211171055
insert into arcinp
       (parametro, valore, descrizione, gruppo, note, flag_visibile)
select 'ATTI_A4_FR'
     , 'S'
     , 'Visibilita'' cornice'
     , 'CIV'
     , 'Valori previsti: ''S'' - ''N''.
Valorizzato a ''S'' attiva la visualizzazione della cornice nella stampa dell''atto'
     , 'S'
  from dual
 where not exists (select 'x' from arcinp
                    where parametro = 'ATTI_A4_FR')
/
