var express = require('express');
var crypto = require('crypto');
var child_process = require('child_process');
var fs = require('fs');

var router = express.Router();

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

            if (stdout.trim()) {
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
        child_process.exec('./shell_scripts/postgres/check_active.sh ' + _osname + ' ' + _osversion, function (err, stdout, stderr) {
            if (err) {
                reject(err);
            }

            if (stdout.trim()) {
                fulfill(1);
            } else {
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

            if (stdout.trim()) {
                var version = stderr.trim().split('/');

                results = {
                    'info': 'Nginx has been installed \nVersion: ' + version[1],
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
        child_process.exec('./shell_scripts/nginx/check_active.sh ' + _osname + ' ' + _osversion, function (err, stdout, stderr) {
            console.log('-------------', 'ERR: ' + err, 'STDOUT: ' + stdout, 'STDERR: ' + stderr);
            if (err) {
                reject(err);
            }

            if (stdout.trim()) {
                fulfill(1);
            } else {
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

            if (stdout.trim()) {
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
    // Check login
    if (!req.session.auth) {
        return res.redirect('/login');
    }

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
        return res.render('index', {
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
        return res.send(err);
    });
});

/* GET login page */
router.get('/login', function (req, res) {
    res.render('login');
});

/* POST login page */
router.post('/login', function (req, res) {
    var hash_password = crypto.createHash('md5').update(req.body.password).digest('hex');
    var init_password = "";

    try {
        init_password = fs.readFileSync('init_password').toString().trim();
    } catch (e) {
        res.locals.msg = '<div class="alert-warning">Cannot get Init password</div>';
        return res.render('login');
    }

    if (hash_password && hash_password == init_password) {
        req.session.auth = true;
        return res.redirect('/');
    } else {
        res.locals.msg = '<div class="alert-warning">Wrong password</div>';
        return res.render('login');
    }
});

module.exports = router;

