--liquibase formatted sql
--changeset amonopoli:202503261011_1 runOnChange:false stripComments:false
CREATE OR REPLACE PACKAGE post_handler IS
  a_post number(1) :=0;
  function torna_post return number;
  procedure setta_post(valore in number);
END;
/
