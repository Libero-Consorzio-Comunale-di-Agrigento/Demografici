package it.finmatica.de4gsdzk.zkutils.controlbar

import it.finmatica.de4gsdzk.utils.controlbar.ControlBarAttributes
import org.zkoss.zk.ui.Component
import org.zkoss.zk.ui.Executions
import org.zkoss.zk.ui.select.Selectors
import org.zkoss.zul.Hlayout

class ControlBar extends Hlayout {

    private ControlBarAttributes _cbAttributes

    ControlBar() {
        super()
    }

    void onCreate() {
        List<Component> tempChildren = new ArrayList<>(this.getChildren())
        this.getChildren().clear()

        Executions.createComponents("/restrict/afc/controlbar/controlBar.zul", this, ["cbAttributes": _cbAttributes])

        Component placeholder = Selectors.iterable(this, ".extraChildrenContainer").iterator().hasNext() ?
                Selectors.iterable(this, ".extraChildrenContainer").iterator().next() : null
        if (placeholder != null) {
            placeholder.getChildren().addAll(tempChildren)
        }

        Selectors.wireVariables(this, this, null)
        Selectors.wireComponents(this, this, false)
        Selectors.wireEventListeners(this, this)
    }

    void setValue(ControlBarAttributes cbAttributes) {
        this._cbAttributes = cbAttributes
    }

    ControlBarAttributes getValue() {
        return _cbAttributes
    }

}