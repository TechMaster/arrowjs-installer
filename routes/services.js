var express = require('express');
var child_process = require('child_process');

var router = express.Router();

function checkPostgresActive() {
    return new Promise(function (fulfill, reject) {
        child_process.exec('./shell_scripts/postgres/check_active.sh ' + _osId + ' ' + _osVersion, function (err, stdout, stderr) {
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

function checkNginxActive() {
    return new Promise(function (fulfill, reject) {
        child_process.exec('./shell_scripts/nginx/check_active.sh ' + _osId + ' ' + _osVersion, function (err, stdout, stderr) {
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

/* GET services page */
router.get('/', function (req, res) {
    // Check login
    if (!req.session.auth) {
        return res.redirect('/login');
    }

    Promise.all([
        checkPostgresActive(),
        checkRedisActive(),
        checkNginxActive()
    ]).then(function (results) {
        res.locals.installedPostgres = _installedPostgres;
        res.locals.installedRedis = _installedRedis;
        res.locals.installedNginx = _installedNginx;
        res.locals.installedPm2 = _installedPm2;

        return res.render('services', {
            postgres_active: results[0],
            redis_active: results[1],
            nginx_active: results[2]
        })
    }).catch(function (err) {
        return res.send(err);
    });
});

module.exports = router;