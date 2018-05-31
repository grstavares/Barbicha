package br.com.plazaz.barbicha.adapters

import android.content.Intent
import android.support.v4.content.ContextCompat
import android.support.v7.widget.RecyclerView
import android.view.View
import android.view.ViewGroup
import android.widget.EditText
import android.widget.ImageView
import android.widget.TextView
import br.com.plazaz.barbicha.R
import br.com.plazaz.barbicha.activities.BarberActivity
import br.com.plazaz.barbicha.model.Barber
import br.com.plazaz.extensions.inflate
import kotlinx.android.synthetic.main.collection_item.view.*

class CollectionItemAdapter(private val barbers: ArrayList<Barber>): RecyclerView.Adapter<CollectionItemAdapter.BarberHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): BarberHolder {
        val inflatedView = parent.inflate(R.layout.collection_item, false)
        return BarberHolder(inflatedView)
    }

    override fun getItemCount(): Int = barbers.size;

    override fun onBindViewHolder(holder: BarberHolder, position: Int) {
        val item = barbers[position]
        holder.bindBarber(item);
    }


    class BarberHolder(v: View): RecyclerView.ViewHolder(v), View.OnClickListener {

        private var view: View = v;
        private var itemDescription: TextView? = null;
        private var thumbnail: ImageView? = null;
        private var barber: Barber? = null;

        init {
            v.setOnClickListener(this)
            this.itemDescription = v.findViewById(R.id.itemDescription)
            this.thumbnail = v.findViewById(R.id.thumbnail)
        }

        override fun onClick(v: View?) {

            val context = itemView.context;
            val showBarberIntent = Intent(context, BarberActivity::class.java);
            showBarberIntent.putExtra(BARBER_KEY, this.barber?.name);
            context.startActivity(showBarberIntent);

        }

        fun bindBarber(barber: Barber) {

            this.barber = barber;
            this.itemDescription?.setText(barber.name);
            this.thumbnail?.setImageDrawable(ContextCompat.getDrawable(view.context, R.drawable.placeholder_person));

        }

        companion object {
            private val BARBER_KEY = "BARBER"
        }

    }

}