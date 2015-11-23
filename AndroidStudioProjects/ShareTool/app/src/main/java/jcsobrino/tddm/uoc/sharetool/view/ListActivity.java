package jcsobrino.tddm.uoc.sharetool.view;

import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.app.SearchManager;
import android.content.Context;
import android.content.DialogInterface;
import android.location.Location;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.v4.widget.SwipeRefreshLayout;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.SearchView;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.SeekBar;
import android.widget.Switch;
import android.widget.Toast;

import com.example.joscarlos.myapplication.R;
import com.example.joscarlos.myapplication.common.ApiFactory;
import com.example.joscarlos.myapplication.common.ToolOrderEnum;
import com.example.joscarlos.myapplication.dto.ITool;
import com.example.joscarlos.myapplication.service.ApiService;
import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.api.GoogleApiClient;
import com.google.android.gms.location.LocationListener;
import com.google.android.gms.location.LocationRequest;
import com.google.android.gms.location.LocationServices;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class ListActivity extends AppCompatActivity implements
        GoogleApiClient.ConnectionCallbacks, GoogleApiClient.OnConnectionFailedListener, LocationListener, SearchView.OnQueryTextListener {

    private GoogleApiClient mGoogleApiClient;
    private Location mCurrentLocation;
    private ApiService api = ApiFactory.INSTANCE.getApi();
    private ListView listaView;
    private ArrayAdapter adaptador;
    private AlertDialog filterDialog;

    private String toolName = null;
    private Date dateStart;
    private Integer numOfDays;
    private Float maxDistance;
    private Float maxPrice;
    private ToolOrderEnum toolOrderEnum;

    private LocationRequest mLocationRequest;

    private SwipeRefreshLayout refreshLayout;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_list);
        deleteDatabase("ShareTool.db");
        buildGoogleApiClient();
        refreshLayout = (SwipeRefreshLayout) findViewById(R.id.swipeRefresh);

        listaView = (ListView) findViewById(R.id.listaView);

        adaptador = new ToolArrayAdapter(this, new ArrayList<ITool>());
        listaView.setAdapter(adaptador);
        filterDialog = createLoginDialogo();


        refreshLayout.setOnRefreshListener(new SwipeRefreshLayout.OnRefreshListener() {
            @Override
            public void onRefresh() {
                new FindToolsTask().execute();
                refreshLayout.setRefreshing(false);
            }
        });


    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.main, menu);

        // Associate searchable configuration with the SearchView
        SearchManager searchManager =
                (SearchManager) getSystemService(Context.SEARCH_SERVICE);
        SearchView searchView =
                (SearchView) menu.findItem(R.id.search).getActionView();

        searchView.setOnQueryTextListener(this);
