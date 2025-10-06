--liquibase formatted sql
--changeset amonopoli:202503211222_2 runOnChange:true stripComments:false
CREATE OR REPLACE package body ISTEDAPX is
PROCEDURE MAIN   (prenotazione  IN number,
                  PASSO          IN number) is
p_prenotazione number;
p_passo        number;
P_pagina 	   number :=1;
P_riga   	   number :=0;
cursor sel_dati is
--
-- modelli apr di iscrizione
--
select 1 w_ord_1, ap4.anno_dic w_ord_2, ap4.numero_dic w_ord_3, ap4.pratica w_ord_4, -1 w_ord_5,
-- 1. stringa terminatori
	 'JJ+;'||
-- 2. tipo record
       'A4TI'||'+'||
-- 3. mese di riferimento
       to_char(to_date(ap4.data_definizione,'j'),'mm')||'+'||
-- 4. anno di riferimento
       to_char(to_date(ap4.data_definizione,'j'),'yyyy')||'+'||
-- 5. numero persone
       apm_v.totale||'+'||
-- 6. tipo pratica
       decode(ap4.provvedimento,1,'A',2,'B',3,'C',4,'D')||'+'||
-- 7. numero pratica iscrizione
       nvl(ap4.pratica,ap4.numero_dic)||'+'||
-- 8. iscrizione comporta conteggio
       nvl(ap4.conteggio,1)||'+'||
-- 9. numero pratica cancellazione
       decode(ap4.provvedimento,1,ap4.pratica_canc)||'+'||
--10. cancellazione comporta conteggio
       decode(ap4.provvedimento,1,nvl(ap4.conteggio_canc,nvl(ap4.conteggio,1)))||'+'||
--11. codice comune cancellazione
       decode(provvedimento,1,lpad(nvl(cod_pro_eve,0),3,'0')||lpad(nvl(cod_com_eve,0),3,'0'))||'+'|| 
--12. provvedimento iscrizione
	 ap4.provvedimento||'+'||
--13. codice stato estero provenienza
       decode(ap4.provvedimento,2,ap4.cod_stato)||'+'||
--14. provvedimento cancellazione
       ''||'+'|| 
--15. codice stato estero destinazione
       ''||'+'|| 
--16. data di comunicazione della pratica
       to_char(to_date(ap4.data_definizione,'j'),'ddmmyyyy')||'+'||
--17. famiglia anagrafica / convivenza
       decode(ap4.famiglia_convivenza,'F','1','C','2')||'+'||
--18. data decorrenza iscrizione
       to_char(to_date(nvl(ap4.data_decorrenza,ap4.data_pratica),'j'),'ddmmyyyy')||'+'|| 
--19. data decorrenza cancellazione
       ''||'+'||
--20. nuovo indirizzo residenza
       vie.denom_uff||ap4.civico_esterno||ap4.civico_interno||';' riga
  from tabrep, arcvie vie, anaap4 ap4, 
       (select apm.anno_dic, apm.numero_dic, count(*) totale
          from anaapm apm
         where apm.annullamento 	is null
           and apm.flag_soggetto	= 'S'
         group by apm.anno_dic, apm.numero_dic) apm_v
 where exists (select 1
                 from anatpr tpr
                where tpr.anno_pratica 		= ap4.anno_dic
                  and tpr.pratica      		= ap4.numero_dic
                  and tpr.flag_perfezionamento 	= 'S'
                  and tpr.anagrafe		 	= 'RES'
                  and tpr.tipo_evento   	 	= 'I')
   and vie.cod_via (+)	    = ap4.cod_via
   and apm_v.anno_dic	    = ap4.anno_dic
   and apm_v.numero_dic	    = ap4.numero_dic
   and ap4.anno_dic         is not null
   and ap4.numero_dic       is not null
   and ap4.anno_pratica     is not null
   and ap4.pratica          is not null
   and ap4.data_definizione between substr(tabrep.parametri,1,7) 
                                and substr(tabrep.parametri,8,7) 
   and tabrep.chiave 	    = 'EDAP' 
   and tabrep.terminale     = nvl(userenv('terminal'),'ISTEDAPX')
