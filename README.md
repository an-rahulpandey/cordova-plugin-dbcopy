cordova-plugin-dbcopy
=====================

Copy SQLite Database from assets(Android) or Resources(iOS) to App Directory

#####Note

If you are using this [SQlite Plugin](https://github.com/brodysoft/Cordova-SQLitePlugin), then do not give the .db extension to your file while pasting it. Since the plugin automatically appends the .db extension while opening the database.

For example, if you are database name is demo.db, then remove the .db extension and paste the file with a name "demo" only (without quotes".

**Android**

Put your sqlite database in the assets directory.                                                                    


**iOS**

Put your database in Resources directory and then Add it in to your Xcode Project.
Right Click on the Resources directory, then click Add files.

**Code**
In your JavaScript or HTML use the following method - 

```
function dbcopy()
{
        window.plugins.sqlDB.copy("demo",copysuccess,copyerror);
}

function copysuccess()
{
        //open db and run your queries
}

funtion copyerror()
{
        //db already exists or problem in copying the db file. Check the Log.
}

```

