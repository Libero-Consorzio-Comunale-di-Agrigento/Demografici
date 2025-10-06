--liquibase formatted sql
--changeset amonopoli:202503211219_2 runOnChange:true stripComments:false
CREATE OR REPLACE package body ISTEDP4X is
PROCEDURE MAIN   (prenotazione  IN number,
                  PASSO          IN number) is
p_prenotazione number;
p_passo        number;
P_pagina 	   number :=1;
P_riga   	   number :=0;
cursor sel_dati is
select 
--   1- 26: alfabetico del comune
	    rpad(substr(nvl(a.descrizione,' '),1,26),26,' ')|| 
--  27- 28: sigla della provincia
            rpad(substr(nvl(a.sigla_provincia,' '),1,2),2,' ')|| 
--  29- 31: codice provincia
            lpad(to_char(nvl(a.cod_provincia,0)),3,'0')||
--  32- 34: codice comune
            lpad(to_char(nvl(a.cod_comune,0)),3,'0')||
--  35- 60: cognome intestatario
            decode(mov.rapporto_par,'IC',
              rpad('CONVIVENZA',26,' '),
              rpad(substr(nvl(substr(mov.intestatario,1,instr(mov.intestatario,'/')-1),' '),1,26),26,' '))||
--  61- 79: nome intestatario
            decode(mov.rapporto_par,'IC',
              rpad('CONVIVENZA',19,' '),
              rpad(substr(nvl(substr(mov.intestatario,instr(mov.intestatario,'/')+1),' '),1,19),19,' '))||
--  80- 81: numero componenti
            decode(mov.rapporto_par,'IC',
              '99',
              lpad(to_char(nvl(mp4.num_componenti,0)),2,'0'))||
--  82-112: indirizzo
	    rpad(substr(nvl(vie.denom_uff,' '),1,31),31,' ')||
-- 113-118: numero civico
            lpad(nvl(to_char(mov.num_civ)||decode(mov.suffisso,'','','/'||mov.suffisso),' '),6,' ')||
-- 119-123: cap (5)
	    lpad(nvl(rtrim(substr(f_unita_territoriale(99,mov.cod_via,mov.num_civ,mov.suffisso),25,5)),
		a.cap),5,'0')||
-- 124-130: sez.censimento (7)
	    lpad(nvl(to_char(nvl(MP4.SEZIONE_CENS,rtrim(substr(f_unita_territoriale(rtrim(substr(parametri,22,2)),mov.cod_via,mov.num_civ,mov.suffisso),21,4)))),
		     '       '),7,'0')||
-- 131-156: cognome nato
	    rpad(substr(nvl(substr(ana.cognome_nome,1,instr(ana.cognome_nome,'/')-1),' '),1,26),26,' ')||
-- 157-175: nome nato
            rpad(substr(nvl(substr(ana.cognome_nome,instr(ana.cognome_nome,'/')+1),' '),1,19),19,' ')||
-- 176-178: provincia nascita
            lpad(to_char(nvl(ana.cod_pro_nas,0)),3,'0')||
-- 179-181: comune nascita
            decode(n0.descrizione,'',
              lpad(to_char(nvl(ana.cod_com_nas,0)),3,'0'),
              '000')||
-- 182-183: giorno nascita
	    nvl(to_char(to_date(ana.data_nas,'j'),'dd'),'00')||
-- 184-185: mese nascita
            nvl(to_char(to_date(ana.data_nas,'j'),'mm'),'00')||
-- 186-189: anno nascita
            nvl(to_char(to_date(ana.data_nas,'j'),'yyyy'),'0000')||
-- 190-190: sesso
            decode(ana.sesso,'M','1','2')||
-- 191-193: cittadinanza 
            decode(ana.nazionalita,'I','   ',
              lpad(to_char(nvl(dci.ist_ci,0)),3,'0'))||
-- 194-195: mese iscrizione anagrafica
	    nvl(to_char(to_date(mov.data_reg,'j'),'mm'),'00')||
-- 196-199: anno iscrizione anagrafica
            nvl(to_char(to_date(mov.data_reg,'j'),'yyyy'),'0000')||
-- 200-225: cognome madre
            rpad(substr(nvl(substr(ana.maternita,1,instr(ana.maternita,'/')-1),' '),1,26),26,' ')||
-- 226-244: nome madre
            rpad(substr(nvl(substr(ana.maternita,instr(ana.maternita,'/')+1),' '),1,19),19,' ')||
