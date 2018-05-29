package br.com.plazaz.barbicha.model

import java.io.Serializable
import java.net.URL

data class Barber(val uuid: String, val name: String, var imageURL: URL? = null): Serializable {

    var imageData: ByteArray? = null;

    fun updateValues(with: Barber) {return}

}