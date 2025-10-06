package it.finmatica.de4gsdzk

import org.springframework.stereotype.Controller
import org.springframework.web.bind.annotation.GetMapping

@Controller
class CaricaModelliController {

    @GetMapping("/carica-modelli")
    String caricaModelli() { "forward:/caricaModelli.zul" }

}
