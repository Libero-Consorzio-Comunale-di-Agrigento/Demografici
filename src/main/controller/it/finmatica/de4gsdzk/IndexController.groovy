package it.finmatica.de4gsdzk

import org.springframework.stereotype.Controller
import org.springframework.web.bind.annotation.GetMapping

@Controller
class IndexController {

    @GetMapping("/")
        String forwardToIndex() {
        return "forward:/index.zul";
    }

}
