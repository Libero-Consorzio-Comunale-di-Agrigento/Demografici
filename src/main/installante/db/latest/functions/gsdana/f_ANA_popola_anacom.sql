--liquibase formatted sql
--changeset amonopoli:202511211450 runOnChange:true stripComments:false
create or replace function f_ANA_popola_anacom
(a_anagrafe		IN	varchar2
,a_tipo_evento		IN	varchar2
,a_anno_pratica		IN	number
,a_pratica		IN	number
,a_flag_priorita	IN	varchar2
,a_codice_co		IN	number
)

return varchar2

IS

w_anagrafe		varchar2(255) := upper(a_anagrafe);
w_tipo_evento		varchar2(255) := upper(a_tipo_evento);
w_flag_priorita		varchar2(255) := upper(a_flag_priorita);

w_anno_pratica		number := a_anno_pratica;
w_pratica		number := a_pratica;
w_codice_co		number := a_codice_co;

w_matricola_mov_prec	number;
w_esiste_anacom_C	number;

cursor sel_dct_P is
select dct_v.*
     , to_number(null) matricola 
  from anadct_v dct_v
 where dct_v.anagrafe               = w_anagrafe
   and dct_v.tipo_evento            = w_tipo_evento
   and nvl(dct_v.flag_priorita,'N') = 'S'
   and dct_v.flag_soggetto          is null
   and ((w_codice_co is null
         and not exists (select 1 from anacom com
                          where anagrafe     = w_anagrafe
                            and tipo_evento  = w_tipo_evento
                            and anno_pratica = w_anno_pratica
                            and pratica      = w_pratica)
        )
        OR
        (w_codice_co is not null
         and dct_v.codice_co = w_codice_co
         and not exists (select 1 from anacom com
                          where anagrafe     = w_anagrafe
                            and tipo_evento  = w_tipo_evento
                            and anno_pratica = w_anno_pratica
                            and pratica      = w_pratica
                            and codice_co    = dct_v.codice_co)
        )
       )
UNION 
-- query x flag_soggetto = 'S' (soggetti attivi della pratica)
select dct_v.* 
     , sog_v.matricola
  from (select 'RES' anagrafe, 'I' tipo_evento, anno_dic anno_pratica, numero_dic pratica, matricola from anaapm where flag_soggetto = 'S' and annullamento is null
        UNION
        select 'RES' anagrafe, 'E' tipo_evento, anno_pratica, pratica, matricola from anacrm where flag_soggetto = 'S' and flag_annullamento is null
        UNION
        select 'RES' anagrafe, 'C' tipo_evento, anno_dic anno_pratica, numero_dic pratica, matricola from anacpm where flag_soggetto = 'S' and annullamento is null
        UNION
        select 'AIR' anagrafe, 'I' tipo_evento, anno_protocollo_aire anno_pratica, protocollo_aire pratica, matricola from anaa0m where flag_soggetto = 'S' and flag_annullamento is null
        UNION
        select 'AIR' anagrafe, 'E' tipo_evento, anno_protocollo_aire anno_pratica, protocollo_aire pratica, matricola from anacam where flag_soggetto = 'S' and flag_annullamento is null
        UNION
        select 'AIR' anagrafe, 'C' tipo_evento, anno_protocollo_aire anno_pratica, protocollo_aire pratica, matricola from anac0m where flag_soggetto = 'S' and annullamento is null) sog_v
     , anadct_v dct_v
 where sog_v.anagrafe               = w_anagrafe
   and sog_v.tipo_evento            = w_tipo_evento
   and sog_v.anno_pratica           = w_anno_pratica
   and sog_v.pratica                = w_pratica
   and dct_v.anagrafe               = w_anagrafe
   and dct_v.tipo_evento            = w_tipo_evento
   and nvl(dct_v.flag_priorita,'N') = 'S'
   and dct_v.flag_soggetto          = 'S'
   and ((w_codice_co is null
         and not exists (select 1 from anacom com
                          where anagrafe     = w_anagrafe
                            and tipo_evento  = w_tipo_evento
                            and anno_pratica = w_anno_pratica   
                            and pratica      = w_pratica
                            and matricola    = sog_v.matricola))
        OR
        (w_codice_co is not null
         and dct_v.codice_co = w_codice_co
         and not exists (select 1 from anacom com
                          where anagrafe     = w_anagrafe
                            and tipo_evento  = w_tipo_evento
                            and anno_pratica = w_anno_pratica   
                            and pratica      = w_pratica
                            and codice_co    = dct_v.codice_co
                            and matricola    = sog_v.matricola)
        )
       )
