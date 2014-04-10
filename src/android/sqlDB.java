package me.rahul.plugins.sqlDB;

import java.io.File;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.PluginResult;

import org.json.JSONArray;
import org.json.JSONException;
import android.util.Log;

/**
 * This class echoes a string called from JavaScript.
 */
public class sqlDB extends CordovaPlugin {

	public static String dbname = "dbname";
	PluginResult plresult = new PluginResult(PluginResult.Status.NO_RESULT);
	
    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
         		
        if (action.equalsIgnoreCase("copy")) {
        		this.copyDB(args.getString(0), callbackContext);
            	return true; 
         } else {
                plresult = new PluginResult(PluginResult.Status.INVALID_ACTION);
                callbackContext.sendPluginResult(plresult);
                return false;
          }
      }
    
    private void copyDB(String dbName, final CallbackContext callbackContext)
    {
    	
    	final File dbpath;
    	   dbname = dbName;
           final DatabaseHelper dbhelper = new DatabaseHelper(this.cordova.getActivity().getApplicationContext());
           dbpath = this.cordova.getActivity().getDatabasePath(dbname);
           Boolean dbexists = dbpath.exists();
           Log.d("CordovaLog", "Inside Plugin");
           Log.d("CordovaLog", "DatabasePath = "+dbpath+"&&&& dbname = "+dbname+"&&&&DB Exists ="+dbexists);
           
           if(dbexists){
           		plresult = new PluginResult(PluginResult.Status.ERROR);
           		callbackContext.sendPluginResult(plresult);
           } else {
           			cordova.getThreadPool().execute(new Runnable(){

						@Override
						public void run() {
							PluginResult plResult = new PluginResult(PluginResult.Status.NO_RESULT);
							// TODO Auto-generated method stub
							try
							{
								dbhelper.createdatabase(dbpath);
								plResult = new PluginResult(PluginResult.Status.OK);
			           			callbackContext.sendPluginResult(plResult);
							} catch (Exception e){
								plResult = new PluginResult(PluginResult.Status.ERROR);
			           			callbackContext.sendPluginResult(plResult);
			           		}
						}
           				
           			});
           }
    }
}
