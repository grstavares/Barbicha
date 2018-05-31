package br.com.plazaz.barbicha

import br.com.plazaz.barbicha.helpers.InitialData
import org.junit.Test

/**
 * Example local unit test, which will execute on the development machine (host).
 *
 * See [testing documentation](http://d.android.com/tools/testing).
 */
class ExampleUnitTest {
    @Test
    fun LoadMockData() {

        val sut = InitialData.create()
        assert(sut.barbers.size == 2);

    }
}
