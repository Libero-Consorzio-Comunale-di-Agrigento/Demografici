package it.finmatica.de4gsdzk.utils

enum ETipoOperazione {

    INS, UPD

    public boolean isInsert(){
        return (this == INS)
    }

    public boolean isUpdate(){
        return (this == UPD)
    }
}