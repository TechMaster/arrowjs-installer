var socket_active = {};
var child_process = require('child_process');

socket_active.postgres = function (socket, callback, action) {
    child_process.exec('./shell_scripts/postgres/toggle_active.sh ' + _osId + ' ' + _osVersion + ' ' + action, function (err, stdout, stderr) {
        if (err) {
            callback("ERROR: " + err);
        } else {
            callback('success');
        }
    });
};

socket_active.redis = function (socket, callback, action) {
    child_process.exec('./shell_scripts/redis/toggle_active.sh ' + _redisPath + ' ' + action, function (err, stdout, stderr) {
        if (err) {
            callback("ERROR: " + err);
        } else {
            callback('success');
        }
    });
};

socket_active.nginx = function (socket, callback, action) {
    child_process.exec('./shell_scripts/nginx/toggle_active.sh ' + _osId + ' ' + _osVersion + ' ' + action, function (err, stdout, stderr) {
        if (err) {
            callback("ERROR: " + err);
        } else {
            callback('success');
        }
    });
};

socket_active.pm2 = function (socket, callback, action) {
    child_process.exec('./shell_scripts/pm2/toggle_active.sh ' + action, function (err, stdout, stderr) {
        if (err) {
            callback("ERROR: " + err);
        } else {
            callback('success');
        }
    });
};

module.exports = socket_active;