UNION
--
-- soggetti in modelli apr di iscrizione
--
select 1 w_ord_1, ap4.anno_dic w_ord_2, ap4.numero_dic w_ord_3, ap4.pratica w_ord_4, nvl(apm.numero_ordine,0) w_ord_5,
-- 1. stringa terminatori
	 'JJ+;'||
-- 2. tipo record
       'A4DI'||'+'||
-- 3. mese di riferimento
       to_char(to_date(ap4.data_definizione,'j'),'mm')||'+'||
-- 4. anno di riferimento
       to_char(to_date(ap4.data_definizione,'j'),'yyyy')||'+'||
-- 5. progressivo persona
	 apm.numero_ordine||'+'||
-- 6. codice fiscale
	 ana.cod_fiscale||'+'||
-- 7. data di nascita
	 to_char(to_date(ana.data_nas,'j'),'ddmmyyyy')||'+'||
-- 8. codice comune / stato estero di nascita
	 decode(a0.descrizione,'',lpad(nvl(ana.cod_pro_nas,0),3,'0')||lpad(nvl(ana.cod_com_nas,0),3,'0'),
	   decode(ana.cod_pro_nas,
	     701,decode(sign(ana.cod_com_nas-499),1,lpad(nvl(ana.cod_pro_nas,0),3,'0')||lpad(nvl(ana.cod_com_nas,0),3,'0'),ana.cod_pro_nas),
	     702,decode(sign(ana.cod_com_nas-700),1,lpad(nvl(ana.cod_pro_nas,0),3,'0')||lpad(nvl(ana.cod_com_nas,0),3,'0'),ana.cod_pro_nas),
	     703,decode(sign(ana.cod_com_nas-700),1,lpad(nvl(ana.cod_pro_nas,0),3,'0')||lpad(nvl(ana.cod_com_nas,0),3,'0'),ana.cod_pro_nas),
		   ana.cod_pro_nas))||'+'||
-- 9. sesso
	 decode(ana.sesso,'M','1','F','2')||'+'||
--10. stato civile
	 decode(mov.stato_civile,'CE','1','NU','1','CN','2','UC','2','VE','3','VU','3','DV','4','GC','4','GU','4')||'+'||
--11. cittadinanza italiana
	 decode(ana.nazionalita,'I','1','2')||'+'||
--12. codice cittadinanza straniera
	 decode(ana.nazionalita,'I','',dci.ist_ci)||'+'||
--13. posizione nella professione
 	 decode(apm.ist_np,'',ana.posizione_prof)||'+'||
--14. condizione non profesionale
	 apm.ist_np||'+'||
--15. titolo di studio
	 apm.ist_ts||'+'||
--16. relazione di parentela
       ltrim(apm.ist_rp,'0')||';' riga
  from tabrep, arccom a0, anadci dci, 
       anamov mov, anaana ana, anaap4 ap4, anaapm apm 
 where dci.cod_ci         (+) = ana.nazionalita 
   and a0.cod_provincia   (+) = ana.cod_pro_nas
   and a0.cod_comune      (+) = 0
   and mov.anno_pratica       = ap4.anno_dic
   and mov.pratica            = nvl(ap4.pratica,ap4.numero_dic)
   and mov.cod_mov            = 1
   and mov.cod_eve            != 17
   and mov.matricola	      = apm.matricola
   and ana.matricola          = apm.matricola 
   and apm.annullamento       is null 
   and apm.flag_soggetto	= 'S'
   and apm.anno_dic		= ap4.anno_dic
   and apm.numero_dic		= ap4.numero_dic
   and ap4.data_definizione between substr(tabrep.parametri,1,7) 
                                and substr(tabrep.parametri,8,7) 
   and tabrep.chiave 	    = 'EDAP' 
   and tabrep.terminale     = nvl(userenv('terminal'),'ISTEDAPX')
