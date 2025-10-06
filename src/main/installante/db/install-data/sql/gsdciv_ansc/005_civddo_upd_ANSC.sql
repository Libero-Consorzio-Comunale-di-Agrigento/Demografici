--liquibase formatted sql
--changeset amonopoli:202305251100 runOnChange:true stripComments:false
update civddo
   set CODICE_ANSC = '999'
 where tipo_atto = -4
   and cod_do    = 'PU'
/
update civddo
   set CODICE_ANSC = '1'
 where tipo_atto = 2
   and cod_do    = '01'
/
update civddo
   set CODICE_ANSC = ''
 where tipo_atto = 1
   and cod_do    = 'ST'
/
update civddo
   set CODICE_ANSC = ''
 where tipo_atto = 5
   and cod_do    = 'TS'
/
update civddo
   set CODICE_ANSC = ''
 where tipo_atto = 1
   and cod_do    = 'AL'
/
update civddo
   set CODICE_ANSC = '3'
 where tipo_atto = 2
   and cod_do    = '03'
/
update civddo
   set CODICE_ANSC = '95'
 where tipo_atto = 2
   and cod_do    = 'ST'
/
update civddo
   set CODICE_ANSC = '95'
 where tipo_atto = 4
   and cod_do    = 'ST'
/
update civddo
   set CODICE_ANSC = '95'
 where tipo_atto = 5
   and cod_do    = 'ST'
/
update civddo
   set CODICE_ANSC = '95'
 where tipo_atto = -4
   and cod_do    = 'ST'
/
update civddo
   set CODICE_ANSC = ''
 where tipo_atto = 2
   and cod_do    = 'AL'
/
update civddo
   set CODICE_ANSC = ''
 where tipo_atto = 4
   and cod_do    = 'AL'
/
update civddo
   set CODICE_ANSC = ''
 where tipo_atto = 5
   and cod_do    = 'AL'
/
update civddo
   set CODICE_ANSC = ''
 where tipo_atto = -4
   and cod_do    = 'AL'
/
update civddo
   set CODICE_ANSC = '999'
 where tipo_atto = 4
   and cod_do    = 'P4'
/
update civddo
   set CODICE_ANSC = ''
 where tipo_atto = 1
   and cod_do    = 'AT'
/
update civddo
   set CODICE_ANSC = ''
 where tipo_atto = 2
   and cod_do    = 'AT'
/
update civddo
   set CODICE_ANSC = ''
 where tipo_atto = 4
   and cod_do    = 'AT'
/
update civddo
   set CODICE_ANSC = ''
 where tipo_atto = 5
   and cod_do    = 'AT'
/
update civddo
   set CODICE_ANSC = ''
 where tipo_atto = -4
   and cod_do    = 'AT'
/
update civddo
   set CODICE_ANSC = ''
 where tipo_atto = 1
   and cod_do    = 'CO'
/
update civddo
   set CODICE_ANSC = ''
 where tipo_atto = 2
   and cod_do    = 'CO'
/
update civddo
   set CODICE_ANSC = ''
 where tipo_atto = 4
   and cod_do    = 'CO'
/
update civddo
   set CODICE_ANSC = ''
 where tipo_atto = 5
   and cod_do    = 'CO'
/
update civddo
   set CODICE_ANSC = ''
 where tipo_atto = -4
   and cod_do    = 'CO'
/
update civddo
   set CODICE_ANSC = ''
 where tipo_atto = 1
   and cod_do    = 'EA'
/
update civddo
   set CODICE_ANSC = ''
 where tipo_atto = 2
   and cod_do    = 'EA'
/
update civddo
   set CODICE_ANSC = ''
 where tipo_atto = 4
   and cod_do    = 'EA'
/
update civddo
   set CODICE_ANSC = ''
 where tipo_atto = 5
   and cod_do    = 'EA'
/
update civddo
   set CODICE_ANSC = ''
 where tipo_atto = -4
   and cod_do    = 'EA'
/
update civddo
   set CODICE_ANSC = ''
 where tipo_atto = 1
   and cod_do    = 'RA'
