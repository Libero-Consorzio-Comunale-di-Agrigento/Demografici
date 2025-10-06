--liquibase formatted sql
--changeset amonopoli:202503261018_2 runOnChange:false stripComments:false
CREATE OR REPLACE package body si4_tree is
function ordertree(p_level in number, p_figlio in varchar2)
return varchar2
is
begin
v_testo := substr(v_testo,1,(p_level-1)*4) || p_figlio;
return v_testo;
exception
when no_data_found then return(null);
end ordertree;

FUNCTION GET_ACRONIMO (wvoce_menu in varchar2) RETURN varchar2 IS
wacronimo varchar2(80);
BEGIN
  begin
   select acronimo
     into wacronimo
	 from a_voci_menu
	where voce_menu = wvoce_menu
	  ;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       Null;
     WHEN OTHERS THEN
       Null;
   end;
   RETURN wacronimo;
END GET_ACRONIMO;

FUNCTION GET_TIPO (wvoce_menu in varchar2) RETURN varchar2 IS
	  wtipo varchar2(1);
BEGIN
  begin
   select tipo
     into wtipo
	 from a_voci_menu
	where voce_menu = wvoce_menu
	  ;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       Null;
     WHEN OTHERS THEN
       Null;
   end;
   RETURN wtipo;
END GET_tipo;

FUNCTION GET_tipo_voce (wvoce_menu in varchar2) RETURN varchar2 IS
wtipo_voce varchar2(80);
BEGIN
  begin
   select tipo_voce
     into wtipo_voce
	 from a_voci_menu
	where voce_menu = wvoce_menu
	  ;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       Null;
     WHEN OTHERS THEN
       Null;
   end;
   RETURN wtipo_voce;
END GET_tipo_voce;

function GET_TITOLO (wvoce_menu in varchar2) RETURN varchar2 IS
wtitolo varchar2(80);
BEGIN
  begin
   select titolo
     into wtitolo
	 from a_voci_menu
	where voce_menu = wvoce_menu
	  ;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       Null;
     WHEN OTHERS THEN
       Null;
   end;
   RETURN wtitolo;
END GET_TITOLO;

end si4_tree;
/

