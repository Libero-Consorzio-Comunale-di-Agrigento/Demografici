--liquibase formatted sql
--changeset amonopoli:202503071600 runOnChange:true stripComments:false
insert into anaana_alle
       (ID, MATRICOLA, ID_OGGETTO_FILE_GDM, NOME_ALLEGATO, D_DATA_REG)
select to_number(null),
       ana.matricola,
       ogfi.id_oggetto_file, 
       ogfi.filename,
       ogfi.data_aggiornamento
  from gdm_oggetti_file ogfi,
       anaana ana
 where ogfi.id_documento = ana.id_documento_gdm
   and ana.id_documento_gdm is not null
   and not exists (select 1 from anaana_alle ana_a
                    where ana_a.matricola = ana.matricola
                      and ana_a.id_oggetto_file_gdm = ogfi.id_oggetto_file)
/
