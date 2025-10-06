--liquibase formatted sql
--changeset amonopoli:202503211217_2 runOnChange:true stripComments:false
CREATE OR REPLACE package body ISTED7AX is
PROCEDURE MAIN   (prenotazione  IN number,
                  PASSO          IN number) is
p_prenotazione number;
p_passo        number;
P_pagina 	   number :=1;
P_riga   	   number :=0;
cursor sel_dati is
select substr(f_regione(nvl(a.cod_provincia,0)),1,2)||-- a1_2,
       to_char(to_date(substr(parametri,1,7),'j'),'yyyy')||-- a3_6,
       to_char(to_date(substr(parametri,1,7),'j'),'mm')||-- a7_8,
       lpad(to_char(nvl(a.cod_provincia,0)),3,'0')||-- a9_11,
       lpad(to_char(nvl(a.cod_comune,0)),3,'0')||-- a12_14,
-- nati vivi - dichiarati all'ufficiale di stato civile
       lpad(a6.maschi,5,'0')||-- a15_19, 
       lpad(a6.femmine,5,'0')||-- a20_24,
-- nati vivi - di cui nati nel territorio del comune
       lpad(a8.maschi,4,'0')||-- a25_28, 
       lpad(a8.femmine,4,'0')||-- a29_32,
-- nati vivi - di cui nati in altro comune
       lpad(a10.maschi,4,'0')||-- a33_36,
       lpad(a10.femmine,4,'0')||-- a37_40,
-- nati vivi - dichiarati in un centro di nascita
       lpad(a12.maschi,4,'0')||-- a41_44,
       lpad(a12.femmine,4,'0')||-- a45_48,
-- nati vivi - da stranieri
       lpad(a14.maschi,4,'0')||-- a49_52,
       lpad(a14.femmine,4,'0')||-- a53_56,
-- nati morti - legittimi
       lpad(a16.maschi,3,'0')||-- a57_59,
       lpad(a16.femmine,3,'0')||-- a60_62,
-- nati morti - naturali
       lpad(a18.maschi,3,'0')||-- a63_65, 
       lpad(a18.femmine,3,'0')||-- a66_68,
-- nati morti - da stranieri
       lpad(a20.maschi,3,'0')||-- a69_71,
       lpad(a20.femmine,3,'0')||-- a72_74,
-- nati vivi legittimi - da parti plurimi
       lpad(a22.maschi,4,'0')||-- a75_78, 
       lpad(a22.femmine,4,'0')||-- a79_82,
-- nati vivi naturali - da parti plurimi
       lpad(a24.maschi,4,'0')||--a83_86, 
       lpad(a24.femmine,4,'0')||-- a87_90,
-- nati vivi e morti - da parti plurimi
       lpad(a26.maschi,3,'0')||-- a91_93,
       lpad(a26.femmine,3,'0')||-- a94_96,
-- morti nel 1 anno
       lpad(a28.maschi,4,'0')||-- a97_100,
       lpad(a28.femmine,4,'0')||--a101_104,
-- morti oltre il 1 anno
       lpad(a30.maschi,5,'0')||-- a105_109,
       lpad(a30.femmine,5,'0')||-- a110_114,
-- morti stranieri
       lpad(a32.maschi,5,'0')||-- a115_119,
       lpad(a32.femmine,5,'0')||-- a120_124,
-- matrimoni religiosi
       lpad(a34.col125_129,5,'0')||-- a125_129,
-- matrimoni civili
       lpad(a35.col130_133,4,'0')||-- a130_133,
-- matrimoni stranieri
       lpad(a36.col134_137,4,'0')||-- a134_137,
-- mese precendente: nati vivi 
       substr(parametri,8,5)||-- a138_142,
-- mese precendente: nati morti
       substr(parametri,13,5)||-- a143_147,
-- mese precendente: morti
       substr(parametri,18,5)||-- a148_152,
-- mese precendente: matrimoni
       substr(parametri,23,5)||-- a153_157,
-- filler
       '          ' riga
  from arccom a, tabrep,
