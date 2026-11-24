package it.finmatica.de4gsdzk.zkutils

import org.zkoss.zk.ui.Component
import org.zkoss.zk.ui.event.CreateEvent
import org.zkoss.zk.ui.event.Events
import org.zkoss.zk.ui.event.OpenEvent
import org.zkoss.zul.Button
import org.zkoss.zul.Groupbox

class UpDownButton extends Button{

    UpDownButton(){
        super()
        this.addEventListener(Events.ON_CREATE, { event ->
            checkGbParentOpenClose()
        })
    }

    void checkGbParentOpenClose(){
        Groupbox target = this.getGroupboxParent()
        if (target){
            target.addEventListener(Events.ON_CREATE,{ event ->
                updateImage(target.open)
            })
            target.addEventListener(Events.ON_OPEN, { event ->
                updateImage(((OpenEvent) event).open)
            })
        }
    }

    void openClose(){
        Groupbox target = this.getGroupboxParent()
        if (target){
            Boolean isOpen = target.open
            target.setOpen(!isOpen)
            Events.postEvent(new OpenEvent(Events.ON_OPEN, target, !isOpen))
            updateImage(!isOpen)
        }
    }

    void updateImage(Boolean open){
        setImage(open?"/images/de4gsdzk/16x16/up_light.png":"/images/de4gsdzk/16x16/down_light.png")
    }

    Groupbox getGroupboxParent(){
        Component target = this.parent
        for (int i=5;( (i<=5) && (target!=null) ); i--){
            if (target instanceof Groupbox){
                return target
            } else {
                target = target?.parent
            }
        }
        return null
    }
}
