package jcsobrino.tddm.uoc.sharetool.view;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.example.joscarlos.myapplication.R;
import com.example.joscarlos.myapplication.dto.ITool;
import com.squareup.picasso.Picasso;

import java.util.List;

/**
 * Created by JoséCarlos on 14/11/2015.
 */
public class ToolArrayAdapter<T extends ITool> extends ArrayAdapter<T> {

    private Context mContext;

    public ToolArrayAdapter(Context context, List<T> objects) {
        super(context, 0, objects);
        mContext = context;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {

        //Obteniendo una instancia del inflater
        LayoutInflater inflater = (LayoutInflater) getContext()
                .getSystemService(Context.LAYOUT_INFLATER_SERVICE);

        //Salvando la referencia del View de la fila
        View listItemView = convertView;

        //Comprobando si el View no existe
        if (null == convertView) {
            //Si no existe, entonces inflarlo con image_list_view.xml
            listItemView = inflater.inflate(
                    R.layout.tool_list_item,
                    parent,
                    false);
        }

        //Obteniendo instancias de los elementos
        TextView nameTool = (TextView) listItemView.findViewById(R.id.nameToolListItem);
        TextView distanceTool = (TextView) listItemView.findViewById(R.id.distanceToolListItem);
        TextView pricePerDayTool = (TextView) listItemView.findViewById(R.id.pricePerDayToolListItem);
        ImageView imageTool = (ImageView) listItemView.findViewById(R.id.imageToolListItem);


        //Obteniendo instancia de la Tarea en la posición actual
        ITool tool = getItem(position);

        nameTool.setText(tool.getName());
        distanceTool.setText(formatDistanceInMeters(tool.getDistanceInMeters()));
        pricePerDayTool.setText(String.format("%.2f €", tool.getPricePerDay()));
                Picasso.with(mContext).load(String.format("http://lorempixel.com/200/100/?id=%s", tool.getId())).into(imageTool);

        //Devolver al ListView la fila creada
        return listItemView;

    }

    private String formatDistanceInMeters(final Float distanceInMeters) {

        if (distanceInMeters == null) {
            return "<Desconocido>";
        }

        return String.format("%.2f %s", distanceInMeters >= 1000f ? distanceInMeters / 1000f : distanceInMeters, distanceInMeters >= 1000f ? "km" : "m");

    }
}
