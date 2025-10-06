--liquibase formatted sql
--changeset amonopoli:202503211211_1 runOnChange:true stripComments:false
CREATE OR REPLACE package body ISTEDP4 is
PROCEDURE MAIN   (prenotazione  IN number,
                  PASSO          IN number) is
p_prenotazione number;
p_passo        number;
P_pagina 	   number :=1;
P_riga   	   number :=0;
cursor sel_dati is
select 0, int.riga
  from istedp4_int int
UNION
select rownum, 
       rownum||';'||
         v.dati_1||';'||
         nvl(v.SEZIONE_CENS,rtrim(substr(f_unita_territoriale(rtrim(substr(parametri,22,2)),v.cod_via,v.num_civ,v.suffisso),21,4)))||';'||
         v.dati_2 riga
  from istedp4_v v, tabrep
 where v.data_reg  between substr(parametri,1,7) and substr(parametri,8,7)
   and v.matricola = decode(to_number(ltrim(substr(parametri,15,7))), '', v.matricola, to_number(ltrim(substr(parametri,15,7))))
   and chiave      = 'EDP4'
   and terminale   = nvl(userenv('terminal'),'ISTEDP4')
order by 1
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
     set valore_default = 'istatel\'||codice_istat||'_P4_'||to_char(sysdate,'yymmdd')||'.csv' 
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
-- 'V2.2 del 20/09/2017'  AM  Adeguamenti 2017 - Nuovi tracciati
-- 'V2.3 del 09/02/2022'  AM  gestione viste istedp4_int / istedp4_v
--
   RETURN 'V2.3 del 09/02/2022';
END VERSIONE;
END ISTEDP4;
/
