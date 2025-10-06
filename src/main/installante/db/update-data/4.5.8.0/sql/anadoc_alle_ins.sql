--liquibase formatted sql
--changeset amonopoli:202502250900_2 runOnChange:true stripComments:false
update anadoc_alle doc_a
   set d_data_reg = (select ogfi.data_aggiornamento
                       from gdm_oggetti_file ogfi
                      where id_oggetto_file = doc_a.id_oggetto_file_gdm)
 where d_data_reg is null
/
insert into ANADOC_ALLE
       (ID, ID_ANADOC, ID_OGGETTO_FILE_GDM, NOME_ALLEGATO, D_DATA_REG)
select to_number(null),
       doc.id,
       ogfi.id_oggetto_file, 
       ogfi.filename,
       ogfi.data_aggiornamento
  from gdm_oggetti_file ogfi,
       anadoc doc
 where ogfi.id_documento = doc.id_documento_gdm
   and doc.id_documento_gdm is not null
   and not exists (select 1 from anadoc_alle doc_a
                    where doc_a.id_anadoc = doc.id
                      and doc_a.id_oggetto_file_gdm = ogfi.id_oggetto_file)
/
