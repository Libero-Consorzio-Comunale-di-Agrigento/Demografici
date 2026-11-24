package it.finmatica.de4gsdzk.elettorale

import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository

interface EleElezioneRepository extends JpaRepository<EleElezione, Long> {

    Page<EleElezione> findAllByDataNotNull(Pageable p)

}