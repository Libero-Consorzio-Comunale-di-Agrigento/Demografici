--liquibase formatted sql
--changeset amonopoli:202602031425_2 runOnChange:true stripComments:false
create or replace view cersce_v_pagamenti
AS
select v.d_data, v.cod_diritto, v.des_diritto,
       nvl(sum(v.VALORE),0) totale,
       nvl(sum(decode(tipo_pag,1,v.valore,0)),0) totale_1,
       nvl(sum(decode(tipo_pag,2,v.valore,0)),0) totale_2,
       nvl(sum(decode(tipo_pag,3,v.valore,0)),0) totale_3,
       nvl(sum(decode(tipo_pag,4,v.valore,0)),0) totale_4,
       nvl(sum(decode(tipo_pag,5,v.valore,0)),0) totale_5,
       nvl(sum(decode(tipo_pag,8,v.valore,0)),0) totale_8,
       nvl(sum(decode(tipo_pag,9,v.valore,0)),0) totale_9,
       min(v.id) id
  from (select d_data, to_number(cod_segreteria) cod_diritto, des_segreteria des_diritto, nvl(to_number(tipo_pagamento),1) tipo_pag, nvl(sum(sum_segreteria),0) valore, min(id) id
          from cersce_v sce
         where cod_segreteria is not null
         group by d_data, cod_segreteria, des_segreteria, tipo_pagamento
        UNION ALL
        select d_data, to_number(cod_stato_civile) cod_diritto, des_stato_civile des_diritto, nvl(to_number(tipo_pagamento),1) tipo_pag, nvl(sum(sum_stato_civile),0) valore, min(id) id
          from cersce_v
         where cod_stato_civile is not null
         group by d_data, cod_stato_civile, des_stato_civile, tipo_pagamento
        UNION ALL
        select d_data, to_number(cod_carta_identita) cod_diritto, des_carta_identita des_diritto, nvl(to_number(tipo_pagamento),1) tipo_pag, nvl(sum(sum_carta_identita),0) valore, min(id) id
          from cersce_v
         where cod_carta_identita is not null
         group by d_data, cod_carta_identita, des_carta_identita, tipo_pagamento
        UNION ALL
        select d_data, to_number(cod_rimborso_st) cod_diritto, des_rimborso_st des_diritto, nvl(to_number(tipo_pagamento),1) tipo_pag, nvl(sum(sum_rimborso_st),0) valore, min(id) id
          from cersce_v
         where cod_rimborso_st is not null
         group by d_data, cod_rimborso_st, des_rimborso_st, tipo_pagamento
        UNION ALL
        select d_data, to_number(cod_diversi_1) cod_diritto, des_diversi_1 des_diritto, nvl(to_number(tipo_pagamento),1) tipo_pag, nvl(sum(sum_diversi_1),0) valore, min(id) id
          from cersce_v
         where sum_diversi_1 > 0
         group by d_data, cod_diversi_1, des_diversi_1, tipo_pagamento
        UNION ALL
        select d_data, to_number(cod_diversi_2) cod_diritto, des_diversi_2 des_diritto, nvl(to_number(tipo_pagamento),1) tipo_pag, nvl(sum(sum_diversi_2),0) valore, min(id) id
          from cersce_v
         where sum_diversi_2 > 0
         group by d_data, cod_diversi_2, des_diversi_2, tipo_pagamento
        UNION ALL
        select d_data, to_number(cod_bollo) cod_diritto, des_bollo des_diritto, nvl(to_number(tipo_pagamento),1) tipo_pag, nvl(sum(sum_bollo),0) valore, min(id) id
          from cersce_v
         where cod_bollo is not null
         group by d_data, cod_bollo, des_bollo, tipo_pagamento
        ) v
group by v.d_data, v.cod_diritto, v.des_diritto
order by 1, 2, 3
/
comment on table cersce_v_pagamenti is 'Certificazione - Statistica Certificati Emessi con Tipi Pagamento (view)'
/
