var express = require('express');
var crypto = require('crypto');
var child_process = require('child_process');
var fs = require('fs');

var router = express.Router();

function getOsInfo() {
    return new Promise(function (fulfill, reject) {
        child_process.exec('./shell_scripts/os/get_os_info.sh ' + _osId + ' ' + _osVersion, function (err, stdout, stderr) {
            if (err) {
                fulfill(err);
            } else {
                if (stdout) {
                    fulfill(stdout);
                }
            }
        });
    });
}

function getPostgresInfo() {
    return new Promise(function (fulfill, reject) {
        var results = {};

        child_process.exec('./shell_scripts/postgres/check_installed.sh', function (err, stdout, stderr) {
            if (err) {
                fulfill(err);
            } else {
                if (stdout.trim()) {
                    _installedPostgres = true;

                    results = {
                        'info': 'Postgres has been installed \nVersion:' + stdout.trim(),
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
            }
        });
    });
}

function configPgHbaConf(data) {
    return new Promise(function (fulfill, reject) {
        if (data.address == 'all') {
            child_process.exec('./shell_scripts/postgres/config_pg_hba.sh ' + _osId + ' ' + _osVersion, function (err, stdout, stderr) {
                if (err) {
                    reject('ERROR: ' + err);
                } else {
                    fulfill('success');
                }
            });
        } else if (data.address == 'custom') {
            child_process.exec('./shell_scripts/postgres/config_pg_hba.sh ' + _osId + ' ' + _osVersion + ' ' + data.address2, function (err, stdout, stderr) {
                if (err) {
                    reject('ERROR: ' + err);
                } else {
                    fulfill('success');
                }
            });
        } else {
            reject('Missing options');
        }
    });
}

function configPostgresqlConf(data) {
    return new Promise(function (fulfill, reject) {
        if (data.listen_addresses) {
            child_process.exec("./shell_scripts/postgres/config_postgresql.sh " + _osId + " " + _osVersion + " '" + data.listen_addresses + "'", function (err, stdout, stderr) {
                if (err) {
                    reject("ERROR: " + err);
                } else {
                    fulfill('success');
                }
            });
        } else {
            reject('Missing options');
        }
    });
}

function getRedisInfo() {
    return new Promise(function (fulfill, reject) {
        var results = {};

        child_process.exec('./shell_scripts/redis/check_installed.sh', function (err, stdout, stderr) {
            if (err) {
                fulfill(err);
            } else {
                if (stdout.trim()) {
                    _installedRedis = true;

                    results = {
                        'info': 'Redis has been installed \nVersion: ' + stdout.trim(),
                        'need_install': 0
                    };
                    fulfill(results);
                } else {
                    results = {
                        'info': 'Redis has not been installed.',
                        'need_install': 1
                    };
                    fulfill(results);
                }
            }
        });
    });
}

function getNginxInfo() {
    return new Promise(function (fulfill, reject) {
        var results = {};

        child_process.exec('./shell_scripts/nginx/check_installed.sh', function (err, stdout, stderr) {
            if (err) {
                fulfill(err);
            } else {
                if (stdout.trim()) {
                    _installedNginx = true;

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
            }
        });
    });
}

function getPm2Info() {
    return new Promise(function (fulfill, reject) {
        var results = {};

        child_process.exec('./shell_scripts/pm2/check_installed.sh', function (err, stdout, stderr) {
            if (err) {
                fulfill(err);
            } else {
                if (stdout.trim()) {
                    _installedPm2 = true;

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
        getPm2Info()
    ]).then(function (results) {
        return res.render('index', {
            os_info: results[0],
            postgres: results[1],
            redis: results[2],
            nginx: results[3],
            pm2: results[4]
        })
    }).catch(function (error) {
        res.send("Error in checking installation: " + error);
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

/* POST login page */
router.post('/config-postgres', function (req, res) {
    // Check login
    if (!req.session.auth) {
        return res.redirect('/login');
    }

    var data = req.body;

    Promise.all([
        configPgHbaConf(data),
        configPostgresqlConf(data)
    ]).then(function (results) {
        console.log('res', results);
        res.send("success");
    }).catch(function (err) {
        console.log("err", err);
        res.send("ERROR: " + err);
    });
});

module.exports = router;

