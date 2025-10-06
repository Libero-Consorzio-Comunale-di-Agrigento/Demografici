--liquibase formatted sql
--changeset amonopoli:202401161720 runOnChange:true stripComments:false
BEGIN

INSERISCI_GSDLOG_DB('CIVDPA', 'UPDATE', 'Inizio valorizzazione accordo_data da aggiornante', '', '');

update civdpa dpa
   set accordo_data = (select mat.data_mat
                         from civmat mat
                        where mat.id_atto = dpa.id_atto)
 where tipo_atto    = 4
   and accordo_data is null
   and nvl(tipo_divorzio,'A') != 'A'
   and exists (select 'x' from civcta cta, civdta dta, civmat mat
                where cta.sigla   = 'AVV'
                  and cta.id      = dta.id_civcta
                  and dta.id      = mat.id_civdta
                  and mat.cod_rec  = 0                
                  and mat.data_mat is not null 
                  and mat.id_atto  = dpa.id_atto)
 ;
update civdpa dpa
   set accordo_data = (select uci.data_mat
                         from civuci uci
                        where uci.id_atto = dpa.id_atto)
 where tipo_atto    = -4
   and accordo_data is null
   and exists (select 'x' from civcta cta, civdta dta, civuci uci
                where cta.sigla   = 'AVV'
                  and cta.id      = dta.id_civcta
                  and dta.id      = uci.id_civdta
                  and uci.cod_rec  = 0
                  and uci.data_mat is not null                 
                  and uci.id_atto  = dpa.id_atto)
 ;

INSERISCI_GSDLOG_DB('CIVDPA', 'UPDATE', 'Fine valorizzazione accordo_data da aggiornante', '', '');

EXCEPTION
    WHEN others THEN
        null;

END;
/
