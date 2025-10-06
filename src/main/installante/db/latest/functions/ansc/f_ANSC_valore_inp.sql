--liquibase formatted sql
--changeset amonopoli:202305181156 runOnChange:true stripComments:false
CREATE OR REPLACE function f_ANSC_valore_inp
(a_parametro		IN	varchar2,
 a_posizione		IN	number,
 a_caratteri		IN	number,
 a_tipo			IN 	VARCHAR2,
 a_maiuscolo		IN 	varchar2)

return varchar2

IS

w_valore 	varchar2(255);
w_caratteri	number;

begin
  w_caratteri := a_caratteri;

  begin
    select rtrim(substr(inp.valore,a_posizione,w_caratteri))
      into w_valore
      from ansinp inp
     where inp.parametro = a_parametro
       and rownum	 = 1
    ;
    if a_tipo = '9' then
       if translate(w_valore,'0123456789','9999999999') in
	  ('9','99','999','9999','99999','999999','9999999',
	   '99999999','999999999','9999999999')
       then
 	  null;
       else
	  w_valore := 0;
       end if;
    elsif a_maiuscolo = 'S' then
       w_valore := upper(w_valore);
    end if;
    return w_valore;
  exception
    when others then
         return null;
  end;
end;
/

