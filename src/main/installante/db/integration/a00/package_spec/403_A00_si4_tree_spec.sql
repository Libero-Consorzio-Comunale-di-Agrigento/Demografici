--liquibase formatted sql
--changeset amonopoli:202503261018_1 runOnChange:false stripComments:false
CREATE OR REPLACE package si4_tree is

function ordertree(p_level in number, p_figlio in varchar2)
return varchar2;

FUNCTION GET_ACRONIMO (wvoce_menu in varchar2)
RETURN varchar2;

FUNCTION GET_TIPO (wvoce_menu in varchar2)
RETURN varchar2;

FUNCTION GET_tipo_voce (wvoce_menu in varchar2)
RETURN varchar2;

function GET_TITOLO (wvoce_menu in varchar2)
RETURN varchar2;

v_testo varchar2(200);
end si4_tree;
/
