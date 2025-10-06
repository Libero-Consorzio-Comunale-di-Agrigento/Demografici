--liquibase formatted sql
--changeset amonopoli:202503190810_2 runOnChange:true stripComments:false
CREATE OR REPLACE package body REGISTRO_UTILITY is
/******************************************************************************
 NOME:        .
 DESCRIZIONE: .
 ANNOTAZIONI: .
 REVISIONI: .
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 001  03/11/2005 MF     Inserimento funzioni di gestione "preferenza" e revisione
                        sintassi.
******************************************************************************/
   s_revisione_body constant VARCHAR2(30) := '001';
   s_predefinita   varchar2(2000) := '(Predefinito)';
   e_stringa_not_found exception;
   pragma exception_init( e_stringa_not_found, -20932 );
--
-- Funzioni private
--
procedure raise_err_registro
( in_errore      in number
, in_riferimento in varchar2 default null
) is
   err_codice   number(10)       := in_errore;
   err_testo   varchar2(2000);
begin
   if in_errore > 0 then
      err_codice:= in_errore*(-1);
   end if;
   if    err_codice = -20901 then
      err_testo := 'DB User non specificato';
   elsif err_codice = -20902 then
      err_testo := 'SI4 User non specificato';
   elsif err_codice = -20910 then
      err_testo := 'Radice "'||in_riferimento||'" non prevista';
   elsif err_codice = -20916 then
      err_testo := 'Impossibile alterare le radici del registro';
   elsif err_codice = -20919 then
      err_testo := 'Impossibile eliminare radici registro';
   elsif err_codice = -20921 then
      err_testo := 'Chiave "'||in_riferimento||'" gia esistente';
   elsif err_codice = -20922 then
      err_testo := 'Chiave "'||in_riferimento||'" non trovata';
   elsif err_codice = -20923 then
      err_testo := 'Chiave "'||in_riferimento||'" incompleta';
   elsif err_codice = -20925 then
      err_testo := 'Nome chiave non valido. Non utilizzare il separatore "/"';
   elsif err_codice = -20926 then
      err_testo := 'Errore creazione chiave "'||in_riferimento||'"';
   elsif err_codice = -20927 then
      err_testo := 'Errore creazione chiave parziale "'||in_riferimento||'"';
   elsif err_codice = -20931 then
      err_testo := 'Stringa "'||in_riferimento||'" gia esistente';
   elsif err_codice = -20932 then
      err_testo := 'Stringa "'||in_riferimento||'" non trovata';
   elsif err_codice = -20936 then
      err_testo := 'Errore variazione stringa "'||in_riferimento||'"';
   elsif err_codice = -20939 then
      err_testo := 'Impossibile eliminare la stringa predefinita';
   else
      err_testo := 'Errore non documentato';
   end if;
   raise_application_error(err_codice,err_testo);
end raise_err_registro;
--
procedure valida_chiave
(in_chiave      varchar2
)
is
begin
   if instr(in_chiave,'/') = 0 then
      raise_err_registro(20916);
   end if;
   if in_chiave like 'DB_USERS/%'
   or in_chiave like 'SI4_USERS/%'
   or in_chiave like 'SI4_DB_USERS/%'
   or in_chiave like 'PRODUCTS/%' then
      null;
   else
      raise_err_registro(20910,substr(in_chiave,1,instr(in_chiave,'/')-1));
   end if;
   if in_chiave like '%/' then
      raise_err_registro(20923,in_chiave);
   end if;
end valida_chiave;
--
function verifica_chiave
( in_chiave   varchar2
) return boolean is
   plsqlappoggio   number(1);
begin
   /* Controllo esistenza  chiave */
   select 1 into plsqlappoggio
     from registro
    where chiave = in_chiave
   ;
   return true;
exception
when too_many_rows then
   return true;
when no_data_found then
   return false;
