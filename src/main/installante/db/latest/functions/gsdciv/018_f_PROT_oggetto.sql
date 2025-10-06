--liquibase formatted sql
--changeset amonopoli:202310260815_2 runOnChange:true stripComments:false
create or replace function f_PROT_oggetto
(a_archivio_rif            IN   varchar2
,a_id_rif                  IN   number
,a_campo                   IN   varchar2   default NULL
)

return varchar2

IS

w_codice_co			number;
w_formula			varchar2(255);
w_tipo_atto			number;
w_atto				number;
w_parte				number;
w_serie				varchar2(255);
w_ufficio			number;
w_anno				number;

w_numero_atto_ansc		varchar2(255);

w_oggetto			varchar2(4000);
w_oggetto_info			varchar2(4000);

errore				exception;
w_errore			varchar2(4000);

w_operazione_log		varchar2(255) := 'f_PROT_oggetto';

begin
  if a_archivio_rif is null or a_id_rif is null then
     goto fine;
  end if;

  if a_archivio_rif = 'CIVCOM' then
     if a_id_rif is not null then
        begin
          select com.codice_co, com.formula, com.tipo_atto, com.ufficio, com.anno, com.parte, com.serie, com.atto
            into w_codice_co, w_formula, w_tipo_atto, w_ufficio, w_anno, w_parte, w_serie, w_atto
            from civcom_prot com
           where com.id = a_id_rif
          ;
          w_numero_atto_ansc := f_CIV_get_numero_atto_ansc(w_tipo_atto,w_ufficio,w_anno,w_parte,w_serie,w_atto);
        exception
          when others then
               w_codice_co  := '';
               w_tipo_atto  := '';
               w_ufficio    := '';
               w_anno       := '';
               w_parte      := '';
               w_serie      := '';
               w_atto       := '';
        end;

        if w_numero_atto_ansc is not null then
           begin
             select dco.descrizione,
                    decode(w_formula, '', 
                      decode(w_tipo_atto, 1, 'Atto di Cittadinanza: N. '||w_numero_atto_ansc,
                                            2, 'Atto di Nascita: N. '||w_numero_atto_ansc,
                                            3, 'Pubblicaziono di Matrimonio: verbale N. '||w_numero_atto_ansc,
                                            4, 'Atto di Matrimonio: N. '||w_numero_atto_ansc,
                                           -4, 'Atto di Unione Civile: N. '||w_numero_atto_ansc,
                                            5, 'Atto di Morte: N. '||w_numero_atto_ansc)||
                        ' '||f_PROT_oggetto_nomi(a_archivio_rif,a_id_rif,w_tipo_atto,w_ufficio,w_anno,w_atto,w_parte,w_serie),
                      'Formula '||decode(substr(w_formula,1,1),'5','1'||substr(w_formula,2),w_formula)||
                        decode(w_tipo_atto, 1, ' (su Atto di Cittadinanza N. '||w_numero_atto_ansc||')',
                                              2, ' (su Atto di Nascita N. '||w_numero_atto_ansc||')',
                                              4, ' (su Atto di Matrimonio N. '||w_numero_atto_ansc||')',
                                             -4, ' (su Atto di Unione Civile N. '||w_numero_atto_ansc||')',
                                              5, ' (su Atto di Morte N. '||w_numero_atto_ansc||')',
                                              6, ' (su Atto di Nascita, generata da Atto di Cittadinanza N. '||w_numero_atto_ansc||')',
                                              7, ' (su Atto di Nascita, generata da Atto di Matrimonio N. '||w_numero_atto_ansc||')',
                                             -7, ' (su Atto di Nascita, generata da Atto di Unione Civile N. '||w_numero_atto_ansc||')',
                                              8, ' (su Atto di Nascita, generata da Atto di Morte N. '||w_numero_atto_ansc||')',
                                              9, ' (su Atto di Matrimonio, generata da Atto di Separazioni / Scioglimento di Matrimonio N. '||w_numero_atto_ansc||')',
                                             -9, ' (su Atto di Unione Civile, generata da Cessazione / Scioglimento di Unione Civile N. '||w_numero_atto_ansc||')'))
               into w_oggetto
                  , w_oggetto_info
               from civdco dco
              where dco.codice_co = w_codice_co
             ;
           exception
             when others then
                  w_errore := 'Errore in decodifica comunicazione - '||a_archivio_rif||' id: '||a_id_rif||' ('||sqlerrm||')';
                  raise errore;
           end;

        else
           begin
             select dco.descrizione,
                    decode(com.formula, '', 
                      decode(com.tipo_atto, 1, 'Atto di Cittadinanza: N. '||com.atto||' uff.'||com.ufficio||' Anno '||com.anno,
                                            2, 'Atto di Nascita: N. '||com.atto||decode(com.parte,'','',' p.'||com.parte)||decode(com.serie,'','',' s.'||com.serie)||' uff.'||com.ufficio||' Anno '||com.anno,
                                            3, 'Pubblicaziono di Matrimonio: verbale N. '||com.atto||decode(com.parte,'','',' p.'||com.parte)||decode(com.serie,'','',' s.'||com.serie)||' uff.'||com.ufficio||' Anno '||com.anno,
                                            4, 'Atto di Matrimonio: N. '||com.atto||decode(com.parte,'','',' p.'||com.parte)||decode(com.serie,'','',' s.'||com.serie)||' uff.'||com.ufficio||' Anno '||com.anno,
                                           -4, 'Atto di Unione Civile: N. '||com.atto||decode(com.parte,'','',' p.'||com.parte)||decode(com.serie,'','',' s.'||com.serie)||' uff.'||com.ufficio||' Anno '||com.anno,
                                            5, 'Atto di Morte: N. '||com.atto||decode(com.parte,'','',' p.'||com.parte)||decode(com.serie,'','',' s.'||com.serie)||' uff.'||com.ufficio||' Anno '||com.anno)||
                        ' '||f_PROT_oggetto_nomi(a_archivio_rif,a_id_rif,com.tipo_atto,com.ufficio,com.anno,com.atto,com.parte,com.serie),
                      'Formula '||decode(substr(com.formula,1,1),'5','1'||substr(com.formula,2),com.formula)||
                        decode(com.tipo_atto, 1, ' (su Atto di Cittadinanza N. '||com.atto||' uff.'||com.ufficio||' Anno '||com.anno||')',
                                              2, ' (su Atto di Nascita N. '||com.atto||decode(com.parte,'','',' p.'||com.parte)||decode(com.serie,'','',' s.'||com.serie)||' uff.'||com.ufficio||' Anno '||com.anno||')',
                                              4, ' (su Atto di Matrimonio N. '||com.atto||decode(com.parte,'','',' p.'||com.parte)||decode(com.serie,'','',' s.'||com.serie)||' uff.'||com.ufficio||' Anno '||com.anno||')',
                                             -4, ' (su Atto di Unione Civile N. '||com.atto||decode(com.parte,'','',' p.'||com.parte)||decode(com.serie,'','',' s.'||com.serie)||' uff.'||com.ufficio||' Anno '||com.anno||')',
                                              5, ' (su Atto di Morte N. '||com.atto||decode(com.parte,'','',' p.'||com.parte)||decode(com.serie,'','',' s.'||com.serie)||' uff.'||com.ufficio||' Anno '||com.anno||')',
                                              6, ' (su Atto di Nascita, generata da Atto di Cittadinanza N. '||com.atto||' uff.'||com.ufficio||' Anno '||com.anno||')',
                                              7, ' (su Atto di Nascita, generata da Atto di Matrimonio N. '||com.atto||decode(com.parte,'','',' p.'||com.parte)||decode(com.serie,'','',' s.'||com.serie)||' uff.'||com.ufficio||' Anno '||com.anno||')',
                                             -7, ' (su Atto di Nascita, generata da Atto di Unione Civile N. '||com.atto||decode(com.parte,'','',' p.'||com.parte)||decode(com.serie,'','',' s.'||com.serie)||' uff.'||com.ufficio||' Anno '||com.anno||')',
                                              8, ' (su Atto di Nascita, generata da Atto di Morte N. '||com.atto||decode(com.parte,'','',' p.'||com.parte)||decode(com.serie,'','',' s.'||com.serie)||' uff.'||com.ufficio||' Anno '||com.anno||')',
                                              9, ' (su Atto di Matrimonio, generata da Atto di Separazioni / Scioglimento di Matrimonio N. '||com.atto||decode(com.parte,'','',' p.'||com.parte)||decode(com.serie,'','',' s.'||com.serie)||' uff.'||com.ufficio||' Anno '||com.anno||')',
                                             -9, ' (su Atto di Unione Civile, generata da Cessazione / Scioglimento di Unione Civile N. '||com.atto||decode(com.parte,'','',' p.'||com.parte)||decode(com.serie,'','',' s.'||com.serie)||' uff.'||com.ufficio||' Anno '||com.anno||')'))                     
               into w_oggetto
                  , w_oggetto_info
               from civdco dco
                  , civcom_prot com
              where dco.codice_co = com.codice_co
                and com.id        = a_id_rif
             ;
           exception
             when others then
                  w_errore := 'Errore in decodifica comunicazione - '||a_archivio_rif||' id: '||a_id_rif||' ('||sqlerrm||')';
                  raise errore;
           end;
        end if; -- if w_numero_atto_ansc is not null then
     end if; -- if a_id_rif is not null then
  
  elsif a_archivio_rif = 'ANACOM' then
     if a_id_rif is not null then
        begin
          select mod.descrizione,
                 decode(com.pratica,'',
                   f_MOV_descrizione_evento(com.anno_progr, com.numero_progr)||
                     decode(com.matricola,'','',' (matr.'||com.matricola||' - '||com.cognome_nome||')'),
                   'Pratica N. '||com.pratica||'/'||com.anno_pratica||
                     ' ('||decode(com.anagrafe,'RES','A.P.R.','AIR','A.I.R.E.')||
                     ' - '||decode(com.tipo_evento,'I','Iscrizioni','C','Cancellazioni','E','Cambi Abitazione','R','Rettifiche')||')')
            into w_oggetto
               , w_oggetto_info
            from anamod mod
               , anacom_prot com
           where mod.cod_modello  = f_SCAW_cod_modello(com.comunicazione)
             and mod.tipo_modello = decode(substr(com.comunicazione,1,4),'SCAW','C','SAPW','P')
             and com.id           = a_id_rif
          ;
        exception
          when others then
               w_errore := 'Errore in decodifica comunicazione - '||a_archivio_rif||' id: '||a_id_rif||' ('||sqlerrm||')';
               raise errore;
        end;
     end if;

  elsif a_archivio_rif = 'LEVCOM' then
     if a_id_rif is not null then
        begin
          select d.descrizione,
                 'Classe '||com.classe||
