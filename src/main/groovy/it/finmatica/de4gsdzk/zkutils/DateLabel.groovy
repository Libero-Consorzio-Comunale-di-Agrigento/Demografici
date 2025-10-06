package it.finmatica.de4gsdzk.zkutils

import it.finmatica.de4gsdzk.utils.DataUtils
import org.zkoss.xel.fn.CommonFns

class DateLabel extends CustomLabel {

    Date date

    DateLabel() {
        super()
    }

    void setValue(Object value) {
        date = value as Date
        if (date == null) {
            super.setValue(null)
            return
        }
        super.setValue(CommonFns.formatDate(date, DataUtils.DATE_FORMAT_PATTERN))
    }

    @Override
    def getValue() {
        return date
    }

}