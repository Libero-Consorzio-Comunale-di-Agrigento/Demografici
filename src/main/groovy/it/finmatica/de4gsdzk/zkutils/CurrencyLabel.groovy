package it.finmatica.de4gsdzk.zkutils

import org.zkoss.xel.fn.CommonFns

class CurrencyLabel extends CustomLabel {

    private static final String DEFAULT_STYLE = "text-align: right"
    private static final String DEFAULT_FORMAT = "€ #,##0.00"

    CurrencyLabel() {
        super()
        setStyle(DEFAULT_STYLE)
    }

    void setValue(Object value) {
        if (value == null) {
            super.setValue(null)
            return
        }
        super.setValue(CommonFns.formatNumber(value, DEFAULT_FORMAT))
    }

}