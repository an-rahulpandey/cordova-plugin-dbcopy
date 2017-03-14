var exec = require('cordova/exec');

exports.copy = function(dbname, location, success, error) {
  exec(success, error, "sqlDB", "copy", [dbname, location]);
};

exports.remove = function(dbname, location, success,error) {
  exec(success, error, "sqlDB", "remove", [dbname, location]);
};

exports.copyDbToStorage = function(dbname,location,destination, overwrite, success,error){
  exec(success, error, "sqlDB", "copyDbToStorage", [dbname, location, destination, overwrite]);
};

exports.copyDbFromStorage = function(dbname,location,source, deleteolddb, success,error){
  exec(success, error, "sqlDB", "copyDbFromStorage", [dbname, location, source, deleteolddb]);
};

exports.checkDbOnStorage = function(dbname,source, success,error){
  exec(success, error, "sqlDB", "checkDbOnStorage", [dbname, source]);
};
