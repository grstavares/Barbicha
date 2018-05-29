package br.com.plazaz.barbicha.activities

import br.com.plazaz.barbicha.*
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.support.v7.widget.GridLayoutManager
import br.com.plazaz.barbicha.adapters.CollectionItemAdapter
import br.com.plazaz.barbicha.helpers.MockData
import br.com.plazaz.barbicha.providers.FirebaseProvider
import kotlinx.android.synthetic.main.activity_barbershop.*


class BarbershopActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {

        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_barbershop)

        val barbershopUUID = "0BC576BD-D174-4F40-8E21-5962A403BCA1"
        val dataProvider = FirebaseProvider(barbershopUUID);

        val shop = MockData.create();
        shopLabel.setText(shop.name);

        val adapter = CollectionItemAdapter(shop.barbers)
        barberCollection.adapter = adapter
        barberCollection.layoutManager = GridLayoutManager(this, 2);

    }
}
