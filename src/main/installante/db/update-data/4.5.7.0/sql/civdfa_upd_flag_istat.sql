--liquibase formatted sql
--changeset snocca:202401090959 runOnChange:true stripComments:false
update civdfa dfa set flag_istat = 'S'
 where dfa.flag_istat is null
   and dfa.formula in ('170', '170-NO', '171', '171-NO', '175', '175-NO', '175-BIS', '175-BIS-NO', '175/A', '175/A-NO', '187-QUINQU');
