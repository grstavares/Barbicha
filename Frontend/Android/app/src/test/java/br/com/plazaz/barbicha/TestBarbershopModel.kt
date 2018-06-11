package br.com.plazaz.barbicha

import br.com.plazaz.barbicha.helpers.Initial
import org.junit.Test
import org.junit.Assert.*
import java.util.*

class TestBarbershopModel {

    val sut = Initial.instance

    @Test
    fun testGetAppointmentsForDay() {

        val today = Date()
        val appointments = sut.getAppointmentsFor(today, null);

        print("Appointments ArrayList Size ${appointments.size}")
        assertEquals(appointments.size, this.calculateSlots(today))

    }

    private fun calculateSlots(date: Date): Int {

        val start = sut.startTime(date)
        val end = sut.endTime(date)
        val slot = sut.slotTime(date) * 60 * 1000

        var walker = start.time
        var counter = 0

        while (walker <= end.time) {

            walker += slot
            counter += 1

        }

        return counter

    }

}