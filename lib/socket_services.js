var socket_services = {};
var child_process = require('child_process');

socket_services.startRedis = function (socket) {
    child_process.exec(_redisPath + '/src/redis-server > /dev/null &', function (err, stdout, stderr) {
        console.log('err:' + err, 'stdout:' + stdout, 'stderr:' + stderr);
    });
};

socket_services.stopRedis = function (socket) {
    child_process.exec(_redisPath + '/src/redis-cli shutdown', function (err, stdout, stderr) {
        console.log('err:' + err, 'stdout:' + stdout, 'stderr:' + stderr);
    });
};

module.exports = socket_services;

