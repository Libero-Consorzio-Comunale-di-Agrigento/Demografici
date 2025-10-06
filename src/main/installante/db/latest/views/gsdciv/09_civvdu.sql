--liquibase formatted sql
--changeset amonopoli:202301181510 runOnChange:true stripComments:false
create or replace view civvdu
	(cod_registro, anno, protocollo, data_protocollo, data,
         ufficio_mor, anno_mor, parte_mor, serie_mor, atto_mor,
         cognome_nome, sesso, 
         cod_pro_nas, cod_com_nas, des_com_nas, sigla_pro_nas, data_nascita, 
         cod_pro_mor, cod_Com_mor, des_com_mor, sigla_pro_mor, data_morte,
         cod_pro_res, cod_Com_res, des_com_res, sigla_pro_res,
         data_reg, terminalista,
         id, id_dts, d_data_protocollo, d_data, d_data_nas, d_data_mor, d_data_reg, 
         cognome, nome,
         id_atto, flag_dts_presente)
AS
select dts_v.cod_registro
     , dts_v.anno_protocollo
     , dts_v.protocollo
     , dts_v.data_protocollo
     , dts_v.data
     , decode(mor.cod_rec,9,to_number(null),mor.ufficio) ufficio_mor
     , decode(mor.cod_rec,9,to_number(null),mor.anno) anno_mor
     , decode(mor.cod_rec,9,to_number(null),mor.parte) parte_mor
     , decode(mor.cod_rec,9,to_char(null),mor.serie) serie_mor
     , decode(mor.cod_rec,9,to_number(null),mor.atto) atto_mor
     , mor.cognome_nome
     , mor.sesso
     , mor.cod_pro_nas
     , mor.cod_com_nas
     , com_nas.descrizione des_com_nas
     , com_nas.sigla_provincia sigla_pro_nas
     , mor.data_nas
     , mor.cod_pro_mor
     , mor.cod_com_mor
     , com_mor.descrizione des_com_mor
     , com_mor.sigla_provincia sigla_pro_mor
     , mor.data_mor
     , mor.cod_pro_res
     , mor.cod_com_res
     , com_res.descrizione des_com_res
     , com_res.sigla_provincia sigla_pro_res
     , dts_v.data_reg
     , dts_v.terminalista
     , decode(dts_v.cod_registro,'',to_char(dts_v.id_dts),dts_v.id) id
     , dts_v.id_dts
     , to_date(dts_v.data_protocollo,'j') d_data_protocollo
     , to_date(dts_v.data,'j') d_data
     , to_date(mor.data_nas,'j') d_data_nas
     , to_date(mor.data_mor,'j') d_data_mor
     , to_date(dts_v.data_reg,'j') d_data_reg
     , mor.cognome
     , mor.nome
     , mor.id_atto
     , 'S'
  from (select dts.id_atto,dts.cod_registro_t cod_registro, dts.anno_protocollo_t anno_protocollo, dts.protocollo_t protocollo,
               dts.data_protocollo_t data_protocollo,
               nvl(dts.data_protocollo_t,dts.data_reg) data,
               dts.ufficio, dts.anno, dts.parte, dts.serie, dts.atto, dts.data_reg, dts.terminalista, dts.id id_dts, 'T.'||id id
          from civdts dts
        UNION
        select dts.id_atto,dts.cod_registro_s cod_registro, dts.anno_protocollo_s anno_protocollo, dts.protocollo_s protocollo,
               dts.data_protocollo_s data_protocollo,
               nvl(dts.data_protocollo_s,dts.data_reg) data,
               dts.ufficio, dts.anno, dts.parte, dts.serie, dts.atto, dts.data_reg, dts.terminalista, dts.id id_dts, 'S.'||id id
          from civdts dts
        UNION
        select dts.id_atto,dts.cod_registro_c cod_registro, dts.anno_protocollo_c anno_protocollo, dts.protocollo_c protocollo,
               dts.data_protocollo_c data_protocollo,
               nvl(dts.data_protocollo_c,dts.data_reg) data,
               dts.ufficio, dts.anno, dts.parte, dts.serie, dts.atto, dts.data_reg, dts.terminalista, dts.id id_dts, 'C'||'.'||id id
          from civdts dts
         where cod_registro_c is not null
           and not exists (select 'x' from civdts t
                            where t.cod_registro_t    = dts.cod_registro_c
                              and t.anno_protocollo_t = dts.anno_protocollo_c
                              and t.protocollo_t      = dts.protocollo_c)
           and not exists (select 'x' from civdts s
                            where s.cod_registro_s    = dts.cod_registro_c
                              and s.anno_protocollo_s = dts.anno_protocollo_c
                              and s.protocollo_s      = dts.protocollo_c)
       ) dts_v
     , arccom com_nas
     , arccom com_mor
     , arccom com_res
     , civmor mor
 where com_nas.cod_provincia (+) = mor.cod_pro_nas
   and com_nas.cod_comune    (+) = mor.cod_Com_nas
   and com_mor.cod_provincia (+) = mor.cod_pro_mor
   and com_mor.cod_comune    (+) = mor.cod_Com_mor
   and com_res.cod_provincia (+) = mor.cod_pro_res
   and com_res.cod_comune    (+) = mor.cod_Com_res
   and mor.id_atto               = dts_v.id_atto