/
update civddo
   set CODICE_ANSC = ''
 where tipo_atto = 2
   and cod_do    = 'RA'
/
update civddo
   set CODICE_ANSC = ''
 where tipo_atto = 4
   and cod_do    = 'RA'
/
update civddo
   set CODICE_ANSC = ''
 where tipo_atto = 5
   and cod_do    = 'RA'
/
update civddo
   set CODICE_ANSC = ''
 where tipo_atto = -4
   and cod_do    = 'RA'
/
update civddo
   set CODICE_ANSC = ''
 where tipo_atto = 3
   and cod_do    = 'AT'
/
update civddo
   set CODICE_ANSC = ''
 where tipo_atto = 1
   and cod_do    = 'AF'
/
update civddo
   set CODICE_ANSC = ''
 where tipo_atto = 2
   and cod_do    = 'AF'
/
update civddo
   set CODICE_ANSC = ''
 where tipo_atto = 4
   and cod_do    = 'AF'
/
update civddo
   set CODICE_ANSC = ''
 where tipo_atto = 5
   and cod_do    = 'AF'
/
update civddo
   set CODICE_ANSC = ''
 where tipo_atto = -4
   and cod_do    = 'AF'
/
update civddo
   set CODICE_ANSC = ''
 where tipo_atto = 3
   and cod_do    = 'AF'
/
update civddo
   set CODICE_ANSC = '2'
 where tipo_atto = 2
   and cod_do    = '02'
/
update civddo
   set CODICE_ANSC = '4'
 where tipo_atto = 2
   and cod_do    = '04'
/
update civddo
   set CODICE_ANSC = '5'
 where tipo_atto = 2
   and cod_do    = '05'
/
update civddo
   set CODICE_ANSC = '6'
 where tipo_atto = 4
   and cod_do    = '06'
/
update civddo
   set CODICE_ANSC = '7'
 where tipo_atto = 2
   and cod_do    = '07'
/
update civddo
   set CODICE_ANSC = '8'
 where tipo_atto = 2
   and cod_do    = '08'
/
update civddo
   set CODICE_ANSC = '9'
 where tipo_atto = 2
   and cod_do    = '09'
/
update civddo
   set CODICE_ANSC = '10'
 where tipo_atto = 2
   and cod_do    = '10'
/
update civddo
   set CODICE_ANSC = '11'
 where tipo_atto = 2
   and cod_do    = '11'
/
update civddo
   set CODICE_ANSC = '12'
 where tipo_atto = 2
   and cod_do    = '12'
/
update civddo
   set CODICE_ANSC = '13'
 where tipo_atto = 2
   and cod_do    = '13'
/
update civddo
   set CODICE_ANSC = '14'
 where tipo_atto = 2
   and cod_do    = '14'
/
update civddo
   set CODICE_ANSC = '15'
 where tipo_atto = 2
   and cod_do    = '15'
/
update civddo
   set CODICE_ANSC = '16'
 where tipo_atto = 2
   and cod_do    = '16'
/
update civddo
   set CODICE_ANSC = '17'
 where tipo_atto = 2
   and cod_do    = '17'
/
update civddo
   set CODICE_ANSC = '18'
 where tipo_atto = 2
   and cod_do    = '18'
/
update civddo
   set CODICE_ANSC = '19'
 where tipo_atto = 5
   and cod_do    = '19'
/
update civddo
   set CODICE_ANSC = '20'
 where tipo_atto = 2
   and cod_do    = '20'
/
update civddo
   set CODICE_ANSC = '21'
 where tipo_atto = 2
   and cod_do    = '21'
/
update civddo
   set CODICE_ANSC = '22'
 where tipo_atto = 2
   and cod_do    = '22'
/
update civddo
   set CODICE_ANSC = '23'
 where tipo_atto = 2
   and cod_do    = '23'
/
update civddo
   set CODICE_ANSC = '25'
 where tipo_atto = 4
   and cod_do    = '25'
/
update civddo
   set CODICE_ANSC = '26'
 where tipo_atto = 5
   and cod_do    = '26'
/
update civddo
   set CODICE_ANSC = '27'
 where tipo_atto = 2
   and cod_do    = '27'
