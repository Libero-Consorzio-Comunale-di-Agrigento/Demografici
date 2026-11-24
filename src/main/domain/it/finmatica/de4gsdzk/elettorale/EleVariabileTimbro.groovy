package it.finmatica.de4gsdzk.elettorale

import org.hibernate.annotations.Immutable

import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.Id
import javax.persistence.Table

@Entity
@Immutable
@Table(name = "ELETIM_VAR")
class EleVariabileTimbro {

    @Id
    @Column(name = "SEQUENZA")
    Integer sequenza

    @Column(name = "VARIABILE")
    String variabile

}
