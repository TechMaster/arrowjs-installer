var socket_services = {};
var child_process = require('child_process');

socket_services.startRedis = function (socket) {
    child_process.exec('./shell_scripts/redis/toggle_active.sh ' + _redisPath + ' start', function (err, stdout, stderr) {
        console.log('callback for start');

        if (err) {
            //socket.emit('start_redis_end', 'ERROR: ' + err);
            return 'err';
        } else {
            return 'success';
            //socket.emit('start_redis_end', 'success');
        }
    });
};

socket_services.stopRedis = function (socket) {
    child_process.exec('./shell_scripts/redis/toggle_active.sh ' + _redisPath + ' stop', function (err, stdout, stderr) {
        console.log('callback for stop');

        if (err) {
            //socket.emit('stop_redis_end', 'ERROR: ' + err);
            return 'stop err';
        } else {
            //socket.emit('stop_redis_end', 'success');
            return 'stop success';
        }
    });
};

module.exports = socket_services;