/
update civddo
   set CODICE_ANSC = '28'
 where tipo_atto = 5
   and cod_do    = '28'
/
update civddo
   set CODICE_ANSC = '29'
 where tipo_atto = 2
   and cod_do    = '29'
/
update civddo
   set CODICE_ANSC = '30'
 where tipo_atto = 1
   and cod_do    = '30'
/
update civddo
   set CODICE_ANSC = '31'
 where tipo_atto = 2
   and cod_do    = '31'
/
update civddo
   set CODICE_ANSC = '32'
 where tipo_atto = 5
   and cod_do    = '32'
/
update civddo
   set CODICE_ANSC = '33'
 where tipo_atto = 5
   and cod_do    = '33'
/
update civddo
   set CODICE_ANSC = '34'
 where tipo_atto = 5
   and cod_do    = '34'
/
update civddo
   set CODICE_ANSC = '35'
 where tipo_atto = 5
   and cod_do    = '35'
/
update civddo
   set CODICE_ANSC = '36'
 where tipo_atto = 4
   and cod_do    = '36'
/
update civddo
   set CODICE_ANSC = '37'
 where tipo_atto = 5
   and cod_do    = '37'
/
update civddo
   set CODICE_ANSC = '38'
 where tipo_atto = 4
   and cod_do    = '38'
/
update civddo
   set CODICE_ANSC = '39'
 where tipo_atto = 5
   and cod_do    = '39'
/
update civddo
   set CODICE_ANSC = '40'
 where tipo_atto = 5
   and cod_do    = '40'
/
update civddo
   set CODICE_ANSC = '41'
 where tipo_atto = 5
   and cod_do    = '41'
/
update civddo
   set CODICE_ANSC = '42'
 where tipo_atto = 4
   and cod_do    = '42'
/
update civddo
   set CODICE_ANSC = '43'
 where tipo_atto = 4
   and cod_do    = '43'
/
update civddo
   set CODICE_ANSC = '44'
 where tipo_atto = 4
   and cod_do    = '44'
/
update civddo
   set CODICE_ANSC = '45'
 where tipo_atto = 4
   and cod_do    = '45'
/
update civddo
   set CODICE_ANSC = '46'
 where tipo_atto = 4
   and cod_do    = '46'
/
update civddo
   set CODICE_ANSC = '47'
 where tipo_atto = 4
   and cod_do    = '47'
/
update civddo
   set CODICE_ANSC = '48'
 where tipo_atto = 4
   and cod_do    = '48'
/
update civddo
   set CODICE_ANSC = '49'
 where tipo_atto = 1
   and cod_do    = '49'
/
update civddo
   set CODICE_ANSC = '50'
 where tipo_atto = 4
   and cod_do    = '50'
/
update civddo
   set CODICE_ANSC = '51'
 where tipo_atto = 4
   and cod_do    = '51'
/
update civddo
   set CODICE_ANSC = '52'
 where tipo_atto = 4
   and cod_do    = '52'
/
update civddo
   set CODICE_ANSC = '53'
 where tipo_atto = 4
   and cod_do    = '53'
/
update civddo
   set CODICE_ANSC = '54'
 where tipo_atto = 5
   and cod_do    = '54'
/
update civddo
   set CODICE_ANSC = '55'
 where tipo_atto = 4
   and cod_do    = '55'
/
update civddo
   set CODICE_ANSC = '56'
 where tipo_atto = -4
   and cod_do    = '56'
/
update civddo
   set CODICE_ANSC = '57'
 where tipo_atto = -4
   and cod_do    = '57'
/
update civddo
   set CODICE_ANSC = '58'
 where tipo_atto = -4
   and cod_do    = '58'
/
update civddo
   set CODICE_ANSC = '59'
 where tipo_atto = -4
   and cod_do    = '59'
/
update civddo
   set CODICE_ANSC = '60'
 where tipo_atto = -4
   and cod_do    = '60'
/
update civddo
   set CODICE_ANSC = '61'
 where tipo_atto = 5
   and cod_do    = '61'
