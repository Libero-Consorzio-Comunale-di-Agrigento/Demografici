--liquibase formatted sql
--changeset amonopoli:202503260910_1 runOnChange:false stripComments:false
CREATE OR REPLACE package si4_base64
as
    function encode(r in raw) return varchar2;
    function decode(p_base64 in varchar2) return raw;
end si4_base64;
/