end verifica_chiave;
--
-- Funzioni pubbliche
--
function versione return VARCHAR2 is
/******************************************************************************
 NOME:        versione.
 DESCRIZIONE: Restituisce versione e revisione di distribuzione del package.
 RITORNA:     VARCHAR2 stringa contenente versione e revisione.
 NOTE:        Primo numero  : versione compatibilit  del Package.
              Secondo numero: revisione del Package specification.
              Terzo numero  : revisione del Package body.
******************************************************************************/
begin
   return s_revisione||'.'||nvl(s_revisione_body,'000');
end versione;
--
function livello_chiave
( in_chiave      varchar2
) return number is
  posizione  number(5);
begin
  posizione := instr(in_chiave,'/');
  if posizione > 0 then
    return 1+livello_chiave(substr(in_chiave,posizione+1));
  else
    return 0;
  end if;
end livello_chiave;
--
function trasforma_chiave
( in_chiave      varchar2
) return varchar2 is
begin
   return trasforma_chiave(in_chiave,null,UPPER(user));
end trasforma_chiave;
--
function trasforma_chiave
( in_chiave      varchar2
, in_si4_user    varchar2
, in_db_user     varchar2   default null
)
return varchar2
is
   chiave_reale   varchar2(2000) := in_chiave;
begin
   if in_chiave like 'LOCAL_DB_USER/%' then
      if in_db_user is null then
         raise_err_registro(20901);
      end if;
      chiave_reale := 'DB_USERS/'||in_db_user||substr(in_chiave,instr(in_chiave,'/'));
   end if;
   if in_chiave like 'LOCAL_SI4_USER/%' then
      if in_si4_user is null then
         raise_err_registro(20902);
      end if;
      chiave_reale := 'SI4_USERS/'||in_si4_user||substr(in_chiave,instr(in_chiave,'/'));
   end if;
   if in_chiave like 'CURRENT_USER/%' then
      if in_si4_user is null then
         raise_err_registro(20902);
      end if;
      if in_db_user is null then
         raise_err_registro(20901);
      end if;
      chiave_reale := 'SI4_DB_USERS/'||in_si4_user||'|'||in_db_user||substr(in_chiave,instr(in_chiave,'/'));
   end if;
   return chiave_reale;
end trasforma_chiave;
--
procedure crea_chiave
( in_chiave      in   varchar2
, in_eccezione   in   boolean    default true
) is
   duplicazione   exception;
   chiave_reale   varchar2(2000);
   chiave_parziale   varchar2(2000);
begin
   chiave_reale := trasforma_chiave(in_chiave);
   valida_chiave(chiave_reale);
   /* Controllo duplicazione chiave */
   if verifica_chiave(chiave_reale) then
      raise duplicazione;
   end if;
   /* Creazioni chiavi parziali */
   chiave_parziale := chiave_reale;
   while instr(chiave_parziale,'/') > 0
   loop
      chiave_parziale := substr(chiave_parziale,1,instr(chiave_parziale,'/',-1)-1);
      /* Controllo esistenza chiave parziale */
      if verifica_chiave(chiave_parziale) then
         exit;
      end if;
      /* Creazione */
      begin
         insert into registro
            (chiave,
             stringa
            )
         values
            (chiave_parziale,
             s_predefinita
            )
         ;
      exception when others then
         raise_err_registro(20927,chiave_parziale);
      end;
   end loop;
   /* Creazione chiave terminale */
   begin
      insert into registro
         (chiave,
          stringa
         )
      values
         (chiave_reale,
          '(Predefinito)'
         )
      ;
   exception when others then
      raise_err_registro(20926,chiave_reale);
   end;
exception when duplicazione then
   if in_eccezione then
      raise_err_registro(20921,chiave_reale);
   end if;
end crea_chiave;
--
procedure crea_chiave
( in_chiave      in   varchar2
, in_eccezione   in   number
) is
begin
   crea_chiave(in_chiave, in_eccezione = 1);
end crea_chiave;
--
procedure elimina_chiave
(in_chiave      in   varchar2,
 in_eccezione   in   boolean    default true
) is
   chiave_reale   varchar2(2000);