-- nati vivi - dichiarati all'ufficiale di stato civile (1.1)
       (select count(decode(nas.sesso,'M','M','')) maschi,
               count(decode(nas.sesso,'F','F','')) femmine  
          from civnas nas, tabrep
         where nas.nato_morto 	is null 
           and nas.cod_rec 	in (0,3)
           and nas.parte 	= 1
	   and nas.serie	in ('A','B')
           and nas.data_nas 	between to_char(last_day(add_months(to_date(substr(parametri,1,7),'j'),-1))+1,'j') 
                            	    and to_char(last_day(to_date(substr(parametri,1,7),'j')),'j') 
--           and nas.data_reg 	between to_char(last_day(add_months(to_date(substr(parametri,1,7),'j'),-1))+1,'j') 
--                            	    and to_char(last_day(to_date(substr(parametri,1,7),'j')),'j') 
           and tabrep.chiave 	= 'ED7A'
           and tabrep.terminale	= nvl(userenv('terminal'),'ISTED7AX')
        ) a6,
-- nati vivi - di cui nati nel territorio del comune (1.1.1)
       (select count(decode(nas.sesso,'M','M','')) maschi,
               count(decode(nas.sesso,'F','F','')) femmine  
          from civnas nas, tabrep
         where lpad(nas.cod_pro_nas,3,0)||lpad(nas.cod_com_nas,3,0) =
		(select lpad(pro_cliente,3,'0')||lpad(com_cliente,3,'0')
		   from menuditta)
           and nas.parte 	= 1
	   and nas.serie	in ('A','B')
           and nas.nato_morto 	is null 
           and nas.cod_rec 	in (0,3)
           and nas.data_nas 	between to_char(last_day(add_months(to_date(substr(parametri,1,7),'j'),-1))+1,'j') 
                            	    and to_char(last_day(to_date(substr(parametri,1,7),'j')),'j') 
--           and nas.data_reg 	between to_char(last_day(add_months(to_date(substr(parametri,1,7),'j'),-1))+1,'j') 
--                            	    and to_char(last_day(to_date(substr(parametri,1,7),'j')),'j') 
           and tabrep.chiave 	= 'ED7A' 
           and tabrep.terminale = nvl(userenv('terminal'),'ISTED7AX')
       ) a8,
-- nati vivi - di cui nati in altro comune (1.1.2)
       (select count(decode(nas.sesso,'M','M','')) maschi,
               count(decode(nas.sesso,'F','F','')) femmine 
          from civnas nas, tabrep
         where lpad(nas.cod_pro_nas,3,0)||lpad(nas.cod_com_nas,3,0) !=
		(select lpad(pro_cliente,3,'0')||lpad(com_cliente,3,'0')
		   from menuditta)
           and nas.parte 	= 1
	   and nas.serie	in ('A','B')
           and nas.nato_morto 	is null 
           and nas.cod_rec 	in (0,3)
           and nas.data_nas 	between to_char(last_day(add_months(to_date(substr(parametri,1,7),'j'),-1))+1,'j') 
                            	    and to_char(last_day(to_date(substr(parametri,1,7),'j')),'j') 
--           and nas.data_reg 	between to_char(last_day(add_months(to_date(substr(parametri,1,7),'j'),-1))+1,'j') 
--                            	    and to_char(last_day(to_date(substr(parametri,1,7),'j')),'j') 
           and tabrep.chiave 	= 'ED7A' 
           and tabrep.terminale = nvl(userenv('terminal'),'ISTED7AX')
       ) a10,
-- nati vivi - dichiarati in un centro di nascita (1.2)
       (select count(decode(nas.sesso,'M','M','')) maschi,
               count(decode(nas.sesso,'F','F','')) femmine  
          from civnas nas, tabrep
         where nas.parte 	= 2 
           and nas.serie 	= 'B' 
           and nas.natura 	in ('O') 
           and nas.cod_pro_nas 	< 199
           and nas.nato_morto 	is null 
           and nas.cod_rec 	in (0,3)
           and nas.data_nas 	between to_char(last_day(add_months(to_date(substr(parametri,1,7),'j'),-1))+1,'j') 
                            	    and to_char(last_day(to_date(substr(parametri,1,7),'j')),'j') 
--           and nas.data_reg 	between to_char(last_day(add_months(to_date(substr(parametri,1,7),'j'),-1))+1,'j') 
--                            	    and to_char(last_day(to_date(substr(parametri,1,7),'j')),'j') 
           and tabrep.chiave 	= 'ED7A' 
           and tabrep.terminale = nvl(userenv('terminal'),'ISTED7AX')
        ) a12,
