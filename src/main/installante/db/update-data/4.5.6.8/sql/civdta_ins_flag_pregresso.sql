--liquibase formatted sql
--changeset snocca:202309271630_2 runOnChange:true stripComments:false
declare
   d_id_cta_ATL number;
   d_seq number;
   d_id_civddo_cia number;
begin
   -- NASCITE
   begin
      SELECT id
        INTO d_id_cta_ATL
        from civcta
       where tipo_Atto = 2 and sigla = 'ATL'
      ;
   exception
      when no_data_found then
         d_id_cta_ATL := 0;
   end;
   if nvl(d_id_cta_ATL, 0) > 0 then
     begin
       begin
         SELECT id
           INTO d_id_civddo_cia
           from civddo
          where tipo_Atto = 2 and cod_do = 'CI'
        ;
       exception
        when no_data_found then
           d_id_civddo_cia := 0;
       end;
       begin
         SELECT nvl(max(sequenza), 0)
           INTO d_seq
           from civdta
          where tipo_Atto = 2
         ;
         -- Originali
         d_seq := d_seq +1;
         insert into civdta (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, ID_CIVDDO_CIA, FLAG_PREGRESSO)
         select 2, 2, 'B', 'Atto Pregresso 2B - Originale', 'O', null, d_seq, '', '', null, '', null, null, null, '', d_id_cta_ATL, null, '', '', d_id_civddo_cia, 'S' from dual
         where not exists (select 1 from civdta where tipo_atto = 2 and  parte = 2 and serie = 'B' and natura = 'O' and flag_pregresso = 'S');
         -- Trascritti
         d_seq := d_seq +1;
         insert into civdta (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, ID_CIVDDO_CIA, FLAG_PREGRESSO)
         select 2, 2, 'B', 'Atto Pregresso 2B - Trascritto', 'T', null, d_seq, '', '', null, '', null, null, null, '', d_id_cta_ATL, null, '', '', null, 'S' from dual
         where not exists (select 1 from civdta where tipo_atto = 2 and  parte = 2 and serie = 'B' and natura = 'T' and flag_pregresso = 'S');
         -- Diversi
         d_seq := d_seq +1;
         insert into civdta (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, ID_CIVDDO_CIA, FLAG_PREGRESSO)
         select 2, 2, 'B', 'Atto Pregresso 2B - Diverso', 'D', null, d_seq, '', '', null, '', null, null, null, '', d_id_cta_ATL, null, '', '', null, 'S' from dual
         where not exists (select 1 from civdta where tipo_atto = 2 and  parte = 2 and serie = 'B' and natura = 'D' and flag_pregresso = 'S');
       end;
     end;
   end if;

   -- MATRIMONI
   begin
      SELECT id
        INTO d_id_cta_ATL
        from civcta
       where tipo_Atto = 4 and sigla = 'ATL'
      ;
   exception
      when no_data_found then
         d_id_cta_ATL := 0;
   end;
   if nvl(d_id_cta_ATL, 0) > 0 then
     begin
       begin
         SELECT id
           INTO d_id_civddo_cia
           from civddo
          where tipo_Atto = 4 and cod_do = 'CI'
        ;
       exception
        when no_data_found then
           d_id_civddo_cia := 0;
       end;
       begin
         SELECT nvl(max(sequenza), 0)
           INTO d_seq
           from civdta
          where tipo_Atto = 4
         ;
         -- Originali
         d_seq := d_seq +1;
         insert into civdta (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, ID_CIVDDO_CIA, FLAG_PREGRESSO)
         select 4, 2, 'C', 'Atto Pregresso 2C - Originale', 'O', null, d_seq, '', '', null, '', null, null, null, '', d_id_cta_ATL, null, '', '', d_id_civddo_cia, 'S' from dual
         where not exists (select 1 from civdta where tipo_atto = 4 and  parte = 2 and serie = 'C' and natura = 'O' and flag_pregresso = 'S');
         -- Trascritti
         d_seq := d_seq +1;
         insert into civdta (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, ID_CIVDDO_CIA, FLAG_PREGRESSO)
         select 4, 2, 'C', 'Atto Pregresso 2C - Trascritto', 'T', null, d_seq, '', '', null, '', null, null, null, '', d_id_cta_ATL, null, '', '', null, 'S' from dual
         where not exists (select 1 from civdta where tipo_atto = 4 and  parte = 2 and serie = 'C' and natura = 'T' and flag_pregresso = 'S');
         -- Diversi
         d_seq := d_seq +1;
         insert into civdta (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, ID_CIVDDO_CIA, FLAG_PREGRESSO)
         select 4, 2, 'C', 'Atto Pregresso 2C - Diverso', 'D', null, d_seq, '', '', null, '', null, null, null, '', d_id_cta_ATL, null, '', '', null, 'S' from dual
         where not exists (select 1 from civdta where tipo_atto = 4 and  parte = 2 and serie = 'C' and natura = 'D' and flag_pregresso = 'S');
       end;
     end;
   end if;

   -- MORTI
   begin
      SELECT id
        INTO d_id_cta_ATL
        from civcta
       where tipo_Atto = 5 and sigla = 'ATL'
      ;
   exception
      when no_data_found then
         d_id_cta_ATL := 0;
   end;
   if nvl(d_id_cta_ATL, 0) > 0 then
     begin
       begin
         SELECT id
           INTO d_id_civddo_cia
           from civddo
          where tipo_Atto = 5 and cod_do = 'CI'
        ;
       exception
        when no_data_found then
           d_id_civddo_cia := 0;
       end;
       begin
         SELECT nvl(max(sequenza), 0)
           INTO d_seq
           from civdta
          where tipo_Atto = 5
         ;
         -- Originali
         d_seq := d_seq +1;
         insert into civdta (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, ID_CIVDDO_CIA, FLAG_PREGRESSO)
         select 5, 2, 'C', 'Atto Pregresso 2C - Originale', 'O', null, d_seq, '', '', null, '', null, null, null, '', d_id_cta_ATL, null, '', '', d_id_civddo_cia, 'S' from dual
         where not exists (select 1 from civdta where tipo_atto = 5 and  parte = 2 and serie = 'C' and natura = 'O' and flag_pregresso = 'S');
         -- Trascritti
         d_seq := d_seq +1;
         insert into civdta (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, ID_CIVDDO_CIA, FLAG_PREGRESSO)
         select 5, 2, 'C', 'Atto Pregresso 2C - Trascritto', 'T', null, d_seq, '', '', null, '', null, null, null, '', d_id_cta_ATL, null, '', '', null, 'S' from dual
         where not exists (select 1 from civdta where tipo_atto = 5 and  parte = 2 and serie = 'C' and natura = 'T' and flag_pregresso = 'S');
         -- Diversi
         d_seq := d_seq +1;
         insert into civdta (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, ID_CIVDDO_CIA, FLAG_PREGRESSO)
         select 5, 2, 'C', 'Atto Pregresso 2C - Diverso', 'D', null, d_seq, '', '', null, '', null, null, null, '', d_id_cta_ATL, null, '', '', null, 'S' from dual
         where not exists (select 1 from civdta where tipo_atto = 5 and  parte = 2 and serie = 'C' and natura = 'D' and flag_pregresso = 'S');
       end;
     end;
   end if;

   -- UNIONI CIVILI
   /* per coerenza con gli altri tipi di atto teniamo solo la gestione delle categorie con più tipi di atto collegati
   begin
      SELECT id
        INTO d_id_cta_O1
        from civcta
       where tipo_Atto = -4 and sigla = 'O1'
      ;
   exception
      when no_data_found then
         d_id_cta_O1 := 0;
   end;
   if nvl(d_id_cta_O1, 0) > 0 then
     begin
       begin
         SELECT id
           INTO d_id_civddo_cia
           from civddo
          where tipo_Atto = -4 and cod_do = 'CI'
        ;
       exception
        when no_data_found then
           d_id_civddo_cia := 0;
       end;
       begin
         SELECT nvl(max(sequenza), 0)
           INTO d_seq
           from civdta
          where tipo_Atto = -4
         ;
         -- Originali parte prima
         d_seq := d_seq +1;
         insert into civdta (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, ID_CIVDDO_CIA, FLAG_PREGRESSO)
         select -4, 1, '', 'Atto pregresso parte 1 Originale', 'O', null, d_seq, '', '', null, '', null, null, null, '', d_id_cta_O1, null, '', '', d_id_civddo_cia, 'S' from dual
         where not exists (select 1 from civdta where tipo_atto = -4 and  parte = 1 and natura = 'O' and flag_pregresso = 'S');
       end;
     end;
   end if;  */   
   begin
      SELECT id
        INTO d_id_cta_ATL
        from civcta
       where tipo_Atto = -4 and sigla = 'ATL'
      ;
   exception
      when no_data_found then
         d_id_cta_ATL := 0;
   end;
   if nvl(d_id_cta_ATL, 0) > 0 then
     begin
       begin
         SELECT id
           INTO d_id_civddo_cia
           from civddo
          where tipo_Atto = -4 and cod_do = 'CI'
        ;
       exception
        when no_data_found then
           d_id_civddo_cia := 0;
       end;
       begin
         SELECT nvl(max(sequenza), 0)
           INTO d_seq
           from civdta
          where tipo_Atto = -4
         ;
         -- Originali
         d_seq := d_seq +1;
         insert into civdta (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, ID_CIVDDO_CIA, FLAG_PREGRESSO)
         select -4, 2, '', 'Atto Pregresso Parte 2 - Originale', 'O', null, d_seq, '', '', null, '', null, null, null, '', d_id_cta_ATL, null, '', '', d_id_civddo_cia, 'S' from dual
         where not exists (select 1 from civdta where tipo_atto = -4 and  parte = 2 and natura = 'O' and flag_pregresso = 'S');
       end;
     end;
   end if;
   
   begin
      SELECT id
        INTO d_id_cta_ATL
        from civcta
       where tipo_Atto = -4 and sigla = 'T2'
      ;
   exception
      when no_data_found then
         d_id_cta_ATL := 0;
   end;
   if nvl(d_id_cta_ATL, 0) > 0 then
     begin
       begin
         SELECT nvl(max(sequenza), 0)
           INTO d_seq
           from civdta
          where tipo_Atto = -4
         ;
         -- Trascritti
         d_seq := d_seq +1;
         insert into civdta (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, ID_CIVDDO_CIA, FLAG_PREGRESSO)
         select -4, 2, '', 'Atto Pregresso Parte 2 - Trascritto', 'T', null, d_seq, '', '', null, '', null, null, null, '', d_id_cta_ATL, null, '', '', null, 'S' from dual
         where not exists (select 1 from civdta where tipo_atto = -4 and  parte = 2 and natura = 'T' and flag_pregresso = 'S');
       end;
     end;
   end if; 
   
   begin
      SELECT id
        INTO d_id_cta_ATL
        from civcta
       where tipo_Atto = -4 and sigla = 'ATL'
      ;
   exception
      when no_data_found then
         d_id_cta_ATL := 0;
   end;
   if nvl(d_id_cta_ATL, 0) > 0 then
     begin
       begin
         SELECT nvl(max(sequenza), 0)
           INTO d_seq
           from civdta
          where tipo_Atto = -4
         ;
         -- Diversi
         d_seq := d_seq +1;
         insert into civdta (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, ID_CIVDDO_CIA, FLAG_PREGRESSO)
         select -4, 2, '', 'Atto Pregresso Parte 2 - Diverso', 'D', null, d_seq, '', '', null, '', null, null, null, '', d_id_cta_ATL, null, '', '', null, 'S' from dual
         where not exists (select 1 from civdta where tipo_atto = -4 and  parte = 2 and natura = 'D' and flag_pregresso = 'S');
       end;
     end;
   end if;   

   -- CITTADINANZE
   begin
      SELECT id
        INTO d_id_cta_ATL
        from civcta
       where tipo_Atto = 1 and sigla = 'DAQ'
      ;
   exception
      when no_data_found then
         d_id_cta_ATL := 0;
   end;
   if nvl(d_id_cta_ATL, 0) > 0 then
     begin
       begin
         SELECT nvl(max(sequenza), 0)
           INTO d_seq
           from civdta
          where tipo_Atto = 1
         ;
         -- Acquisto
         d_seq := d_seq +1;
         insert into civdta (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, ID_CIVDDO_CIA, FLAG_PREGRESSO)
         select 1, null, '', 'Atto Pregresso - Acquisto', 'A', null, d_seq, '', '', null, '', null, null, null, '', d_id_cta_ATL, null, '', '', null, 'S' from dual
         where not exists (select 1 from civdta where tipo_atto = 1 and natura = 'A' and flag_pregresso = 'S');
        end;
     end;
   end if;
   begin
      SELECT id
        INTO d_id_cta_ATL
        from civcta
       where tipo_Atto = 1 and sigla = 'DPE'
      ;
   exception
      when no_data_found then
         d_id_cta_ATL := 0;
   end;
   if nvl(d_id_cta_ATL, 0) > 0 then
     begin
       begin
         SELECT nvl(max(sequenza), 0)
           INTO d_seq
           from civdta
          where tipo_Atto = 1
         ;
         -- Perdita
         d_seq := d_seq +1;
         insert into civdta (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, ID_CIVDDO_CIA, FLAG_PREGRESSO)
         select 1, null, '', 'Atto Pregresso - Perdita', 'P', null, d_seq, '', '', null, '', null, null, null, '', d_id_cta_ATL, null, '', '', null, 'S' from dual
         where not exists (select 1 from civdta where tipo_atto = 1 and natura = 'P' and flag_pregresso = 'S');
        end;
     end;
   end if;
   begin
      SELECT id
        INTO d_id_cta_ATL
        from civcta
       where tipo_Atto = 1 and sigla = 'GIU'
      ;
   exception
      when no_data_found then
         d_id_cta_ATL := 0;
   end;
   if nvl(d_id_cta_ATL, 0) > 0 then
     begin
       begin
         SELECT nvl(max(sequenza), 0)
           INTO d_seq
           from civdta
          where tipo_Atto = 1
         ;
         -- Giuramento
         d_seq := d_seq +1;
         insert into civdta (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, ID_CIVDDO_CIA, FLAG_PREGRESSO)
         select 1, null, '', 'Atto Pregresso - Giuramento', 'D', null, d_seq, '', '', null, '', null, null, null, '', d_id_cta_ATL, null, '', '', null, 'S' from dual
         where not exists (select 1 from civdta where tipo_atto = 1 and natura = 'D' and flag_pregresso = 'S' and id_civcta = d_id_cta_ATL);
        end;
     end;
   end if;
   begin
      SELECT id
        INTO d_id_cta_ATL
        from civcta
       where tipo_Atto = 1 and sigla = 'ATL'
      ;
   exception
      when no_data_found then
         d_id_cta_ATL := 0;
   end;
   if nvl(d_id_cta_ATL, 0) > 0 then
     begin
       begin
         SELECT nvl(max(sequenza), 0)
           INTO d_seq
           from civdta
          where tipo_Atto = 1
         ;
         -- Diverso
         d_seq := d_seq +1;
         insert into civdta (TIPO_ATTO, PARTE, SERIE, DESCRIZIONE, NATURA, COD_MI, SEQUENZA, NOTE, FLAG_WEGO, QUERY_WEGO, TYPE_WEGO, ID, NUM_COLONNE, NUM_RIGHE, FLAG_DIMENSIONI_FISSE, ID_CIVCTA, ID_CIVDMI, FLAG_DIVORZIO, TIPO_DIVORZIO, ID_CIVDDO_CIA, FLAG_PREGRESSO)
         select 1, null, '', 'Atto Pregresso - Diverso', 'D', null, d_seq, '', '', null, '', null, null, null, '', d_id_cta_ATL, null, '', '', null, 'S' from dual
         where not exists (select 1 from civdta where tipo_atto = 1 and natura = 'D' and flag_pregresso = 'S' and id_civcta = d_id_cta_ATL);
        end;
     end;
   end if;   

end;
/

