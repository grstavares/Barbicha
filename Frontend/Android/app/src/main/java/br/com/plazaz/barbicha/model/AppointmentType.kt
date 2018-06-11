package br.com.plazaz.barbicha.model

data class AppointmentType(val index:Int, val label:String, val minutes: Int) {

    companion object {

        const val kIndex = "index"
        const val kLabel = "label"
        const val kTime = "minutes"


        const val kEmptyTypeIndex:Int = -1
        const val kUnavailableTypeIndex: Int = -2

        fun empty(): AppointmentType {return AppointmentType(kEmptyTypeIndex, "", 30)}
        fun unavailable(): AppointmentType {return AppointmentType(kUnavailableTypeIndex, "", 30)}

        fun fromMap(map: Map<String, Any>): AppointmentType {

            val index = map.get(kIndex) as Long
            val label = map.get(kLabel) as String
            val minutes = map.get(kTime) as Long
            return AppointmentType(index.toInt() , label, minutes.toInt())

        }

    }

}