package it.finmatica.de4gsdzk.utils

import org.zkoss.zk.ui.Component
import org.zkoss.zk.ui.util.Clients
import org.zkoss.zul.Messagebox

class MessaggioUtils {

    public static final String I = "I"
    public static final String W = "W"
    public static final String E = "E"

    static void showMsg(Component c, String tipo, String msg, String position="before_start", int duration=3000, Boolean closable = Boolean.TRUE) {
        if ( (msg?:"") != ""){
            String t
            switch (tipo) {
                case W:
                    t = Clients.NOTIFICATION_TYPE_WARNING
                    break
                case I:
                    t = Clients.NOTIFICATION_TYPE_INFO
                    break
                default:
                    t = Clients.NOTIFICATION_TYPE_ERROR
                    break
            }
            Clients.showNotification(msg, t, c, position, duration, closable)
        }
    }

    static void showInfoMsg(Component c, String msg) {
        showMsg(c, I, msg)
    }

    static void showMsgBox(String title, String tipo, String msg){
        switch (tipo) {
            case W:
                Messagebox.show(msg, title, Messagebox.OK, Messagebox.EXCLAMATION)
                break
            case I:
                Messagebox.show(msg, title, Messagebox.OK, Messagebox.INFORMATION)
                break
            default:
                Messagebox.show(msg, title, Messagebox.OK, Messagebox.ERROR)
                break
        }
    }

}
