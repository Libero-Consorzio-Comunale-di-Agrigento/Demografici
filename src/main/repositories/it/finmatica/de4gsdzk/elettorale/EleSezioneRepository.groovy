package it.finmatica.de4gsdzk.elettorale

import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query

interface EleSezioneRepository extends JpaRepository<EleSezione, Integer> {

    @Query("SELECT MIN(e.sezione) FROM EleSezione e")
    Integer getSezioneMin()

    @Query("SELECT MAX(e.sezione) FROM EleSezione e")
    Integer getSezioneMax()

}