UNION
-- query x flag_soggetto = 'N' (soggetti annullati della pratica)
select dct_v.* 
     , sog_v.matricola
  from (select 'RES' anagrafe, 'I' tipo_evento, anno_dic anno_pratica, numero_dic pratica, matricola from anaapm where flag_soggetto = 'S' and annullamento = 'S'
        UNION
        select 'RES' anagrafe, 'E' tipo_evento, anno_pratica, pratica, matricola from anacrm where flag_soggetto = 'S' and flag_annullamento = 'S'
        UNION
        select 'RES' anagrafe, 'C' tipo_evento, anno_dic anno_pratica, numero_dic pratica, matricola from anacpm where flag_soggetto = 'S' and annullamento = 'S'
        UNION
        select 'AIR' anagrafe, 'I' tipo_evento, anno_protocollo_aire anno_pratica, protocollo_aire pratica, matricola from anaa0m  where flag_soggetto = 'S' and flag_annullamento = 'S'
        UNION
        select 'AIR' anagrafe, 'E' tipo_evento, anno_protocollo_aire anno_pratica, protocollo_aire pratica, matricola from anacam  where flag_soggetto = 'S' and flag_annullamento = 'S'
        UNION
        select 'AIR' anagrafe, 'C' tipo_evento, anno_protocollo_aire anno_pratica, protocollo_aire pratica, matricola from anac0m  where flag_soggetto = 'S' and annullamento = 'S') sog_v
     , anadct_v dct_v
 where sog_v.anagrafe               = w_anagrafe
   and sog_v.tipo_evento            = w_tipo_evento
   and sog_v.anno_pratica           = w_anno_pratica
   and sog_v.pratica                = w_pratica
   and dct_v.anagrafe               = w_anagrafe
   and dct_v.tipo_evento            = w_tipo_evento
   and nvl(dct_v.flag_priorita,'N') = 'S'
   and dct_v.flag_soggetto          = 'N'
   and ((w_codice_co is null
         and not exists (select 1 from anacom com
                          where anagrafe     = w_anagrafe
                            and tipo_evento  = w_tipo_evento
                            and anno_pratica = w_anno_pratica   
                            and pratica      = w_pratica
                            and matricola    = sog_v.matricola))
        OR
        (w_codice_co is not null
         and dct_v.codice_co = w_codice_co
         and not exists (select 1 from anacom com
                          where anagrafe     = w_anagrafe
                            and tipo_evento  = w_tipo_evento
                            and anno_pratica = w_anno_pratica   
                            and pratica      = w_pratica
                            and codice_co    = dct_v.codice_co
                            and matricola    = sog_v.matricola)
        )
       )
;

cursor sel_mov is
       select mov.matricola w_ord_1, mov.data_reg w_ord_2, mov.cod_mov w_ord_3,
              mov.anno_progr, mov.numero_progr, mov.data_reg, mov.cod_mov, mov.cod_eve, mov.cod_variazione, mov.matricola
         from anamov mov, anadce dce
        where anno_progr    != 9999 and numero_progr != 9999999
          and anno_progr    is not null
          and numero_progr  is not null
--          and not exists (select 'x' from anacom b
--                           where b.anno_progr	= mov.anno_progr
--                             and b.numero_progr	= mov.numero_progr)
          and mov.pratica                 = a_pratica 
          and mov.anno_pratica            = a_anno_pratica 
          and mov.cod_mov                 = dce.cod_mov
          and mov.cod_eve                 = dce.cod_eve
          and nvl(mov.cod_variazione,' ') = nvl(dce.cod_variazione,' ')
          and dce.anagrafe                = a_anagrafe
          and dce.tipo_evento             = a_tipo_evento
        order by 1, 2, 3 desc
