var socket_install = {};
var child_process = require('child_process');

socket_install.postgres = function (socket) {
    var install_process = child_process.spawn('./shell_scripts/postgres/install_postgres.sh', [_osname, _osversion]);

    install_process.stdout.on('data', function (data) {
        socket.emit('install_postgres_process', data.toString());
    });

    install_process.stderr.on('data', function (data) {
        socket.emit('install_postgres_process', data.toString());
    });

    install_process.on('close', function (code) {
        socket.emit('install_postgres_completed', code);
        _installingPostgres = false;
    });
};

socket_install.redis = function (socket) {
    var install_process = child_process.spawn('./shell_scripts/redis/install_redis.sh');

    install_process.stdout.on('data', function (data) {
        socket.emit('install_redis_process', data.toString());
    });

    install_process.stderr.on('data', function (data) {
        socket.emit('install_redis_process', data.toString());
    });

    install_process.on('close', function (code) {
        socket.emit('install_redis_completed', code);
        _installingRedis = false;
    });
};

socket_install.nginx = function (socket) {
    var install_process = child_process.spawn('./shell_scripts/nginx/install_nginx.sh');

    install_process.stdout.on('data', function (data) {
        socket.emit('install_nginx_process', data.toString());

    });

    install_process.stderr.on('data', function (data) {
        socket.emit('install_nginx_process', data.toString());
    });

    install_process.on('close', function (code) {
        socket.emit('install_nginx_completed', code);
        _installingNginx = false;
    });
};

socket_install.pm2 = function (socket) {
    var install_process = child_process.spawn('./shell_scripts/pm2/install_pm2.sh');

    install_process.stdout.on('data', function (data) {
        socket.emit('install_pm2_process', data.toString());
    });

    install_process.stderr.on('data', function (data) {
        socket.emit('install_pm2_process', data.toString());
    });

    install_process.on('close', function (code) {
        socket.emit('install_pm2_completed', code);
        _installingPm2 = false;
    });
};

module.exports = socket_install;

