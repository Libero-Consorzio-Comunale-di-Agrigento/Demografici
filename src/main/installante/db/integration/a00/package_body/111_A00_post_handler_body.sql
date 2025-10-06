--liquibase formatted sql
--changeset amonopoli:202503261011_2 runOnChange:false stripComments:false
CREATE OR REPLACE PACKAGE BODY post_handler IS
 function torna_post return number is
    begin
	return post_handler.a_post;
    end;
  procedure setta_post(valore in number) is
	begin
		post_handler.a_post := valore;
	end;
END;
/