begin
   chiave_reale := trasforma_chiave(in_chiave);
   valida_chiave(chiave_reale);
   if instr(chiave_reale,'/') = 0 then
      raise_err_registro(20916);
   end if;
   delete registro
    where chiave    = chiave_reale
       or chiave like chiave_reale||'/%'
   ;
   if sql%rowcount = 0 then
      if in_eccezione then
         raise_err_registro(20922,chiave_reale);
      end if;
   end if;
end elimina_chiave;
--
procedure elimina_chiave
( in_chiave      in   varchar2
, in_eccezione   in   number
) is
begin
   elimina_chiave(in_chiave, in_eccezione = 1);
end elimina_chiave;
--
procedure rinomina_chiave
(in_chiave      in   varchar2,
 in_nuovo_nome  in    varchar2,
 in_eccezione   in   boolean     default true
) is
   radice_reale   varchar2(2000);
   chiave_reale   varchar2(2000);
begin
   chiave_reale := trasforma_chiave(in_chiave);
   valida_chiave(chiave_reale);
   if instr(chiave_reale,'/') = 0 then
      raise_err_registro(20916);
   end if;
   if instr(in_nuovo_nome,'/') > 0 then
      raise_err_registro(20925);
   end if;
   if not verifica_chiave(chiave_reale) then
      if in_eccezione then
         raise_err_registro(20922,chiave_reale);
      end if;
   end if;
   radice_reale := substr(chiave_reale,1,instr(chiave_reale,'/',-1)-1);
   update registro
      set chiave = replace(chiave,chiave_reale,radice_reale||'/'||in_nuovo_nome)
    where chiave    = radice_reale
       or chiave like radice_reale||'/%'
   ;
   if sql%rowcount = 0 then
      if in_eccezione then
         raise_err_registro(20922,chiave_reale);
      end if;
   end if;
end rinomina_chiave;
--
procedure rinomina_chiave
( in_chiave      in   varchar2
, in_nuovo_nome  in   varchar2
, in_eccezione   in   number
) is
begin
   rinomina_chiave(in_chiave, in_nuovo_nome, in_eccezione = 1);
end rinomina_chiave;
--
procedure leggi_stringa
( in_chiave     in   varchar2
, in_stringa    in   varchar2
, out_valore    out  varchar2
, in_eccezione  in   boolean    default true
) is
   chiave_reale   varchar2(2000);
   chiave         varchar2(2000);
begin
   chiave := UPPER(in_chiave);
   chiave_reale := trasforma_chiave(chiave);
   valida_chiave(chiave_reale);
   select valore
     into out_valore
     from registro
    where chiave    = chiave_reale
      and UPPER(stringa)   = UPPER(in_stringa)
   ;
exception when no_data_found then
   if  in_eccezione then
      if verifica_chiave(chiave_reale) then
         raise_err_registro(20932,in_stringa);
      else
         raise_err_registro(20922,chiave_reale);
      end if;
   else
      out_valore := null;
   end if;
end leggi_stringa;
--
function leggi_stringa
( in_chiave    in   varchar2
, in_stringa   in   varchar2
, in_eccezione in   number
) return varchar2 is
  out_valore varchar2(2000);
begin
  leggi_stringa(in_chiave, in_stringa, out_valore, in_eccezione = 1);
  return out_valore;
end leggi_stringa;
--
procedure scrivi_stringa
( in_chiave     in   varchar2
, in_stringa    in   varchar2
, in_valore     in   varchar2
, in_commento   in   varchar2  default null
, in_eccezione  in   boolean   default true
) is
   chiave_reale   varchar2(2000);
