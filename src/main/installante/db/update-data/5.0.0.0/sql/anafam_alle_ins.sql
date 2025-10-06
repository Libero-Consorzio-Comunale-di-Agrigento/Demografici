--liquibase formatted sql
--changeset amonopoli:202503071510 runOnChange:true stripComments:false
insert into anafam_alle
       (ID, COD_FAM_UNIQUE, ID_OGGETTO_FILE_GDM, NOME_ALLEGATO, D_DATA_REG)
select to_number(null),
       fam.cod_fam_unique,
       ogfi.id_oggetto_file, 
       ogfi.filename,
       ogfi.data_aggiornamento
  from gdm_oggetti_file ogfi,
       anafam fam
 where ogfi.id_documento = fam.id_documento_gdm
   and fam.id_documento_gdm is not null
   and not exists (select 1 from anafam_alle fam_a
                    where fam_a.cod_fam_unique      = fam.cod_fam_unique
                      and fam_a.id_oggetto_file_gdm = ogfi.id_oggetto_file)
/
