--liquibase formatted sql
--changeset amonopoli:202503211212_2 runOnChange:true stripComments:false
CREATE OR REPLACE package body ISTEDDU is
PROCEDURE MAIN   (prenotazione  IN number,
                  PASSO          IN number) is
p_prenotazione number;
p_passo        number;
P_pagina 	   number :=1;
P_riga   	   number :=0;
cursor sel_dati is
select 0, riga
  from isteddu_int
UNION
select 1, 
       rownum||';'||v.riga
  from tabrep, isteddu_v v
 where v.data_reg between substr(parametri,1,7) and substr(parametri,8,7) 
   and v.data_MAT between substr(parametri,15,7) and substr(parametri,22,7) 
   and chiave = 'EDDU' 
   and terminale = nvl(userenv('terminal'),'ISTEDDU')
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
     set valore_default = 'istatel\'||codice_istat||'_D3U_'||to_char(sysdate,'yymmdd')||'.csv'
   where parametro 	= 'TXTFILE'
     and voce_menu	= 'ISTEDDU'
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
-- 'V1.0 del 18/01/2018'  AM  Prima emissione
-- 'V2.0 del 16/02/2022'  AM  gestione viste isteddu_int / isteddu_v
--
   RETURN 'V2.0 del 16/02/2022';
END VERSIONE;
END ISTEDDU;
/
