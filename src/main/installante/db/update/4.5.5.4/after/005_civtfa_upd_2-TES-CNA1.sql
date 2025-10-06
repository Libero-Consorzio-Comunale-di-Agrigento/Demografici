--liquibase formatted sql
--changeset snocca:202301301703_1 runOnChange:true
declare
   d_esiste number;
begin
   begin
      SELECT INSTR(a.TESTO_4000, 'Atto Numero <NOTA_RIF>;<ANNO_NOTA_RIF> del Registro', 1)
        INTO d_esiste
        from civtfa a where a.formula = '2-TES-CNA1' and a.riga = 1
         and rownum = 1
      ;
   exception
      when no_data_found then
         d_esiste := 0;
   end;
   if nvl(d_esiste, 0) > 0 then
   begin
      update civtfa set TESTO_4000 = replace(TESTO_4000, 'Atto Numero <NOTA_RIF>;<ANNO_NOTA_RIF> del Registro', 'Atto Numero <NOTA_RIF>/<ANNO_NOTA_RIF> del Registro')
       where formula = '2-TES-CNA1' and riga = 1
      ;
   end;
   end if;
end;
/
