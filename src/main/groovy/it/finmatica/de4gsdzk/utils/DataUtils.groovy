package it.finmatica.de4gsdzk.utils

import it.finmatica.de4gsdzk.statocivile.CivNascita

import java.text.SimpleDateFormat

class DataUtils {

    public static final String DATE_FORMAT_PATTERN = "dd/MM/yyyy"

    public static final String DATE_TIME_FORMAT_PATTERN = "dd/MM/yyyy HH:mm:ss"

    static String fromDateToString(Date data, String formato = null) {
        if (data != null) {
            String f = (formato ?: DATE_FORMAT_PATTERN)
            return new SimpleDateFormat(f).format(data)
        }
        return null
    }

    static String toString(Object d) {
        d instanceof Date ? fromDateToString(d) : String.valueOf(d)
    }

    static Date fromStringToDate(String data, String formato = DATE_FORMAT_PATTERN) {
        if (data) {
            return Date.parse(formato, data)
        }
        return null
    }

    static Date addYears(Date d, int amount) {
        if (d) {
            Calendar cal = Calendar.getInstance()
            cal.setTime(d)
            cal.add(Calendar.YEAR, amount)
            return cal.getTime()
        }
        return null
    }

    static Date addDays(Date d, int amount) {
        if (d) {
            Calendar cal = Calendar.getInstance()
            cal.setTime(d)
            cal.add(Calendar.DATE, amount)
            return cal.getTime()
        }
        return null
    }

    static Date subtractDays(Date d, int amount) {
        if (d) {
            Calendar cal = Calendar.getInstance()
            cal.setTime(d)
            cal.add(Calendar.DATE, -amount)
            return cal.getTime()
        }
        return null
    }

    static Date substractYears(Date d, int amount) {
        if (d) {
            Calendar cal = Calendar.getInstance()
            cal.setTime(d)
            cal.add(Calendar.YEAR, -amount)
            return cal.getTime()
        }
        return null
    }

    static Date addSeconds(Date d, int amount) {
        if (d) {
            Calendar cal = Calendar.getInstance()
            cal.setTime(d)
            cal.add(Calendar.SECOND, amount)
            return cal.getTime()
        }
        return null
    }

    static Date addMinutes(Date d, int amount) {
        if (d) {
            Calendar cal = Calendar.getInstance()
            cal.setTime(d)
            cal.add(Calendar.MINUTE, amount)
            return cal.getTime()
        }
        return null
    }

    static Date lastDayOfMonth(Date d) {
        if (d) {
            Calendar cal = Calendar.getInstance()
            cal.setTime(d)
            cal.set(Calendar.DATE, 1)
            cal.add(Calendar.MONTH, 1)
            cal.add(Calendar.DATE, -1)
            return cal.getTime()
        }
        return null
    }

    static Date firstDayOfYear(Date d) {
        if (d) {
            Calendar cal = Calendar.getInstance()
            cal.setTime(d)
            cal.set(Calendar.MONTH, Calendar.JANUARY)
            cal.set(Calendar.DAY_OF_MONTH, 1)
            return cal.getTime()
        }
        return null
    }

    static Date getDataAttoRif(Date dataEvento, Integer annoAtto) {
        if (annoAtto != null) {
            String dataAnnoAtto = "01/01/${annoAtto}"
            if (dataEvento == null) {
                return fromStringToDate(dataAnnoAtto)
            } else {
                Calendar calendar = Calendar.getInstance()
                calendar.setTime(dataEvento)
                int annoEvento = calendar.get(Calendar.YEAR)
                if (annoEvento.compareTo(annoAtto) == 0) {
                    return dataEvento
                } else {
                    return fromStringToDate(dataAnnoAtto)
                }
            }
        } else {
            if (dataEvento != null) {
                return dataEvento
            }
        }
        return null
    }

    static Integer getAnnoFromData(Date data) {
        if (data) {
            Calendar c = Calendar.getInstance()
            c.setTime(data)
            return new Integer(c.get(Calendar.YEAR))
        }
        return null
    }

    static Integer getAnnoCorrente() {
        return new Integer(Calendar.getInstance().get(Calendar.YEAR))
    }

    static Date getDataCorrente() {
        Calendar calendar = Calendar.getInstance();
        calendar.set(Calendar.HOUR_OF_DAY, 0);
        calendar.set(Calendar.MINUTE, 0);
        calendar.set(Calendar.SECOND, 0);
        calendar.set(Calendar.MILLISECOND, 0);

        return calendar.getTime();
    }

    static Date getStartOfDay(Date date) {
        Calendar cal = Calendar.getInstance()
        cal.setTime(date)
        cal.set(Calendar.HOUR_OF_DAY, 0)
        cal.set(Calendar.MINUTE, 0)
        cal.set(Calendar.SECOND, 0)
        cal.set(Calendar.MILLISECOND, 0)
        return cal.getTime()
    }

    static Date getEndOfDay(Date date) {
        Calendar cal = Calendar.getInstance()
        cal.setTime(date)
        cal.set(Calendar.HOUR_OF_DAY, 23)
        cal.set(Calendar.MINUTE, 59)
        cal.set(Calendar.SECOND, 59)
        cal.set(Calendar.MILLISECOND, 999)
        return cal.getTime()
    }

    static Boolean isDataFutura(Date data) {
        if (data == null) {
            return false
        }
        if (data?.compareTo(new Date()) > 0) {
            return true
        }
        return false
    }

    ////////////////////////////// PER ATTO //////////////////////////////

    static Boolean isDataNascitaIncompatibileInPrimaA(CivNascita obj) {
        if (obj.dataNascita != null && obj.isPrimaA()) {
            Date oggi = (new Date()).clearTime()
            Calendar cal = Calendar.getInstance()
            cal.setTime(oggi)
            cal.add(Calendar.DATE, -10)
            Date tenDaysAgo = cal.getTime()
            if (obj.dataNascita.compareTo(tenDaysAgo) == -1) {
                return true
            }
        }
        return false
    }

    static Boolean isDataNascitaIncompatibileInPrimaB(CivNascita obj) {
        if (obj.dataNascita != null && obj.isPrimaB()) {
            Date oggi = (new Date()).clearTime()
            Calendar cal = Calendar.getInstance()
            cal.setTime(oggi)
            cal.add(Calendar.DATE, -10)
            Date tenDaysAgo = cal.getTime()
            if (obj.dataNascita.compareTo(tenDaysAgo) == 1) {
                return true
            }
        }
        return false
    }

}
