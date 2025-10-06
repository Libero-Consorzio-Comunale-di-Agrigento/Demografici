--liquibase formatted sql
--changeset amonopoli:202302071741 runOnChange:true
alter table civann disable all triggers
/
update civann
   set id_atto_rif = substr(id_atto,1,instr(id_atto,'.')-1)
 where id_atto_rif is null
   and instr(id_atto,'.') > 0
/
update civann ann
   set id_atto_rif = (select distinct com.id_atto_rif 
                        from civcom com
                       where com.id_civann   = ann.id
                         and com.id_atto_rif is not null)
 where id_atto_rif is null
   and exists (select 1
                 from civcom com
                where com.id_civann   = ann.id
                  and com.id_atto_rif is not null)
/
alter table civann enable all triggers
/
