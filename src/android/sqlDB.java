package me.rahul.plugins.sqlDB;

import java.io.File;

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

	@Override
	public boolean execute(String action, JSONArray args,
			CallbackContext callbackContext) throws JSONException {

		if (action.equalsIgnoreCase("copy")) {
			this.copyDB(args.getString(0), callbackContext);
			return true;
		} else if (action.equalsIgnoreCase("remove")) {
			String db = args.getString(0);
			File path = cordova.getActivity().getDatabasePath(db);
			Boolean fileExists = path.exists();
			if (fileExists) {
				boolean deleted = path.delete();
				if (deleted) {
					plresult = new PluginResult(PluginResult.Status.OK, deleted);
					callbackContext.sendPluginResult(plresult);
				} else {
					plresult = new PluginResult(PluginResult.Status.ERROR,
							deleted);
					callbackContext.sendPluginResult(plresult);
				}
			} else {
				plresult = new PluginResult(PluginResult.Status.ERROR,
						"File Doesn't Exists");
				callbackContext.sendPluginResult(plresult);
			}
			return true;
		} else {
			plresult = new PluginResult(PluginResult.Status.INVALID_ACTION);
			callbackContext.sendPluginResult(plresult);
			return false;
		}
	}

	private void copyDB(String dbName, final CallbackContext callbackContext) {

		final File dbpath;
		dbname = dbName;
		JSONObject error = new JSONObject();
		final DatabaseHelper dbhelper = new DatabaseHelper(this.cordova
				.getActivity().getApplicationContext());
		dbpath = this.cordova.getActivity().getDatabasePath(dbname);
		Boolean dbexists = dbpath.exists();
		//Log.d("CordovaLog", "DatabasePath = " + dbpath + "&&&& dbname = " + dbname + "&&&&DB Exists =" + dbexists);

		if (dbexists) {
			try {
				error.put("message", "File already exists");
				error.put("code", 516);
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

			plresult = new PluginResult(PluginResult.Status.ERROR, error);
			callbackContext.sendPluginResult(plresult);
		} else {
			cordova.getThreadPool().execute(new Runnable() {

				@Override
				public void run() {
					PluginResult plResult = new PluginResult(
							PluginResult.Status.NO_RESULT);
					// TODO Auto-generated method stub
					try {
						dbhelper.createdatabase(dbpath);
						plResult = new PluginResult(PluginResult.Status.OK);
						callbackContext.sendPluginResult(plResult);
					} catch (Exception e) {

						plResult = new PluginResult(PluginResult.Status.ERROR,
								e.getMessage());
						callbackContext.sendPluginResult(plResult);
					}
				}

			});
		}
	}
}
