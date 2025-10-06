--liquibase formatted sql
--changeset vmigliore:202410221030 runOnChange:true stripComments:false
declare
    w_oracle_ver varchar2(255) := f_GSD_versione_oracle();
    w_tipo_ogg   varchar2(255) := 'tab';
    w_nome_ogg   varchar2(255) := 'cerdce_ctc';
    w_nome_col   varchar2(255) := '';
    w_des_ogg    varchar2(255) := w_tipo_ogg || '.' || w_nome_ogg || '.' || w_nome_col;
    w_check_db   number        := f_GSD_check_db(w_tipo_ogg, w_nome_ogg, w_nome_col);
    w_sql        varchar2(32000);
    w_result     varchar2(32000);

begin
    if w_check_db = 0 then
        dbms_output.put_line('oggetto ' || w_des_ogg || ' non esistente');

    elsif w_check_db = 1 then
        dbms_output.put_line('oggetto ' || w_des_ogg || ' esistente');
        w_sql := 'drop table cerdce_ctc';

        begin
            execute immediate w_sql;
            dbms_output.put_line('oggetto ' || w_des_ogg || ' eliminato');
        exception
            when others then
                dbms_output.put_line('oggetto ' || w_des_ogg || ' non creato (' || SQLERRM || ')');
        end;
    end if;
end;
/
declare
    w_oracle_ver varchar2(255) := f_GSD_versione_oracle();
    w_tipo_ogg   varchar2(255) := 'SEQ';
    w_nome_ogg   varchar2(255) := 'cerdce_ctc_sq';
    w_nome_col   varchar2(255) := '';
    w_des_ogg    varchar2(255) := w_tipo_ogg || '.' || w_nome_ogg || '.' || w_nome_col;
    w_check_db   number        := f_GSD_check_db(w_tipo_ogg, w_nome_ogg, w_nome_col);
    w_sql        varchar2(32000);
    w_result     varchar2(32000);

begin
    if w_check_db = 0 then
        dbms_output.put_line('oggetto ' || w_des_ogg || ' non esistente');

    elsif w_check_db = 1 then
        dbms_output.put_line('oggetto ' || w_des_ogg || ' esistente');
        w_sql := 'drop sequence cerdce_ctc_sq';

        begin
            execute immediate w_sql;
            dbms_output.put_line('oggetto ' || w_des_ogg || ' eliminato');
        exception
            when others then
                dbms_output.put_line('oggetto ' || w_des_ogg || ' non creato (' || SQLERRM || ')');
        end;
    end if;
end;
/
declare
    w_oracle_ver varchar2(255) := f_GSD_versione_oracle();
    w_tipo_ogg   varchar2(255) := 'FNC';
    w_nome_ogg   varchar2(255) := 'f_cerdce_ctc_nr';
    w_nome_col   varchar2(255) := '';
    w_des_ogg    varchar2(255) := w_tipo_ogg || '.' || w_nome_ogg || '.' || w_nome_col;
    w_check_db   number        := f_GSD_check_db(w_tipo_ogg, w_nome_ogg, w_nome_col);
    w_sql        varchar2(32000);
    w_result     varchar2(32000);

begin
    if w_check_db = 0 then
        dbms_output.put_line('oggetto ' || w_des_ogg || ' non esistente');

    elsif w_check_db = 1 then
        dbms_output.put_line('oggetto ' || w_des_ogg || ' esistente');
        w_sql := 'drop function f_cerdce_ctc_nr';

        begin
            execute immediate w_sql;
            dbms_output.put_line('oggetto ' || w_des_ogg || ' eliminato');
        exception
            when others then
                dbms_output.put_line('oggetto ' || w_des_ogg || ' non creato (' || SQLERRM || ')');
        end;
    end if;
end;
/