/
update civddo
   set CODICE_ANSC = '62'
 where tipo_atto = -4
   and cod_do    = '62'
/
update civddo
   set CODICE_ANSC = '63'
 where tipo_atto = 1
   and cod_do    = '63'
/
update civddo
   set CODICE_ANSC = '64'
 where tipo_atto = 1
   and cod_do    = '64'
/
update civddo
   set CODICE_ANSC = '65'
 where tipo_atto = 4
   and cod_do    = '65'
/
update civddo
   set CODICE_ANSC = '66'
 where tipo_atto = 1
   and cod_do    = '66'
/
update civddo
   set CODICE_ANSC = '67'
 where tipo_atto = 1
   and cod_do    = '67'
/
update civddo
   set CODICE_ANSC = '68'
 where tipo_atto = 1
   and cod_do    = '68'
/
update civddo
   set CODICE_ANSC = '69'
 where tipo_atto = 1
   and cod_do    = '69'
/
update civddo
   set CODICE_ANSC = '70'
 where tipo_atto = 1
   and cod_do    = '70'
/
update civddo
   set CODICE_ANSC = '71'
 where tipo_atto = 1
   and cod_do    = '71'
/
update civddo
   set CODICE_ANSC = '72'
 where tipo_atto = 1
   and cod_do    = '72'
/
update civddo
   set CODICE_ANSC = '73'
 where tipo_atto = 1
   and cod_do    = '73'
/
update civddo
   set CODICE_ANSC = '74'
 where tipo_atto = 1
   and cod_do    = '74'
/
update civddo
   set CODICE_ANSC = '75'
 where tipo_atto = 1
   and cod_do    = '75'
/
update civddo
   set CODICE_ANSC = '76'
 where tipo_atto = 1
   and cod_do    = '76'
/
update civddo
   set CODICE_ANSC = '77'
 where tipo_atto = 5
   and cod_do    = '77'
/
update civddo
   set CODICE_ANSC = '78'
 where tipo_atto = 5
   and cod_do    = '78'
/
update civddo
   set CODICE_ANSC = '79'
 where tipo_atto = 1
   and cod_do    = '79'
/
update civddo
   set CODICE_ANSC = '80'
 where tipo_atto = 5
   and cod_do    = '80'
/
update civddo
   set CODICE_ANSC = '81'
 where tipo_atto = 1
   and cod_do    = '81'
/
update civddo
   set CODICE_ANSC = '82'
 where tipo_atto = 2
   and cod_do    = '82'
/
update civddo
   set CODICE_ANSC = '83'
 where tipo_atto = 1
   and cod_do    = '83'
/
update civddo
   set CODICE_ANSC = '998'
 where tipo_atto = 5
   and cod_do    = '99'
/
update civddo
   set CODICE_ANSC = '998'
 where tipo_atto = -4
   and cod_do    = '99'
/
update civddo
   set CODICE_ANSC = '998'
 where tipo_atto = 4
   and cod_do    = '99'
/
update civddo
   set CODICE_ANSC = '998'
 where tipo_atto = 2
   and cod_do    = '99'
/
update civddo
   set CODICE_ANSC = '998'
 where tipo_atto = 1
   and cod_do    = '99'
/
update civddo
   set CODICE_ANSC = '55'
 where tipo_atto = 2
   and cod_do    = '55'
/
update civddo
   set CODICE_ANSC = '37'
 where tipo_atto = -4
   and cod_do    = '37'
/
update civddo
   set CODICE_ANSC = '37'
 where tipo_atto = 4
   and cod_do    = '37'
/
update civddo
   set CODICE_ANSC = '37'
 where tipo_atto = 2
   and cod_do    = '37'
/
update civddo
   set CODICE_ANSC = '37'
 where tipo_atto = 1
   and cod_do    = '37'
/
update civddo
   set CODICE_ANSC = '19'
 where tipo_atto = -4
   and cod_do    = '19'
/
update civddo
   set CODICE_ANSC = '19'
 where tipo_atto = 4
   and cod_do    = '19'
/
update civddo
   set CODICE_ANSC = '19'
 where tipo_atto = 2
   and cod_do    = '19'
