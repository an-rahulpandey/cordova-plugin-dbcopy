package me.rahul.plugins.sqlDB;

import android.util.Log;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

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
            if (error) {
                plresult = new PluginResult(PluginResult.Status.ERROR,
                        response);
            } else {
                plresult = new PluginResult(PluginResult.Status.OK, response);
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
                    sendPluginResponse(200, "Database Deleted", false, callbackContext);
                } else {
                    sendPluginResponse(400, "Unable to Delete", true, callbackContext);
                }
            } else {
                sendPluginResponse(404, "Invalid DB Location or DB Doesn't Exists", true, callbackContext);
            }
            return true;
        } else if (action.equalsIgnoreCase("copyDbToStorage")) {
            String db = args.getString(0);
            String dest = args.getString(2);
            boolean overwrite = args.getBoolean(3);
            this.copyDbToStorage(db, dest, overwrite, callbackContext);
            return true;
        } else if (action.equalsIgnoreCase("copyDbFromStorage")) {
            String db = args.getString(0);
            String src = args.getString(2);
            boolean deleteolddb = args.getBoolean(3);
            this.copyDbFromStorage(db, src, deleteolddb, callbackContext);
            return true;
        } else if (action.equalsIgnoreCase("checkDbOnStorage")) {
            String db = args.getString(0);
            String src = args.getString(1);
            this.checkDbOnStorage(db, src, callbackContext);
            return true;
        } else {
            plresult = new PluginResult(PluginResult.Status.INVALID_ACTION);
            callbackContext.sendPluginResult(plresult);
            return false;
        }
    }

    private void copyDB(final String dbName, final String src, final CallbackContext callbackContext) {

        final File dbpath;
        dbname = dbName;
        JSONObject response = new JSONObject();
        final DatabaseHelper dbhelper = new DatabaseHelper(this.cordova
                .getActivity().getApplicationContext());
        dbpath = this.cordova.getActivity().getDatabasePath(dbname);
        Boolean dbexists = dbpath.exists();
        Log.d("CordovaLog", "DatabasePath = " + dbpath + "&&&& dbname = " + dbname + "&&&&DB Exists =" + dbexists);

        if (dbexists) {
            sendPluginResponse(516, "DB Already Exists", true, callbackContext);
        } else {
            cordova.getThreadPool().execute(new Runnable() {

                @Override
                public void run() {
                    PluginResult plresult;

                    // TODO Auto-generated method stub
//                    try {
//                        dbhelper.createdatabase(dbpath, src, callbackContext);
////						plResult = new PluginResult(PluginResult.Status.OK);
////						callbackContext.sendPluginResult(plResult);
//                        //sendPluginResponse(200,"Db Copied", false, callbackContext);
//                    } catch (Exception e) {
//
////						plResult = new PluginResult(PluginResult.Status.ERROR,
////								e.getMessage());
////						callbackContext.sendPluginResult(plResult);
//                        sendPluginResponse(400, e.getMessage(), true, callbackContext);
//                    }
                    InputStream myInput = null;
                    JSONObject response = new JSONObject();
                    try {
                        myInput = cordova.getActivity().getAssets().open("www/" + dbName);

                        OutputStream myOutput = new FileOutputStream(dbpath);
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
                        Log.d("Cordova", "Try Error = "+e.getMessage());
                        try {
                            dbhelper.createdatabase(dbpath, src, callbackContext);
                        } catch (Exception err) {
                            sendPluginResponse(400, err.getMessage(), true, callbackContext);
                        }
                    }
                }

            });
        }
    }


    private void newCopyDB(File source, File destination, CallbackContext callbackContext) {
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

    private void copyDbFromStorage(String db, String src, boolean deleteolddb, final CallbackContext callbackContext) {
        File source;
        if (src.indexOf("file://") != -1) {
            source = new File(src.replace("file://", ""));
        } else {
            source = new File(src);
        }

        if (source.exists()) {
            if (deleteolddb) {
                File path = cordova.getActivity().getDatabasePath(db);
                Boolean fileExists = path.exists();
                if (fileExists) {
                    boolean deleted = path.delete();
                    if (deleted) {
                        this.copyDB(db, source.getAbsolutePath(), callbackContext);
                    } else {
                        sendPluginResponse(400, "Unable to Delete", true, callbackContext);
                    }
                } else {
                    sendPluginResponse(404, "Old DB Doesn't Exists", true, callbackContext);
                }
            } else {
                this.copyDB(db, source.getAbsolutePath(), callbackContext);
            }
        } else {
            sendPluginResponse(404, "Invalid DB Source Location", true, callbackContext);
        }
    }

    private void checkDbOnStorage(String db, String src, final CallbackContext callbackContext) {
        File source;
        if (src.indexOf("file://") != -1) {
            source = new File(src.replace("file://", "")+db);
        } else {
            source = new File(src+db);
        }
        if (source.exists()) {
            sendPluginResponse(200, "DB File Exists At Source Location", false, callbackContext);
        } else {
            sendPluginResponse(404, "Invalid DB Source Location", true, callbackContext);
        }

    }

    private void copyDbToStorage(String dbname, String dest, boolean overwrite, final CallbackContext callbackContext) {

        File source = cordova.getActivity().getDatabasePath(dbname);
        File destFolder;
        File destination;

        if (dest.indexOf("file://") != -1) {
            destination = new File(dest.replace("file://", "") + dbname);
            destFolder = new File(dest.replace("file://", ""));
        } else {
            destination = new File(dest + dbname);
            destFolder = new File(dest);
        }


        if (!destFolder.exists()) {
            destFolder.mkdirs();
        }

        if (!destFolder.exists()) {
            sendPluginResponse(404, "Invalid output DB Location", true, callbackContext);
            return;
        }

        //Check if the db exists at source
        if (source.exists()) {
            //check if the db file is already present at destination and overwrite flag is false
            if(destination.exists() && !overwrite) {
                sendPluginResponse(400, "DB already exists at destination", true, callbackContext);
            } else {
                this.newCopyDB(source, destination, callbackContext);
            }
        } else {
            sendPluginResponse(404, "Invalid DB Location or DB Doesn't Exists", true, callbackContext);
        }
    }
}
