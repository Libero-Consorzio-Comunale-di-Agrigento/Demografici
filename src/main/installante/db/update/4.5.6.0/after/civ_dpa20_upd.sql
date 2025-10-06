--liquibase formatted sql
--changeset amonopoli:202303311240 runOnChange:true stripComments:false
update civdpa dpa
   set ENTE_STRANIERO             = autorita_atto_orig,
       D_ENTE_STRANIERO_DATA_ATTO = d_data_atto_orig
 where tipo_atto = 2
   and exists (select 1
                 from civcta cta, civdta dta, civnas nas
                where cta.sigla   in ('TEA','TEP')
                  and cta.id      = dta.id_civcta
                  and dta.id      = nas.id_civdta
                  and nas.id_atto = dpa.id_atto)
   and autorita_atto_orig||d_data_atto_orig       is not null
   and ente_straniero||d_ente_straniero_data_atto is null
/
update civdpa dpa
   set ENTE_STRANIERO             = autorita_atto_orig,
       D_ENTE_STRANIERO_DATA_ATTO = d_data_atto_orig
 where tipo_atto = 4
   and exists (select 1
                 from civcta cta, civdta dta, civmat mat
                where cta.sigla   in ('TEA','TEP')
                  and cta.id      = dta.id_civcta
                  and dta.id      = mat.id_civdta
                  and mat.id_atto = dpa.id_atto)
   and autorita_atto_orig||d_data_atto_orig       is not null
   and ente_straniero||d_ente_straniero_data_atto is null
/
update civdpa dpa
   set ENTE_STRANIERO             = autorita_atto_orig,
       D_ENTE_STRANIERO_DATA_ATTO = d_data_atto_orig
 where tipo_atto = -4
   and exists (select 1
                 from civcta cta, civdta dta, civuci uci
                where cta.sigla   in ('TEA','TEP')
                  and cta.id      = dta.id_civcta
                  and dta.id      = uci.id_civdta
                  and uci.id_atto = dpa.id_atto)
   and autorita_atto_orig||d_data_atto_orig       is not null
   and ente_straniero||d_ente_straniero_data_atto is null
/
update civdpa dpa
   set ENTE_STRANIERO             = autorita_atto_orig,
       D_ENTE_STRANIERO_DATA_ATTO = d_data_atto_orig
 where tipo_atto = 5
   and exists (select 1
                 from civcta cta, civdta dta, civmor mor
                where cta.sigla   in ('TEA','TEP')
                  and cta.id      = dta.id_civcta
                  and dta.id      = mor.id_civdta
                  and mor.id_atto = dpa.id_atto)
   and autorita_atto_orig||d_data_atto_orig       is not null
   and ente_straniero||d_ente_straniero_data_atto is null
/
