--liquibase formatted sql
--changeset amonopoli:202503190815_2 runOnChange:true stripComments:false
CREATE OR REPLACE PACKAGE BODY AFC_HTTP AS
/******************************************************************************
   NAME:       AFC_HTTP
   PURPOSE:
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        15/01/2008             1. Created this package body.
******************************************************************************/
   d_service  VARCHAR2(1000);
      SUBTYPE t_service IS d_service%TYPE;
   s_service_url   t_service;
   d_servlet  VARCHAR2(1000);
      SUBTYPE t_servlet IS d_servlet%TYPE;
   s_servlet  t_servlet;
   s_revisione_body           constant AFC.t_revision := '001';
   s_method         VARCHAR2(10) := 'GET';
   d_path  VARCHAR2(1000);
      SUBTYPE t_path IS d_path%TYPE;
   s_session_wallet   t_path;
   d_password  VARCHAR2(100);
      SUBTYPE t_password IS d_password%TYPE;
   s_session_wallet_pwd t_password;
--------------------------------------------------------------------------------
   function versione
   return varchar2 is
   /******************************************************************************
    NOME:        versione.
    DESCRIZIONE: Versione e revisione di distribuzione del package.
    RITORNA:     varchar2 stringa contenente versione e revisione.
    NOTE:        Primo numero  : versione compatibilit  del Package.
                 Secondo numero: revisione del Package specification.
                 Terzo numero  : revisione del Package body.
   ******************************************************************************/
   begin
      return AFC.version( s_revisione, s_revisione_body );
   end; -- AFC_Error.versione
   PROCEDURE set_service_url
   ( p_url in varchar2
   )is
   BEGIN
    s_service_url := p_url;
   END;
   FUNCTION get_service_url
   return varchar2 is
   d_service_url   t_service;
   d_istanza       ad4_istanze.istanza%type;
   BEGIN
    if s_service_url is not null then
       d_service_url := s_service_url;
    else
       /* Se la variabile interna non   settata cerco di recuperare l'informazione da AD4*/
       d_istanza := si4.istanza;
       if d_istanza is not null then
          select max(servizio)
            into d_service_url
            from ad4_istanze
           where istanza = d_istanza
             and servizio like 'http%';
       elsif d_istanza is null or d_service_url is null then
          select max(servizio)
            into d_service_url
            from ad4_istanze
           where user_oracle = user
             and servizio like 'http%';
       end if;
    end if;
    d_service_url := nvl(d_service_url,'http://localhost:8080/'||lower(d_istanza));
    RETURN d_service_url;
   END;
   PROCEDURE set_servlet
   ( p_nome_servlet in varchar2
   ) is
   BEGIN
    s_servlet := p_nome_servlet;
   END;
   PROCEDURE set_method
   ( p_method in varchar2 default 'GET'
   ) is
   BEGIN
   if upper(p_method) in ('GET', 'POST') then
      s_method := upper(p_method);
   else
      raise_application_error(-20999, 'Metodi previsti: GET - POST');
   end if;
   END;
   PROCEDURE set_session_wallet
   ( p_session_wallet in varchar2
   ) is
   BEGIN
    s_session_wallet := p_session_wallet;
   END;
   FUNCTION get_wallet
    return varchar2 is
   d_wallet t_path;
   begin
      ad4_registro_utility.leggi_stringa('PRODUCTS/AUTHENTICATION/HTTPS','WALLET',d_wallet,false);
      d_wallet := nvl(s_session_wallet,d_wallet);
      return d_wallet;
   end;
   PROCEDURE set_session_wallet_pwd
   ( p_session_wallet_pwd in varchar2
   ) is
   BEGIN
    s_session_wallet_pwd := p_session_wallet_pwd;
   END;
   FUNCTION get_wallet_pwd
    return varchar2 is
   d_wallet_pwd t_password;
   begin
      registro_utility.leggi_stringa('PRODUCTS/AUTHENTICATION/HTTPS','PWDWALLET',d_wallet_pwd,false);
      d_wallet_pwd := nvl(s_session_wallet_pwd,d_wallet_pwd);
      return d_wallet_pwd;
   end;
   FUNCTION get_servlet
   ( p_nome_servlet varchar2 default null
   ) return varchar2 is
   d_servlet t_servlet;
   begin
      if p_nome_servlet is null then
         d_servlet := s_servlet;
      else
         registro_utility.leggi_stringa('PRODUCTS/SERVLET',p_nome_servlet,d_servlet,false);
         d_servlet := nvl(d_servlet,p_nome_servlet);
      end if;
      return d_servlet;
   end;
   FUNCTION get_servlet_url
   ( p_nome_servlet varchar2 default null
   ) return varchar2  is
   d_servlet_url t_servlet;
   begin
   d_servlet_url := get_service_url||'/'||get_servlet(p_nome_servlet);
   return d_servlet_url;
   end;
   FUNCTION sendRequest
   ( p_request in varchar2
   , p_user     in varchar2 default null
   , p_password in varchar2 default null
   ) return varchar2 is
   d_request   varchar2(30000);
   d_response  varchar2(30000);
   d_http_req  utl_http.req;
   d_http_resp utl_http.resp;
   r utl_http.req;
   BEGIN
    d_request  := replace(utl_url.escape(p_request),'#','%23'); --, true);
    --dbms_output.put_line(substr(d_request,1,250));
    if instr(lower(d_request),'https') > 0 then
       --utl_http.set_wallet('file:/oracle/app/oracle/admin/PAL','lavoro17');
       utl_http.set_wallet(get_wallet,get_wallet_pwd);
    end if;
    d_http_req := utl_http.begin_request
                 ( d_request
                 , s_method --'POST'
                 , 'HTTP/1.1'
                 );
    if p_user is not null then
       utl_http.set_authentication(d_http_req, p_user, p_password);
    end if;
    d_http_resp := utl_http.get_response(d_http_req);
    utl_http.read_text (d_http_resp, d_response);
   -- dbms_output.put_line(d_http_resp.status_code||' - '||d_http_resp.reason_phrase);
    utl_http.end_response(d_http_resp);
   -- utl_http.end_request(d_http_req);
    RETURN d_response;
    exception when others then
      raise_application_error(-20999,d_http_resp.status_code||' - '||d_http_resp.reason_phrase, true);
   --raise;
   END;
   FUNCTION sendSoaRequest
   ( p_soaService in varchar2
   , p_soaAlias in varchar2
   , p_soaParameters in varchar2
   , p_user     in varchar2 default null
   , p_password in varchar2 default null
   ) return varchar2 is
   d_request        AFC.t_statement;
   d_response       AFC.t_statement;
   BEGIN
      d_request := get_servlet_url(p_soaService)
                || '?' ||p_soaAlias
                || '&' ||p_soaParameters;
       d_response := sendRequest(d_request, p_user, p_password);
      return d_response;
   END;
END AFC_HTTP;
/