/*
        searchView.setSearchableInfo(
                searchManager.getSearchableInfo(new ComponentName(getApplicationContext(), SearchResultsActivity.class)));
*/

        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {

        switch (item.getItemId()) {
            case R.id.add:

                filterDialog.show();
                return true;
            default:
                return super.onOptionsItemSelected(item);
        }

    }

    protected synchronized void buildGoogleApiClient() {
        mGoogleApiClient = new GoogleApiClient.Builder(this)
                .addConnectionCallbacks(this)
                .addOnConnectionFailedListener(this)
                .addApi(LocationServices.API)
                .build();
    }





   /* @Override
    protected void onPause() {
        super.onPause();
        stopLocationUpdates();
    }

    protected void stopLocationUpdates() {
        LocationServices.FusedLocationApi.removeLocationUpdates(
                mGoogleApiClient, this);
    }*/

    @Override
    public void onConnected(Bundle connectionHint) {

        mCurrentLocation = LocationServices.FusedLocationApi.getLastLocation(
                mGoogleApiClient);
       // new FindToolsTask().execute();

        createLocationRequest();
        LocationServices.FusedLocationApi.requestLocationUpdates(
                mGoogleApiClient, mLocationRequest, this);
    }

    public void onLocationChanged(Location location) {

        mCurrentLocation = location;
        Log.i(ListActivity.class.toString(), "Updated location: " + location);
    }

    protected void startLocationUpdates() {

    }

    protected void createLocationRequest() {
        mLocationRequest = new LocationRequest();
        mLocationRequest.setInterval(10000);
        mLocationRequest.setFastestInterval(5000);
        mLocationRequest.setPriority(LocationRequest.PRIORITY_HIGH_ACCURACY);
    }

    @Override
    public void onConnectionSuspended(int var1) {

    }

    @Override
    public boolean onQueryTextChange(String newText) {

        Toast.makeText(this, newText, Toast.LENGTH_SHORT).show();

        return false;
    }

    @Override
    public boolean onQueryTextSubmit(String text) {

        //Toast.makeText(this, "Searching for " + text, Toast.LENGTH_LONG).show();
        toolName = text;
        new FindToolsTask().execute();
        return false;
    }

    @Override
    protected void onStart() {
        super.onStart();
        mGoogleApiClient.connect();
    }

    public void onConnectionFailed(ConnectionResult var1) {
        Log.e(ListActivity.class.toString(), String.format("Connection failed. ConnectionResult: %s", var1.toString()));
    }

    public AlertDialog createLoginDialogo() {
        AlertDialog.Builder builder = new AlertDialog.Builder(this);

        LayoutInflater inflater = this.getLayoutInflater();

        View v = inflater.inflate(R.layout.filter_tool_list, null);

        builder.setView(v);

        final Switch distanciaSwitch = (Switch) v.findViewById(R.id.distanciaSwitch);
        final Switch precioSwitch = (Switch) v.findViewById(R.id.precioSwitch);
        final Switch fechaSwitch = (Switch) v.findViewById(R.id.fechaSwitch);

        final RadioButton orderNear = (RadioButton) v.findViewById(R.id.cercanos);
        final RadioButton orderPrice = (RadioButton) v.findViewById(R.id.baratos);

        final RadioGroup orderRadioGroup = (RadioGroup) v.findViewById(R.id.orderRadioGroup);

        final SeekBar distanciaMax = (SeekBar) v.findViewById(R.id.distanciaSelector);
        final EditText fechaStart = (EditText) v.findViewById(R.id.dateEditText);
        final EditText numDays = (EditText) v.findViewById(R.id.daysEditText);
        final EditText precioMax = (EditText) v.findViewById(R.id.precioEditText);

        builder.setPositiveButton(R.string.accept, new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int id) {
                // User clicked OK button
                maxDistance = distanciaSwitch.isChecked() ? new Float(distanciaMax.getProgress()) : null;
                maxPrice = precioSwitch.isChecked() ? Float.valueOf(precioMax.getText().toString()) : null;
                toolOrderEnum = orderPrice.isChecked() ? ToolOrderEnum.MIN_PRICE : ToolOrderEnum.NEAR_TOOL;

                new FindToolsTask().execute();
            }
        });
        builder.setNegativeButton(R.string.search, new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int id) {
                // User cancelled the dialog
            }
        });

        builder.setTitle("Filtros");

        return builder.create();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        deleteDatabase("ShareTool.db");
    }

    private class FindToolsTask extends AsyncTask<Void, Integer, List<? extends ITool>> {

        ProgressDialog pd;

        @Override
        protected void onPreExecute() {
            pd = ProgressDialog.show(ListActivity.this, "Loading", "Wait while loading...", true, true);
            adaptador.clear();
        }

        @Override
        protected List<? extends ITool> doInBackground(Void... params) {

            return api.findTools(toolName, maxPrice, maxDistance, mCurrentLocation != null ? new Float(mCurrentLocation.getLatitude()) : null, mCurrentLocation != null ? new Float(mCurrentLocation.getLongitude()) : null, toolOrderEnum);
        }

        @Override
        protected void onCancelled() {
            super.onCancelled();
        }

        @Override
        protected void onPostExecute(List<? extends ITool> result) {
            super.onPostExecute(result);
            adaptador.addAll(result);
            pd.dismiss();
        }

    }
}
