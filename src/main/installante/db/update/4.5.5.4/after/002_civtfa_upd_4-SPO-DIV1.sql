--liquibase formatted sql
--changeset snocca:202301131246 runOnChange:true
declare
   d_esiste number;
begin
   begin
      SELECT INSTR(a.TESTO_4000, 'nato in <COMUNE_NASCITA_SPOSA>', 1)
        INTO d_esiste
        from civtfa a where a.formula = '4-SPO-DIV1' and a.riga = 1
         and rownum = 1
      ;
   exception
      when no_data_found then
         d_esiste := 0;
   end;
   if nvl(d_esiste, 0) > 0 then
   begin
      update civtfa set TESTO_4000 = replace(TESTO_4000, 'nato in <COMUNE_NASCITA_SPOSA>', 'nata in <COMUNE_NASCITA_SPOSA>')
       where formula = '4-SPO-DIV1' and riga = 1
      ;
   end;
   end if;
end;
/
