--liquibase formatted sql
--changeset snocca:202212051128
ALTER TABLE CIVCOM DISABLE ALL TRIGGERS
/
update civcom c
   set id = (select p.id
               from civcom_prot p
              where p.tipo_atto        = c.TIPO_ATTO
                and p.ufficio          = c.UFFICIO
                and p.anno             = c.ANNO
                and p.atto             = c.ATTO
                and nvl(p.parte,0)     = nvl(c.PARTE,0)
                and nvl(p.serie,' ')   = nvl(c.SERIE,' ')
                and nvl(p.formula,' ') = nvl(c.FORMULA,' ')
                and nvl(p.data_reg,0)  = nvl(c.DATA_REG,0)
                and nvl(p.VERSIONE,0)  = nvl(c.versione,0)
                and c.codice_co        = p.CODICE_CO
                and nvl(c.sequenza,0)  = nvl(p.SEQUENZA,0)
                and rownum = 1)
 where id is null
/
update civcom
   set id = CIVCOM_SQ.nextval
 where id is null
/
update civcom
   set d_data_reg = to_date(data_reg,'j')
 where d_data_reg is null
   and data_reg is not null
/
update civcom
   set id_atto = f_CIV_get_id_atto(tipo_atto,ufficio,anno,parte,serie,atto)
 where id_atto is null
/
update civcom
   set stampa_eseguita = 'NO'
 where stampa_eseguita is null
/
ALTER TABLE CIVCOM ENABLE ALL TRIGGERS
/
