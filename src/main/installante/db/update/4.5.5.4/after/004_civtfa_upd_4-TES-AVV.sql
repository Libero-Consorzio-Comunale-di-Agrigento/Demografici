--liquibase formatted sql
--changeset snocca:202301301703_3 runOnChange:true
declare
   d_esiste number;
begin
   begin
      SELECT INSTR(a.TESTO_4000, 'EX ART. 6, COMMA 2, PRIMA PARTE DEL D.L. 132;2014, CONVERTITO IN LEGGE CON MODIFICHE DALLA L. 10 NOVEMBRE 2014, N. 162', 1)
        INTO d_esiste
        from civtfa a where a.formula = '4-TES-AVV' and a.riga = 1
         and rownum = 1
      ;
   exception
      when no_data_found then
         d_esiste := 0;
   end;
   if nvl(d_esiste, 0) > 0 then
   begin
      update civtfa set TESTO_4000 = replace(TESTO_4000, 'EX ART. 6, COMMA 2, PRIMA PARTE DEL D.L. 132;2014, CONVERTITO IN LEGGE CON MODIFICHE DALLA L. 10 NOVEMBRE 2014, N. 162',
      'EX ART. 6, COMMA 2, PRIMA PARTE DEL D.L. 132/2014, CONVERTITO IN LEGGE CON MODIFICHE DALLA L. 10 NOVEMBRE 2014, N. 162')
       where formula = '4-TES-AVV' and riga = 1
      ;
   end;
   end if;
end;
/
