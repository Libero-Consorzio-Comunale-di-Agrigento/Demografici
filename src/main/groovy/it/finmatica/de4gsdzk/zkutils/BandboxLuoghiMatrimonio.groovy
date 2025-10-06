package it.finmatica.de4gsdzk.zkutils

import it.finmatica.de4gsdzk.utils.ETipoAtto

class BandboxLuoghiMatrimonio extends BandboxLuoghi {

	public BandboxLuoghiMatrimonio() {
		super()
        tipoAttoEnum = ETipoAtto.MAT
		onChangePreventDefault = Boolean.TRUE
	}
	
}
