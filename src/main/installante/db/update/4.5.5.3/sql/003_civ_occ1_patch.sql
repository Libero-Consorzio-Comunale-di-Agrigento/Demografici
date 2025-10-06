--liquibase formatted sql
--changeset snocca:202212221501
alter table civocc
modify
(COGNOME			varchar2(100)
,NOME				varchar2(100)
,COGNOME_CN			varchar2(100)
,NOME_CN			varchar2(100)
)
/
