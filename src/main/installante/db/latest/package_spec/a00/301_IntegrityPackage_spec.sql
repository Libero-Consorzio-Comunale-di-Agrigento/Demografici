--liquibase formatted sql
--changeset amonopoli:202503260900_1 runOnChange:false stripComments:false
create or replace package IntegrityPackage
AS
   -- Variabili per SET Switched FUNCTIONAL Integrity
   Functional boolean := TRUE;

   -- Procedure for Referential Integrity
   procedure SetFunctional;
   procedure ReSetFunctional;
   procedure InitNestLevel;
   function  GetNestLevel return number;
   procedure NextNestLevel;
   procedure PreviousNestLevel;

   -- Variabili e Procedure per
   --  Integrita Referenziale su Relazioni Ricorsive
   type t_operazione is TABLE of varchar2(32000) index by binary_integer;
   type t_messaggio  is TABLE of varchar2(2000) index by binary_integer;
   v_istruzione   t_operazione;
   v_messaggio    t_messaggio;
   v_entry        binary_integer := 0;
   procedure Set_PostEvent (a_istruzione varchar2,
                            a_messaggio  varchar2);
   procedure Exec_PostEvent;

END IntegrityPackage;
/* End Package: IntegrityPackage */
/