--                   ' - Comune '||c.descrizione||' ('||c.sigla_provincia||') - '||lpad(com.cod_pro_dest,3,'0')||lpad(com.cod_com_dest,3,'0')
                   ' - Comune '||c.descrizione||' ('||c.sigla_provincia||')'
            into w_oggetto
               , w_oggetto_info
            from arccom c
               , levdcl d
               , levcom_prot com
           where c.cod_provincia (+) = com.cod_pro_dest
             and c.cod_comune    (+) = com.cod_com_dest
             and d.codice_co         = com.codice_co
             and com.id              = a_id_rif
          ;
        exception
          when others then
               w_errore := 'Errore in decodifica comunicazione - '||a_archivio_rif||' id: '||a_id_rif||' ('||sqlerrm||')';
               raise errore;
        end;
     end if;

  elsif a_archivio_rif = 'ELECOM' then
     if a_id_rif is not null then
        begin
          select d.descrizione,
                 com.anno_revisione||'-'||dre.descrizione||'-'||com.progr_revisione||
                   decode(c.descrizione,'','',' - Comune '||c.descrizione||' ('||c.sigla_provincia||')')
            into w_oggetto
               , w_oggetto_info
            from arccom c
               , eledre dre
               , eledta d
               , elecom_prot com
           where c.cod_provincia (+) = ltrim(com.cod_pro_dest,'0')
             and c.cod_comune    (+) = ltrim(com.cod_com_dest,'0')
             and dre.cod_re          = com.revisione
             and d.cod_ta            = com.tabulato
             and com.id              = a_id_rif
          ;
        exception
          when others then
               w_errore := 'Errore in decodifica comunicazione - '||a_archivio_rif||' id: '||a_id_rif||' ('||sqlerrm||')';
               raise errore;
        end;
     end if;

  elsif a_archivio_rif = 'ELE34D' then
     w_oggetto := 'MODELLO 3-4/D XML (REVISIONE: '||a_id_rif||')';
     w_oggetto_info := 'COMUNE DI '||f_comune_al(substr(a_id_rif,7,3),substr(a_id_rif,10,3),'');

  else
     w_errore := 'Archivio di riferimento '||a_archivio_rif||' non gestito';
     raise errore;

  end if;          

<< fine>>
  if nvl(a_campo,' ') = 'INFO' then
     return w_oggetto_info;
  else
     return w_oggetto;
  end if;
        
exception
  when errore then
--       DOCAREA_PKG.ins_log(w_operazione_log, w_errore);        
       return null;
  when others then
       w_errore := 'errore ('||sqlerrm||')';
--       DOCAREA_PKG.ins_log(w_operazione_log, w_errore);        
       return null;
end;
/
