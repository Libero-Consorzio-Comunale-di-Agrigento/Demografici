--liquibase formatted sql
--changeset amonopoli:202604011425_2 runOnChange:true stripComments:false
create or replace function f_ANPR_des_evento_ciu_x_id_rif
(a_archivio_rif		IN	varchar2
,a_servizio 		IN	varchar2
,a_tipo_operazione	IN	varchar2
,a_id_rif		IN	number
,a_matricola		IN	number
,a_fascia_fam		IN	number
,a_cod_fam		IN	number
,a_campo		IN	varchar2
)

return varchar2

IS

w_archivio_rif		varchar2(255) := upper(a_archivio_rif);
w_servizio		varchar2(255) := upper(a_servizio);
w_tipo_operazione	varchar2(255) := upper(a_tipo_operazione);
w_campo			varchar2(255) := upper(a_campo);

w_anno_progr		number;
w_numero_progr		number;
w_id_anadoc		number;
w_id_anamsi		number;

w_cod_mov		number;
w_cod_eve		number;
w_cod_variazione	varchar2(255);
w_pratica		number;
w_anno_pratica		number;
w_anagrafe		varchar2(255);
w_tipo_evento		varchar2(255);

w_tipo_documento	varchar2(255);
w_numero_documento	varchar2(255);
w_sospensione		number;

w_cod_fam_unique	varchar2(255);

w_descrizione 		varchar2(255);

begin
  if nvl(w_campo,'EVENTO') in ('EVENTO','ID_ANATPR') then
     if w_archivio_rif = 'MOV' then
        w_anno_progr   := substr(a_id_rif,1,4);
        w_numero_progr := substr(a_id_rif,5);
        begin
          select cod_mov, cod_eve, cod_variazione, 
                 pratica, anno_pratica,
                 f_ANPR_anagrafe_ciu(cod_mov,cod_eve),
                 f_ANPR_tipo_evento_ciu(cod_mov,cod_eve)
            into w_cod_mov, w_cod_eve, w_cod_variazione, 
                 w_pratica, w_anno_pratica, w_anagrafe, w_tipo_evento
            from anamov
           where anno_progr   = w_anno_progr
             and numero_progr = w_numero_progr
          UNION
          select cod_mov, cod_eve, cod_variazione, 
                 pratica, anno_pratica,
                 f_ANPR_anagrafe_ciu(cod_mov,cod_eve),
                 f_ANPR_tipo_evento_ciu(cod_mov,cod_eve)
            from anamov_elev
           where anno_progr   = w_anno_progr
             and numero_progr = w_numero_progr
          ;
        exception
          when others then
               w_cod_mov        := '';
               w_cod_eve        := '';
               w_cod_variazione := '';
               w_pratica        := '';
               w_anno_pratica   := '';
               w_anagrafe       := '';
               w_tipo_evento    := '';
        end;

     elsif w_archivio_rif like 'DOC%' then
        w_id_anadoc := a_id_rif;
        begin
          select tipo_documento, numero
            into w_tipo_documento, w_numero_documento
            from anadoc
           where id = w_id_anadoc
          ;
        exception
          when others then
               w_tipo_documento   := '';
               w_numero_documento := '';
        end;

     elsif w_archivio_rif = 'MSI' then
        w_id_anamsi := a_id_rif;
        begin
          select sospensione
            into w_sospensione
            from anamsi
           where id = w_id_anamsi
          ;
        exception
          when others then
               w_sospensione := '';
        end;

     end if;

     if nvl(w_campo,'EVENTO') = 'EVENTO' then
        w_descrizione := f_ANPR_des_evento_ciu(a_archivio_rif,a_servizio,a_tipo_operazione, w_cod_mov, w_cod_eve, w_cod_variazione, w_tipo_documento, w_numero_documento, w_sospensione);

     elsif nvl(w_campo,'EVENTO') = 'ID_ANATPR' then
        begin
          select id
            into w_descrizione
            from anatpr
           where anagrafe     = w_anagrafe
             and tipo_evento  = w_tipo_evento
             and anno_pratica = w_anno_pratica
             and pratica      = w_pratica
             and rownum = 1
          ;
        exception
          when others then
--               w_descrizione := w_anagrafe||w_tipo_evento||w_anno_pratica||lpad(w_pratica,4,'0');
               w_descrizione := '';
        end;
     end if;

  elsif w_campo = 'DETTAGLIO' then
    if a_matricola is not null then
       begin
         select translate(cognome_nome,'/',' ')||' - '||sesso||' - '||to_char(d_data_nas,'dd/mm/yyyy')
           into w_descrizione
           from anaana
          where matricola = a_matricola
         ;
       exception
         when others then
              w_descrizione := 'Matricola: '||a_matricola;
       end;
 
    elsif a_fascia_fam||a_cod_fam is not null then
       w_cod_fam_unique := f_ANA_get_cod_fam_unique(a_fascia_fam,a_cod_fam);
       begin
         select decode(convivenza,'',
                  decode(intestatario,'', '*** DATI MANCANTI',
                    'Intestatario: '||intestatario),
                  'Convivenza: '||convivenza)
           into w_descrizione
           from anafam
          where cod_fam_unique = w_cod_fam_unique
         ;
       exception
         when others then
              w_descrizione := 'Codice Famiglia: '||w_cod_fam_unique;
       end;
    end if;

  end if;

  if nvl(w_campo,'EVENTO') = 'EVENTO' and w_descrizione is null then
     w_descrizione := 'archivio_rif '||a_archivio_rif;
  end if;

  return w_descrizione;
end;
/