-- nati vivi - da stranieri
       (select count(decode(nas.sesso,'M','M','')) maschi,
               count(decode(nas.sesso,'F','F','')) femmine 
          from civnas nas, tabrep 
         where (f_nati_stranieri(nas.ufficio,nas.anno,nas.atto,nas.parte,nas.serie,'MAT') != 'I' or
		f_nati_stranieri(nas.ufficio,nas.anno,nas.atto,nas.parte,nas.serie,'PAT') != 'I')
	   and ((nas.parte = 1 and nas.serie in ('A','B')) 
		or
		(nas.parte = 2 and nas.serie = 'B' and nas.natura in ('O') and 
		 nas.cod_pro_nas < 199)) 
           and nas.nato_morto 	is null 
           and nas.cod_rec 	in (0,3)
           and nas.data_nas 	between to_char(last_day(add_months(to_date(substr(parametri,1,7),'j'),-1))+1,'j') 
                            	    and to_char(last_day(to_date(substr(parametri,1,7),'j')),'j') 
--           and nas.data_reg 	between to_char(last_day(add_months(to_date(substr(parametri,1,7),'j'),-1))+1,'j') 
--                            	    and to_char(last_day(to_date(substr(parametri,1,7),'j')),'j')         
           and tabrep.chiave 	= 'ED7A' 
           and tabrep.terminale = nvl(userenv('terminal'),'ISTED7AX')
        ) a14,
-- nati morti - legittimi
       (select count(decode(nas.sesso,'M','M','')) maschi,
               count(decode(nas.sesso,'F','F','')) femmine 
          from civnas nas, tabrep
         where nvl(nas.tipo_filiazione,' ') = 'L'
	   and ((nas.parte = 1 and nas.serie in ('A','B')) 
		or
		(nas.parte = 2 and nas.serie = 'B' and nas.natura in ('O') and nas.cod_pro_nas < 199)) 
           and nas.nato_morto 	is not null
           and nas.cod_rec 	in (0,3)
           and nas.data_nas 	between to_char(last_day(add_months(to_date(substr(parametri,1,7),'j'),-1))+1,'j') 
                            	    and to_char(last_day(to_date(substr(parametri,1,7),'j')),'j') 
--           and nas.data_reg 	between to_char(last_day(add_months(to_date(substr(parametri,1,7),'j'),-1))+1,'j') 
--                            	    and to_char(last_day(to_date(substr(parametri,1,7),'j')),'j') 
           and tabrep.chiave 	= 'ED7A' 
           and tabrep.terminale = nvl(userenv('terminal'),'ISTED7AX')
        ) a16,
-- nati morti - naturali
       (select count(decode(nas.sesso,'M','M','')) maschi,
               count(decode(nas.sesso,'F','F','')) femmine 
          from civnas nas, tabrep
         where nvl(nas.tipo_filiazione,' ') in ('C','S',' ')
	   and ((nas.parte = 1 and nas.serie = 'A') 
		or
		(nas.parte = 2 and nas.serie = 'B' and nas.natura in ('O') and 
		 nas.cod_pro_nas < 199)) 
           and nas.nato_morto 	is not null
           and nas.cod_rec 	in (0,3)
           and nas.data_nas 	between to_char(last_day(add_months(to_date(substr(parametri,1,7),'j'),-1))+1,'j') 
                            	    and to_char(last_day(to_date(substr(parametri,1,7),'j')),'j') 
--           and nas.data_reg 	between to_char(last_day(add_months(to_date(substr(parametri,1,7),'j'),-1))+1,'j') 
--                            	    and to_char(last_day(to_date(substr(parametri,1,7),'j')),'j') 
           and tabrep.chiave 	= 'ED7A' 
           and tabrep.terminale = nvl(userenv('terminal'),'ISTED7AX')
        ) a18,
