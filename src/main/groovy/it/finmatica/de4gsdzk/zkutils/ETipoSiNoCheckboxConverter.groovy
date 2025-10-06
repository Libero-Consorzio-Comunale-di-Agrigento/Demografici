package it.finmatica.de4gsdzk.zkutils

import it.finmatica.de4gsdzk.utils.ETipoSiNo
import org.zkoss.bind.BindContext
import org.zkoss.bind.Converter
import org.zkoss.zk.ui.Component

class ETipoSiNoCheckboxConverter implements Converter<Boolean, ETipoSiNo, Component> {

    @Override
    Boolean coerceToUi(ETipoSiNo value, Component component, BindContext ctx) {
        return ETipoSiNo.SI == value;
    }

    @Override
    ETipoSiNo coerceToBean(Boolean value, Component component, BindContext ctx) {
        return value ? ETipoSiNo.SI : null
    }
}