package restrict

import it.finmatica.de4gsdzk.utils.ConfigurazioneUtils
import org.zkoss.bind.BindUtils
import org.zkoss.bind.annotation.BindingParam
import org.zkoss.bind.annotation.Command
import org.zkoss.bind.annotation.GlobalCommand
import org.zkoss.zk.ui.Executions
import org.zkoss.zk.ui.Session

abstract class AbstractResizedViewModel {

    String wCenterHeight
    String wCenterWidth

    @GlobalCommand('onDesktopResize')
    @Command resizeHeightAndWidth(@BindingParam("desktopHeight") int desktopHeight, @BindingParam("desktopWidth") int desktopWidth) {
        Boolean refresh = Boolean.FALSE
        if ((wCenterHeight == null) && desktopHeight){
            wCenterHeight = (desktopHeight - ConfigurazioneUtils.HEADER_HEIGHT).toString() + "px"
            refresh = Boolean.TRUE
        }
        if ((wCenterWidth == null) && desktopWidth){
            wCenterWidth = (desktopWidth - (ConfigurazioneUtils.WEST_WIDTH + ConfigurazioneUtils.SPACING)).toString() + "px"
            refresh = Boolean.TRUE
        }
        if (refresh){
            BindUtils.postNotifyChange(null, null, this, "*")
        }
    }

    void resize(){
        Session s = Executions.getCurrent().getSession()
        if (s.getAttribute("desktopHeight") || s.getAttribute("desktopWidth")){
            resizeHeightAndWidth(s.getAttribute("desktopHeight"), s.getAttribute("desktopWidth"))
        }
    }

}
