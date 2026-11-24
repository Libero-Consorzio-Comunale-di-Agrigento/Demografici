package it.finmatica.de4gsdzk.elettorale

import org.springframework.data.jpa.repository.JpaRepository

interface De4ElezioneRepository extends JpaRepository<De4Elezione, Long> {

    List<De4Elezione> findAllByElezione(EleElezione elezione)
}