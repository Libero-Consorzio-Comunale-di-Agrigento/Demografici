--liquibase formatted sql
--changeset amonopoli:202504021030 runOnChange:true stripComments:false
create or replace view anaeve_VANA
AS
select eve_v.*
--
     , case
         when eve_v.cod_mov in (10,11,12,13) then
              f_flag_data_convenzionale(eve_v.matricola,eve_v.cod_mov,eve_v.data_inizio)
       end flag_data_convenzionale
--
     , case
         when eve_v.cod_mov = 11 then
              eve_v.des_cod_via||eve_v.civico_esterno||eve_v.civico_interno
         when eve_v.cod_mov = 13 then
              eve_v.via_aire||
                decode(eve_v.zipcode,'','',' - '||eve_v.zipcode)||
                decode(eve_v.des_com_aire,'','',' - '||eve_v.des_com_aire)
         when eve_v.cod_mov not in (11,13) then
              dev.descrizione||
                decode(eve_v.des_com_eve,'','',
                  decode(dce.tipo_evento,'I',decode(dce.tipo_evento_istat,'N',' a ',' da '),'C',' a ')||
                  eve_v.des_com_eve||' ('||eve_v.sigla_pro_eve||')'
                )
       end des_evento
     , case
         when eve_v.cod_mov in (1,11) then
              rtrim(rtrim('RES'||substr(f_famiglia_al_j(eve_v.matricola,eve_v.data_eve),1,7)),'RES')
         when eve_v.cod_mov in (2) then
              rtrim(rtrim('RES'||substr(f_famiglia_al_j(eve_v.matricola,eve_v.data_eve-1),1,7)),'RES')
         when eve_v.cod_mov in (3,13) then
              rtrim(rtrim('AIR'||substr(f_famiglia_aire_al_j(eve_v.matricola,eve_v.data_eve),1,7)),'AIR')
         when eve_v.cod_mov in (4) then
              rtrim(rtrim('AIR'||substr(f_famiglia_aire_al_j(eve_v.matricola,eve_v.data_eve-1),1,7)),'AIR')
       end cod_fam_unique_storico
     , eve_v.d_data_eve d_data_eve_storico
     , com_air.cod_consolato||lpad(com_air.tipo_consolato,2,'0') codice_consolato
     , dco_air.descrizione des_tipo_consolato
     , con_air.indirizzo indirizzo_consolato
     , con_air.sede sede_consolato
     , nvl(com_air.cod_territorio,com_air.cod_provincia) cod_territorio
     , tes_air.descrizione des_territorio
  from arcdco dco_air
     , arctes tes_air
     , arccon con_air
     , arccom com_air
     , anadce dce
     , anadev dev
     , anaeve_v eve_v
 where dco_air.tipo_consolato (+) = com_air.tipo_consolato
   and tes_air.cod_territorio (+) = con_air.stato
   and con_air.stato          (+) = nvl(com_air.cod_territorio,com_air.cod_provincia)
   and con_air.cod_consolato  (+) = com_air.cod_consolato
   and con_air.tipo_consolato (+) = com_air.tipo_consolato
   and com_air.cod_provincia  (+) = eve_v.cod_pro_aire
   and com_air.cod_comune     (+) = eve_v.cod_com_aire
   and dev.cod_ev                  = eve_v.cod_eve
   and dce.anagrafe          (+)   = eve_v.anagrafe
   and dce.cod_mov           (+)   = eve_v.cod_mov
   and dce.cod_eve           (+)   = eve_v.cod_eve
   and nvl(dce.cod_variazione(+),' ') = nvl(eve_v.cod_variazione,' ')
   and eve_v.cod_mov               not in (10,12)
/
comment on table anaeve_VANA is 'Anagrafe - Storico Anagrafico dell''Individuo - con filtro - per Visualizzazione (view)'
/
