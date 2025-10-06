--liquibase formatted sql
--changeset amonopoli:202312211140_2 runOnChange:true stripComments:false
CREATE OR REPLACE package body ISTEDDVX is
PROCEDURE MAIN   (prenotazione  IN number,
                  PASSO          IN number) is
p_prenotazione number;
p_passo        number;
P_pagina 	   number :=1;
P_riga   	   number :=0;
cursor sel_dati is
select 0, int.riga
  from isteddv_int int
 where int.cod_modello = 'DDV'
UNION
select 1, ddv.riga
  from isteddv_v ddv, tabrep
 where ddv.data_REG    between substr(parametri,1,7) and substr(parametri,8,7) 
   and ddv.data_MAT    between substr(parametri,15,7) and substr(parametri,22,7) 
--   and ddv.cod_modello = 'DDV'
   and chiave          = 'EDDV' 
   and terminale       = nvl(userenv('terminal'),'ISTEDDV')
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
     set valore_default = 'istatel\'||codice_istat||'_DivSep_'||to_char(sysdate,'yymmdd')||'.csv'
   where parametro 	= 'TXTFILE'
     and voce_menu	= 'ISTEDDV'
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
-- 'V1.0 del 22/02/2018'  AM  Prima emissione
-- 'V2.0 del 16/02/2022'  AM  Gestione viste isteddv_int / isteddv_v
-- 'V2.1 del 21/12/2023'  AM  Adeguamenti 2024 - Rename pkg per gestione "vecchio tracciato"
--
   RETURN 'V2.1 del 21/12/2023';
END VERSIONE;
END ISTEDDVX;
/

