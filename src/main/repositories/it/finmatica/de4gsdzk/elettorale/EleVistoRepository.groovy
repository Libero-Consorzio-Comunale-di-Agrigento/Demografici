package it.finmatica.de4gsdzk.elettorale

import org.springframework.data.jpa.repository.JpaRepository

interface EleVistoRepository extends JpaRepository<EleVisto, Long> {

    List<EleVisto> findAll()

}