/
update civddo
   set CODICE_ANSC = '19'
 where tipo_atto = 1
   and cod_do    = '19'
/
update civddo
   set CODICE_ANSC = '78'
 where tipo_atto = -4
   and cod_do    = '78'
/
update civddo
   set CODICE_ANSC = '78'
 where tipo_atto = 4
   and cod_do    = '78'
/
update civddo
   set CODICE_ANSC = '78'
 where tipo_atto = 2
   and cod_do    = '78'
/
update civddo
   set CODICE_ANSC = '78'
 where tipo_atto = 1
   and cod_do    = '78'
/
update civddo
   set CODICE_ANSC = '39'
 where tipo_atto = -4
   and cod_do    = '39'
/
update civddo
   set CODICE_ANSC = '39'
 where tipo_atto = 4
   and cod_do    = '39'
/
update civddo
   set CODICE_ANSC = '39'
 where tipo_atto = 2
   and cod_do    = '39'
/
update civddo
   set CODICE_ANSC = '39'
 where tipo_atto = 1
   and cod_do    = '39'
/
update civddo
   set CODICE_ANSC = '80'
 where tipo_atto = -4
   and cod_do    = '80'
/
update civddo
   set CODICE_ANSC = '80'
 where tipo_atto = 4
   and cod_do    = '80'
/
update civddo
   set CODICE_ANSC = '80'
 where tipo_atto = 2
   and cod_do    = '80'
/
update civddo
   set CODICE_ANSC = '80'
 where tipo_atto = 1
   and cod_do    = '80'
/
update civddo
   set CODICE_ANSC = '61'
 where tipo_atto = -4
   and cod_do    = '61'
/
update civddo
   set CODICE_ANSC = '61'
 where tipo_atto = 4
   and cod_do    = '61'
/
update civddo
   set CODICE_ANSC = '61'
 where tipo_atto = 2
   and cod_do    = '61'
/
update civddo
   set CODICE_ANSC = '61'
 where tipo_atto = 1
   and cod_do    = '61'
/
update civddo
   set CODICE_ANSC = '26'
 where tipo_atto = -4
   and cod_do    = '26'
/
update civddo
   set CODICE_ANSC = '26'
 where tipo_atto = 4
   and cod_do    = '26'
/
update civddo
   set CODICE_ANSC = '26'
 where tipo_atto = 2
   and cod_do    = '26'
/
update civddo
   set CODICE_ANSC = '26'
 where tipo_atto = 1
   and cod_do    = '26'
/
update civddo
   set CODICE_ANSC = '36'
 where tipo_atto = -4
   and cod_do    = '36'
/
update civddo
   set CODICE_ANSC = '28'
 where tipo_atto = -4
   and cod_do    = '28'
/
update civddo
   set CODICE_ANSC = '28'
 where tipo_atto = 4
   and cod_do    = '28'
/
update civddo
   set CODICE_ANSC = '28'
 where tipo_atto = 2
   and cod_do    = '28'
/
update civddo
   set CODICE_ANSC = '28'
 where tipo_atto = 1
   and cod_do    = '28'
/
update civddo
   set CODICE_ANSC = '77'
 where tipo_atto = -4
   and cod_do    = '77'
/
update civddo
   set CODICE_ANSC = '77'
 where tipo_atto = 4
   and cod_do    = '77'
/
update civddo
   set CODICE_ANSC = '77'
 where tipo_atto = 2
   and cod_do    = '77'
/
update civddo
   set CODICE_ANSC = '77'
 where tipo_atto = 1
   and cod_do    = '77'
/
update civddo
   set CODICE_ANSC = ''
 where tipo_atto = 0
   and cod_do    = 'EA'
/
update civddo
   set CODICE_ANSC = ''
 where tipo_atto = 0
   and cod_do    = 'RA'
/
update civddo
   set CODICE_ANSC = ''
 where tipo_atto = 0
   and cod_do    = 'CO'
/
update civddo
   set CODICE_ANSC = ''
 where tipo_atto = 3
   and cod_do    = 'CO'