begin
   chiave_reale := trasforma_chiave(in_chiave);
   valida_chiave(chiave_reale);
   /* Controllo esistenza chiave */
   if not verifica_chiave(chiave_reale) then
      if in_eccezione then
         raise_err_registro(20922,chiave_reale);
      else
         crea_chiave(chiave_reale,false);
      end if;
   end if;
   /* Creazione stringa */
   begin
      insert into registro
         (chiave,
          stringa,
          valore,
          commento
         )
      values
         (chiave_reale,
          in_stringa,
          in_valore,
          in_commento
         )
      ;
   exception when dup_val_on_index then
      if in_eccezione then
         raise_err_registro(20931,in_stringa);
      else
         update registro
            set valore   = in_valore,
                commento = nvl(in_commento,commento)
          where chiave   = chiave_reale
            and stringa  = in_stringa
         ;
         if sql%rowcount != 1 then
            raise_err_registro(20936,in_stringa);
         end if;
      end if;
   end;
end scrivi_stringa;
--
procedure scrivi_stringa
( in_chiave      in   varchar2
, in_stringa     in   varchar2
, in_valore      in   varchar2
, in_commento    in   varchar2
, in_eccezione   in   number
) is
begin
   scrivi_stringa(in_chiave, in_stringa, in_valore, in_commento, in_eccezione = 1);
end scrivi_stringa;
--
procedure elimina_stringa
( in_chiave      in   varchar2
, in_stringa     in   varchar2
, in_eccezione   in   boolean    default true
) is
   chiave_reale   varchar2(2000);
begin
   if in_stringa = s_predefinita then
      raise_err_registro(20939);
   end if;
   chiave_reale := trasforma_chiave(in_chiave);
   valida_chiave(chiave_reale);
   delete registro
    where chiave   = chiave_reale
      and stringa    = in_stringa
   ;
   if sql%rowcount = 0 then
      if in_eccezione then
         if verifica_chiave(chiave_reale) then
            raise_err_registro(20932,in_stringa);
         else
            raise_err_registro(20922,chiave_reale);
         end if;
      end if;
   end if;
end elimina_stringa;
--
procedure elimina_stringa
( in_chiave      in   varchar2
, in_stringa     in   varchar2
, in_eccezione   in   number
) is
begin
   elimina_stringa(in_chiave, in_stringa, in_eccezione = 1);
end elimina_stringa;
--
function get_stringa 
( in_chiave     varchar2
, in_stringa    varchar2
) return VARCHAR2 is
/***********************************************************************************************
 NOME:        get_stringa
 DESCRIZIONE: Ritorna il valore di una stringa per la chiave indicata.
 PARAMETRI:   p_chiave    VARCHAR2  Chiave di accesso al Registro
              p_stringa   VARCHAR2  Nome della Stringa del Registro
 RITORNA:     VARCHAR2  : valore della stringa
************************************************************************************************/
   d_result VARCHAR2(2000);
begin
  begin
     leggi_stringa(in_chiave, in_stringa, d_result, true);
  exception
     when e_stringa_not_found then -- se viene intercettata una NOT FOUND riemette eccezione
                                   -- (comportamento standard per le funzioni "get_" in DbC)
        raise no_data_found;
  end;
  return d_result;
end get_stringa;
--
function get_preferenza 
( p_stringa VARCHAR2
, p_modulo  VARCHAR2 DEFAULT null
, p_utente  VARCHAR2 DEFAULT null
) return VARCHAR2 is
/***********************************************************************************************
 NOME:        get_preferenza
 DESCRIZIONE: Trova una preferenza a livello di utente di sistema,
              se non e' definito l'utente cerca a livello di DB User,
              se   indicato il modulo cerca sulla chiave PRODUCT/NomeModulo.
 PARAMETRI:   p_stringa   VARCHAR2  Nome preferenza
              p_modulo    VARCHAR2  Modulo di sistema per il quale cercare la chiave
              p_utente    VARCHAR2  Nome utente di sistema 
 RITORNA:     VARCHAR2  : valore della preferenza
************************************************************************************************/
   d_valore VARCHAR2(2000);
   d_chiave VARCHAR2(512);
