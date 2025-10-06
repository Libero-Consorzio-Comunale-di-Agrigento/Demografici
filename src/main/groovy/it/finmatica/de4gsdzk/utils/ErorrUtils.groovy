package it.finmatica.de4gsdzk.utils

import java.sql.Driver
import java.sql.DriverManager
import java.sql.SQLException

import static it.finmatica.de4gsdzk.utils.EtichetteMessaggi.Errore_Db_Constraint_Violation
import static it.finmatica.de4gsdzk.utils.EtichetteUtils.getEtichetta

class ErorrUtils {

    static String decodeSqlExceptionMessage(String defaultMsg, SQLException sqlException, Map<String,String> etichette){
        String detailMsg = defaultMsg
        if (sqlException != null) {
            Enumeration<Driver> drivers = DriverManager.getDrivers()
            for (Driver d : drivers) {
                if (d.getClass().getName().toLowerCase().contains("oracle") && checkedException(sqlException.getErrorCode()) ) {
                    if (sqlException.getErrorCode() == 20007) {
                        detailMsg = getEtichetta(etichette, Errore_Db_Constraint_Violation)
                    }
                    String oraInitSubstr = "ORA-"
                    if (sqlException.message.startsWith(oraInitSubstr)) {
                        String str = sqlException.message.substring(10)
                        int pos = str.indexOf('(' + oraInitSubstr)
                        if (pos <= 0){
                            pos = str.indexOf(oraInitSubstr)
                        }
                        detailMsg = str.substring(0, pos > 0 ? pos : str.length())
                    }
                    break
                }
            }
        }
        return detailMsg
    }

    private static boolean checkedException(int errorCode){
        return ( (errorCode == 20007) || (errorCode == 20999) )
    }

    static SQLException getSQLException(Throwable e) {
        if (e == null) {
            return null
        }

        if (e == e.cause) {
            return null
        }

        if (e instanceof SQLException) {
            return e
        }

        return getSQLException(e.cause)
    }
}
