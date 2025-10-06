--liquibase formatted sql
--changeset snocca:202405161710 runOnChange:true
declare
   d_esiste number;
begin
   begin
      SELECT INSTR(a.TESTO_4000, 'insussistenza di impedimenti alla pubblicazione, che questa, si fara'' in <COMUNE_MATRIMONIO>.', 1)
        INTO d_esiste
        from civtfa a where a.formula = '3-PDO' and a.riga = 1
         and rownum = 1
      ;
   exception
      when no_data_found then
         d_esiste := 0;
   end;
   if nvl(d_esiste, 0) > 0 then
   begin
      update civtfa set TESTO_4000 = replace(TESTO_4000, 'insussistenza di impedimenti alla pubblicazione, che questa, si fara'' in <COMUNE_MATRIMONIO>.',
      'insussistenza di impedimenti alla pubblicazione, che questa, si fara'' in <COMUNE_AFFISSIONE_PUB_1>.')
       where formula = '3-PDO' and riga = 1
      ;
   end;
   end if;
end;
/