UNION
--
-- modelli apr di cancellazione (no ripristini)
--
select 2 w_ord_1, cp4.anno_dic w_ord_2, cp4.pratica w_ord_3, cp4.numero_dic w_ord_4, -1 w_ord_5,
-- 1. stringa terminatori
	 'JJ+;'||
-- 2. tipo record
       'A4TI'||'+'||
-- 3. mese di riferimento
       to_char(to_date(cp4.data_definizione,'j'),'mm')||'+'||
-- 4. anno di riferimento
       to_char(to_date(cp4.data_definizione,'j'),'yyyy')||'+'||
-- 5. numero persone
       cpm_v.totale||'+'||
-- 6. tipo pratica
       decode(cp4.provvedimento,1,'E',2,'F',3,'G',4,'H',5,'I')||'+'||
-- 7. numero pratica iscrizione
       ''||'+'||
-- 8. iscrizione comporta conteggio
       ''||'+'||
-- 9. numero pratica cancellazione
       nvl(cp4.pratica,cp4.numero_dic)||'+'||
--10. cancellazione comporta conteggio
       decode(cp4.provvedimento,2,2,nvl(cp4.conteggio,1))||'+'||
--11. codice comune cancellazione
       lpad(m.pro_cliente,3,'0')||lpad(m.com_cliente,3,'0')||'+'|| 
--12. provvedimento iscrizione
       ''||'+'||
--13. codice stato estero provenienza
       ''||'+'||
--14. provvedimento cancellazione
       cp4.provvedimento||'+'|| 
--15. codice stato estero destinazione
       decode(cp4.provvedimento,1,cp4.cod_stato)||'+'|| 
--16. data di comunicazione della pratica
       to_char(to_date(cp4.data_definizione,'j'),'ddmmyyyy')||'+'||
--17. famiglia anagrafica / convivenza
       ''||'+'||
--18. data decorrenza iscrizione
       ''||'+'|| 
--19. data decorrenza cancellazione
       to_char(to_date(nvl(cp4.data_decorrenza,cp4.data_pratica),'j'),'ddmmyyyy')||'+'||
--20. nuovo indirizzo residenza
       ''||';' riga
  from tabrep, menuditta m, anacp4 cp4, 
       (select cpm.anno_dic, cpm.numero_dic, count(*) totale
          from anacpm cpm
         where cpm.flag_soggetto	= 'S'
           and cpm.annullamento	is null
         group by cpm.anno_dic, cpm.numero_dic) cpm_v
 where exists (select 1
                 from anatpr
                where anno_pratica 		 = cp4.anno_dic
                  and pratica      		 = cp4.pratica
                  and flag_perfezionamento = 'S'
	            and anagrafe		 = 'RES'
                  and tipo_evento 		 = 'C')
   and cpm_v.totale		> 0
   and cpm_v.anno_dic		= cp4.anno_dic
   and cpm_v.numero_dic		= cp4.numero_dic
   and ((cp4.provvedimento = 1 and cp4.cod_stato is not null) or
          (cp4.provvedimento in (2,3,4)))
   and cp4.anno_dic 		is not null
   and cp4.numero_dic 		is not null
   and cp4.anno_pratica 	is not null
   and cp4.pratica 		is not null
   and cp4.data_definizione 	between substr(tabrep.parametri,1,7) 
                                  and substr(tabrep.parametri,8,7) 
   and tabrep.chiave 		= 'EDAP' 
   and tabrep.terminale 	= nvl(userenv('terminal'),'ISTEDAPX')
UNION
--
-- modelli apr di ripristino scheda anagrafica
--
select 2 w_ord_1, cp4.anno_dic w_ord_2, cp4.pratica w_ord_3, cp4.numero_dic w_ord_4, -1 w_ord_5,
-- 1. stringa terminatori
	 'JJ+;'||
