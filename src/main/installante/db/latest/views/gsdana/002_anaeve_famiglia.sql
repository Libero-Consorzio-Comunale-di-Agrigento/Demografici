--liquibase formatted sql
--changeset amonopoli:202503050805_2 runOnChange:true stripComments:false
create or replace view anaeve_famiglia
       (archivio, cod_eve_pr, des_cod_eve_pr, cod_mov, cod_fam, anagrafe, cod_fam_unique, data_eve, d_data_eve, id)
AS
select distinct
-- archivio
       vt8.archivio,
-- cod_eve_pr
       vt8.cod_eve_pr,
-- des_cod_eve_pr
       decode(vt8.cod_eve_pr,
         0, 'TRASFERIMENTO DA ALTRO NUCLEO',
         1, decode(vt8.cod_mov, 1, 'NASCITA', 3, 'ISCRIZIONE AIRE PER NASCITA'),
        92, 'TRASFERIMENTO AD ALTRO NUCLEO',
            dev.descrizione),
-- cod_mov
       vt8.cod_mov,
-- cod_fam
       vt8.cod_fam,
-- anagrafe
       decode(vt8.cod_mov,1,'RES',3,'AIR'),
-- cod_fam_unique
       f_ANA_get_cod_fam_unique(vt8.cod_mov,vt8.cod_fam),
-- data_eve
       vt8.data_eve,
-- d_data_eve
       to_date(vt8.data_eve,'j'),
-- id
       decode(vt8.cod_mov,1,'RES',3,'AIR')||lpad(vt8.cod_fam,7,'0')||vt8.data_eve||vt8.cod_mov||vt8.cod_eve_pr
  from anadev dev, anavt8 vt8
 where dev.cod_ev (+) = vt8.cod_eve_pr
/
comment on table anaeve_famiglia is 'Anagrafe - Storiche Anagrafico della Famiglia (view)'
/
