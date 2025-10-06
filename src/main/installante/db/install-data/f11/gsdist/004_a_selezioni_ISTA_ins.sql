--liquibase formatted sql
--changeset amonopoli:202503210950_4 runOnChange:true stripComments:false
delete a_selezioni
 where voce_menu in ('ISTED4B','ISTED7A','ISTED7B','ISTEDAP','ISTEDD3','ISTEDD4','ISTEDDV','ISTEDP2','ISTEDP4')
/
insert into a_selezioni (PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS, NUMERO_FK)
select 'NUM_CARATTERI', 'ISTED4B', 0, 'Caratteri per Substring', '', '', 5, 'C', 'S', '200', '', '', '', '' from dual UNION
select 'SE_SUBSTR', 'ISTED4B', 0, 'Abilita Substring', '', '', 10, 'C', 'S', 'SI', '', '', '', ''           from dual UNION
select 'TXTFILE', 'ISTED4B', 0, 'Nome TXT File', '', '', 80, 'C', 'S', 'istatel\D4B.txt', '', '', '', ''    from dual
/
insert into a_selezioni (PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2,  LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS, NUMERO_FK)
select 'NUM_CARATTERI', 'ISTED7A', 0, 'Caratteri per Substring', '', '', 5, 'C', 'S', '167', '', '', '', '' from dual UNION
select 'SE_SUBSTR', 'ISTED7A', 0, 'Abilita Substring', '', '', 10, 'C', 'S', 'SI', '', '', '', ''           from dual UNION
select 'TXTFILE', 'ISTED7A', 0, 'Nome TXT File', '', '', 80, 'C', 'S', 'istatel\7A.txt', '', '', '', ''     from dual
/
insert into a_selezioni (PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS, NUMERO_FK)
select 'NUM_CARATTERI', 'ISTED7B', 0, 'Caratteri per Substring', '', '', 5, 'C', 'S', '257', '', '', '', '' from dual UNION
select 'SE_SUBSTR', 'ISTED7B', 0, 'Abilita Substring', '', '', 10, 'C', 'S', 'SI', '', '', '', ''           from dual UNION
select 'TXTFILE', 'ISTED7B', 0, 'Nome TXT File', '', '', 80, 'C', 'S', 'istatel\7B.txt', '', '', '', ''     from dual
/
insert into a_selezioni (PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS, NUMERO_FK)
select 'NUM_CARATTERI', 'ISTEDAP', 0, 'Caratteri per Substring', '', '', 5, 'C', 'S', '2000', '', '', '', '' from dual UNION
select 'SE_SUBSTR', 'ISTEDAP', 0, 'Abilita Substring', '', '', 10, 'C', 'S', 'SI', '', '', '', ''            from dual UNION
select 'SE_RTRIM', 'ISTEDAP', 0, 'Abilita Ltrim', '', '', 10, 'C', 'S', 'SI', '', '', '', ''                 from dual UNION
select 'TXTFILE', 'ISTEDAP', 0, 'Nome TXT File', '', '', 80, 'C', 'S', 'istatel\APR4.txt', '', '', '', ''    from dual
/
insert into a_selezioni (PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS, NUMERO_FK)
select 'NUM_CARATTERI', 'ISTEDD3', 0, 'Caratteri per Substring', '', '', 5, 'C', 'S', '250', '', '', '', '' from dual UNION
select 'SE_SUBSTR', 'ISTEDD3', 0, 'Abilita Substring', '', '', 10, 'C', 'S', 'SI', '', '', '', ''           from dual UNION
select 'TXTFILE', 'ISTEDD3', 0, 'Nome TXT File', '', '', 80, 'C', 'S', 'istatel\D3.txt', '', '', '', ''     from dual
/
insert into a_selezioni (PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS, NUMERO_FK)
select 'NUM_CARATTERI', 'ISTEDD4', 0, 'Caratteri per Substring', '', '', 5, 'C', 'S', '87', '', '', '', '' from dual UNION
select 'SE_SUBSTR', 'ISTEDD4', 0, 'Abilita Substring', '', '', 10, 'C', 'S', 'SI', '', '', '', ''          from dual UNION
select 'TXTFILE', 'ISTEDD4', 0, 'Nome TXT File', '', '', 80, 'C', 'S', 'istatel\D4.txt', '', '', '', ''    from dual
/
insert into a_selezioni (PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS, NUMERO_FK)
select 'NUM_CARATTERI', 'ISTEDDV', 0, 'Caratteri per Substring', '', '', 5, 'C', 'S', '4000', '', '', '', '' from dual UNION
select 'SE_SUBSTR', 'ISTEDDV', 0, 'Abilita Substring', '', '', 10, 'C', 'S', 'SI', '', '', '', ''            from dual UNION
select 'SE_RTRIM', 'ISTEDDV', 0, 'Abilita Ltrim', '', '', 10, 'C', 'S', 'SI', '', '', '', ''                 from dual UNION
select 'TXTFILE', 'ISTEDDV', 0, 'Nome TXT File', '', '', 80, 'C', 'S', 'istatel\DV.txt', '', '', '', ''      from dual
/
insert into a_selezioni (PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS, NUMERO_FK)
select 'NUM_CARATTERI', 'ISTEDP2', 0, 'Caratteri per Substring', '', '', 5, 'C', 'S', '261', '', '', '', '' from dual UNION
select 'SE_SUBSTR', 'ISTEDP2', 0, 'Abilita Substring', '', '', 10, 'C', 'S', 'SI', '', '', '', ''           from dual UNION
select 'TXTFILE', 'ISTEDP2', 0, 'Nome TXT File', '', '', 80, 'C', 'S', 'istatel\P2.txt', '', '', '', ''     from dual
/
insert into a_selezioni (PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS, NUMERO_FK)
select 'NUM_CARATTERI', 'ISTEDP4', 0, 'Caratteri per Substring', '', '', 5, 'C', 'S', '330', '', '', '', '' from dual UNION
select 'SE_SUBSTR', 'ISTEDP4', 0, 'Abilita Substring', '', '', 10, 'C', 'S', 'SI', '', '', '', '' from dual UNION
select 'TXTFILE', 'ISTEDP4', 0, 'Nome TXT File', '', '', 80, 'C', 'S', 'istatel\P4.txt', '', '', '', '' from dual
/
