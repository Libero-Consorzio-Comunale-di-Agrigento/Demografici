package it.finmatica.de4gsdzk.elettorale

import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.Id
import javax.persistence.Table

@Entity
@Table(name = "ELEDCC")
public class EleVisto {

    @Id
    @Column(name = "COMMISSIONE", nullable = true, updatable = false, insertable = false)
    public String commissione

    @Column(name = "SOTTOCOMMISSIONE", nullable = true, updatable = false, insertable = false)
    public String sottocommissione

    @Column(name = "PRESIDENTE", nullable = true, updatable = false, insertable = false)
    public String presidente


}
