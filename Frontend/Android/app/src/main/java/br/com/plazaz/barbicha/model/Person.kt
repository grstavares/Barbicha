package br.com.plazaz.barbicha.model

import java.net.URL

data class Person(val uuid: String, val name: String, var alias: String?, var phone: String?, var email: String?, var imageURL: URL? = null) {

    var imageData: ByteArray? = null;

}