-- nati morti - da stranieri
       (select count(decode(nas.sesso,'M','M','')) maschi,
               count(decode(nas.sesso,'F','F','')) femmine 
          from civnas nas,  tabrep
         where (f_nati_stranieri(nas.ufficio,nas.anno,nas.atto,nas.parte,nas.serie,'MAT') != 'I' or
		f_nati_stranieri(nas.ufficio,nas.anno,nas.atto,nas.parte,nas.serie,'PAT') != 'I')
	   and ((nas.parte = 1 and nas.serie in ('A','B')) 
		or
		(nas.parte = 2 and nas.serie = 'B' and nas.natura in ('O') and nas.cod_pro_nas < 199)) 
           and nas.nato_morto 	is not null
           and nas.cod_rec 	in (0,3)
           and nas.data_nas 	between to_char(last_day(add_months(to_date(substr(parametri,1,7),'j'),-1))+1,'j') 
                            	    and to_char(last_day(to_date(substr(parametri,1,7),'j')),'j') 
--           and nas.data_reg 	between to_char(last_day(add_months(to_date(substr(parametri,1,7),'j'),-1))+1,'j') 
--                            	    and to_char(last_day(to_date(substr(parametri,1,7),'j')),'j') 
           and tabrep.chiave 	= 'ED7A' 
           and tabrep.terminale = nvl(userenv('terminal'),'ISTED7AX')
        ) a20,
-- nati vivi legittimi
       (select count(decode(nas.sesso,'M','M','')) maschi,
               count(decode(nas.sesso,'F','F','')) femmine 
          from civnas nas, tabrep
         where nvl(nas.tipo_filiazione,' ') = 'L'
--	   and nas.parto_plurimo is null
	   and ((nas.parte = 1 and nas.serie in ('A','B')) 
		or
		(nas.parte = 2 and nas.serie = 'B' and nas.natura in ('O') and nas.cod_pro_nas < 199)) 
           and nas.nato_morto 	is null
           and nas.cod_rec 	in (0,3)
           and nas.data_nas 	between to_char(last_day(add_months(to_date(substr(parametri,1,7),'j'),-1))+1,'j') 
                            	    and to_char(last_day(to_date(substr(parametri,1,7),'j')),'j') 
--           and nas.data_reg 	between to_char(last_day(add_months(to_date(substr(parametri,1,7),'j'),-1))+1,'j') 
--                            	    and to_char(last_day(to_date(substr(parametri,1,7),'j')),'j') 
           and tabrep.chiave 	= 'ED7A' 
           and tabrep.terminale = nvl(userenv('terminal'),'ISTED7AX')
        ) a22,
-- nati vivi naturali 
       (select count(decode(nas.sesso,'M','M','')) maschi,
               count(decode(nas.sesso,'F','F','')) femmine 
          from civnas nas, tabrep
         where nvl(nas.tipo_filiazione,' ') in ('C','S',' ')
--	   and nas.parto_plurimo is null
	   and ((nas.parte = 1 and nas.serie in ('A','B')) 
		or
		(nas.parte = 2 and nas.serie = 'B' and nas.natura in ('O') and nas.cod_pro_nas < 199)) 
           and nas.nato_morto 	is null
           and nas.cod_rec 	in (0,3)
           and nas.data_nas 	between to_char(last_day(add_months(to_date(substr(parametri,1,7),'j'),-1))+1,'j') 
                            	    and to_char(last_day(to_date(substr(parametri,1,7),'j')),'j') 
--           and nas.data_reg 	between to_char(last_day(add_months(to_date(substr(parametri,1,7),'j'),-1))+1,'j') 
--                            	    and to_char(last_day(to_date(substr(parametri,1,7),'j')),'j') 
           and tabrep.chiave 	= 'ED7A' 
           and tabrep.terminale = nvl(userenv('terminal'),'ISTED7AX')
       ) a24,
