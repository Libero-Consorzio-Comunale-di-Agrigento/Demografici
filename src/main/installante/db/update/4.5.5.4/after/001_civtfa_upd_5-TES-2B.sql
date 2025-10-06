--liquibase formatted sql
--changeset snocca:202301041746 runOnChange:true
declare
   d_esiste number;
begin
   begin
      SELECT INSTR(a.TESTO_4000, 'un <TESTATA_DOCUMENTO>', 1)
        INTO d_esiste
        from civtfa a where a.formula = '5-TES-2B' and a.riga = 1
         and rownum = 1
      ;
   exception
      when no_data_found then
         d_esiste := 0;
   end;
   if nvl(d_esiste, 0) > 0 then
   begin
      --insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
      --select 'X5-TES-2B', 1, '', TESTO_4000, TESTO_A3
        --from civtfa a where a.formula = '5-TES-2B' and a.riga = 1
         --and not exists (select 1 from civtfa b where b.formula = 'X5-TES-2B')
      --;
      update civtfa set TESTO_4000 = replace(TESTO_4000, 'un <TESTATA_DOCUMENTO>', '<TESTATA_DOCUMENTO>')
       where formula = '5-TES-2B' and riga = 1
      ;
   end;
   end if;
end;
/
