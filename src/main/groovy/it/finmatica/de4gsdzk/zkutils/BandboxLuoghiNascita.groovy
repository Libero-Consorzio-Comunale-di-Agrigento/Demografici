package it.finmatica.de4gsdzk.zkutils

import it.finmatica.de4gsdzk.utils.ETipoAtto

class BandboxLuoghiNascita extends BandboxLuoghi {

	public BandboxLuoghiNascita() {
		super()
        tipoAttoEnum = ETipoAtto.NAS
		onChangePreventDefault = Boolean.TRUE
	}
	
}