-- 245-246: giorno nascita madre
            nvl(to_char(to_date(mp4.data_nas_mat,'j'),'dd'),'  ')||
-- 247-248: mese nascita madre
            nvl(to_char(to_date(mp4.data_nas_mat,'j'),'mm'),'  ')||
-- 249-252: anno nascita madre
            nvl(to_char(to_date(mp4.data_nas_mat,'j'),'yyyy'),'    ')||
-- 253-253: stato civile madre
            nvl(decode(mp4.stato_civile_mat,'NU','1','CN','2','UC','2','GC','2','VE','3','VU','3','DV','4','GU','4',' '),' ')||
-- 254-256: cittadinanza madre
            decode(mp4.nazionalita_mat,'I','   ',
	      lpad(nvl(to_char(dci_m.ist_ci),' '),3,' '))||
-- 257-282: cognome padre
            decode(ana.paternita,'',rpad(' ',26,' '),
             decode(instr(ana.paternita,'/'),0,
              rpad(substr(nvl(substr(ana.cognome_nome,1,instr(ana.cognome_nome,'/')-1),' '),1,26),26,' '),
              rpad(substr(nvl(substr(ana.paternita,1,instr(ana.paternita,'/')-1),' '),1,26),26,' ')))||
-- 283-301: nome padre
            rpad(substr(nvl(substr(ana.paternita,instr(ana.paternita,'/')+1),' '),1,19),19,' ')||
-- 302-303: giorno nascita padre
            nvl(to_char(to_date(mp4.data_nas_pat,'j'),'dd'),'  ')||
-- 304-305: mese nascita padre
            nvl(to_char(to_date(mp4.data_nas_pat,'j'),'mm'),'  ')||
-- 306-309: anno nascita padre
            nvl(to_char(to_date(mp4.data_nas_pat,'j'),'yyyy'),'    ')||
-- 310-310: stato civile padre
            nvl(decode(mp4.stato_civile_pat,'CE','1','CN','2','UC','2','GC','2','VE','3','VU','3','DV','4','GU','4',' '),' ')||
-- 311-313: cittadinanza padre
            decode(mp4.nazionalita_pat,'I','   ',
              lpad(nvl(to_char(dci_p.ist_ci),' '),3,' '))||
-- 314-314: numero componenti minorenni
            decode(mov.rapporto_par,'IC',
              '9',
              decode(sign(8-mp4.num_componenti_minori),-1,'8',lpad(to_char(nvl(mp4.num_componenti_minori,0)),1,'0')))||
-- 315-330: codice fiscale madre
            rpad(nvl(mp4.cod_fiscale_mat,' '),16,' ') RIGA
       from arccom a, arccom n0, arcvie vie, 
            anadci dci, anadci dci_m, anadci dci_p,
	      anaana ana, anamov mov, istmp4 mp4, tabrep
	  where (a.cod_provincia,a.cod_comune) =
             (select pro_cliente, com_cliente
                from menuditta)
        and vie.cod_via 	(+) 	= mov.cod_via
        and dci.cod_ci  	(+) 	= ana.nazionalita
        and dci_m.cod_ci  	(+) 	= mp4.nazionalita_mat
        and dci_p.cod_ci  	(+) 	= mp4.nazionalita_pat       
        and n0.cod_provincia	(+)	= ana.cod_pro_nas
        and n0.cod_comune	(+)	= 0
        and ana.matricola 		= mov.matricola
        and mov.cod_mov 		= 1 
        and mov.cod_eve 		= 1 
        and mp4.flag_completo           is not null
        and mov.matricola 		= mp4.matricola
        and mov.data_reg 		between substr(parametri,1,7) 
                                	    and substr(parametri,8,7)
        and mov.matricola 		= decode(to_number(ltrim(substr(parametri,15,7))),null,
					    mov.matricola,
					    to_number(ltrim(substr(parametri,15,7))))
        and chiave 		= 'EDP4'
        and terminale 		= nvl(userenv('terminal'),'ISTEDP4X')
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
     set valore_default = 'istatel\'||codice_istat||'_P4_'||to_char(sysdate,'yymmdd')||'.txt' 
   where parametro 	= 'TXTFILE'
     and voce_menu	= 'ISTEDP4'
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
-- 'V2.0 del 20/11/2015'  AM  Adeguamenti 2015
-- 'V2.1 del 21/12/2016'  AM  Adeguamenti 2016 - Unioni Civili
--
   RETURN 'V2.1 del 21/12/2016';
END VERSIONE;
END ISTEDP4X;
/
