package br.com.plazaz.barbicha.services

import android.app.Service
import android.content.Intent
import android.os.Binder
import android.os.IBinder
import android.support.v4.content.LocalBroadcastManager
import android.util.Log
import br.com.plazaz.barbicha.logTag
import br.com.plazaz.barbicha.model.Barbershop
import br.com.plazaz.barbicha.providers.DataProvider
import br.com.plazaz.barbicha.providers.FirebaseProvider
import br.com.plazaz.barbicha.providers.ProviderListener

class DataService(): Service(), ProviderListener {

    private val myBinder = DataProviderBinder()
    private var providers: HashMap<String,FirebaseProvider> = HashMap()
    private var listeners: HashMap<String,String> = HashMap()

    override fun onBind(intent: Intent): IBinder? {
        Log.d(logTag, "DataService:Service Bound")
        return this.myBinder
    }

    fun getProvider(barbershop: Barbershop): DataProvider {

        Log.d(logTag, "DataService:Getting Provider")
        val found = this.providers.get(barbershop.uuid)
        if (found == null) {

            Log.d(logTag, "DataService:Initializing New Provider")
            val provider = FirebaseProvider(barbershop)
            val token = provider.addListener(this)

            this.providers.put(barbershop.uuid, provider)
            this.listeners.put(barbershop.uuid, token)
            return provider

        } else {Log.d(logTag, "DataService:Returning Provider from Cache");return found}

    }

    override fun onDestroy() {

        Log.d(logTag, "DataService:Removing Provider")
        for (barbershopUUID in this.providers.keys) {

            val provider = this.providers.get(barbershopUUID)
            val token = this.listeners.get(barbershopUUID)
            if (token != null) {provider?.removeListener(token)}

        }

        super.onDestroy()

    }

    override fun receiveMessage(message: String) {

        Log.d(logTag, "DataService:Message Received -> ${message}")
        val intent = Intent(message)
        intent.putExtra(kBarbershopUUID, "")
        LocalBroadcastManager.getInstance(this).sendBroadcast(intent)

    }

    inner class DataProviderBinder : Binder() {
        fun getService() : DataService {
            return this@DataService
        }

    }

    companion object {

        val kBarbershopUUID = "baarbershopUUID"


    }

}