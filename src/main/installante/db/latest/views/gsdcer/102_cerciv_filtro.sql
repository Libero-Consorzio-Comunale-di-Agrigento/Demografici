--liquibase formatted sql
--changeset amonopoli:202410291755 runOnChange:true stripComments:false
create or replace view cerciv_filtro
       (tipo_archivio, id, id_atto, cognome, nome, d_data_nas, sesso, cod_rec, anno, atto, parte, serie, id_atto_ansc, numero_unico, filtro)
AS
select 2, nas_f.id, nas_f.id_atto, nas_f.cognome, nas_f.nome, nas_f.d_data_nas, nas_f.sesso, nas_f.cod_rec, nas_f.anno, nas_f.atto, nas_f.parte, nas_f.serie, nas_f.id_atto_ansc, nas_f.numero_unico, nas_f.filtro
  from cernas_filtro nas_f
UNION 
select 4, mat_f.id, mat_f.id_atto, mat_f.cognome, mat_f.nome, mat_f.d_data_nas, mat_f.sesso,  mat_f.cod_rec, mat_f.anno, mat_f.atto, mat_f.parte, mat_f.serie, mat_f.id_atto_ansc, mat_f.numero_unico, mat_f.filtro
  from (select id, id_atto, cognome_m cognome, nome_m nome, data_nas_m data_nas, d_data_nas_m d_data_nas, 'M' sesso, cod_rec, anno, atto, parte, serie, id_atto_ansc, numero_unico, filtro from cermat_filtro 
        UNION 
        select id, id_atto,cognome_f cognome, nome_f nome, data_nas_f data_nas, d_data_nas_f d_data_nas, 'F' sesso, cod_rec, anno, atto, parte, serie, id_atto_ansc, numero_unico, filtro from cermat_filtro) mat_f
UNION 
select -4, uci_f.id, uci_f.id_atto, uci_f.cognome, uci_f.nome, uci_f.d_data_nas, uci_f.sesso,  uci_f.cod_rec, uci_f.anno, uci_f.atto, uci_f.parte, uci_f.serie, uci_f.id_atto_ansc, uci_f.numero_unico, uci_f.filtro
  from (select id, id_atto,cognome_m cognome, nome_m nome, data_nas_m data_nas, d_data_nas_m d_data_nas, sesso_m sesso, cod_rec, anno, atto, parte, serie, id_atto_ansc, numero_unico, filtro from ceruci_filtro 
        UNION 
        select id, id_atto,cognome_f cognome, nome_f nome, data_nas_f data_nas, d_data_nas_f d_data_nas, sesso_f sesso, cod_rec, anno, atto, parte, serie, id_atto_ansc, numero_unico, filtro from ceruci_filtro) uci_f
UNION 
select 5, mor_f.id, mor_f.id_atto, mor_f.cognome, mor_f.nome, mor_f.d_data_nas, mor_f.sesso, mor_f.cod_rec, mor_f.anno, mor_f.atto, mor_f.parte, mor_f.serie, mor_f.id_atto_ansc, mor_f.numero_unico, mor_f.filtro
  from cermor_filtro mor_f
/
comment on table cerciv_filtro is 'Certificazione - Atti di Stato Civile con Filri (view)'
/