-- nati vivi e morti - da parti plurimi
       (select count(decode(nas.sesso,'M','M','')) maschi,
               count(decode(nas.sesso,'F','F','')) femmine 
          from civnas nas, tabrep
         where nas.parto_plurimo = 'SI'
	   and ((nas.parte = 1 and nas.serie in ('A','B')) 
		or
		(nas.parte = 2 and nas.serie = 'B' and nas.natura in ('O') and nas.cod_pro_nas < 199)) 
           and nas.cod_rec 	in (0,3)
           and nas.data_nas 	between to_char(last_day(add_months(to_date(substr(parametri,1,7),'j'),-1))+1,'j') 
                            	    and to_char(last_day(to_date(substr(parametri,1,7),'j')),'j') 
--           and nas.data_reg 	between to_char(last_day(add_months(to_date(substr(parametri,1,7),'j'),-1))+1,'j') 
--                            	    and to_char(last_day(to_date(substr(parametri,1,7),'j')),'j') 
           and tabrep.chiave 	= 'ED7A' 
           and tabrep.terminale = nvl(userenv('terminal'),'ISTED7AX')
        ) a26,
-- morti nel 1 anno
       (select count(decode(sesso,'M','M','')) maschi,
               count(decode(sesso,'F','F','')) femmine 
          from civmor mor, tabrep
         where mor.data_mor - to_number(to_char(add_months(to_date(mor.data_nas,'j'),12),'j')) < 0
           and mor.natura	= 'O'
	   and (mor.cod_pro_mor, cod_com_mor) = (select pro_cliente, com_cliente from menuditta)
	   and mor.cod_rec	in (0,3)
           and mor.data_mor 	between to_char(last_day(add_months(to_date(substr(parametri,1,7),'j'),-1))+1,'j') 
                            	    and to_char(last_day(to_date(substr(parametri,1,7),'j')),'j') 
--           and mor.data_reg 	between to_char(last_day(add_months(to_date(substr(parametri,1,7),'j'),-1))+1,'j') 
--                            	    and to_char(last_day(to_date(substr(parametri,1,7),'j')),'j')  
           and tabrep.chiave 	= 'ED7A' 
           and tabrep.terminale = nvl(userenv('terminal'),'ISTED7AX')
        ) a28,
-- morti oltre il 1 anno
       (select count(decode(sesso,'M','M','')) maschi,
               count(decode(sesso,'F','F','')) femmine
          from civmor mor, tabrep
         where mor.data_mor - to_number(to_char(add_months(to_date(mor.data_nas,'j'),12),'j')) >= 0
           and mor.natura	= 'O'
	   and (mor.cod_pro_mor, cod_com_mor) = (select pro_cliente, com_cliente from menuditta)
	   and mor.cod_rec	in (0,3)
           and mor.data_mor 	between to_char(last_day(add_months(to_date(substr(parametri,1,7),'j'),-1))+1,'j') 
                            	    and to_char(last_day(to_date(substr(parametri,1,7),'j')),'j') 
--           and mor.data_reg 	between to_char(last_day(add_months(to_date(substr(parametri,1,7),'j'),-1))+1,'j') 
--                        	    and to_char(last_day(to_date(substr(parametri,1,7),'j')),'j') 
           and tabrep.chiave 	= 'ED7A' 
           and tabrep.terminale = nvl(userenv('terminal'),'ISTED7AX')
        ) a30,
-- morti stranieri
       (select count(decode(sesso,'M','M','')) maschi,
               count(decode(sesso,'F','F','')) femmine
          from civdmo dmo, civmor mor, tabrep
         where upper(dmo.cittadinanza) not like '%ITALIA%'
	   and dmo.ufficio	= mor.ufficio
	   and dmo.anno		= mor.anno
	   and dmo.atto		= mor.atto
	   and dmo.parte	= mor.parte
	   and nvl(dmo.serie,' ') = nvl(mor.serie,' ')
           and mor.natura	= 'O'
	   and (mor.cod_pro_mor, cod_com_mor) = (select pro_cliente, com_cliente from menuditta)
	   and mor.cod_rec	in (0,3)
           and mor.data_mor 	between to_char(last_day(add_months(to_date(substr(parametri,1,7),'j'),-1))+1,'j') 
                            	    and to_char(last_day(to_date(substr(parametri,1,7),'j')),'j') 
--           and mor.data_reg 	between to_char(last_day(add_months(to_date(substr(parametri,1,7),'j'),-1))+1,'j') 
--                        	    and to_char(last_day(to_date(substr(parametri,1,7),'j')),'j') 
           and tabrep.chiave 	= 'ED7A' 
           and tabrep.terminale = nvl(userenv('terminal'),'ISTED7AX')
        ) a32,
