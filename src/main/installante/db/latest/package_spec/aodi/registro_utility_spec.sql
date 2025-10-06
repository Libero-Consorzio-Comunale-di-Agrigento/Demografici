--liquibase formatted sql
--changeset amonopoli:202503190810_1 runOnChange:true stripComments:false
CREATE OR REPLACE package REGISTRO_UTILITY is
/******************************************************************************
 NOME:        REGISTRO_UTILITY.
 DESCRIZIONE: Funzioni per la gestione del Registro (analogo al Registry di
              Windows).
              Le chiavi sono organizzate secondo un modello gerarchico ad
              albero. Per riferirsi ad una chiave e necessario utilizzare il
              percorso completo indicando tutte le chiavi di livello superiore
              utilizzando il carattere "/" come separatore.
              Le radici (chiavi di primo livello) sono predefinite ed
              invariabili:
                DB_USERS     impostazioni utenti di Database User
                SI4_USERS    impostazioni utenti Sistema Informativo 4
                SI4_DB_USERS impostazioni utenti Sistema Informativo 4
                             nel contesto dei singoli utenti di database
                PRODUCTS     impostazioni di Prodotto
              Le chiavi di secondo livello devono essere significative
              nell'ambito della radice:
                DB_USERS/<utente_database>
                SI4_USERS/<utente_si4>
                SI4_DB_USERS/<utente_si4>|<utente_database>
                PRODUCTS/<nome_prodotto>>
              Sono utilizzabili anche radici abbreviate che indirizzano
              direttamente il secondo livello:
                LOCAL_DB_USER  per DB_USERS/<utente_database>
                LOCAL_SI4_USER per SI4_USERS/<utente_si4>
                CURRENT_USER   per SI4_DB_USERS/<utente_si4>|<utente_database>
              Le radici LOCAL_SI4_USER e CURRENT_USER sono utilizzabili solo
              tramite la funzione TRASFORMA_CHIAVE in quanto non e possibile
              determinate automaticamente il valore <utente_si4>.
 FUNZIONI:    versione         : restituisce la versione del Package.
              livello_chiave   : restituisce numero di separatori utilizzati nella chiave.
              trasforma_chiave : risolve le chiavi con radici abbreviate.
              crea_chiave      : aggiunge una chiave crendo anche tutte le chiavi di livello superiore.
              elimina_chiave   : elimna chiave e tuttl le chiavi di livello inferiore.
              rinomina_chiave  : modifica il livello minimo della chiave.
              leggi_stringa    : restituisce il valore corrente.
              scrivi_stringa   : crea e/o valorizza una stringa.
              elimina_stringa  : elimina una stringa.
              get_stringa      : Ritorna il valore di una stringa per la chiave indicata.
              get_preferenza:  : Trova una preferenza cercando a livello di utente di sistema,
                                 se non e' definito l'utente  cerca a livello di portale 
                                 se   indicato il modulo cerca sulla chiave PRODUCT/NomeModulo.
              get_preferenza_SI4_DB_USER
                               : Trova una preferenza a livello di utente di sistema con chiave
                                    SI4_DB_USERS/NomeSi4User|NomeUser/PRODUCTS/NomeModulo
                                 o in seconda istanza
                                    SI4_DB_USERS/NomeSi4User|NomeUser.
              get_preferenza_DB_USER
                               : Trova una preferenza a livello di DB User con chiave
                                    DB_USER|NomeUser/PRODUCTS/NomeModulo
                                 o in seconda istanza
                                    DB_USER|NomeUser.
              is_preferenza    : Verifica che la preferenza sia stata impostata specificamente
                                 per i parametri passati.  
              set_preferenza   : Registra una preferenza a livello di utente di sistema,
                                 se non e' definito l'utente registra a livello di DB user,
                                 se   indicato il modulo aggiunge PRODUCT/NomeModulo.
 ARGOMENTI:   in_si4_user   IN  varchar2 : Utente applicativo definito in AD4,A00,SI.
              in_db_user    IN  varchar2 : User di database.
              in_chiave     IN  varchar2 : Percorso completo con separatore "/".
              in_stringa    IN  varchar2 : Identificativo nel contesto della chiave.
              in_valore     IN  varchar2 : Valore da attrubire alla stringa di registro.
              in_commento   IN  varchar2 : Annotazione relativa alla stringa.
              in_eccezione  IN  boolean default true
                                         : Livello dei controlli. 
                                           Il valore false inibisce gli errori di basso livello.
              in_nuovo_nome IN  varchar2 : Elemento di livello minimo della chiave.
              out_valore    OUT varchar2 : Valore corrente della stringa di registro.
              p_stringa         VARCHAR2 : Nome preferenza.
              p_modulo          VARCHAR2 : Modulo di sistema per il quale cercare la preferenza.
              p_utente          VARCHAR2 : Nome utente di sistema per il quale cercare la preferenza.
 ECCEZIONI:
              20901    - DB User non specificato
              20902    - SI4 User non specificato
              20910    - Radice "<valore_radice>" non prevista
              20916    - Impossibile alterare le radici del registro
              20919    - Impossibile eliminare radici registro
              20921 low   - Chiave "<valore_chiave>" gia esistente
              20922 low   - Chiave "<valore_chiave>" non trovata
              20923    - Chiave "<valore_chiave>" incompleta. Eliminare il carattere finale
              20925    - Nome chiave non valido. Non utilizzare il separatore "/"
              20926    - Errore creazione chiave "<valore_chiave>"
              20927    - Errore creazione chiave parziale "<valore_chiave>"
              20931 low   - Stringa "<valore_stringa>" gia esistente
              20932 low   - Stringa "<valore_stringa>" non trovata
              20936    - Errore variazione stringa "<valore_stringa>"
              20939    - Impossibile eliminare la stringa predefinita
 ANNOTAZIONI: .
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 00   08/08/2001 MP     Prima emissione.
 01   13/11/2002 MF     Introduzione della Chiave "PRODUCTS".
 02   20/01/2003 MM     Duplicazione delle procedure con parametri BOOLEAN
                        (sostituiti con NUMBER) per chiamarle da applicativi terzi.
 03   03/11/2005 MF     Inserimento funzioni di gestione "preferenza" e revisione
                        sintassi.
******************************************************************************/
   s_revisione constant VARCHAR2(30) := 'V1.03';
   function versione return VARCHAR2;
   pragma restrict_references(versione, WNDS, WNPS);
   function livello_chiave
   ( in_chiave      varchar2
   ) return number;
   pragma restrict_references(livello_chiave, WNDS, RNDS);
   function trasforma_chiave -- solo traduzione db corrente
   ( in_chiave      varchar2
   ) return varchar2;
   function trasforma_chiave
   ( in_chiave      varchar2
   , in_si4_user    varchar2
   , in_db_user     varchar2   default null
   ) return varchar2;
   procedure crea_chiave
   ( in_chiave      in   varchar2
   , in_eccezione   in   boolean    default true
   );
   procedure crea_chiave
   ( in_chiave      in   varchar2
   , in_eccezione   in   number
   );
   procedure elimina_chiave
   ( in_chiave      in   varchar2
   , in_eccezione   in   boolean     default true
   );
   procedure elimina_chiave
   ( in_chiave      in   varchar2
   , in_eccezione   in   number
   );
   procedure leggi_stringa
   ( in_chiave      in   varchar2
   , in_stringa     in   varchar2
   , out_valore     out  varchar2
   , in_eccezione   in   boolean    default true
   );
   function leggi_stringa
   ( in_chiave      in   varchar2
   , in_stringa     in   varchar2
   , in_eccezione   in   number
   )
   return varchar2;
   procedure rinomina_chiave
   ( in_chiave      in   varchar2
   , in_nuovo_nome  in   varchar2
   , in_eccezione   in   boolean     default true
   );
   procedure rinomina_chiave
   ( in_chiave      in   varchar2
   , in_nuovo_nome  in   varchar2
   , in_eccezione   in   number
   );
   procedure scrivi_stringa
   ( in_chiave      in   varchar2
   , in_stringa     in   varchar2
   , in_valore      in   varchar2
   , in_commento    in   varchar2   default null
   , in_eccezione   in   boolean    default true
   );
   procedure scrivi_stringa
   ( in_chiave      in   varchar2
   , in_stringa     in   varchar2
   , in_valore      in   varchar2
   , in_commento    in   varchar2
   , in_eccezione   in   number
   );
   procedure elimina_stringa
   ( in_chiave      in   varchar2
   , in_stringa     in   varchar2
   , in_eccezione   in   boolean    default true
   );
   procedure elimina_stringa
   ( in_chiave      in   varchar2
   , in_stringa     in   varchar2
   , in_eccezione   in   number
   );
   function get_stringa 
   ( in_chiave     varchar2
   , in_stringa    varchar2
   ) return varchar2;
   function get_preferenza 
   ( p_stringa varchar2
   , p_modulo  varchar2 default null 
   , p_utente  varchar2 default null 
   ) return varchar2;
   function get_preferenza_SI4_DB_USERS 
   ( p_stringa varchar2
   , p_modulo  varchar2 default null 
   , p_utente  varchar2 default null 
   ) return varchar2;
   function get_preferenza_DB_USERS
   ( p_stringa varchar2
   , p_modulo  varchar2 default null 
   ) return varchar2;
   function is_preferenza 
   ( p_stringa varchar2
   , p_modulo  varchar2 default null
   , p_utente  varchar2 default null
   ) return varchar2;
   procedure set_preferenza 
   ( p_stringa varchar2
   , p_valore  varchar2
   , p_modulo  varchar2 default null 
   , p_utente  varchar2 default null 
   );
end REGISTRO_UTILITY;
/
