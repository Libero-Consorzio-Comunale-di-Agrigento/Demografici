--liquibase formatted sql
--changeset amonopoli:202405271420_2 runOnChange:true stripComments:false
create or replace view isted4b_v
       (data_reg, data_mor, d_data_reg, d_data_mor, riga)
AS
select mor.data_reg, 
       nvl(mor.data_mor,mor.data_reg),
       mor.d_data_reg, 
       nvl(mor.d_data_mor,mor.d_data_reg),
       'JJ+;'||
       decode(mor.sesso,'M','D4BI+','D5BI+')||-- n1_n2,
       to_char(to_date(mor.data_mor,'j'),'mm')||'+'||-- n3,
       to_char(to_date(mor.data_mor,'j'),'yyyy')||'+'||-- n4,
       m4b.atto||'+'||-- n5,
       m4b.parte||'+'||-- n6,
       decode(m4b.parte,2,decode(m4b.serie,'B','1','C','2',''),'')||'+'||-- n7,
       '00'||'+'||-- n8,
       decode(mor.sesso,'M','1','2')||'+'||-- n9,
       mor.ore ||'+'||--n10, 
       to_char(to_date(mor.data_mor,'j'),'ddmmyyyy')||'+'||-- n11,
       null||'+'||-- n12, 
       to_char(to_date(mor.data_nas,'j'),'ddmmyyyy')||'+'||-- n13, 
       decode(lpad(nvl(mor.cod_com_nas,0),3,'0')||lpad(nvl(mor.cod_pro_nas,0),3,'0'), 
              lpad(nvl(mor.cod_com_mor,0),3,'0')||lpad(nvl(mor.cod_pro_mor,0),3,'0'), 
              '1+', 
              decode(sign(nvl(mor.cod_pro_nas,0)-199),
                     -1,'2+'||lpad(mor.cod_pro_nas,3,'0')||lpad(mor.cod_com_nas,3,'0'), 
                      '3+'||lpad(mor.cod_pro_nas,3,'0')))||'+'||-- n14_n15, 
       m4b.indicazione_eta||'+'||-- n16,
       '0'||m4b.eta_compiuta||'+'||-- n17, 
       genere_parto||'+'||-- n18, 
       null||'+'||-- n19, 
       null||'+'||-- n20, 
       null||'+'||-- n21, 
       null||'+'||-- n22, 
       null||'+'||-- n23, 
       null||'+'||-- n24, 
       null||'+'||-- n25, 
       null||'+'||-- n26, 
       null||'+'||-- n27, 
       null||'+'||-- n28, 
       null||'+'||-- n29, 
       to_char(to_date(m4b.data_nas_mat,'j'),'ddmmyyyy')||'+'||-- n30, 
       null||'+'||-- n31, 
       null||'+'||-- n32, 
       null||'+'||-- n33, 
       decode(lpad(nvl(m4b.cod_com_res_mat,0),3,'0')||lpad(nvl(m4b.cod_pro_res_mat,0),3,'0'), 
              lpad(nvl(mor.cod_com_mor,0),3,'0')||lpad(nvl(mor.cod_pro_mor,0),3,'0'),
              '1+', 
              '000000','9+', 
              decode(sign(nvl(mor.cod_pro_nas,0)-199), 
                     -1,'9+', 
                      '3+'||lpad(nvl(mor.cod_pro_nas,0),3,'0')))||'+'||-- n34_n35, 
       m4b.grado_istruzione_pat||'+'||-- n36, 
       m4b.grado_istruzione_mat||'+'||-- n37, 
       m4b.condizione_prof_pat||'+'||-- n38, 
       m4b.condizione_prof_mat||'+'||-- n39, 
       m4b.posizione_prof_pat||'+'||-- n40, 
       m4b.posizione_prof_mat||'+'||-- n41, 
       m4b.attivita_prof_pat||'+'||-- n42, 
       m4b.attivita_prof_mat||'+'||-- n43, 
       nvl(m4b.nazionalita_ita_pat,9)||'+'||-- n44,
       decode(nvl(m4b.nazionalita_ita_pat,9),1,'000', 
              2,'000', 
              3,lpad(to_char(dci_p.ist_ci),3,'0'), 
              9,'888')||'+'||-- n45,  
       nvl(m4b.nazionalita_ita_mat,9)||'+'||-- n46, 
       decode(nvl(m4b.nazionalita_ita_mat,9),1,'000', 
              2,'000', 
              3,lpad(to_char(dci_m.ist_ci),3,'0'), 
              9,'888')||'+'||-- n47, 
       upper(m4b.cod_fiscale_pat)||'+'||-- n48, 
       upper(m4b.cod_fiscale_mat)||'+'||-- n49, 
       upper(mor.cod_fiscale)||';' riga 
  from anadci dci_p,anadci dci_m,civmor mor, istm4b m4b
 where dci_p.cod_ci  (+) = m4b.nazionalita_pat 
   and dci_m.cod_ci  (+) = m4b.nazionalita_mat 
   and nvl(m4b.serie,' ') = nvl(mor.serie,' ') 
   and m4b.parte      = mor.parte 
   and m4b.atto       = mor.atto 
   and m4b.anno       = mor.anno 
   and m4b.ufficio    = mor.ufficio 
   and m4b.flag_completo is not null 
   and mor.cod_rec	in (0,3)
/
comment on table isted4b_v is 'ISTAT - Modello D.4 BIS - Dati'
/

