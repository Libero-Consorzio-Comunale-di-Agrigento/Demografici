--liquibase formatted sql
--changeset amonopoli:202602051410_2 runOnChange:true stripComments:false
insert into civddo (ID, TIPO_ATTO, COD_DO, DESCRIZIONE, FLAG_ARCHIVIAZIONE, TIPO_ACQUISIZIONE, SEQUENZA, FLAG_PVU, FLAG_RICORRENTE, CODICE_ANSC, VERSION)
select to_number(null), 1, '115', 'ATTO DI COSTITUZIONE E TRADUZIONE', null, null, null, null, null, 115, 0
  from dual
 where not exists (select 1 from civddo
                    where cod_do    = '115'
                      and tipo_atto = 1)
/
insert into civddo (ID, TIPO_ATTO, COD_DO, DESCRIZIONE, FLAG_ARCHIVIAZIONE, TIPO_ACQUISIZIONE, SEQUENZA, FLAG_PVU, FLAG_RICORRENTE, CODICE_ANSC, VERSION)
select to_number(null), 2, '115', 'ATTO DI COSTITUZIONE E TRADUZIONE', null, null, null, null, null, 115, 0
  from dual
 where not exists (select 1 from civddo
                    where cod_do    = '115'
                      and tipo_atto = 2)
/
insert into civddo (ID, TIPO_ATTO, COD_DO, DESCRIZIONE, FLAG_ARCHIVIAZIONE, TIPO_ACQUISIZIONE, SEQUENZA, FLAG_PVU, FLAG_RICORRENTE, CODICE_ANSC, VERSION)
select to_number(null), 4, '115', 'ATTO DI COSTITUZIONE E TRADUZIONE', null, null, null, null, null, 115, 0
  from dual
 where not exists (select 1 from civddo
                    where cod_do    = '115'
                      and tipo_atto = 4)
/
insert into civddo (ID, TIPO_ATTO, COD_DO, DESCRIZIONE, FLAG_ARCHIVIAZIONE, TIPO_ACQUISIZIONE, SEQUENZA, FLAG_PVU, FLAG_RICORRENTE, CODICE_ANSC, VERSION)
select to_number(null), 5, '115', 'ATTO DI COSTITUZIONE E TRADUZIONE', null, null, null, null, null, 115, 0
  from dual
 where not exists (select 1 from civddo
                    where cod_do    = '115'
                      and tipo_atto = 5)
/
insert into civddo (ID, TIPO_ATTO, COD_DO, DESCRIZIONE, FLAG_ARCHIVIAZIONE, TIPO_ACQUISIZIONE, SEQUENZA, FLAG_PVU, FLAG_RICORRENTE, CODICE_ANSC, VERSION)
select to_number(null), -4, '115', 'ATTO DI COSTITUZIONE E TRADUZIONE', null, null, null, null, null, 115, 0
  from dual
 where not exists (select 1 from civddo
                    where cod_do    = '115'
                      and tipo_atto = -4)
/
