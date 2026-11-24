package it.finmatica.de4gsdzk.anagrafe.pratiche


import javax.persistence.Entity
import javax.persistence.FetchType
import javax.persistence.OneToMany
import javax.persistence.Table

@Entity
@Table(name = "WEB_CABI_V_ZK")
class AnaPraticaWeb extends AnaRecuperoPraticaBaseDomain{

    @OneToMany(fetch = FetchType.LAZY, mappedBy = "praticaWeb")
    List<AnaAllegatoPraticaWeb> allegati

    List<IAllegatoPratica> getAllegati() {
        return allegati
    }
}
