package it.finmatica.de4gsdzk.statocivile.embed


import javax.persistence.Embeddable

@Embeddable
class EstremiAtto {

    Integer ufficio

    Integer anno

    Integer atto

    Integer parte

    String serie

    void setSerie(String serie) {
        this.serie = serie?.toUpperCase()
    }

    String idAttoAnsc

    @Override
    boolean equals(Object obj) {
        if (this.is(obj)) return true
        if (obj == null || getClass() != obj.getClass()) return false
        EstremiAtto that = (EstremiAtto) obj;
        return Objects.equals(ufficio, that.ufficio) &&
                Objects.equals(anno, that.anno) &&
                Objects.equals(atto, that.atto) &&
                Objects.equals(parte, that.parte) &&
                Objects.equals(serie, that.serie) &&
                Objects.equals(idAttoAnsc, that.idAttoAnsc)
    }

}

