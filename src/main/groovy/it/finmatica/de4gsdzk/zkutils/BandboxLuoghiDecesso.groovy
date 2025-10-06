package it.finmatica.de4gsdzk.zkutils

import it.finmatica.de4gsdzk.utils.ETipoAtto

class BandboxLuoghiDecesso extends BandboxLuoghi {

	public BandboxLuoghiDecesso() {
		super()
        tipoAttoEnum = ETipoAtto.MOR
		onChangePreventDefault = Boolean.TRUE
	}
	
}
