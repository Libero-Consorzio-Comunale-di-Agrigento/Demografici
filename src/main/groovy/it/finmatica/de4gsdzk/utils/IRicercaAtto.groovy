package it.finmatica.de4gsdzk.utils

interface IRicercaAtto extends IRicerca {

    Integer getAnno()
    void setAnno(Integer anno)

    Integer getUfficio()
    void setUfficio(Integer ufficio)

    Integer getParte()
    void setParte(Integer parte)

    String getSerie()
    void setSerie(String serie)

    Integer getAtto()
    void setAtto(Integer atto)

    String getCognome()
    void setCognome(String cognome)

    String getNome()
    void setNome(String nome)

}
