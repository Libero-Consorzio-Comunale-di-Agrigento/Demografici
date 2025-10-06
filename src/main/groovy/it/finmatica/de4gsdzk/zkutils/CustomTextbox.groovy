package it.finmatica.de4gsdzk.zkutils


import org.zkoss.zul.Textbox

class CustomTextbox extends Textbox {
    private boolean userReadonly = false

    CustomTextbox() {
        super()
        setMold('rounded')
    }

    @Override
    void setDisabled(boolean disabled) {
        super.setDisabled(disabled)
        super.setReadonly(userReadonly ?: disabled)
    }

    @Override
    void setReadonly(boolean readonly) {
        this.userReadonly = readonly
        super.setReadonly(readonly)
    }
}