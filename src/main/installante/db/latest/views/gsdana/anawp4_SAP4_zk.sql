--liquibase formatted sql
--changeset amonopoli:202601230855_1 runOnChange:true stripComments:false
create or replace view anawp4_SAP4_zk
       (anagrafe, tipo_evento, anno_dic, numero_dic, des_comune_utente, sigla_pro_utente,
        richiesta, provvedimento,
        t1_I_1, t1_I_2, t1_I_3, t1_I_4, t1_I_5, t1_I_6, t1_I_7, t1_I_8, t1_I_9, t1_I_9_0, t1_I_10, t1_I_11, 
        t1_C_1, t1_C_2, t1_C_3, t1_C_4, t1_C_5, t1_C_6, t1_C_7, t1_C_8, t1_C_9, t1_C_9_0, t1_C_10, t1_C_11, 
        t2_I_1, t2_I_2, t2_I_3, t2_I_4, t2_I_5, t2_I_6, t2_I_7, 
        t2_C_1, t2_C_2, t2_C_3, t2_C_4, t2_C_5, t2_C_6, t2_C_7, t2_C_8, t2_C_9,
        t3_I_1, t3_I_2, t3_I_3, t3_I_4, t3_I_5, t3_I_6, t3_I_7, t3_I_8,  
        t3_C_1, t3_C_2, t3_C_3, t3_C_4, t3_C_5, t3_C_6, t3_C_7, t3_C_8,
        t4_1,
        c1_1, c2_1, c3_1, c3_2, c3_3, 
        ID, ID_DICHIARAZIONE, 
        anno_pratica, pratica, ID_ANATPR)
AS
select 'RES', ISCR_CANC, ANNO_DIC, NUMERO_DIC, COMUNE_UTENTE, SIGLA_PRO_UTENTE,
       RICHIESTA, PROVVEDIMENTO,
-- t1_I
       PRATICA_I t1_I_1, 
       f_espandi_stringa(DATA_PRATICA_I,1,' ') t1_I_2,
       CONTEGGIO_1_I t1_I_3, CONTEGGIO_2_I t1_I_4, 
       DES_COMUNE_I t1_I_5, 
       f_espandi_stringa(COD_COMUNE_I,1,' ') t1_I_6,
       DES_PROVINCIA_I t1_I_7, 
       f_espandi_stringa(COD_PROVINCIA_I,1,' ') t1_I_8,
       f_espandi_stringa(DATA_DECORRENZA_I,1,' ') t1_I_9,
       DATA_DECORRENZA_I t1_I_9_0,
       TIPO_RICHIESTA_1_I t1_I_10, TIPO_RICHIESTA_2_I t1_I_11, 
-- t1_C
       PRATICA_C t1_C_1, 
       f_espandi_stringa(DATA_PRATICA_C,1,' ') t1_C_2,
       CONTEGGIO_1_C t1_C_3, CONTEGGIO_2_C t1_C_4,
       DES_COMUNE_C t1_C_5, 
       f_espandi_stringa(COD_COMUNE_C,1,' ') t1_C_6,
       DES_PROVINCIA_C t1_C_7, 
       f_espandi_stringa(COD_PROVINCIA_C,1,' ') t1_C_8,
       f_espandi_stringa(DATA_DECORRENZA_C,1,' ') t1_C_9,
       DATA_DECORRENZA_C t1_C_9_0,
       TIPO_RICHIESTA_1_C t1_C_10, TIPO_RICHIESTA_2_C t1_C_11,
-- t2_I
       DES_COM_EVE_I, SIGLA_PRO_EVE_I, 
       RICHIESTA_1_I, DES_STATO_RICH_I, RICHIESTA_2_I, RICHIESTA_3_I, RICHIESTA_4_I,
       CONFERMA_1_C, DES_STATO_CONF_C, DATA_STATO_CONF_C, CONFERMA_2_C, 
       DATA_IRR_CONF_C, CONFERMA_3_C, CONFERMA_4_C, MOTIVO_CONF_C, CONFERMA_5_C,
       COMUNICO_1_I, DES_STATO_COMU_I, 
       f_espandi_stringa(COD_STATO_COMU_I,1,' '),
       COMUNICO_2_I,
       DATA_IRR_COMU_I, COMUNICO_3_I, COMUNICO_4_I, COMUNICO_4_I_MOTIVO, 
