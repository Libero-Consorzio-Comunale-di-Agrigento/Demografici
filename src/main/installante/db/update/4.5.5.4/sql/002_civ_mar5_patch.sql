--liquibase formatted sql
--changeset amonopoli:202301271615 runOnChange:true
update civmar mar
   set DOCUMENTI_PRESENTATI_MAT = 'ALT'
 where tipo_atto = 4
   and documenti_presentati_mat is null
   and exists (select 'x' from civmat_v v
                where v.cod_rec       = 0
                  and v.flag_divorzio is null
                  and v.id_atto       = mar.id_atto)
/
