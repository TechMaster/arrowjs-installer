var express = require('express');
var router = express.Router();

var child_process = require('child_process');

function getOsInfo() {
    return new Promise(function (fulfill, reject) {
        child_process.exec('./shell_scripts/os/get_os_info.sh', function (err, stdout, stderr) {
            if (err) {
                reject(err);
            }

            if (stdout) {
                fulfill(stdout + 'Architecture: ' + _osArchitecture + 'bit');
            }
        });
    });
}

function getPostgresInfo() {
    return new Promise(function (fulfill, reject) {
        var results = {};

        child_process.exec('which psql', function (err, stdout, stderr) {
            if (err) {
                results = {
                    'info': 'Postgres has not been installed.',
                    'need_install': 1
                };
                fulfill(results);
            }

            if (stdout) {
                child_process.exec('psql --version', function (err, stdout, stderr) {
                    if (err) {
                        reject(err);
                    }

                    if (stdout) {
                        results = {
                            'info': 'Postgres has been installed \n' + stdout,
                            'need_install': 0
                        };
                        fulfill(results);
                    }
                });
            }
        });
    });
}

function getRedisInfo() {
    return new Promise(function (fulfill, reject) {
        var results = {};

        child_process.exec('./shell_scripts/redis/check_redis.sh', function (err, stdout, stderr) {
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

function getRedisStatus() {
    return new Promise(function (fulfill, reject) {
        child_process.exec(_redisPath + '/src/redis-cli ping', function (err, stdout, stderr) {
            if(stdout == "PONG"){
                fulfill(1)
            }else{
                fulfill(0)
            }
        });
    });
}

function getNginxInfo() {
    return new Promise(function (fulfill, reject) {
        var results = {};

        child_process.exec('which nginx', function (err, stdout, stderr) {
            if (err) {
                results = {
                    'info': 'Nginx has not been installed.',
                    'need_install': 1
                };
                fulfill(results);
            }

            if (stdout) {
                child_process.exec('nginx -v', function (err, stdout, stderr) {
                    if (err) {
                        reject(err);
                    }

                    if (stderr) {
                        results = {
                            'info': 'Nginx has been installed \n' + stderr,
                            'need_install': 0
                        };
                        fulfill(results);
                    }
                });
            }
        });
    });
}

function getPm2Info() {
    return new Promise(function (fulfill, reject) {
        var results = {};

        child_process.exec('npm list -g | grep pm2@', function (err, stdout, stderr) {
            if (err) {
                results = {
                    'info': 'PM2 has not been installed.',
                    'need_install': 1
                };
                fulfill(results);
            }

            if (stdout) {
                var version = stdout.trim().split('@')[1];
                results = {
                    'info': 'PM2 has been installed \nVersion: ' + version,
                    'need_install': 0
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
        getRedisStatus()
    ]).then(function (results) {
        res.render('index', {
            os_info: results[0],
            postgres: results[1],
            redis: results[2],
            nginx: results[3],
            pm2: results[4],
            redis_status: results[5]
        })
    }).catch(function (err) {
        res.send(err);
    });
});

module.exports = router;