/
update civddo
   set CODICE_ANSC = ''
 where tipo_atto = 3
   and cod_do    = 'AL'
/
update civddo
   set CODICE_ANSC = ''
 where tipo_atto = 1
   and cod_do    = 'CI'
/
update civddo
   set CODICE_ANSC = ''
 where tipo_atto = 2
   and cod_do    = 'CI'
/
update civddo
   set CODICE_ANSC = ''
 where tipo_atto = 4
   and cod_do    = 'CI'
/
update civddo
   set CODICE_ANSC = ''
 where tipo_atto = -4
   and cod_do    = 'CI'
/
update civddo
   set CODICE_ANSC = ''
 where tipo_atto = 5
   and cod_do    = 'CI'
/
update civddo
   set CODICE_ANSC = '999'
 where tipo_atto = 2
   and cod_do    = 'P2'
/
update civddo
   set CODICE_ANSC = '999'
 where tipo_atto = 1
   and cod_do    = 'P1'
/
update civddo
   set CODICE_ANSC = '999'
 where tipo_atto = 5
   and cod_do    = 'P5'
/
update civddo
   set CODICE_ANSC = '36'
 where tipo_atto = 5
   and cod_do    = '36'
/
update civddo
   set CODICE_ANSC = '49'
 where tipo_atto = 4
   and cod_do    = '49'
/
update civddo
   set CODICE_ANSC = '65'
 where tipo_atto = 1
   and cod_do    = '65'
/
update civddo
   set CODICE_ANSC = '20'
 where tipo_atto = 1
   and cod_do    = '20'
/
update civddo
   set CODICE_ANSC = '6'
 where tipo_atto = 2
   and cod_do    = '06'
/
update civddo
   set CODICE_ANSC = '91'
 where tipo_atto = 1
   and cod_do    = '91'
/
update civddo
   set CODICE_ANSC = '92'
 where tipo_atto = 1
   and cod_do    = '92'
/
update civddo
   set CODICE_ANSC = '998'
 where tipo_atto = 2
   and cod_do    = 'AO'
/
update civddo
   set CODICE_ANSC = '998'
 where tipo_atto = 4
   and cod_do    = 'AO'
/
update civddo
   set CODICE_ANSC = '998'
 where tipo_atto = -4
   and cod_do    = 'AO'
/
update civddo
   set CODICE_ANSC = '998'
 where tipo_atto = 5
   and cod_do    = 'AO'
/
update civddo
   set CODICE_ANSC = '86'
 where tipo_atto = 4
   and cod_do    = 'EP'
/
update civddo
   set CODICE_ANSC = '100'
 where tipo_atto = 2
   and cod_do    = '100'
/
update civddo
   set CODICE_ANSC = '103'
 where tipo_atto = 4
   and cod_do    = '103'
/
update civddo
   set CODICE_ANSC = '90'
 where tipo_atto = 4
   and cod_do    = '90'
/
update civddo
   set CODICE_ANSC = '84'
 where tipo_atto = 4
   and cod_do    = '84'
/
update civddo
   set CODICE_ANSC = '85'
 where tipo_atto = 4
   and cod_do    = '85'
/
update civddo
   set CODICE_ANSC = '87'
 where tipo_atto = 4
   and cod_do    = '87'
/
update civddo
   set CODICE_ANSC = '88'
 where tipo_atto = 4
   and cod_do    = '88'
/
update civddo
   set CODICE_ANSC = '89'
 where tipo_atto = 4
   and cod_do    = '89'
/
update civddo
   set CODICE_ANSC = '93'
 where tipo_atto = 2
   and cod_do    = '93'
/
update civddo
   set CODICE_ANSC = '94'
 where tipo_atto = 2
   and cod_do    = '94'
/
update civddo
   set CODICE_ANSC = '96'
 where tipo_atto = 2
   and cod_do    = '96'
/
update civddo
   set CODICE_ANSC = '97'
 where tipo_atto = 1
   and cod_do    = '97'
/
update civddo
   set CODICE_ANSC = '98'
 where tipo_atto = 1
   and cod_do    = '98'
