package it.finmatica.de4gsdzk.anagrafe.pratiche

import it.finmatica.de4gsdzk.GsdBaseDomain

import javax.persistence.*

@Entity
@Table(name = "WEB_CABI_ALLEGATI")
class AnaAllegatoPraticaWeb extends GsdBaseDomain implements IAllegatoPratica {

    @Id
    @Column(name = "ID")
    Long id

    @Column(name = "ALLEGATO_BLOB", nullable = false)
    @Lob
    byte[] blob

    @Column(name = "ALLEGATO_NOME")
    String nome

    @Column(name = "NUMERO_ORDINE")
    Integer sequenza

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "WEB_CABI_ID", nullable = false)
    AnaPraticaWeb praticaWeb
}