UNION
select to_number(null) cod_registro
     , to_number(null) anno_protocollo
     , to_number(null) protocollo
     , to_number(null) data_protocollo
     , to_number(null) data
     , decode(mor.cod_rec,9,to_number(null),mor.ufficio) ufficio_mor
     , decode(mor.cod_rec,9,to_number(null),mor.anno) anno_mor
     , decode(mor.cod_rec,9,to_number(null),mor.parte) parte_mor
     , decode(mor.cod_rec,9,to_char(null),mor.serie) serie_mor
     , decode(mor.cod_rec,9,to_number(null),mor.atto) atto_mor
     , mor.cognome_nome
     , mor.sesso
     , mor.cod_pro_nas
     , mor.cod_com_nas
     , com_nas.descrizione des_com_nas
     , com_nas.sigla_provincia sigla_pro_nas
     , mor.data_nas
     , mor.cod_pro_mor
     , mor.cod_com_mor
     , com_mor.descrizione des_com_mor
     , com_mor.sigla_provincia sigla_pro_mor
     , mor.data_mor
     , mor.cod_pro_res
     , mor.cod_com_res
     , com_res.descrizione des_com_res
     , com_res.sigla_provincia sigla_pro_res
     , to_number(null) data_reg
     , to_char(null) terminalista
     , mor.id_atto id
     , to_number(null) id_dts
     , to_date(null) d_data_protocollo
     , to_date(null) d_data
     , to_date(mor.data_nas,'j') d_data_nas
     , to_date(mor.data_mor,'j') d_data_mor
     , to_date(null) d_data_reg
     , mor.cognome
     , mor.nome
     , mor.id_atto
     , '' flag_dts_presente
  from arccom com_nas
     , arccom com_mor
     , arccom com_res
     , civmor mor
 where com_nas.cod_provincia (+) = mor.cod_pro_nas
   and com_nas.cod_comune    (+) = mor.cod_Com_nas
   and com_mor.cod_provincia (+) = mor.cod_pro_mor
   and com_mor.cod_comune    (+) = mor.cod_Com_mor
   and com_res.cod_provincia (+) = mor.cod_pro_res
   and com_res.cod_comune    (+) = mor.cod_Com_res
   and mor.cod_rec               in (0,3)
   and not exists (select 'x' from civdts dts
                    where dts.id_atto = mor.id_atto)
/
comment on table civvdu is 'Stato Civile - Registro Documenti in Uscita (Visualizzazione Dati)'
/
