package it.finmatica.de4gsdzk.anagrafe.pratiche

import javax.persistence.Entity
import javax.persistence.FetchType
import javax.persistence.OneToMany
import javax.persistence.Table

@Entity
@Table(name = "WEB_ANPR_V_ZK")
class AnaPraticaAnpr extends AnaRecuperoPraticaBaseDomain{

    @OneToMany(fetch = FetchType.LAZY, mappedBy = "praticaAnpr")
    List<AnaAllegatoPraticaAnpr> allegati

    List<IAllegatoPratica> getAllegati() {
        return allegati
    }
}
