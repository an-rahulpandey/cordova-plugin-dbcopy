cordova-plugin-dbcopy
=====================

Add a prepopulated SQLite database in your Phonegap/Cordova Android and iOS app.

###Note

The database file may have extensions or not for e.g the db file name would be sample.db or sample.sqlite or sample. It doesn't matter what is the file extension, just remember to use the whole filename with extensions(if having one otherwise not) as a paramter when passing to the plugin methods.

###Database file location

The database initial location for both platforms has been now changed to www folder. Now you have to put your database file inside www folder.

###Installation

Plugin can be install with simple cordova plugin add command -

    cordova plugin add https://github.com/an-rahulpandey/cordova-plugin-dbcopy.git


###Methods

Currently there are two methods supported by the plugin.

* ####Copy
This Method allows you the copy the database from the asset directory(for Android) or Resource directory (for iOS).

  ````
    window.plugins.sqlDB.copy(dbname, location, success,error);
  ````
  Here -

    **dbname** -> Is the name of the database you want to copy. The dbname can be filename (without extensions) or filename.db or filename.sqlite. The plugin will look for and copy the file according to the filename provided here. And the same file name should be used while opening the database via [SQLitePlugin](https://github.com/litehelpers/Cordova-sqlite-storage).

    **location** -> You can pass three integer arguments here (Use 0 for Android)-

    ````
    (for ios only)
      location = 0; // It will copy the database in the default SQLite Database directory. This is the default location for database
      or
      location = 1; // If set will copy the database to Library folder instead of Documents folder.
      or
      location = 2; // (Disable iCloud Backup) If set will copy the database to Library/LocalDatabase. The database will not be synced by the iCloud Backup.
    ````

    **success** -> function will be called if the db is copied sucessfully.

    **error** -> function will be called if the there is some problem in copying the db or the file already exists on the location.

* ####Remove
This method allows you to remove the database from the apps default database storage location.

  ````
    window.plugins.sqlDB.remove(dbname, location, success,error);
  ````
  Here -

    **dbname** -> Is the name of the database you want to remove. If the database file is having any extension, please provide that also.

    **location** -> The integer value for the location of database, see the copy method for options.

    **success** -> function will be called if the db is removed sucessfully.

    **error** -> function will be called if the there is some problem in removing the db or the file doesn't exists on the default database storage location.

###Example Usage

In your JavaScript or HTML use the following method -

```
function dbcopy()
{
        //Database filename to be copied is demo.db

        //location = 0, will copy the db to default SQLite Database Directory
        window.plugins.sqlDB.copy("demo.db", 0, copysuccess,copyerror);

        or

        //location = 1, will copy the database to /Library folder
        window.plugins.sqlDB.copy("demo.db", 1, copysuccess,copyerror);

        or

        //location = 2, will copy the database to /Library/LocalDatabase folder (Disable iCloud Backup)
        window.plugins.sqlDB.copy("demo.db", 2, copysuccess,copyerror);

}

function removeDB()
{
      var location = 1;
      window.plugins.sqlDB.remove("demo.db", location, rmsuccess,rmerror);  
}

function copysuccess()
{
        //open db and run your queries
         db = window.sqlitePlugin.openDatabase({name: "demo.db"});.
}

function copyerror(e)
{
        //db already exists or problem in copying the db file. Check the Log.
        console.log("Error Code = "+JSON.stringify(e));
        //e.code = 516 => if db exists
}

```