/
update civddo
   set CODICE_ANSC = '101'
 where tipo_atto = 5
   and cod_do    = '101'
/
update civddo
   set CODICE_ANSC = '104'
 where tipo_atto = 4
   and cod_do    = '104'
/
update civddo
   set CODICE_ANSC = '97'
 where tipo_atto = 2
   and cod_do    = '97'
/
update civddo
   set CODICE_ANSC = '98'
 where tipo_atto = 2
   and cod_do    = '98'
/
update civddo
   set CODICE_ANSC = '97'
 where tipo_atto = 4
   and cod_do    = '97'
/
update civddo
   set CODICE_ANSC = '98'
 where tipo_atto = 4
   and cod_do    = '98'
/
update civddo
   set CODICE_ANSC = '97'
 where tipo_atto = -4
   and cod_do    = '97'
/
update civddo
   set CODICE_ANSC = '98'
 where tipo_atto = -4
   and cod_do    = '98'
/
update civddo
   set CODICE_ANSC = '97'
 where tipo_atto = 5
   and cod_do    = '97'
/
update civddo
   set CODICE_ANSC = '98'
 where tipo_atto = 5
   and cod_do    = '98'
/
update civddo
   set CODICE_ANSC = '13'
 where tipo_atto = 4
   and cod_do    = '13'
/
update civddo
   set CODICE_ANSC = '25'
 where tipo_atto = -4
   and cod_do    = '25'
/
update civddo
   set CODICE_ANSC = '25'
 where tipo_atto = 2
   and cod_do    = '25'
/
update civddo
   set CODICE_ANSC = '25'
 where tipo_atto = 1
   and cod_do    = '25'
/
update civddo
   set CODICE_ANSC = '25'
 where tipo_atto = 5
   and cod_do    = '25'
/
update civddo
   set CODICE_ANSC = '29'
 where tipo_atto = 1
   and cod_do    = '29'
/
update civddo
   set CODICE_ANSC = '27'
 where tipo_atto = 1
   and cod_do    = '27'
/
update civddo
   set CODICE_ANSC = '82'
 where tipo_atto = 1
   and cod_do    = '82'
/
update civddo
   set CODICE_ANSC = '54'
 where tipo_atto = 4
   and cod_do    = '54'
/
update civddo
   set CODICE_ANSC = '48'
 where tipo_atto = 1
   and cod_do    = '48'
/
update civddo
   set CODICE_ANSC = '43'
 where tipo_atto = -4
   and cod_do    = '43'
/
update civddo
   set CODICE_ANSC = '44'
 where tipo_atto = -4
   and cod_do    = '44'
/
update civddo
   set CODICE_ANSC = '45'
 where tipo_atto = -4
   and cod_do    = '45'
/
update civddo
   set CODICE_ANSC = '46'
 where tipo_atto = -4
   and cod_do    = '46'
/
update civddo
   set CODICE_ANSC = '38'
 where tipo_atto = 5
   and cod_do    = '38'
/
update civddo
   set CODICE_ANSC = '38'
 where tipo_atto = -4
   and cod_do    = '38'
/
update civddo
   set CODICE_ANSC = '38'
 where tipo_atto = 1
   and cod_do    = '38'
/
update civddo
   set CODICE_ANSC = '38'
 where tipo_atto = 2
   and cod_do    = '38'
/
update civddo
   set CODICE_ANSC = '30'
 where tipo_atto = 2
   and cod_do    = '30'
/
update civddo
   set CODICE_ANSC = '105'
 where tipo_atto = 2
   and cod_do    = '105'
/
update civddo
   set CODICE_ANSC = '106'
 where tipo_atto = 4
   and cod_do    = '106'
/
update civddo
   set CODICE_ANSC = '107'
 where tipo_atto = 4
   and cod_do    = '107'
/
update civddo
   set CODICE_ANSC = '107'
 where tipo_atto = -4
   and cod_do    = '107'
/
update civddo
   set CODICE_ANSC = '108'
 where tipo_atto = 4
   and cod_do    = '108'
/
update civddo
   set CODICE_ANSC = '109'
 where tipo_atto = 4
   and cod_do    = '109'
/
