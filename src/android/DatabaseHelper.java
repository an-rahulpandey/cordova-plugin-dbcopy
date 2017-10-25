package me.rahul.plugins.sqlDB;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import android.content.Context;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import android.util.Log;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.PluginResult;
import org.json.JSONException;
import org.json.JSONObject;


public class DatabaseHelper extends SQLiteOpenHelper {

	private Context myContext;

	public DatabaseHelper(Context context) {
		super(context, sqlDB.dbname, null, 1);
		this.myContext = context;
		// TODO Auto-generated constructor stub
	}

	public void createdatabase(File dbPath, String source, final CallbackContext callbackContext) throws IOException {

		// Log.d("CordovaLog","Inside CreateDatabase = "+dbPath);
		this.getReadableDatabase();
		try {
			copyDatabase(dbPath, source, callbackContext);
		} catch (IOException e) {
			throw new Error(
					"Create Database Exception ============================ "
							+ e);
		}

	}

	private void copyDatabase(File database, String source, final CallbackContext callbackContext) throws IOException {
		InputStream myInput = null;
		JSONObject response = new JSONObject();
		PluginResult plresult = new PluginResult(PluginResult.Status.NO_RESULT);
		try {
			if(source.indexOf("www") != -1) {
				myInput = myContext.getAssets().open("www/" + sqlDB.dbname);
			} else {
				File src = new File(source);
				myInput = new FileInputStream(src);
			}
			OutputStream myOutput = new FileOutputStream(database);
			byte[] buffer = new byte[1024];
			while ((myInput.read(buffer)) > -1) {
				myOutput.write(buffer);
			}

			myOutput.flush();
			myOutput.close();
			myInput.close();
			try {
				response.put("message", "Db Copied");
	            response.put("code", 200);
				plresult = new PluginResult(PluginResult.Status.OK,response);
				callbackContext.sendPluginResult(plresult);
			} catch (JSONException err) {
				throw new Error(err.getMessage());
			}
		} catch (Exception e) {
			Log.d("CordovaLog",e.getMessage());
			try {
				response.put("message", e.getMessage());
	            		response.put("code", 400);
				plresult = new PluginResult(PluginResult.Status.ERROR, response);
	            callbackContext.sendPluginResult(plresult);    
            } catch (JSONException err1) {
				throw new Error(err1.getMessage());
			}
		}
	}


	@Override
	public void onCreate(SQLiteDatabase db) {
		// TODO Auto-generated method stub

	}

	@Override
	public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
		// TODO Auto-generated method stub

	}

}
