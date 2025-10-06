--liquibase formatted sql
--changeset amonopoli:202307141620 runOnChange:true stripComments:false
create or replace function f_CIV_esiste_atto_x_tipo_atto
(a_tipo_atto	IN	number
,a_id_civdta	IN	number
)

return varchar2

IS            

w_errore	varchar2(4000);
w_esiste  	number := 0;

begin
  w_errore := '';

  if a_tipo_atto is not null and a_id_civdta is not null then

    if a_tipo_atto = 1 then
       begin
         select 1
           into w_esiste
           from civcit cit
          where id_civdta = a_id_civdta
            and rownum = 1
         ;
       exception
         when no_data_found then
              w_errore := '';
       end;

    elsif a_tipo_atto = 2 then
       begin
         select 1
           into w_esiste
           from civnas nas
          where id_civdta = a_id_civdta
            and rownum = 1
         ;
       exception
         when no_data_found then
              w_errore := '';
       end;

    elsif a_tipo_atto = 3 then
       begin
         select 1
           into w_esiste
           from civpub pub
          where id_civdta = a_id_civdta
            and rownum = 1
         ;
       exception
         when no_data_found then
              w_errore := '';
       end;

    elsif a_tipo_atto = 4 then
       begin
         select 1
           into w_esiste
           from civmat mat
          where id_civdta = a_id_civdta
            and rownum = 1
         ;
       exception
         when no_data_found then
              w_errore := '';
       end;

    elsif a_tipo_atto = -4 then
       begin
         select 1
           into w_esiste
           from civuci uci
          where id_civdta = a_id_civdta
            and rownum = 1
         ;
       exception
         when no_data_found then
              w_errore := '';
       end;

    elsif a_tipo_atto = 5 then
       begin
         select 1
           into w_esiste
           from civcit cit
          where id_civdta = a_id_civdta
            and rownum = 1
         ;
       exception
         when no_data_found then
              w_errore := '';
       end;

    end if;  -- if per tipo atto

    if w_esiste = 1 then
       w_errore := 'Operazione non consentita: cancellazione permessa per i soli tipi di atto NON referenziati da alcun atto';
    end if;

  end if; --if a_tipo_atto is not null and a_id_civdta is not null

  return w_errore;
exception
  when others then
       w_errore := 'Errore in cancellazione tipo atto';
       return w_errore;
end;
/
