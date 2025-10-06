--liquibase formatted sql
--changeset amonopoli:202503190815_1 runOnChange:true stripComments:false
CREATE OR REPLACE package AFC_HTTP is
/******************************************************************************
 NOME:        AFC_HTTP.
 DESCRIZIONE: Gestione chiamate classi Java esposte come istruzioni da una 
              Servlet di servizio ad DataBase
 ANNOTAZIONI: .
 REVISIONI: .
 <CODE>
 Rev.  Data        Autore  Descrizione.
 00    19/12/2007  VA  Prima emissione.
 </CODE>
******************************************************************************/

   s_revisione constant VARCHAR2(30) := 'V1.00';

   procedure set_service_url
   ( p_url in varchar2
   );

   procedure set_method
   ( p_method in varchar2 default 'GET'
   );

   procedure set_session_wallet
   ( p_session_wallet in varchar2
   );

   procedure set_session_wallet_pwd
   ( p_session_wallet_pwd in varchar2
   );


   function versione
   return varchar2;

   function get_service_url
   return varchar2;

   procedure set_servlet
   ( p_nome_servlet in varchar2
   );

   function get_servlet
   ( p_nome_servlet varchar2 default null
   ) return varchar2;

   function get_servlet_url
   ( p_nome_servlet varchar2 default null
   ) return varchar2;

   function sendRequest
   ( p_request  in varchar2
   , p_user     in varchar2 default null
   , p_password in varchar2 default null
   ) return varchar2;

   function sendSoaRequest
   ( p_soaService in varchar2
   , p_soaAlias in varchar2
   , p_soaParameters in varchar2
   , p_user     in varchar2 default null
   , p_password in varchar2 default null
   ) return varchar2;

end AFC_HTTP; 
/
