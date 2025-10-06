--liquibase formatted sql
--changeset amonopoli:202503251155_2 runOnChange:false stripComments:false
declare
w_istanze_ambinente	number;

begin
  begin
    select 1 into w_istanze_ambiente
      from a_istanze_ambiente
     where ambiente = 'A00'
       and rownum = 1
    ;
  exception
    when no_data_found then
         w_istanze_ambiente := 0;
    when others then
         w_istanze_ambiente := -1;
  end;

  if w_istanze_ambiente = 0 then
begin
INSERT INTO A_ISTANZE_AMBIENTE ( AMBIENTE, ENTE, GRUPPO_LING, DESCRIZIONE, USER_ORACLE, PASSWORD, LINK_ORACLE, DISLOCAZIONE, STAMPANTE, VERSIONE, DISLOCAZIONE_CLIENT)
VALUES ( 'A00', 'A00', '*', 'Ambiente di Sistema', '${global.db.a00.username}', '${global.db.a00.password}', NULL, '\\[nome_server]\si4\si4v3-[disco_server]:\si4\si4v3\-[nr_coda_stampa]', NULL, NULL, NULL);
end;
  end if;
end;
/
