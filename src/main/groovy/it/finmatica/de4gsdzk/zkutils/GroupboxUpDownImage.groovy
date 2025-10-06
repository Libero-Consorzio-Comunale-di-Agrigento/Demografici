package it.finmatica.de4gsdzk.zkutils

import org.zkoss.zk.ui.event.OpenEvent
import org.zkoss.zul.Caption
import org.zkoss.zul.Groupbox

class GroupboxUpDownImage extends Groupbox{

    public void onOpen(OpenEvent evt){
        Caption cp = getCaption();
        if (cp != null){
            cp.setImage(evt.isOpen()?"/images/de4gsdzk/16x16/up_light.png":"/images/de4gsdzk/16x16/down_light.png");
        }
    }

}