-- matrimoni religiosi
       (select count(*) col125_129
          from civmat mat, tabrep
         where mat.parte 	= 2
           and mat.serie 	= 'A'
	   and mat.cod_rec	in (0,3)
           and mat.data_mat 	between to_char(last_day(add_months(to_date(substr(parametri,1,7),'j'),-1))+1,'j') 
                            	    and to_char(last_day(to_date(substr(parametri,1,7),'j')),'j') 
--           and mat.data_reg 	between to_char(last_day(add_months(to_date(substr(parametri,1,7),'j'),-1))+1,'j') 
--                        	    and to_char(last_day(to_date(substr(parametri,1,7),'j')),'j') 
           and tabrep.chiave 	= 'ED7A' 
           and tabrep.terminale = nvl(userenv('terminal'),'ISTED7AX')
       ) a34,
-- matrimoni civili
       (select count(*) col130_133
          from civmat mat, tabrep
         where (mat.parte = 1 or (mat.parte = 2 and nvl(mat.serie,' ') = 'C'))
	   and (mat.cod_pro_mat, mat.cod_com_mat) = (select pro_cliente, com_cliente from menuditta) 
	   and mat.natura	= 'O'
 	   and mat.cod_rec	in (0,3)
           and mat.data_mat 	between to_char(last_day(add_months(to_date(substr(parametri,1,7),'j'),-1))+1,'j') 
                            	    and to_char(last_day(to_date(substr(parametri,1,7),'j')),'j') 
--           and mat.data_reg 	between to_char(last_day(add_months(to_date(substr(parametri,1,7),'j'),-1))+1,'j') 
--                        	and to_char(last_day(to_date(substr(parametri,1,7),'j')),'j') 
           and tabrep.chiave	= 'ED7A' 
           and tabrep.terminale = nvl(userenv('terminal'),'ISTED7AX')
        ) a35,
-- matrimoni stranieri
       (select count(*) col134_137
          from civmat mat, tabrep
         where mat.natura	= 'O'
	   and (mat.cod_pro_mat, mat.cod_com_mat) = (select pro_cliente, com_cliente from menuditta) 
 	   and mat.cod_rec	in (0,3)
           and (mat.nazionalita_m != 'I' or mat.nazionalita_f != 'I')
           and mat.data_mat 	between to_char(last_day(add_months(to_date(substr(parametri,1,7),'j'),-1))+1,'j') 
                            	    and to_char(last_day(to_date(substr(parametri,1,7),'j')),'j') 
--           and mat.data_reg 	between to_char(last_day(add_months(to_date(substr(parametri,1,7),'j'),-1))+1,'j') 
--                            	    and to_char(last_day(to_date(substr(parametri,1,7),'j')),'j') 
           and tabrep.chiave 	= 'ED7A' 
           and tabrep.terminale = nvl(userenv('terminal'),'ISTED7AX')
       ) a36
 where (a.cod_provincia,a.cod_comune) = (select pro_cliente, com_cliente
			                   from menuditta)
   and chiave 		= 'ED7A'
   and terminale 	= nvl(userenv('terminal'),'ISTED7AX')
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
     set valore_default = 'istatel\'||codice_istat||'_D7A_'||to_char(sysdate,'yymmdd')||'.txt'
   where parametro 	= 'TXTFILE'
     and voce_menu	= 'ISTED7A'
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
   RETURN 'V1.0 del 29/07/2003';
END VERSIONE;
END ISTED7AX;
/
