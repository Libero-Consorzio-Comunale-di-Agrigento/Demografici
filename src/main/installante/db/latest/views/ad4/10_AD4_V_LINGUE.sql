--liquibase formatted sql
--changeset snocca:202210181656 runOnChange:true
CREATE OR REPLACE FORCE VIEW AD4_V_LINGUE
AS
   SELECT *
     FROM AD4_LINGUE
/
