package br.com.plazaz.barbicha.activities

import android.content.*
import br.com.plazaz.barbicha.*
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.os.IBinder
import android.support.v4.content.ContextCompat
import android.support.v4.content.LocalBroadcastManager
import android.support.v7.widget.GridLayoutManager
import android.util.Log
import br.com.plazaz.barbicha.adapters.CollectionItemAdapter
import br.com.plazaz.barbicha.helpers.Initial
import br.com.plazaz.barbicha.model.Barbershop
import br.com.plazaz.barbicha.providers.DataProvider
import br.com.plazaz.barbicha.providers.DataProviderObservableEvent
import br.com.plazaz.barbicha.services.DataService
import kotlinx.android.synthetic.main.activity_barbershop.*

class BarbershopActivity : AppCompatActivity() {

    private var connection: ServiceConnection? = null
    private var dataProvider: DataProvider? = null
    private var barbershop: Barbershop = Initial.instance
    private var observer: BroadcastReceiver = ObservableEventReceiver()

    override fun onCreate(savedInstanceState: Bundle?) {

        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_barbershop)

        this.initializeCollection()
        this.connection = DataServiceConnection

    }

    override fun onResume() {
        super.onResume()
        this.bindService()
    }

    override fun onPause() {
        super.onPause()
        unbindService(DataServiceConnection)
    }

    override fun onStart() {
        Log.d("BarbershopActivity", "Registering on Start")
        super.onStart()
        this.registerObservers()
    }

    override fun onStop() {
        super.onStop()
        LocalBroadcastManager.getInstance(this).unregisterReceiver(this.observer)
    }


    private fun bindService() {
        val intent = Intent(this, DataService::class.java)
        bindService(intent, this.connection, Context.BIND_AUTO_CREATE)
    }

    private fun registerObservers() {

        val filter = IntentFilter()
        filter.addAction(DataProviderObservableEvent.barbershopUpdated.toString())
        filter.addAction(DataProviderObservableEvent.barberListUpdated.toString())
        LocalBroadcastManager.getInstance(this).registerReceiver(this.observer, filter)

    }

    private fun initializeCollection() {

        val adapter = CollectionItemAdapter(this.barbershop)
        barberCollection.adapter = adapter
        barberCollection.layoutManager = GridLayoutManager(this, 2);

    }

    private fun refreshViews() {

        Log.d("BROADCAST", "RefreshViews")
        shopLabel.setText(this.barbershop.name);
        shopImage.setImageDrawable(ContextCompat.getDrawable(shopImage.context, R.drawable.placeholder_person))

    }

    private fun refreshAdapter() {

        Log.d("BROADCAST", "RefreshAdapter")
        val adapter = CollectionItemAdapter(this.barbershop)
        barberCollection.adapter = adapter
        barberCollection.adapter.notifyDataSetChanged()

    }


    private val DataServiceConnection = object : ServiceConnection {

        override fun onServiceConnected(className: ComponentName, service: IBinder) {

            val binder = service as DataService.DataProviderBinder
            val dataService = binder.getService()
            this@BarbershopActivity.dataProvider = dataService.getProvider(this@BarbershopActivity.barbershop)
        }

        override fun onServiceDisconnected(name: ComponentName) {
            this@BarbershopActivity.dataProvider = null
        }
    }

    inner class ObservableEventReceiver: BroadcastReceiver() {

        override fun onReceive(context: Context?, intent: Intent?) {
            Log.d("BROADCAST", intent?.action)
            when (intent?.action) {

                DataProviderObservableEvent.barbershopUpdated.toString() -> this@BarbershopActivity.refreshViews()
                DataProviderObservableEvent.barberListUpdated.toString() -> this@BarbershopActivity.refreshAdapter()

            }
        }

    }

}
