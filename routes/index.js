var express = require('express');
var router = express.Router();

var child_process = require('child_process');

function getOsInfo() {
    return new Promise(function (fulfill, reject) {
        child_process.exec('./shell_scripts/os/get_os_info.sh ' + _osname + ' ' + _osversion, function (err, stdout, stderr) {
            if (err) {
                reject(err);
            }

            if (stdout) {
                fulfill(stdout);
            }
        });
    });
}

function getPostgresInfo() {
    return new Promise(function (fulfill, reject) {
        var results = {};

        child_process.exec('./shell_scripts/postgres/check_installed.sh', function (err, stdout, stderr) {
            if (err) {
                reject(err);
            }

            if (stdout) {
                results = {
                    'info': 'Postgres has been installed \nVersion:' + stdout,
                    'need_install': 0
                };
                fulfill(results);
            } else {
                results = {
                    'info': 'Postgres has not been installed.',
                    'need_install': 1
                };
                fulfill(results);
            }
        });
    });
}

function checkPostgresActive() {
    return new Promise(function (fulfill, reject) {
        child_process.exec('./shell_scripts/postgres/check_active.sh', function (err, stdout, stderr) {
            if(err){
                reject(err);
            }

            if(stdout){
                fulfill(1);
            }else{
                fulfill(0);
            }
        });
    });
}

function getRedisInfo() {
    return new Promise(function (fulfill, reject) {
        var results = {};

        child_process.exec('./shell_scripts/redis/check_installed.sh', function (err, stdout, stderr) {
            if (err) {
                reject(err);
            }

            stdout = stdout.trim();

            if (stdout == "") {
                results = {
                    'info': 'Redis has not been installed.',
                    'need_install': 1
                };
                fulfill(results);
            } else {
                _redisPath = stdout;

                results = {
                    'info': 'Redis has been installed \nVersion: ' + stdout.split('-')[1],
                    'need_install': 0
                };
                fulfill(results);
            }
        });
    });
}

function checkRedisActive() {
    return new Promise(function (fulfill, reject) {
        child_process.exec('./shell_scripts/redis/check_active.sh ' + _redisPath, function (err, stdout, stderr) {
            if (stdout.trim() == "PONG") {
                fulfill(1)
            } else {
                fulfill(0)
            }
        });
    });
}

function getNginxInfo() {
    return new Promise(function (fulfill, reject) {
        var results = {};

        child_process.exec('./shell_scripts/nginx/check_installed.sh', function (err, stdout, stderr) {
            if (err) {
                reject(err);
            }

            if (stdout) {
                results = {
                    'info': 'Nginx has been installed \nVersion:' + stdout,
                    'need_install': 0
                };
                fulfill(results);
            } else {
                results = {
                    'info': 'Nginx has not been installed.',
                    'need_install': 1
                };
                fulfill(results);
            }
        });
    });
}

function checkNginxActive() {
    return new Promise(function (fulfill, reject) {
        child_process.exec('./shell_scripts/nginx/check_active.sh', function (err, stdout, stderr) {
            if(err){
                reject(err);
            }

            if(stdout){
                fulfill(1);
            }else{
                fulfill(0);
            }
        });
    });
}

function getPm2Info() {
    return new Promise(function (fulfill, reject) {
        var results = {};

        child_process.exec('./shell_scripts/pm2/check_installed.sh', function (err, stdout, stderr) {
            if (err) {
                reject(err);
            }

            if (stdout) {
                results = {
                    'info': 'PM2 has been installed \nVersion:' + stdout,
                    'need_install': 0
                };
                fulfill(results);
            } else {
                results = {
                    'info': 'PM2 has not been installed.',
                    'need_install': 1
                };
                fulfill(results);
            }
        });
    });
}

/* GET index page */
router.get('/', function (req, res) {
    // Async call use promise + child_process
    Promise.all([
        getOsInfo(),
        getPostgresInfo(),
        getRedisInfo(),
        getNginxInfo(),
        getPm2Info(),
        checkPostgresActive(),
        checkRedisActive(),
        checkNginxActive()
    ]).then(function (results) {
        res.render('index', {
            os_info: results[0],
            postgres: results[1],
            redis: results[2],
            nginx: results[3],
            pm2: results[4],
            postgres_active: results[5],
            redis_active: results[6],
            nginx_active: results[7]
        })
    }).catch(function (err) {
        res.send(err);
    });
});

module.exports = router;

