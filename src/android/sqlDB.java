package me.rahul.plugins.sqlDB;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.PluginResult;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.util.Log;

/**
 * This class echoes a string called from JavaScript.
 */
public class sqlDB extends CordovaPlugin {

	public static String dbname = "dbname";
	PluginResult plresult = new PluginResult(PluginResult.Status.NO_RESULT);

    private void sendPluginResponse(int code, String msg, boolean error, CallbackContext callbackContext) {
        JSONObject response = new JSONObject();
        try {
            response.put("message", msg);
            response.put("code", code);
            if(error) {
                plresult = new PluginResult(PluginResult.Status.ERROR,
                        response);
            } else {
                plresult = new PluginResult(PluginResult.Status.OK,response);
            }
        } catch (JSONException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
            plresult = new PluginResult(PluginResult.Status.ERROR,
                    e.getMessage());
        }
        callbackContext.sendPluginResult(plresult);
    }

	@Override
	public boolean execute(String action, JSONArray args,
			CallbackContext callbackContext) throws JSONException {

		if (action.equalsIgnoreCase("copy")) {
			this.copyDB(args.getString(0), "www", callbackContext);
			return true;
		} else if (action.equalsIgnoreCase("remove")) {
			String db = args.getString(0);
			File path = cordova.getActivity().getDatabasePath(db);
			Boolean fileExists = path.exists();
			if (fileExists) {
				boolean deleted = path.delete();
				if (deleted) {
					sendPluginResponse(200,"Database Deleted",false, callbackContext);
				} else {
                    sendPluginResponse(400,"Unable to Delete",true, callbackContext);
				}
			} else {
                sendPluginResponse(404, "Invalid DB Location or DB Doesn't Exists", true, callbackContext);
			}
			return true;
        } else if (action.equalsIgnoreCase("copyDbToStorage")) {
            String db = args.getString(0);
            String dest = args.getString(2);
            this.copyDbToStorage(db, dest, callbackContext);
            return true;
        } else if(action.equalsIgnoreCase("copyDbFromStorage")) {
					String db = args.getString(0);
					String src = args.getString(2);
					this.copyDbFromStorage(db, src, callbackContext);
						return true;
        } else {
			plresult = new PluginResult(PluginResult.Status.INVALID_ACTION);
			callbackContext.sendPluginResult(plresult);
			return false;
		}
	}

	private void copyDB(String dbName, final String src, final CallbackContext callbackContext) {

		final File dbpath;
		dbname = dbName;
		JSONObject response = new JSONObject();
		final DatabaseHelper dbhelper = new DatabaseHelper(this.cordova
				.getActivity().getApplicationContext());
		dbpath = this.cordova.getActivity().getDatabasePath(dbname);
		Boolean dbexists = dbpath.exists();
		//Log.d("CordovaLog", "DatabasePath = " + dbpath + "&&&& dbname = " + dbname + "&&&&DB Exists =" + dbexists);

		if (dbexists) {
            sendPluginResponse(516,"DB Already Exists", true, callbackContext);
		} else {
			cordova.getThreadPool().execute(new Runnable() {

				@Override
				public void run() {
					PluginResult plResult;
					// TODO Auto-generated method stub
					try {
						dbhelper.createdatabase(dbpath,src, callbackContext);
//						plResult = new PluginResult(PluginResult.Status.OK);
//						callbackContext.sendPluginResult(plResult);
                        //sendPluginResponse(200,"Db Copied", false, callbackContext);
					} catch (Exception e) {

//						plResult = new PluginResult(PluginResult.Status.ERROR,
//								e.getMessage());
//						callbackContext.sendPluginResult(plResult);
                        sendPluginResponse(400,e.getMessage(), true, callbackContext);
					}
				}

			});
		}
	}


    private void newCopyDB(File source, File destination, CallbackContext callbackContext){
        try {
            InputStream myInput = new FileInputStream(source);
            OutputStream myOutput = new FileOutputStream(destination);
            byte[] buffer = new byte[1024];
            while ((myInput.read(buffer)) > -1) {
                myOutput.write(buffer);
            }

            myOutput.flush();
            myOutput.close();
            myInput.close();
            sendPluginResponse(200, "DB Copied Successfully", false, callbackContext);
        } catch (IOException e) {
            sendPluginResponse(400, e.getMessage(), true, callbackContext);
        }
    }

    private void copyDbFromStorage(String db, String src, final CallbackContext callbackContext) {
	File source;
	if(src.indexOf("file://") != -1){
            source = new File(src.replace("file://",""));
        } else {
            source = new File(src);
        }

	if(source.exists()){
	    this.copyDB(db, source.getAbsolutePath(), callbackContext);
	} else {
	    sendPluginResponse(404, "Invalid DB Source Location", true, callbackContext);
	}
    }

    private void copyDbToStorage(String dbname, String dest, final CallbackContext callbackContext){
        File source = cordova.getActivity().getDatabasePath(dbname);
        File destination;
        if(dest.indexOf("file://") != -1){
            destination = new File(dest.replace("file://",""));
        } else {
            destination = new File(dest);
        }
        if(!destination.exists()){
            destination.mkdirs();
        }

        if(source.exists()) {
            this.newCopyDB(source,destination,callbackContext);
        } else {
            sendPluginResponse(404, "Invalid DB Location or DB Doesn't Exists", true, callbackContext);
        }
    }
}