begin
   -- Ricerca preferenza a livello utente di sistema
   d_valore := REGISTRO_UTILITY.get_preferenza_SI4_DB_USERS (p_stringa, p_modulo , p_utente);
   -- Ricerca preferenza a livello di db user
   IF d_valore IS NULL THEN
      d_valore := REGISTRO_UTILITY.get_preferenza_DB_USERS (p_stringa, p_modulo);
   END IF;
   -- Ricerca preferenza a livello generale per lo specifico modulo
   IF d_valore IS NULL AND p_modulo IS NOT NULL THEN
      d_chiave := 'PRODUCTS/'||UPPER(p_modulo);
      leggi_stringa (d_chiave,p_stringa, d_valore, FALSE);
   END IF;
   return d_valore;
end get_preferenza;
--
function get_preferenza_SI4_DB_USERS
( p_stringa VARCHAR2
, p_modulo  VARCHAR2 DEFAULT null
, p_utente  VARCHAR2 DEFAULT null
) return VARCHAR2 is
/***********************************************************************************************
 NOME:        get_preferenza_SI4_DB_USER
 DESCRIZIONE: Trova una preferenza a livello di utente di sistema con chiave
                 SI4_DB_USERS/NomeSi4User|NomeUser/PRODUCTS/NomeModulo 
              o in seconda istanza
                 SI4_DB_USERS/NomeSi4User|NomeUser.
 PARAMETRI:   P_STRINGA   VARCHAR2  Nome preferenza
              P_MODULO    VARCHAR2  Modulo AD4 per il quale cercare la chiave.
              P_UTENTE    VARCHAR2  Codice utente AD4
 RITORNA:     VARCHAR2  : valore della preferenza
************************************************************************************************/
   d_valore VARCHAR2(2000) := '';
   d_chiave VARCHAR2(512);
BEGIN
   -- Ricerca preferenza a livello utente di sistema con e senza modulo
   IF p_utente IS NOT NULL AND p_modulo IS NOT NULL THEN
      d_chiave := 'SI4_DB_USERS/'||p_utente||'|'||USER||'/PRODUCTS/'||UPPER(p_modulo);
      leggi_stringa (d_chiave,p_stringa, d_valore, FALSE);
   END IF;
   IF p_utente IS NOT NULL AND d_valore IS NULL THEN
      d_chiave := 'SI4_DB_USERS/'||p_utente||'|'||USER;
      leggi_stringa (d_chiave,p_stringa, d_valore, FALSE);
   END IF;
   RETURN d_valore;
end get_preferenza_SI4_DB_USERS;
--
function get_preferenza_DB_USERS
( p_stringa VARCHAR2
, p_modulo  VARCHAR2 DEFAULT null
) return VARCHAR2 is
/***********************************************************************************************
 NOME:        get_preferenza_DB_USER
 DESCRIZIONE: Trova una preferenza a livello di DB User con chiave
                 DB_USER|NomeUser/PRODUCTS/NomeModulo
              o in seconda istanza la chiave
                 DB_USER|NomeUser.
 PARAMETRI:   P_STRINGA   VARCHAR2  Nome preferenza
              P_MODULO    VARCHAR2  Modulo AD4 per il quale cercare la chiave
 RITORNA:     VARCHAR2  : valore della preferenza
************************************************************************************************/
   d_valore VARCHAR2(2000) := '';
   d_chiave VARCHAR2(512);
BEGIN
   -- Ricerca preferenza a livello di db user con e senza modulo
   IF p_modulo IS NOT NULL THEN
      d_chiave := 'DB_USERS/'||USER||'/PRODUCTS/'||UPPER(p_modulo);
      leggi_stringa (d_chiave,p_stringa, d_valore, FALSE);
   END IF;
   IF d_valore IS NULL THEN
      d_chiave := 'DB_USERS/'||USER;
      leggi_stringa (d_chiave,p_stringa, d_valore, FALSE);
   END IF;
   RETURN d_valore;
