package it.finmatica.de4gsdzk.zkutils

import org.zkoss.zk.ui.Executions
import org.zkoss.zk.ui.annotation.ComponentAnnotation
import org.zkoss.zk.ui.event.Events
import org.zkoss.zk.ui.event.InputEvent
import org.zkoss.zk.ui.select.Selectors
import org.zkoss.zk.ui.select.annotation.Wire
import org.zkoss.zul.Hlayout
import org.zkoss.zul.Image
import org.zkoss.zul.Textbox

class PasswordTextbox extends Hlayout {

    static enum EState {
        UNLOCKED("/images/icon/action/22x22/unlock.png", "text"),
        LOCKED("/images/icon/action/22x22/lock.png", "password");

        String image
        String type

        EState(String image, String type) {
            this.image = image
            this.type = type
        }
    }

    @Wire('textbox')
    protected Textbox textbox
    @Wire('image')
    protected Image image

    EState state

    PasswordTextbox() {
        super()
        Executions.createComponents("/restrict/afc/passwordTextbox.zul", this, null)

        Selectors.wireVariables(this, this, null)
        Selectors.wireComponents(this, this, false)
        Selectors.wireEventListeners(this, this)

        image.addEventListener(Events.ON_CLICK, {
            state = state == EState.UNLOCKED ? EState.LOCKED : EState.UNLOCKED

            refreshUi()
        })

        textbox.addEventListener(Events.ON_CHANGE, { InputEvent event ->
            Events.postEvent(Events.ON_CHANGE, this, event.value)
        })

        textbox.addEventListener(Events.ON_CHANGING, { InputEvent event ->
            Events.postEvent(Events.ON_CHANGING, this, event.value)
        })

        state = EState.LOCKED
        refreshUi()

    }

    private void refreshUi() {
        textbox.type = state.type
        image.src = state.image
    }

    @ComponentAnnotation("@ZKBIND(ACCESS=both, SAVE_EVENT=onChange)")
    def getValue() {
        return textbox.value
    }

    void setValue(def value) {
        if (value == null) {
            textbox.value = null
            return
        }

        textbox.value = value
    }

}