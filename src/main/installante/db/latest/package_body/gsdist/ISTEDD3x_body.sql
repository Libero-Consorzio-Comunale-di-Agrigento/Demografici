--liquibase formatted sql
--changeset amonopoli:202503211221_2 runOnChange:true stripComments:false
CREATE OR REPLACE package body ISTEDD3X is
PROCEDURE MAIN   (prenotazione  IN number,
                  PASSO          IN number) is
p_prenotazione number;
p_passo        number;
P_pagina 	   number :=1;
P_riga   	   number :=0;
cursor sel_dati is
select 'JJ+;D3IN+'||-- n1_n2,
       nvl(to_char(to_date(mat.data_mat,'j'),'mm'),'00')||'+'||-- n3,
       nvl(to_char(to_date(mat.data_mat,'j'),'yyyy'),'00')||'+'||-- n4,
--       nvl(to_char(md3.anno_mat),to_char(sysdate,'yyyy'))||'+'||-- n4,   
       md3.atto_mat||'+'||-- n5, 
       md3.parte_mat||'+'||-- n6, 
       decode(md3.serie_mat,'A','1','C','2','')||'+'||-- n7, 
       to_char(to_date(mat.data_mat,'j'),'ddmmyyyy')||'+'||-- n8,
       decode(to_char(md3.parte_mat)||md3.serie_mat,'2A','1','2')||'+'||-- n9,
       -- sposo 
       decode(lpad(nvl(mat.cod_pro_res_m,0),3,'0')||lpad(nvl(mat.cod_com_res_m,0),3,'0'),
              lpad(nvl(mat.cod_pro_mat,0),3,'0')||lpad(nvl(mat.cod_com_mat,0),3,'0'),
              '1+',
              decode(sign(nvl(mat.cod_pro_res_m,0)-199),
                     -1,'2+'||lpad(nvl(mat.cod_pro_res_m,0),3,'0')||lpad(nvl(mat.cod_com_res_m,0),3,'0'),
                     '3+'||nvl(mat.cod_pro_res_m,0)))||'+'||-- n10_n11,
       decode(lpad(nvl(mat.cod_pro_nas_m,0),3,'0'),
              lpad(nvl(mat.cod_pro_mat,0),3,'0'),
              '1+',
              decode(sign(nvl(mat.cod_pro_nas_m,0)-199),
                     -1,'2+'||lpad(mat.cod_pro_nas_m,3,'0'),
                     '3+'||lpad(mat.cod_pro_nas_m,3,'0')))||'+'||-- n12_N13,
       to_char(to_date(mat.data_nas_m,'j'),'ddmmyyyy')||'+'||-- n14, 
       decode(md3.stato_civile_m,'CE','1','VE','2','VU','2','GC','3','CN','3','DV','3','UC','3','GU','3')||'+'||-- n15,
       decode(md3.stato_civile_m,'CE','',to_char(to_date(md3.data_fine_mat_m,'j'),'ddmmyyyy'))||'+'||-- n16, 
       to_char(md3.grado_istruzione_m)||'+'||-- n17,
       to_char(md3.condizione_prof_m)||'+'||-- n18, 
       decode(md3.condizione_prof_m,1,to_char(md3.posizione_prof_m),'')||'+'||-- n19, 
       decode(md3.condizione_prof_m,1,to_char(md3.attivita_prof_m),'')||'+'||-- n20, 
       decode(nazionalita_ita_m,1,'1+',2,'2+','3+'||to_char(nvl(dci_m.ist_ci,0)))||'+'||-- n21_n22,
       mat.cod_fiscale_m||'+'||-- n23,
       decode(lpad(nvl(md3.cod_pro_res_post_m,0),3,'0')||lpad(nvl(md3.cod_com_res_post_m,0),3,'0'),
              lpad(nvl(mat.cod_pro_res_m,0),3,'0')||lpad(nvl(mat.cod_com_res_m,0),3,'0'),
              '1+',
              lpad(nvl(mat.cod_pro_res_f,0),3,'0')||lpad(nvl(mat.cod_com_res_f,0),3,'0'),
              '2+',
              decode(sign(nvl(md3.cod_pro_res_post_m,0)-199),
                     -1,'3+'||lpad(nvl(md3.cod_pro_res_post_m,0),3,'0')||lpad(nvl(md3.cod_com_res_post_m,0),3,'0'),
                    '4+'||nvl(md3.cod_pro_res_post_m,0)))||'+'||-- n24_n25,
       -- sposa 
       decode(lpad(nvl(mat.cod_pro_res_f,0),3,'0')||lpad(nvl(mat.cod_com_res_f,0),3,'0'),
              lpad(nvl(mat.cod_pro_mat,0),3,'0')||lpad(nvl(mat.cod_com_mat,0),3,'0'),
              '1+',
              decode(sign(nvl(mat.cod_pro_res_f,0)-199),
                     -1,'2+'||lpad(nvl(mat.cod_pro_res_f,0),3,'0')||lpad(nvl(mat.cod_com_res_f,0),3,'0'),
                     '3+'||nvl(mat.cod_pro_res_f,0)))||'+'||-- n26_n27,
       decode(lpad(nvl(mat.cod_pro_nas_f,0),3,'0'),
              lpad(nvl(mat.cod_pro_mat,0),3,'0'),
              '1+',
              decode(sign(nvl(mat.cod_pro_nas_f,0)-199),
                     -1,'2+'||lpad(mat.cod_pro_nas_f,3,'0'),
                     '3+'||lpad(mat.cod_pro_nas_f,3,'0')))||'+'||-- n28_N29,
       to_char(to_date(mat.data_nas_f,'j'),'ddmmyyyy')||'+'||-- n30, 
       decode(md3.stato_civile_f,'NU','1','VE','2','VU','2','GC','3','CN','3','DV','3','UC','3','GU','3')||'+'||-- n31,
       decode(md3.stato_civile_f,'NU','',to_char(to_date(md3.data_fine_mat_f,'j'),'ddmmyyyy'))||'+'||-- n32, 
       to_char(md3.grado_istruzione_f)||'+'||-- n33,
       to_char(md3.condizione_prof_f)||'+'||-- n34, 
       decode(md3.condizione_prof_f,1,to_char(md3.posizione_prof_f),'')||'+'||-- n35, 
       decode(md3.condizione_prof_f,1,to_char(md3.attivita_prof_f),'')||'+'||-- n36, 
       decode(nazionalita_ita_f,1,'1+',2,'2+','3+'||to_char(nvl(dci_f.ist_ci,0)))||'+'||-- n37_n38,
       mat.cod_fiscale_f||'+'||-- n39,
       decode(lpad(nvl(md3.cod_pro_res_post_f,0),3,'0')||lpad(nvl(md3.cod_com_res_post_f,0),3,'0'),
              lpad(nvl(mat.cod_pro_res_f,0),3,'0')||lpad(nvl(mat.cod_com_res_f,0),3,'0'),
              '1+',
              lpad(nvl(mat.cod_pro_res_m,0),3,'0')||lpad(nvl(mat.cod_com_res_m,0),3,'0'),
              '2+',
              decode(sign(nvl(md3.cod_pro_res_post_f,0)-199),
                     -1,'3+'||lpad(nvl(md3.cod_pro_res_post_f,0),3,'0')||lpad(nvl(md3.cod_com_res_post_f,0),3,'0'),
                    '4+'||nvl(md3.cod_pro_res_post_f,0)))||'+'||-- n40_n41,
       decode(mat.convenzioni,'SI','2','1')||';' RIGA
  from anadci dci_m,anadci dci_f,istmd3 md3,civmat mat, tabrep
 where dci_m.cod_ci  (+) = mat.nazionalita_m 
   and dci_f.cod_ci  (+) = mat.nazionalita_f 
   and nvl(md3.serie_mat,' ') = nvl(mat.serie,' ') 
   and md3.parte_mat      = mat.parte 
   and md3.atto_mat       = mat.atto 
   and md3.anno_mat       = mat.anno 
   and md3.ufficio_mat    = mat.ufficio 
   and md3.flag_completo is not null
   and mat.cod_rec	 in (0,3)
   and mat.data_REG between substr(parametri,1,7) and substr(parametri,8,7) 
   and mat.data_MAT between substr(parametri,15,7) and substr(parametri,22,7) 
   and chiave = 'EDD3' 
   and terminale = nvl(userenv('terminal'),'ISTEDD3X')