;
cursor sel_dct_C (w_cod_mov number, w_cod_eve number, w_matricola number) is
select dct_v.*
  from anadct_v dct_v
 where dct_v.anagrafe               = a_anagrafe
   and dct_v.tipo_evento            = a_tipo_evento
   and nvl(dct_v.flag_priorita,'N') = 'N'
   and dct_v.numero_copie           > 0
   and ((w_codice_co is null and w_esiste_anacom_C = 0
        )
        OR
        (w_codice_co is not null
         and dct_v.codice_co = w_codice_co
         and not exists (select 1 from anacom com
                          where anagrafe     = w_anagrafe
                            and tipo_evento  = w_tipo_evento
                            and anno_pratica = w_anno_pratica   
                            and pratica      = w_pratica
                            and codice_co    = dct_v.codice_co
                            and matricola    = w_matricola)
        )
       )
 order by dct_v.cod_modello, dct_v.codice_co
;
cursor sel_doc (w_ente_destinatario number, w_tipo_documento varchar2, w_matricola number) is
select distinct doc.ente_emissione
  from anadoc doc
 where doc.matricola              = w_matricola
   and doc.tipo_documento         = w_tipo_documento
   and doc.natura_documento       != 'A'
   and doc.ente_emissione         = nvl(w_ente_destinatario,doc.ente_emissione)
   and nvl(w_ente_destinatario,0) >= 0
UNION
select distinct doc.ente_emissione
  from anadoc doc
 where doc.matricola              = w_matricola
   and doc.tipo_documento         = w_tipo_documento
   and doc.natura_documento       != 'A'
   and doc.ente_emissione         != (nvl(w_ente_destinatario,0) * -1)
   and nvl(w_ente_destinatario,0) < 0
