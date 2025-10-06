--liquibase formatted sql
--changeset amonopoli:202503261017_1 runOnChange:false stripComments:false
CREATE OR REPLACE PACKAGE Si4_Error_Log AS

   type key_error_log_rc is record (
   						 		   		data 			 date,
										Tipo 			 varchar2(1),
										Oggetto 		 varchar2(2000),
										Utente			 varchar2(8),
										Messagge		 varchar2(8)
									);
   type kelcurtype is REF CURSOR return key_error_log_rc;

   FUNCTION  VERSIONE         RETURN varchar2;

   FUNCTION  Count			  ( SessionFilter in number,
   			 				  	ObjectFilter in varchar2,
								UserCodeFilter in varchar2,
								TypeFilter in varchar2
							   ) RETURN NUMBER;
   FUNCTION  Count			  ( SessionFilter in number,
   			 				  	ObjectFilter in varchar2
							   ) RETURN NUMBER;
   FUNCTION  Count			  ( SessionFilter in number
							   ) RETURN NUMBER;

   procedure get_message 	 (	SessionFilter  in NUMBER,
                              	ObjectFilter   in VARCHAR2,
								UserCodeFilter in varchar2,
								Messages 	   in out kelcurtype
                              ) ;

   FUNCTION set_message 	 (	MessageText	   in VARCHAR2,
								UserCode	   in varchar2,
								Object		   in varchar2
                              ) RETURN NUMBER;

   FUNCTION set_message 	 (	MessageText	   in VARCHAR2,
								Object		   in varchar2
                              ) RETURN NUMBER;


   FUNCTION set_error		  (	ErrorText	   in VARCHAR2,
								UserCode	   in varchar2,
								UserText	   in varchar2
                              ) RETURN NUMBER;

   FUNCTION set_error		  (	ErrorText	   in VARCHAR2
                              ) RETURN NUMBER;

END Si4_Error_Log;
/
