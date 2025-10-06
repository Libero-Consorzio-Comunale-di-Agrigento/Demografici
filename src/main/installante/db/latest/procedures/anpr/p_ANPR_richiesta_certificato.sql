--liquibase formatted sql
--changeset amonopoli:202410231535 runOnChange:true stripComments:false
create or replace procedure ANPR_richiesta_certificato
(p_id_emissione		IN	varchar2
,p_flag_forzatura  	IN	varchar2
,p_allegato_clob	IN OUT	clob
,p_allegato_blob	IN OUT	blob
,p_errore		IN OUT	varchar2
)

IS

w_servizio		varchar2(255) := '6001';
w_tipo_operazione	varchar2(255);
w_archivio_rif		varchar2(255) := 'CER';
w_anno_rif		number;
w_numero_rif		number;
w_matricola		number;
w_utente		varchar2(255);

w_id_operazione		number;
w_flag_ws		varchar2(255);
w_session_id		varchar2(255) := f_tabrep_terminale();

w_allegato_clob		clob;
w_allegato_blob		blob;

w_errore                varchar2(4000);
errore			exception;

cursor sel_cerinc is
select v.anno_emissione, v.progr_emissione, v.matricola,
       v.id_emissione w_chiave_anpr,
       cem.terminalista
  from cercem cem, cerinc_v v
 where cem.anno_emissione  = v.anno_emissione
   and cem.progr_emissione = v.progr_emissione
   and v.id_emissione      = p_id_emissione
 order by 1, 2
;

cursor sel_anpciu (w_anno_emissione number, w_progr_emissione number) is
select ciu.id_operazione, ciu.flag_INVIO_ws
  from anpciu CIU
 where servizio   = '6001'
   and anno_rif   = w_anno_emissione
   and numero_rif = w_progr_emissione
 order by 1 desc
;

begin
  for rec in sel_cerinc loop
      w_matricola  := rec.matricola;
      w_utente     := rec.terminalista;
      w_anno_rif   := rec.anno_emissione;
      w_numero_rif := rec.progr_emissione;

      if nvl(p_flag_forzatura,'N') = 'S' then
      	 w_tipo_operazione := 'V';
      else
      	 w_tipo_operazione := 'C';
      end if;

      begin
        anpciu_ins(w_servizio           -- servizio
                  ,w_tipo_operazione    -- tipo_operazione
                  ,w_anno_rif           -- anno_rif
                  ,w_numero_rif         -- numero_rif
                  ,w_matricola          -- matricola
                  ,''                   -- fascia_fam
                  ,''                   -- cod_fam
                  ,''                   -- id_anadoc
                  ,''                   -- id_anamsi
                  ,w_archivio_rif       -- archivio_rif
                  ,''                   -- data_rif
                  ,''                   -- note
                  ,w_utente             -- terminalista
                  ,'');                 -- data_reg
        commit;
      exception
        when others then
             w_errore := 'Errore in generazione comunicazione ANPR';
             raise errore;
      end;

      w_id_operazione := '';
      w_flag_ws       := '';
      OPEN sel_anpciu (rec.anno_emissione, rec.progr_emissione);
      FETCH sel_anpciu into w_id_operazione, w_flag_ws;
      CLOSE sel_anpciu;

      if nvl(w_flag_ws,'N') = 'S' then
         begin
           select allegato_clob, allegato_blob
             into w_allegato_clob, w_allegato_blob
             from anpr_allegati
            where servizio   = w_servizio
              and session_id = w_session_id
              and chiave     = rec.w_chiave_anpr
           ;
         exception
           when others then
                w_errore := 'Errore nel recuperto del certificato ANPR';
                raise errore;
         end;

      elsif nvl(w_flag_ws,'N') = 'N' then
         begin
      	   select testo_errore
      	     into w_errore
      	     from anperr a
      	    where id_operazione = w_id_operazione
      	      and tipo_errore   = 'E'
      	      and data_ora = (select max(b.data_ora)
      	                        from anperr b
      	                       where b.id_operazione = a.id_operazione
      	                         and b.tipo_errore   = a.tipo_errore)
      	      and rownum   = 1
      	   ;
         exception
           when others then
                w_errore := '';
         end;

         if w_errore is not null then
            w_errore := 'Certificato non elaborato.'||chr(10)||chr(10)||
                        'Errore ANPR: '||chr(10)||w_errore;
         else
            w_errore := 'Certificato non elaborato.'||chr(10)||chr(10)||
                        'Errore ANPR non presente';
         end if;

         goto salta_annullamento;

         begin
           update cercem
              set annullamento        = 'SI'
                , note_annullamento   = w_errore
                , utente_annullamento = w_utente
                , d_data_annullamento = sysdate
            where anno_emissione  = rec.anno_emissione
              and progr_emissione = rec.progr_emissione
           ;
           if sql%found then
              if w_errore is not null then
                 w_errore := w_errore||chr(10)||chr(10)||
                             '(Certificato annullato ai fini del conteggio dei diritti)';
              else
                 w_errore := '(Certificato annullato ai fini del conteggio dei diritti)';
              end if;
           end if;
           commit;
         exception
           when others then
                if w_errore is not null then
                   w_errore := w_errore||chr(10)||chr(10)||'(Errore in annullamento certificato)';
                else
                   w_errore := '(Errore in annullamento certificato)';
                end if;
         end;
<< salta_annullamento >>
null;
      end if;
  end loop;

<< FINE >>
null;

  p_allegato_clob := w_allegato_clob;
  p_allegato_blob := w_allegato_blob;
  p_errore        := w_errore;

EXCEPTION
  when errore then
       p_allegato_clob := empty_clob();
       p_allegato_blob := empty_blob();
       p_errore        := w_errore;
  when others then
       w_errore := 'Errore in richiesta certificato ANPR';
       p_allegato_clob := empty_clob();
       p_allegato_blob := empty_blob();
       p_errore        := w_errore;
END;
/
