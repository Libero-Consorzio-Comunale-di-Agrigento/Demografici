--liquibase formatted sql
--changeset amonopoli:202503051355 runOnChange:true stripComments:false
create or replace function f_get_campo_FAM
(a_cod_fam_unique  IN varchar2
,a_campo  IN varchar2
)

return varchar2

IS

w_campo  varchar2(255) := upper(a_campo);
w_valore varchar2(255);

begin
  begin
    select decode(w_campo,
             'DES_COD_VIA', vie.denom_uff,
             'INDIRIZZO_COMPLETO', vie.denom_uff||fam.civico_esterno,
             'INDIRIZZO_COMPLETO_INT', vie.denom_uff||fam.civico_esterno||fam.civico_interno,
             'CAP', f_cap(fam.cod_via,fam.num_civ,fam.suffisso),
             'VIA_AIRE', fam.via_aire,
             'COD_PRO_AIRE', fam.cod_pro_aire,
             'COD_COM_AIRE', fam.cod_com_aire,
             'DES_COM_AIRE', f_comune_al(fam.cod_pro_aire,fam.cod_com_aire,''),
             'SIGLA_PRO_AIRE', f_provincia_stato_al(fam.cod_pro_aire,fam.cod_com_aire,'','S','',''),
             'ZIPCODE', fam.zipcode,
             'PROVINCIA_CONTEA', fam.provincia_contea,
             'PRESSO', fam.presso,
             'CODICE_CONSOLATO', com_air.cod_consolato||lpad(com_air.tipo_consolato,2,'0'),
             'INDIRIZZO_CONSOLATO', con_air.indirizzo,
             'SEDE_CONSOLATO', con_air.sede,
             'COD_TERRITORIO', nvl(com_air.cod_territorio,com_air.cod_provincia),
             'DES_TERRITORIO', tes_air.descrizione,
             'VIA_RES', fam.via_res,
             'COD_PRO_RES', fam.cod_pro_res,
             'COD_COM_RES', fam.cod_com_res,
             'DES_COM_RES', f_comune_al(fam.cod_pro_res,fam.cod_com_res,''),
             'SIGLA_PRO_RES', f_provincia_stato_al(fam.cod_pro_res,fam.cod_com_res,'','S','',''),
             'FLAG_SENZA_FISSA_DIMORA', f_senza_fissa_dimora(fam.cod_via,fam.num_civ,fam.suffisso,fam.interno),
             'FLAG_NUCLEO_COABITANTE', f_nucleo_coabitante_NCO(fam.fascia,fam.cod_fam)
           )
      into w_valore
      from arcvie vie,
           arctes tes_air,
           arccon con_air,
           arccom com_air,
           anafam fam
     where vie.cod_via            (+) = fam.cod_via
       and tes_air.cod_territorio (+) = con_air.stato
       and con_air.stato          (+) = nvl(com_air.cod_territorio,com_air.cod_provincia)
       and con_air.cod_consolato  (+) = com_air.cod_consolato
       and con_air.tipo_consolato (+) = com_air.tipo_consolato
       and com_air.cod_provincia  (+) = fam.cod_pro_aire
       and com_air.cod_comune     (+) = fam.cod_com_aire
       and fam.cod_fam_unique       = a_cod_fam_unique
    ;
  exception
    when others then
         w_valore := '';
  end;

  return w_valore;

end;
/
