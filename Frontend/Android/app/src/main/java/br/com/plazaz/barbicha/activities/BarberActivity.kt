package br.com.plazaz.barbicha.activities

import br.com.plazaz.barbicha.*
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import kotlinx.android.synthetic.main.activity_barber.*

class BarberActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {

        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_barber)

        val intent = getIntent();
        val name = intent.getStringExtra("BARBER");
        barberLabel.setText(name)

    }
}
