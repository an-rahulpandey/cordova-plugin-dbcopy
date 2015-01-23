var exec = require('cordova/exec');

exports.copy = function(dbname, success, error) {
    exec(success, error, "sqlDB", "copy", [dbname]);
};

exports.remove = function(dbname,success,error) {
	exec(success, error, "sqlDB", "remove", [dbname]);
};
