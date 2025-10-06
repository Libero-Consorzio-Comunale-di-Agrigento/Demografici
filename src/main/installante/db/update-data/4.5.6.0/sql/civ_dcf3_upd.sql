--liquibase formatted sql
--changeset amonopoli:202303060955_4_2 runOnChange:true stripComments:false
update civdcf dcf
   set id_civddo = (select id from civddo ddo, civdfa dfa
                     where ddo.cod_do           = 'EA'
                       and ddo.tipo_atto        = dfa.tipo_atto
                       and dfa.formula          = dcf.formula
                       and dfa.tipo_annotazione in ('M','C'))
 where id_civddo is null
   and exists (select 1 from civddo ddo, civdfa dfa
                where ddo.cod_do           = 'EA'
                  and ddo.tipo_atto        = dfa.tipo_atto
                  and dfa.formula          = dcf.formula
                  and dfa.tipo_annotazione in ('M','C'))
/
update civdcf dcf
   set id_civddo_rif = (select distinct id 
                          from civddo ddo, civcta_v_formule_ann v
                         where ddo.cod_do           = 'RA'
                           and ddo.tipo_atto        = v.tipo_atto
                           and v.formula            = dcf.formula)
 where id_civddo_rif is null
   and exists (select 1 
                 from civddo ddo, civcta_v_formule_ann v
                where ddo.cod_do           = 'RA'
                  and ddo.tipo_atto        = v.tipo_atto
                  and v.formula            = dcf.formula)
/