;
cursor sel_dcp (w_codice number, w_modello varchar2) is
select replace(dcc.condizione_sql,'P_MODELLO',''''||w_modello||'''') condizione_sql
  from anadcc dcc, anadcp dcp
 where dcc.cod_cc    = dcp.cod_condizione
   and dcp.codice_co = w_codice
;

w_comunicazione		varchar2(255);
w_count_com		number;

w_matricola		number;
w_cognome_nome		varchar2(255);
w_cod_mov		number;
w_cod_eve		number;
w_data_reg		number;
w_anno_progr		number;
w_numero_progr		number;
w_ente_lp		number;
w_numero_copie		number;

w_stringa               varchar2(4000);

w_return		clob;

begin

  if nvl(w_flag_priorita,'N') = 'S' then
     w_count_com := 0;
     for rec_dct in sel_dct_P loop
         if rec_dct.anagrafe||rec_dct.tipo_evento = 'RESI' then
            w_comunicazione := 'IAPR';
         elsif rec_dct.anagrafe||rec_dct.tipo_evento = 'RESE' then
            w_comunicazione := 'CABI';
         elsif rec_dct.anagrafe||rec_dct.tipo_evento = 'RESC' then
            w_comunicazione := 'CAPR';
         elsif rec_dct.anagrafe||rec_dct.tipo_evento = 'AIRI' then
            w_comunicazione := 'IAIR';
         elsif rec_dct.anagrafe||rec_dct.tipo_evento = 'AIRE' then
            w_comunicazione := 'CABA';
         elsif rec_dct.anagrafe||rec_dct.tipo_evento = 'AIRC' then
            w_comunicazione := 'KAIR';
         elsif rec_dct.anagrafe||rec_dct.tipo_evento = 'RESR' then
            w_comunicazione := 'RANR';
         elsif rec_dct.anagrafe||rec_dct.tipo_evento = 'AIRR' then
            w_comunicazione := 'RANA';
         else
            w_comunicazione := 'SAPW';
         end if;

         w_comunicazione := w_comunicazione||'_'||rec_dct.cod_modello;

         begin
           insert into anacom
                  (COMUNICAZIONE, MATRICOLA, COGNOME_NOME, 
                   ANNO_PRATICA, PRATICA, COD_MOV, COD_EVE, DATA_REG, ANNO_PROGR, NUMERO_PROGR, 
                   ENTE_LP, NUMERO_COPIE,
                   ID, ANAGRAFE, TIPO_EVENTO, CODICE_CO, STAMPA_ESEGUITA,  
                   D_DATA_REG)
           values (w_comunicazione, rec_dct.matricola, '', 
                   w_anno_pratica, w_pratica, '', '', '', '', '', 
                   rec_dct.ente_destinatario, rec_dct.numero_copie,
                   '', w_anagrafe, w_tipo_evento, rec_dct.codice_co, 'NO', 
                   '')
           ;
           if sql%found then
              w_count_com := w_count_com + 1;
           end if;
         exception 
           when others then
                w_count_com := -1;
         end;
     end loop;

  elsif nvl(w_flag_priorita,'N') = 'N' then
     w_matricola_mov_prec := 0;
     for rec_mov in sel_mov loop
         if w_matricola_mov_prec != rec_mov.matricola then
            w_count_com          := 0;
         end if;
         w_esiste_anacom_C := 0;
         if w_count_com = 0 then
            if a_codice_co is null then
               begin
                 select 1 
                   into w_esiste_anacom_C
                   from anacom com
                  where anagrafe     = w_anagrafe
                    and tipo_evento  = w_tipo_evento
                    and anno_pratica = w_anno_pratica
                    and pratica      = w_pratica
                    and cod_mov      = rec_mov.cod_mov
                    and cod_eve      = rec_mov.cod_eve
                    and matricola    = rec_mov.matricola
                    and rownum = 1
                 ;
               exception
                 when others then
                      w_esiste_anacom_C := 0;
               end;
            end if;
         end if;

         for rec_dct in sel_dct_C (rec_mov.cod_mov,rec_mov.cod_eve,rec_mov.matricola) loop
             if rec_dct.tipo_documento_rif is not null then
                for rec_doc in sel_doc (rec_dct.ente_destinatario, rec_dct.tipo_documento_rif, rec_mov.matricola) loop
                    w_stringa := 'select ''SCAW_'||rec_dct.cod_modello||''','||
                                 '       mov.matricola, mov.cognome_nome,'||
                                 '       mov.anno_pratica, mov.pratica, mov.cod_mov, mov.cod_eve,'||
                                 '       mov.data_reg, mov.anno_progr, mov.numero_progr,'||
                                 '      '||nvl(to_char(rec_doc.ente_emissione),'to_number(null)')||' ente_lp,'||
                                 '      '||rec_dct.numero_copie||' numero_copie'||
                                 '  from anamov mov'||
                                 ' where mov.anno_progr = '||rec_mov.anno_progr||
                                 '   and mov.numero_progr = '||rec_mov.numero_progr;
                    for rec_dcp in sel_dcp (rec_dct.codice_co, rec_dct.cod_modello) loop
                        if rec_dcp.condizione_sql is not null then
                           w_stringa := w_stringa||' and '||rec_dcp.condizione_sql;
                        end if;
                    end loop;

                    if w_stringa is not null then
                       begin
                         EXECUTE IMMEDIATE W_STRINGA
                            INTO w_comunicazione, w_matricola, w_cognome_nome,
                                 w_anno_pratica, w_pratica, w_cod_mov, w_cod_eve,
                                 w_data_reg, w_anno_progr, w_numero_progr, w_ente_lp,
                                 w_numero_copie;
                       exception
                         when no_data_found then
                              w_comunicazione := '';
                              w_count_com     := 0;
                         when too_many_rows then
                              w_comunicazione := '';
                              w_count_com     := -1;
                         when others then
                              w_comunicazione := '';
                              w_count_com     := -1;
                       end;
                       if w_comunicazione is not null then
                          begin
                            insert into anacom
                                   (comunicazione, matricola, cognome_nome,
                                    anno_pratica, pratica, cod_mov, cod_eve,
                                    data_reg, anno_progr, numero_progr, ente_lp, numero_copie,
                                    id, anagrafe, tipo_evento, codice_co, stampa_eseguita, d_data_reg)
                            values (w_comunicazione, w_matricola, w_cognome_nome,
                                    w_anno_pratica, w_pratica, w_cod_mov, w_cod_eve,
                                    w_data_reg, w_anno_progr, w_numero_progr, w_ente_lp, w_numero_copie,
                                    '', w_anagrafe, w_tipo_evento, rec_dct.codice_co, 'NO', '')
                            ;
                            if sql%found then
                               w_count_com := w_count_com + 1;
                            end if;
                          exception
                            when others then
                                 w_count_com := -1;
                          end;
                       end if;
                    end if;
                end loop;
             else
                w_stringa := 'select ''SCAW_'||rec_dct.cod_modello||''','||
                             '       mov.matricola, mov.cognome_nome,'||
                             '       mov.anno_pratica, mov.pratica, mov.cod_mov, mov.cod_eve,'||
                             '       mov.data_reg, mov.anno_progr, mov.numero_progr,'||
                             '      '||nvl(to_char(rec_dct.ente_destinatario),'to_number(null)')||' ente_lp,'||
                             '      '||rec_dct.numero_copie||' numero_copie'||
                             '  from anamov mov'||
                             ' where mov.anno_progr = '||rec_mov.anno_progr||
                             '   and mov.numero_progr = '||rec_mov.numero_progr;
                for rec_dcp in sel_dcp (rec_dct.codice_co, rec_dct.cod_modello) loop
                    if rec_dcp.condizione_sql is not null then
                       w_stringa := w_stringa||' and '||rec_dcp.condizione_sql;
                    end if;
                end loop;
                if w_stringa is not null then
                   begin
                     EXECUTE IMMEDIATE W_STRINGA
                        INTO w_comunicazione, w_matricola, w_cognome_nome,
                             w_anno_pratica, w_pratica, w_cod_mov, w_cod_eve,
                             w_data_reg, w_anno_progr, w_numero_progr, w_ente_lp, w_numero_copie;
                   exception
                     when no_data_found then
                          w_comunicazione := '';
                          w_count_com     := 0;
--raise_application_error(-209999,'popola_anacom - no_data_found');
                     when too_many_rows then
                          w_comunicazione := '';
                          w_count_com     := -1;
--raise_application_error(-209999,'popola_anacom - too_many_rows');
                     when others then
                          w_comunicazione := '';
                          w_count_com     := -1;
--raise_application_error(-209999,'popola_anacom - others');
                   end;
                   if w_comunicazione is not null then
                      begin
                        insert into anacom
                               (comunicazione, matricola, cognome_nome,
                                anno_pratica, pratica, cod_mov, cod_eve,
                                data_reg, anno_progr, numero_progr, ente_lp, numero_copie,
                                id, anagrafe, tipo_evento, codice_co, stampa_eseguita, d_data_reg)
                        values (w_comunicazione, w_matricola, w_cognome_nome,
                                w_anno_pratica, w_pratica, w_cod_mov, w_cod_eve,
                                w_data_reg, w_anno_progr, w_numero_progr, w_ente_lp, w_numero_copie,
                                '', w_anagrafe, w_tipo_evento, rec_dct.codice_co, 'NO', '')
                        ;
                        if sql%found then
                           w_count_com := w_count_com + 1;
                        end if;
                      exception
                        when others then
                             w_count_com := -1;
                      end;
                   end if;
                end if;
             end if;
         end loop;
         w_matricola_mov_prec := rec_mov.matricola;
     end loop;

  end if;

  if w_count_com < 0 then
     w_return := 'Errori in fase di inserimento delle comunicazioni';
  elsif w_count_com = 0 then
     w_return := 'Nessuna comunicazione inserita';
  elsif w_count_com = 1 then
     w_return := 'Inserita 1 comunicazione';
  else
     w_return := 'Inserite '||w_count_com||' comunicazioni';
  end if;

  return w_return;
  
end;
/

