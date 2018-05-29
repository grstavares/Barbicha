package br.com.plazaz.barbicha.model

import java.io.Serializable
import java.net.URL

data class Barber(val uuid: String, val name: String, var imageURL: URL? = null): Serializable {

    var imageData: ByteArray? = null;

    fun updateValues(with: Barber) {return}

    companion object {

        val kUUID: String = "uuid";
        val kName: String = "name"
        val kAlias: String = "alias"
        val kPhone: String = "phone"
        val kEmail: String = "email"
        val kImageUrl: String = "imageUrl"

        fun fromMap(map: Map<String, Any>): Barber {

            val uuid = map.get(kUUID) as String
            val name = map.get(kName) as String
            val alias = map.get(kAlias) as String?
            val phone = map.get(kPhone) as String?
            val email = map.get(kEmail) as String?
            val image = map.get(kImageUrl) as? String
            val imageUrl = if (image != null) URL(image) else null

            return Barber(uuid, name, imageUrl)
        }

    }

}