var exec = require('cordova/exec');

exports.copy = function(dbname, location, success, error) {
  exec(success, error, "sqlDB", "copy", [dbname, location]);
};

exports.remove = function(dbname, location, success,error) {
  exec(success, error, "sqlDB", "remove", [dbname, location]);
};
