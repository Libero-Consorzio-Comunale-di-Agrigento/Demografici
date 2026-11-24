package it.finmatica.de4gsdzk.statocivile.embed

import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.anagrafe.AnaAnagrafe
import it.finmatica.de4gsdzk.anagrafe.AnaCittadinanza
import it.finmatica.de4gsdzk.anagrafe.IConiuge
import it.finmatica.de4gsdzk.utils.ESesso

import javax.persistence.*

@Embeddable
class AnaConiuge implements IConiuge {

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "MATRICOLA_CN", nullable = true)
    AnaAnagrafe anagrafe

    @Column(name = "COGNOME_CN", nullable = true)
    String cognome

    @Column(name = "NOME_CN", nullable = true)
    String nome

    @Convert(converter = GsdBaseDomain.BooleanToStringConverter.class)
    @Column(name = "SENZA_COGNOME_CN", nullable = true)
    Boolean senzaCognome

    @Convert(converter = GsdBaseDomain.BooleanToStringConverter.class)
    @Column(name = "SENZA_NOME_CN", nullable = true)
    Boolean senzaNome

    @Column(name = "COGNOME_NOME_CN", nullable = true)
    String cognomeNome

    @Override
    Integer getIdAnagrafe() {
        return anagrafe?.id
    }

    @Override
    String getCognome() {
        return this.cognome
    }

    @Override
    String getNome() {
        return this.nome
    }

    @Override
    ESesso getSesso() {
        return anagrafe?.sesso
    }

    @Override
    Date getDataNascita() {
        return anagrafe?.dataNascita
    }

    @Override
    Comune getComuneNascita() {
        return anagrafe?.comuneNascita
    }

    @Override
    Comune getComuneResidenza() {
        return anagrafe?.comuneResidenza
    }

    @Override
    AnaCittadinanza getNazionalita() {
        return anagrafe?.nazionalita
    }
}
