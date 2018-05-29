package br.com.plazaz.barbicha.activities

import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.support.v7.widget.GridLayoutManager
import br.com.plazaz.barbicha.CollectionItemAdapter
import br.com.plazaz.barbicha.MockData
import br.com.plazaz.barbicha.R
import kotlinx.android.synthetic.main.activity_barbershop.*

class BarbershopActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {

        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_barbershop)

        val shop = MockData.create();
        shopLabel.setText(shop.name);

        val adapter = CollectionItemAdapter(shop.barbers)
        barberCollection.adapter = adapter
        barberCollection.layoutManager = GridLayoutManager(this, 2);

    }
}