-- 2. tipo record
       'A4TI'||'+'||
-- 3. mese di riferimento
       to_char(to_date(cp4.data_ripristino,'j'),'mm')||'+'||
-- 4. anno di riferimento
       to_char(to_date(cp4.data_ripristino,'j'),'yyyy')||'+'||
-- 5. numero persone
       cpm_v.totale||'+'||
-- 6. tipo pratica
       decode(cp4.provvedimento,1,'E',2,'F',3,'G',4,'H',5,'I')||'+'||
-- 7. numero pratica iscrizione
       ''||'+'||
-- 8. iscrizione comporta conteggio
       ''||'+'||
-- 9. numero pratica cancellazione
       nvl(cp4.pratica,cp4.numero_dic)||'+'||
--10. cancellazione comporta conteggio
       nvl(cp4.conteggio,1)||'+'||
--11. codice comune cancellazione
       lpad(m.pro_cliente,3,'0')||lpad(m.com_cliente,3,'0')||'+'|| 
--12. provvedimento iscrizione
       ''||'+'||
--13. codice stato estero provenienza
       ''||'+'||
--14. provvedimento cancellazione
       cp4.provvedimento||'+'|| 
--15. codice stato estero destinazione
       ''||'+'|| 
--16. data di comunicazione della pratica
       to_char(to_date(cp4.data_ripristino,'j'),'ddmmyyyy')||'+'||
--17. famiglia anagrafica / convivenza
       ''||'+'||
--18. data decorrenza iscrizione
       ''||'+'|| 
--19. data decorrenza cancellazione
       to_char(to_date(nvl(cp4.data_decorrenza,cp4.data_pratica),'j'),'ddmmyyyy')||'+'||
--20. nuovo indirizzo residenza
       ''||';' riga
  from tabrep, menuditta m, anacp4 cp4, 
       (select cpm.anno_dic, cpm.numero_dic, count(*) totale
          from anacpm cpm
         where cpm.flag_ripristino	= 'S'
         group by cpm.anno_dic, cpm.numero_dic) cpm_v
 where exists (select 1
                 from anatpr
                where anno_pratica 		 = cp4.anno_dic
                  and pratica      		 = cp4.pratica
                  and flag_perfezionamento||flag_annullamento = 'S'
	            and anagrafe		 = 'RES'
                  and tipo_evento 		 = 'C')
   and cpm_v.totale		> 0
   and cpm_v.anno_dic		= cp4.anno_dic
   and cpm_v.numero_dic		= cp4.numero_dic
   and cp4.provvedimento	= 5
   and cp4.anno_dic 		is not null
   and cp4.numero_dic 		is not null
   and cp4.anno_pratica 	is not null
   and cp4.pratica 		is not null
   and cp4.data_ripristino 	between substr(tabrep.parametri,1,7) 
                                  and substr(tabrep.parametri,8,7) 
   and tabrep.chiave 		= 'EDAP' 
   and tabrep.terminale 	= nvl(userenv('terminal'),'ISTEDAPX')
UNION
--
-- soggetti in modelli apr di cancellazione
--
select 2 w_ord_1, cp4.anno_dic w_ord_2, cp4.pratica w_ord_3, cp4.numero_dic w_ord_4, nvl(cpm.numero_ordine,0) w_ord_5,
-- 1. stringa terminatori
	 'JJ+;'||
-- 2. tipo record
       'A4DI'||'+'||
-- 3. mese di riferimento
       to_char(to_date(cp4.data_definizione,'j'),'mm')||'+'||
-- 4. anno di riferimento
       to_char(to_date(cp4.data_definizione,'j'),'yyyy')||'+'||
-- 5. progressivo persona
	 cpm.numero_ordine||'+'||
-- 6. codice fiscale
	 ana.cod_fiscale||'+'||
