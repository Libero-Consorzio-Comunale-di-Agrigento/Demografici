package it.finmatica.de4gsdzk.elettorale

import org.springframework.data.jpa.repository.JpaRepository

interface EleVariabileTimbroRepository extends JpaRepository<EleVariabileTimbro, Integer> {

    List<EleVariabileTimbro> findAllByOrderBySequenzaAsc()

}
