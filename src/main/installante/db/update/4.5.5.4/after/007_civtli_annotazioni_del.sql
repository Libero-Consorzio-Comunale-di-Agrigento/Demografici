--liquibase formatted sql
--changeset amonopoli:202302071632 runOnChange:true
delete civtli_annotazioni t
 where not exists (select 1 from civcit
                   where id_atto = t.id_atto)
  and tipo_atto = 1                   
/
delete civtli_annotazioni t
 where not exists (select 1 from civnas
                   where id_atto = t.id_atto)
  and tipo_atto = 2
/
delete civtli_annotazioni t
 where not exists (select 1 from civmat
                   where id_atto = t.id_atto)
  and tipo_atto = 4
/
delete civtli_annotazioni t
 where not exists (select 1 from civuci
                   where id_atto = t.id_atto)
  and tipo_atto = -4
/
delete civtli_annotazioni t
 where not exists (select 1 from civmor
                   where id_atto = t.id_atto)
  and tipo_atto = 5
/