-- t2_C
       DES_STATO_COMU_C, 
       f_espandi_stringa(COD_STATO_COMU_C,1,' '),
       COMUNICO_1_C, COMUNICO_2_C, COMUNICO_3_C,
       MOTIVO_COMU_C, COMUNICO_4_C, COMUNICO_5_C,
       f_espandi_stringa(DATA_COMUNICAZIONE,1,' '),
       INDIRIZZO_I, INDIRIZZO_C, FAMIGLIA_I, CONVIVENZA_I, PRESSO_I,
       v.id,
       f_ANA_get_id_pratica('RES',iscr_canc,anno_dic,numero_dic) id_dichiarazione,
       tpr.anno_pratica, tpr.pratica, tpr.id id_anatpr
from anatpr tpr,
(
select 'I' iscr_canc, ap4.anno_dic, ap4.numero_dic, ap4.anno_pratica, ap4.pratica,
       m.descrizione comune_utente, m.sigla_provincia sigla_pro_utente,
       ap4.richiesta, ap4.provvedimento,
-- t1_I
       to_char(ap4.pratica) pratica_I,
       to_char(to_date(ap4.data_pratica,'j'),'dd/mm/yyyy') data_pratica_I,
       decode(ap4.conteggio,'1','X') conteggio_1_I,
       decode(ap4.conteggio,'2','X') conteggio_2_I,
       m.descrizione des_comune_I, 
       lpad(m.cod_comune,3,'0') cod_comune_I,
       pro_m.descrizione des_provincia_I, 
       lpad(pro_m.cod_provincia,3,'0') cod_provincia_I,
       to_char(to_date(ap4.data_decorrenza,'j'),'dd/mm/yyyy') data_decorrenza_I,
       decode(ap4.tipo_richiesta,1,'X') tipo_richiesta_1_I,
       decode(ap4.tipo_richiesta,2,'X') tipo_richiesta_2_I,
-- t1_C
       to_char(null) pratica_C,
       to_char(null) data_pratica_C,
       to_char(null) conteggio_1_C,
       to_char(null) conteggio_2_C,
       decode(ap4.cod_stato,'', a.descrizione, c.descrizione) des_comune_C,
       lpad(decode(ap4.cod_stato,'', ap4.cod_com_eve, ap4.cod_com_iscr_aire),3,'0') cod_comune_C,
       decode(ap4.cod_stato,'', pro_a.descrizione, pro_c.descrizione) des_provincia_C,
       lpad(decode(ap4.cod_stato,'', ap4.cod_pro_eve, ap4.cod_pro_iscr_aire),3,'0') cod_provincia_C,
       to_char(null) data_decorrenza_C,
       to_char(null) tipo_richiesta_1_C,
       to_char(null) tipo_richiesta_2_C,
-- t2_I
       decode(c.descrizione,'',a.descrizione,c.descrizione) des_com_eve_I,
       decode(c.descrizione,'',a.sigla_provincia,c.sigla_provincia) sigla_pro_eve_I,
       decode(ap4.richiesta,1,'X') richiesta_1_I,
       decode(ap4.richiesta,2,
         decode(ap4.cod_stato,'','',b.descrizione||' ('||b.sigla_provincia||')')) des_stato_rich_I,
       decode(ap4.richiesta,2,'X') richiesta_2_I,
       decode(ap4.richiesta,3,'X') richiesta_3_I,
       decode(ap4.richiesta,4,'X') richiesta_4_I,
-- t2_C
       to_char(null) conferma_1_C,
       to_char(null) des_stato_conf_C,
       to_char(null) data_stato_conf_C,
       to_char(null) conferma_2_C,
       to_char(null) data_irr_conf_C,
       to_char(null) conferma_3_C,
       to_char(null) conferma_4_C,
       to_char(null) motivo_conf_C,
       to_char(null) conferma_5_C,
-- t3_I
       decode(ap4.provvedimento,1,'X') comunico_1_I,
       decode(ap4.cod_stato,'','',b.descrizione||' ('||b.sigla_provincia||')') des_stato_comu_I,
       to_char(ap4.cod_stato) cod_stato_comu_I,
       decode(ap4.provvedimento,2,'X') comunico_2_I,
       to_char(to_date(data_irreperibilita,'j'),'dd/mm/yyyy') data_irr_comu_I,
       decode(ap4.provvedimento,3,'X') comunico_3_I,
       decode(ap4.provvedimento,4,'X') comunico_4_I,
       decode(ap4.provvedimento,4,ap4.motivo) comunico_4_I_motivo,
-- t3_C
       to_char(null) des_stato_comu_C,
       to_char(null) cod_stato_comu_C,
       to_char(null) comunico_1_C,
       to_char(null) comunico_2_C,
       to_char(null) comunico_3_C,
       to_char(null) motivo_comu_C,
       to_char(null) comunico_4_C,
       to_char(null) comunico_5_C,
-- t4
       nvl(to_char(to_date(data_definizione,'j'),'dd/mm/yyyy'),' ') data_comunicazione,           
-- c1              
       vie.denom_uff||civico_esterno||civico_interno indirizzo_I,
-- c2              
       to_char(null) indirizzo_C,
-- c3
       decode(ap4.famiglia_convivenza,'F','X') famiglia_I,
       decode(ap4.famiglia_convivenza,'C','X') convivenza_I,
       translate(nvl(nvl(ap4.convivenza,presso),' '),'/',' ') presso_I,
       'AP4'||lpad(ap4.id,10,'0') id
  from arcpro pro_m, arcpro pro_a, arcpro pro_c,
       arccom m, arccom a, arccom b, arccom c, arcvie vie,
       anaap4 ap4
 where pro_m.cod_provincia   = m.cod_provincia
   and (m.cod_provincia, m.cod_comune) = (select pro_cliente, com_cliente from menuditta)
   and pro_a.cod_provincia (+)  = a.cod_provincia
   and a.cod_provincia (+)   = cod_pro_eve
   and a.cod_comune    (+)   = cod_com_eve
   and b.cod_provincia (+)   = cod_stato
   and b.cod_comune    (+)   = 0
   and pro_c.cod_provincia (+)   = c.cod_provincia
   and c.cod_provincia (+)   = cod_pro_iscr_aire
   and c.cod_comune    (+)   = cod_com_iscr_aire
   and vie.cod_via           = ap4.cod_via
   and ap4.stato_pratica     is null
UNION
select 'C', cp4.anno_dic, cp4.numero_dic, cp4.anno_pratica, cp4.pratica,
       m.descrizione comune_utente, m.sigla_provincia sigla_pro_utente,
       cp4.richiesta, cp4.provvedimento,
-- t1_I
       to_char(null) pratica_I,
       to_char(null) data_pratica_I,
       decode(cp4.richiesta,1,decode(cp4.conteggio,'1','X')) conteggio_1_I,
       decode(cp4.richiesta,1,decode(cp4.conteggio,'2','X')) conteggio_2_I,
       decode(cp4.provvedimento, 5, a.descrizione,
         decode(cp4.richiesta, 1, a.descrizione, 3, a.descrizione, 5, a.descrizione)) des_comune_I,
       decode(cp4.provvedimento, 5, lpad(cp4.cod_com_eve,3,'0'),
         decode(cp4.richiesta, 1, lpad(cp4.cod_com_eve,3,'0'), 3, lpad(cp4.cod_com_eve,3,'0'), 5, lpad(cp4.cod_com_eve,3,'0'))) cod_comune_I,
       decode(cp4.provvedimento, 5, pro_a.descrizione,
         decode(cp4.richiesta, 1, pro_a.descrizione, 3, pro_a.descrizione, 5, pro_a.descrizione)) des_provincia_I,
       decode(cp4.provvedimento, 5, lpad(cp4.cod_pro_eve,3,'0'),
         decode(cp4.richiesta, 1, lpad(cp4.cod_pro_eve,3,'0'), 3, lpad(cp4.cod_pro_eve,3,'0'), 5, lpad(cp4.cod_pro_eve,3,'0'))) cod_provincia_I,
       decode(cp4.richiesta, 
         1, to_char(to_date(cp4.data_decorrenza,'j'),'dd/mm/yyyy'),
         5, to_char(to_date(cp4.data_decorrenza,'j'),'dd/mm/yyyy')) data_decorrenza_I,
       to_char(null) tipo_richiesta_1_I,
       to_char(null) tipo_richiesta_2_I,
-- t1_C
       to_char(cp4.pratica) pratica_C,
       to_char(to_date(cp4.data_pratica,'j'),'dd/mm/yyyy') data_pratica_C,
       decode(cp4.conteggio,'1','X') conteggio_1_C,
       decode(cp4.conteggio,'2','X') conteggio_2_C,
       m.descrizione des_comune_C, 
       lpad(m.cod_comune,3,'0') cod_comune_C,
       pro_m.descrizione des_provincia_C, 
       lpad(pro_m.cod_provincia,3,'0') cod_provincia_C,
       to_char(to_date(cp4.data_decorrenza,'j'),'dd/mm/yyyy') data_decorrenza_C,
       decode(cp4.tipo_richiesta,1,'X') tipo_richiesta_1_C,
       decode(cp4.tipo_richiesta,2,'X') tipo_richiesta_2_C,
-- t2_I
       decode(cp4.richiesta,1,m.descrizione,3,m.descrizione) des_com_eve_I,
       decode(cp4.richiesta,1,m.sigla_provincia,3,m.sigla_provincia) sigla_pro_eve_I,
       decode(cp4.richiesta,1,'X',3,'X') richiesta_1_I,
       to_char(null) des_stato_I,
       to_char(null) richiesta_2_I,
       to_char(null) richiesta_3_I,
       to_char(null) richiesta_4_I,
-- t2_C
       decode(cp4.provvedimento,5,to_char(null),decode(cp4.richiesta,1,'X')) conferma_1_C,
       decode(cp4.richiesta,2,
         decode(cp4.cod_stato,'','',b.descrizione||' ('||b.sigla_provincia||')')) des_stato_C,
       decode(cp4.richiesta,2,
         to_char(to_date(cp4.data_decorrenza,'j'),'dd/mm/yyyy')) cod_stato_C,
       decode(cp4.richiesta,2,'X') conferma_2_C,
       decode(cp4.richiesta,3,
         to_char(to_date(cp4.data_decorrenza,'j'),'dd/mm/yyyy')) data_irreperibilita_C,
       decode(cp4.richiesta,3,'X') conferma_3_C,
       decode(cp4.richiesta,4,'X') conferma_4_C,
       decode(cp4.richiesta,4,cp4.motivo) motivo_C,
       decode(cp4.richiesta,5,'X') conferma_5_C,
-- t3_I
       to_char(null) comunico_1_I,
       to_char(null) des_stato_I,
       to_char(null) cod_stato_I,
       to_char(null) comunico_2_I,
       to_char(null) data_irreperibilita_I,
       to_char(null) comunico_3_I,
       to_char(null) comunico_4_I,
       to_char(null) comunico_4_I_motivo,
-- t3_C
       decode(cp4.cod_stato,'','',b.descrizione||' ('||b.sigla_provincia||')') des_stato_C,
       to_char(cp4.cod_stato) cod_stato_C,
       decode(cp4.provvedimento,1,'X') comunico_1_C,
       decode(cp4.provvedimento,2,'X') comunico_2_C,
       decode(cp4.provvedimento,3,'X') comunico_3_C,
       decode(cp4.provvedimento,4,cp4.motivo) motivo_C,
       decode(cp4.provvedimento,4,'X') comunico_4_C,
       decode(cp4.provvedimento,5,'X') comunico_5_C,
-- t4
       decode(cp4.provvedimento,5,
         nvl(to_char(to_date(data_ripristino,'j'),'dd/mm/yyyy'),' '),
         nvl(to_char(to_date(data_definizione,'j'),'dd/mm/yyyy'),' ')) data_comunicazione,           
-- c1              
       decode(cp4.provvedimento,'',cp4.indirizzo_emi)  indirizzo_I,
-- c2              
       decode(cp4.provvedimento,'',to_char(null),5,to_char(null),cp4.indirizzo_emi) indirizzo_C,
-- c3
       to_char(null) famiglia,
       to_char(null) convivenza,
       to_char(null) presso,
       'CP4'||lpad(rownum,10,'0') id
  from arcpro pro_m, arcpro pro_a, 
       arccom m, arccom a, arccom b,
       anacp4 cp4
 where pro_m.cod_provincia   = m.cod_provincia
   and (m.cod_provincia, m.cod_comune) = (select pro_cliente, com_cliente from menuditta)
   and pro_a.cod_provincia (+)  = a.cod_provincia
   and a.cod_provincia (+)   = cod_pro_eve
   and a.cod_comune    (+)   = cod_com_eve
   and b.cod_provincia (+)   = cod_stato
   and b.cod_comune    (+)   = 0
   and nvl(cp4.stato_pratica,' ') != 'A'
) v
 where tpr.anno_pratica = v.anno_pratica
   and tpr.pratica      = v.pratica
   and tpr.tipo_evento  = v.iscr_canc
   and tpr.anagrafe     = 'RES'
/
comment on table anawp4_SAP4_zk is 'Anagrafe - Dati Modello APR/4 (testata) per Stampa - ZK (view)'
/