;
BEGIN
p_prenotazione := prenotazione;
p_passo        := passo;
declare 
codice_istat varchar2(10);
begin
  begin
   select lpad(pro_cliente,3,'0')||lpad(com_cliente,3,'0')
     into codice_istat
     from menuditta;
  exception
    when others then
      codice_istat := '';
  end;

begin
  update a_selezioni
     set valore_default = 'istatel\'||codice_istat||'_D3_'||to_char(sysdate,'yymmdd')||'.txt'
   where parametro 	= 'TXTFILE'
     and voce_menu	= 'ISTEDD3'
  ;
end;
commit;
end;
for dati in sel_dati loop
  begin
           P_riga   := P_riga   + 1;
           insert into a_appoggio_stampe
           values ( p_prenotazione
                  , p_passo
                  , P_pagina
                  , P_riga
                  , dati.riga
                  )
           ;
	end;
end loop;
commit;
END MAIN;
FUNCTION VERSIONE  RETURN varchar2 IS
/******************************************************************************
 NOME:        VERSIONE
 DESCRIZIONE: Restituisce la versione e la data di distribuzione del package.
 PARAMETRI:   --
 RITORNA:     stringa varchar2 contenente versione e data.
 NOTE:        Il secondo numero della versione corrisponde alla revisione
              del package.
******************************************************************************/
BEGIN
--
-- 'V1.0 del 29/07/2003'  AM  Prima emissione
-- 'V2.0 del 15/10/2013'  AM  Adeguamenti 2013
-- 'V2.1 del 21/12/2016'  AM  Adeguamenti 2016 - Unioni Civili
--
   RETURN 'V2.1 del 21/12/2016';
END VERSIONE;
END ISTEDD3X;
/
