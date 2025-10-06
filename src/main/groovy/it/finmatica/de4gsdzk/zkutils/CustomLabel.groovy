package it.finmatica.de4gsdzk.zkutils


import org.zkoss.zk.ui.Executions
import org.zkoss.zk.ui.HtmlMacroComponent
import org.zkoss.zk.ui.select.Selectors
import org.zkoss.zk.ui.select.annotation.Wire
import org.zkoss.zul.Div
import org.zkoss.zul.Label

class CustomLabel extends HtmlMacroComponent implements ICustomLabel {

    @Wire('div')
    protected Div span
    @Wire('label')
    protected Label label
    protected Boolean mandatory = Boolean.FALSE

    CustomLabel() {
        super()
        Executions.createComponents("/restrict/afc/customLabel.zul", this, null)

        Selectors.wireVariables(this, this, null)
        Selectors.wireComponents(this, this, false)
        Selectors.wireEventListeners(this, this)
    }

    @Override
    void setMandatory(Boolean mandatory) {
        this.mandatory = mandatory
        span.visible = mandatory?:Boolean.FALSE
    }

    @Override
    def getValue() {
        return label.value
    }

    @Override
    void setValue(def value) {
        if (value == null) {
            label.value = null
            return
        }

        label.value = value
    }

    @Override
    void setBold(Boolean bold) {
        if (bold) {
            label.setStyle("font-weight: bold;")
        }
    }

    void setMultiline(Boolean multiline) {
        label.setMultiline(multiline)
    }

    void afterCompose() {
        super.afterCompose()
        span.visible = mandatory
    }

}