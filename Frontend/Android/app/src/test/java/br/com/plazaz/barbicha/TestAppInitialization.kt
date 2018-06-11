package br.com.plazaz.barbicha

import br.com.plazaz.barbicha.helpers.Initial
import org.junit.Test

/**
 * Example local unit test, which will execute on the development machine (host).
 *
 * See [testing documentation](http://d.android.com/tools/testing).
 */
class TestAppInitialization {

    @Test
    fun LoadMockData() {

        val sut = Initial.instance
        assert(sut.barbers.size == 2);

    }
}
