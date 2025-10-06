package it.finmatica.de4gsdzk.zkutils

import org.zkoss.bind.BindUtils
import org.zkoss.zk.ui.Component
import org.zkoss.zk.ui.annotation.ComponentAnnotation
import org.zkoss.zk.ui.event.Event
import org.zkoss.zk.ui.event.EventListener
import org.zkoss.zk.ui.event.Events
import org.zkoss.zk.ui.util.Clients
import org.zkoss.zul.Decimalbox
import org.zkoss.zul.Div
import org.zkoss.zul.Popup

@ComponentAnnotation("value: @ZKBIND(ACCESS=both, SAVE_EVENT=onChange)")
class DecimalFakeBandbox extends Div {

    protected final Decimalbox input
    protected Popup fakeBandpopup

    DecimalFakeBandbox() {
        super()

        input = new Decimalbox()
        input.setSclass('z-bandbox')
        appendChild(input)

        input.addEventListener(Events.ON_FOCUS, new EventListener<Event>() {
            void onEvent(Event event) throws Exception {
                openPopup()
            }
        })

        input.addEventListener(Events.ON_CHANGING, new EventListener<Event>() {
            void onEvent(Event event) throws Exception {
                openPopup()
            }
        })

        input.addEventListener(Events.ON_CHANGE, new EventListener<Event>() {
            void onEvent(Event event) throws Exception {
                BindUtils.postNotifyChange(null, null, DecimalFakeBandbox.this, "value")
            }
        })

        this.addEventListener("onPopupPosition", new EventListener<Event>() {
            @Override
            public void onEvent(Event event) throws Exception {
                String pos = (String) event.getData();
                fakeBandpopup.open(input, pos);
                Events.sendEvent(new Event(Events.ON_OPEN, DecimalFakeBandbox.this, null));
            }
        });
    }

    @Override
    void onChildAdded(Component child) {
        if (child instanceof Popup) {
            fakeBandpopup = (Popup) child
            fakeBandpopup.setZclass("z-bandbox")
            fakeBandpopup.setSclass('z-bandbox-rounded-pp z-bandbox-rounded-shadow')
        }
        super.onChildAdded(child)
    }

    @Override
    boolean addEventListener(int priority, String evtnm, EventListener<? extends Event> listener) {
        if (evtnm in [Events.ON_CHANGE, Events.ON_CHANGING, Events.ON_FOCUS, Events.ON_BLUR, Events.ON_SELECTION, Events.ON_ERROR]) {
            return input.addEventListener(priority, evtnm, listener)
        }
        return super.addEventListener(priority, evtnm, listener)
    }

    boolean isOpen() {
        return fakeBandpopup?.isVisible()
    }

    void openPopup() {
        if (isDisabled() || isReadonly() || isOpen() || fakeBandpopup == null) {
            return
        }

        String selfUuid = this.getUuid();
        String script = "var inputWidget = zk.Widget.\$('" + input.getUuid() + "'); " +
                "console.log('inputWidget:'+inputWidget);" +

                "var inputElem = jq(inputWidget.\$n()); " +
                "console.log('inputElem:'+inputElem);" +

                "var inputDom = inputWidget.\$n(); " +
                "console.log('inputElem:'+inputDom);" +

                "var winHeight = jq(window).height(); " +
                "console.log('winHeight:'+winHeight);" +

                "var scrollTop = jq(window).scrollTop(); " +
                "console.log('scrollTop:'+scrollTop);" +

                "var inputTop = inputElem.offset().top - scrollTop; " +
                "console.log('inputTop:'+inputTop);" +

                "var popupHeight = 350; " +
                "debugger;" +

                "var pos = (winHeight - inputTop < popupHeight) ? 'before_start' : 'after_start'; " +
                "console.log('pos:'+pos);" +

                "var selfWidget = zk.Widget.\$('" + selfUuid + "'); " +
                "zAu.send(new zk.Event(selfWidget, 'onPopupPosition', pos));";
        Clients.evalJavaScript(script);
    }

    void closePopup() {
        if (fakeBandpopup != null) {
            fakeBandpopup.close()

            Events.sendEvent(new Event(Events.ON_CLOSE, this, null))
        }
    }

    BigDecimal getValue() {
        return input.getValue()
    }

    void setValue(BigDecimal value) {
        if (value == null) {
            input.setRawValue(null) // Safely clear the field without NPE
        } else {
            input.setValue(value)
        }
    }

    String getFormat() {
        return input.getFormat()
    }

    void setFormat(String format) {
        input.setFormat(format)
    }

    boolean isDisabled() {
        return input.isDisabled()
    }

    void setDisabled(boolean disabled) {
        input.setDisabled(disabled)
    }

    boolean isReadonly() {
        return input.isReadonly()
    }

    void setReadonly(boolean readonly) {
        input.setReadonly(readonly)
    }
}