end get_preferenza_DB_USERS;
--
function  is_preferenza 
( p_stringa VARCHAR2
, p_modulo  VARCHAR2 DEFAULT null
, p_utente  VARCHAR2 DEFAULT null
) return VARCHAR2 is
/***********************************************************************************************
 NOME:        is_preferenza
 DESCRIZIONE: Verifica che la preferenza sia stata impostata specificamente per i parametri
              passati.
 PARAMETRI:   P_STRINGA   VARCHAR2  Nome preferenza
              P_MODULO    VARCHAR2  Modulo AD4 per il quale cercare la chiave
 RITORNA:     VARCHAR2  : 1 preferenza impostata, 0 preferenza non impostata
************************************************************************************************/
   d_valore VARCHAR2(2000);
   d_chiave VARCHAR2(512);
BEGIN
   -- Ricerca preferenza a livello utente di sistema
   IF p_utente IS NOT NULL AND p_modulo IS NOT NULL THEN
      d_chiave := 'SI4_DB_USERS/'||p_utente||'|'||USER||'/PRODUCTS/'||UPPER(p_modulo);
      leggi_stringa (d_chiave,p_stringa, d_valore, FALSE);
     IF d_valore IS NOT NULL THEN
        RETURN 1;
     ELSE
        RETURN 0;
     END IF;
   END IF;
   -- Ricerca preferenza a livello di db user
   IF p_modulo IS NOT NULL THEN
      d_chiave := 'DB_USERS/'||USER||'/PRODUCTS/'||UPPER(p_modulo);
      leggi_stringa (d_chiave,p_stringa, d_valore, FALSE);
     IF d_valore IS NOT NULL THEN
        RETURN 1;
     ELSE
        RETURN 0;
     END IF;
   ELSE
      d_chiave := 'DB_USERS/'||USER;
      leggi_stringa (d_chiave,p_stringa, d_valore, FALSE);
      IF d_valore IS NOT NULL THEN
         RETURN 1;
      ELSE
         RETURN 0;
      END IF;
   END IF;
end is_preferenza;
--
procedure set_preferenza
( p_stringa VARCHAR2
, p_valore  VARCHAR2
, p_modulo  VARCHAR2 DEFAULT NULL
, p_utente  VARCHAR2 DEFAULT NULL
) is
/***********************************************************************************************
 NOME:        set_preferenza
 DESCRIZIONE: Registra una preferenza a livello di utente di sistema,
              se non e' definito l'utente registra a livello di DB user,
              se   indicato il modulo aggiunge PRODUCT/NomeModulo.
 PARAMETRI:   p_stringa   VARCHAR2  Nome preferenza
              p_modulo    VARCHAR2  Modulo di sistema per il quale cercare la chiave
              p_utente    VARCHAR2  Nome utente di sistema 
 RITORNA:     VARCHAR2  : valore della preferenza
************************************************************************************************/
   d_chiave   VARCHAR2(512);
BEGIN
   -- Composizione della chiave con cui andare a scrivere su registro
   IF p_utente IS NOT NULL THEN
      d_chiave := 'SI4_DB_USERS/'||p_utente||'|'||USER;
      IF p_modulo IS NOT NULL THEN
         d_chiave := d_chiave||'/PRODUCTS/'||UPPER(p_modulo);
     END IF;
   ELSE
      d_chiave := 'DB_USERS/'||USER;
      IF p_modulo IS NOT NULL THEN
         d_chiave := d_chiave||'/PRODUCTS/'||UPPER(p_modulo);
     END IF;
   END IF;
   crea_chiave(d_chiave, FALSE);
   elimina_stringa(d_chiave ,p_stringa, FALSE);
   -- Se il valore della preferenza e gia presente a livello piu generale non si effettua la registrazione.
   IF p_valore != NVL(get_preferenza (p_stringa, p_modulo, p_utente),' ') THEN
         scrivi_stringa(d_chiave, p_stringa, p_valore);
   END IF;
end set_preferenza;
end REGISTRO_UTILITY;
/
