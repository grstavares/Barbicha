package br.com.plazaz.barbicha.helpers

import java.util.*

class Utils {

    companion object {

        fun zeroedDate(date: Date): Date {

            var calendar = Calendar.getInstance(TimeZone.getDefault());
            calendar.time = date
            calendar.set(Calendar.HOUR_OF_DAY, 0)
            calendar.set(Calendar.MINUTE, 0)
            calendar.set(Calendar.SECOND,0)
            return calendar.time

        }

    }

}