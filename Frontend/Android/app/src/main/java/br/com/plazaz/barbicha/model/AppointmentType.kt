package br.com.plazaz.barbicha.model

data class AppointmentType(val index:Int, val label:String, val minutes: Int) {

    companion object {

        const val kIndex = "index"
        const val kLabel = "label"
        const val kTime = "minutes"

        fun fromMap(map: Map<String, Any>): AppointmentType {

            val index = map.get(kIndex) as Int
            val label = map.get(kLabel) as String
            val minutes = map.get(kTime) as Int
            return AppointmentType(index, label, minutes)

        }

    }

}