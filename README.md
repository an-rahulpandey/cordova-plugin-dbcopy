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
    window.plugins.sqlDB.copy(dbname,success,error);
  ````
  Here -

    **dbname** -> Is the name of the database you want to copy. The dbname can be filename (without extensions) or filename.db or filename.sqlite. The plugin will look for and copy the file according to the filename provided here. And the same file name should be used while opening the database via [SQLitePlugin](https://github.com/brodysoft/Cordova-SQLitePlugin).
        
    **success** -> function will be called if the db is copied sucessfully.
        
    **error** -> function will be called if the there is some problem in copying the db or the file already exists on the location.

* ####Remove
This method allows you to remove the database from the apps default database storage location.

  ````
    window.plugins.sqlDB.remove(dbname,success,error);
  ````
  Here -

    **dbname** -> Is the name of the database you want to remove. If the database file is having any extension, please provide that also.
        
    **success** -> function will be called if the db is removed sucessfully.
        
    **error** -> function will be called if the there is some problem in removing the db or the file doesn't exists on the default database storage location.

###Example Usage

In your JavaScript or HTML use the following method - 

```
function dbcopy()
{
        //Database filename to be copied is demo.db
        window.plugins.sqlDB.copy("demo.db",copysuccess,copyerror);
}

function removeDB()
{
      window.plugins.sqlDB.remove("demo.db",rmsuccess,rmerror);  
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