-- 7. data di nascita
	 to_char(to_date(ana.data_nas,'j'),'ddmmyyyy')||'+'||
-- 8. codice comune / stato estero di nascita
	 decode(a0.descrizione,'',lpad(nvl(ana.cod_pro_nas,0),3,'0')||lpad(nvl(ana.cod_com_nas,0),3,'0'),
	   decode(ana.cod_pro_nas,
	     701,decode(sign(ana.cod_com_nas-499),1,lpad(nvl(ana.cod_pro_nas,0),3,'0')||lpad(nvl(ana.cod_com_nas,0),3,'0'),ana.cod_pro_nas),
	     702,decode(sign(ana.cod_com_nas-700),1,lpad(nvl(ana.cod_pro_nas,0),3,'0')||lpad(nvl(ana.cod_com_nas,0),3,'0'),ana.cod_pro_nas),
	     703,decode(sign(ana.cod_com_nas-700),1,lpad(nvl(ana.cod_pro_nas,0),3,'0')||lpad(nvl(ana.cod_com_nas,0),3,'0'),ana.cod_pro_nas),
		   ana.cod_pro_nas))||'+'||
-- 9. sesso
	 decode(ana.sesso,'M','1','F','2')||'+'||
--10. stato civile
	 decode(mov.stato_civile,'CE','1','NU','1','CN','2','UC','2','VE','3','VU','3','DV','4','GC','4','GU','4')||'+'||
--11. cittadinanza italiana
	 decode(ana.nazionalita,'I','1','2')||'+'||
--12. codice cittadinanza straniera
	 decode(ana.nazionalita,'I','',dci.ist_ci)||'+'||
--13. posizione nella professione
 	 decode(cpm.ist_np,'',ana.posizione_prof)||'+'||
--14. condizione non profesionale
	 cpm.ist_np||'+'||
--15. titolo di studio
	 cpm.ist_ts||'+'||
--16. relazione di parentela
       ltrim(cpm.ist_rp,'0')||';' riga
  from tabrep, arccom a0, anadci dci, 
       anamov mov, anaana ana, anacp4 cp4, anacpm cpm 
 where dci.cod_ci         (+) = ana.nazionalita
   and a0.cod_provincia	  (+) = ana.cod_pro_nas
   and a0.cod_comune      (+) = 0 
   and mov.anno_pratica       = cp4.anno_dic
   and mov.pratica            = nvl(cp4.pratica,cp4.anno_dic)
   and mov.cod_mov            in (2,3)
   and mov.matricola	      = cpm.matricola
   and ana.matricola          = cpm.matricola 
   and ((cp4.provvedimento in (1,2,3,4) and cpm.flag_soggetto = 'S' and cpm.annullamento is null)
        or (cp4.provvedimento = 5 and cpm.flag_ripristino = 'S'))
   and cpm.anno_dic		= cp4.anno_dic
   and cpm.numero_dic		= cp4.numero_dic
   and ((cp4.provvedimento = 1 and cp4.cod_stato is not null) 
        or (cp4.provvedimento in (2,3,4,5)))
   and cp4.anno_dic 		is not null
   and cp4.numero_dic 		is not null
   and cp4.anno_pratica 	is not null
   and cp4.pratica 		is not null
   and decode(cp4.provvedimento,5,cp4.data_ripristino,cp4.data_definizione) 	
					between substr(tabrep.parametri,1,7) 
                                  and substr(tabrep.parametri,8,7) 
   and tabrep.chiave 		= 'EDAP' 
   and tabrep.terminale 	= nvl(userenv('terminal'),'ISTEDAPX')
 order by 1,2,3,4,5
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
     set valore_default = 'istatel\'||codice_istat||'_APR4_'||to_char(sysdate,'yymmdd')||'.txt'
   where parametro 	= 'TXTFILE'
     and voce_menu	= 'ISTEDAP'
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
END ISTEDAPX;
/
