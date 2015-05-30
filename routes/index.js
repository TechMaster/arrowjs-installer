var express = require('express');
var crypto = require('crypto');
var child_process = require('child_process');
var fs = require('fs');
var os = require('os');

var router = express.Router();

function getOsInfo() {
    return new Promise(function (fulfill, reject) {
        child_process.exec('./shell_scripts/os/get_os_info.sh ' + _osId + ' ' + _osVersion, function (err, stdout, stderr) {
            if (err) {
                fulfill(err);
            } else {
                if (stdout) {
                    try {
                        var os_info = JSON.parse(stdout);
                        os_info.totalmem = Math.round(os.totalmem() / 1048576);
                        os_info.freemem = Math.round(os.freemem() / 1048576);
                        os_info.os_core = os.cpus().length;
                        fulfill(os_info);
                    } catch (error) {
                        fulfill(error);
                    }
                }
            }
        });
    });
}

function getNodeInfo() {
    return new Promise(function (fulfill, reject) {
        child_process.exec('./shell_scripts/os/get_node_info.sh', function (err, stdout, stderr) {
            if (err) {
                fulfill(err);
            } else {
                if (stdout) {
                    try {
                        var node_info = JSON.parse(stdout);
                        fulfill(node_info);
                    } catch (error) {
                        fulfill(error);
                    }
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
                        'info': 'Postgres has been installed \nVersion: ' + stdout.trim(),
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
        if (data.password == '') {
            reject('Missing options');
        }

        if (data.address == 'all') {
            child_process.exec('./shell_scripts/postgres/config_pg_hba.sh ' + _osId + ' ' + _osVersion + ' ' + data.password, function (err, stdout, stderr) {
                if (err) {
                    reject('ERROR: ' + err);
                } else {
                    fulfill('success');
                }
            });
        } else if (data.address == 'custom') {
            child_process.exec('./shell_scripts/postgres/config_pg_hba.sh ' + _osId + ' ' + _osVersion + ' ' + data.password + ' ' + data.address2, function (err, stdout, stderr) {
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

function getPostgresConfigPath() {
    return new Promise(function (fulfill, reject) {
        child_process.exec('./shell_scripts/postgres/get_config_path.sh ' + _osId + ' ' + _osVersion, function (err, stdout, stderr) {
            if (err) {
                fulfill(err);
            } else {
                if (stdout) {
                    fulfill(stdout.match(/\S+/g));
                } else {
                    fulfill([0, 0]);
                }
            }
        });
    });
}

function getPostgresConfigHbaContent() {
    return new Promise(function (fulfill, reject) {
        child_process.exec('./shell_scripts/postgres/get_config_content.sh ' + _osId + ' ' + _osVersion + ' 1', function (err, stdout, stderr) {
            if (err) {
                fulfill(err);
            } else {
                if (stdout) {
                    fulfill(stdout);
                } else {
                    fulfill("Cannot find config file pg_hba.conf");
                }
            }
        });
    });
}

function getPostgresConfigPgContent() {
    return new Promise(function (fulfill, reject) {
        child_process.exec('./shell_scripts/postgres/get_config_content.sh ' + _osId + ' ' + _osVersion + ' 2', function (err, stdout, stderr) {
            if (err) {
                fulfill(err);
            } else {
                if (stdout) {
                    fulfill(stdout);
                } else {
                    fulfill("Cannot find config file postgresql.conf");
                }
            }
        });
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

function getRedisConfigPath() {
    return new Promise(function (fulfill, reject) {
        child_process.exec('./shell_scripts/redis/get_config_path.sh ' + _osId + ' ' + _osVersion, function (err, stdout, stderr) {
            if (err) {
                fulfill(err);
            } else {
                if (stdout) {
                    fulfill(stdout.trim());
                } else {
                    fulfill(0);
                }
            }
        });
    });
}

function getRedisConfigContent() {
    return new Promise(function (fulfill, reject) {
        child_process.exec('./shell_scripts/redis/get_config_content.sh ' + _osId + ' ' + _osVersion, function (err, stdout, stderr) {
            if (err) {
                fulfill(err);
            } else {
                if (stdout) {
                    fulfill(stdout);
                } else {
                    fulfill("Cannot find config file redis.conf");
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

function getNginxConfigPath() {
    return new Promise(function (fulfill, reject) {
        child_process.exec('./shell_scripts/nginx/get_config_path.sh ' + _osId + ' ' + _osVersion, function (err, stdout, stderr) {
            if (err) {
                fulfill(err);
            } else {
                if (stdout) {
                    fulfill(stdout.trim());
                } else {
                    fulfill(0);
                }
            }
        });
    });
}

function getNginxConfigContent() {
    return new Promise(function (fulfill, reject) {
        child_process.exec('./shell_scripts/nginx/get_config_content.sh ' + _osId + ' ' + _osVersion, function (err, stdout, stderr) {
            if (err) {
                fulfill(err);
            } else {
                if (stdout) {
                    fulfill(stdout);
                } else {
                    fulfill("Cannot find config file nginx.conf");
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
                        'info': 'PM2 has been installed \nVersion: ' + stdout,
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
        getNodeInfo(),
        getPostgresInfo(),
        getPostgresConfigPath(),
        getPostgresConfigHbaContent(),
        getPostgresConfigPgContent(),
        getRedisInfo(),
        getRedisConfigPath(),
        getRedisConfigContent(),
        getNginxInfo(),
        getNginxConfigPath(),
        getNginxConfigContent(),
        getPm2Info()
    ]).then(function (results) {
        return res.render('index', {
            os_info: results[0],
            node_info: results[1],
            postgres: results[2],
            postgres_config_path: results[3],
            postgres_config_hba: results[4],
            postgres_config_pg: results[5],
            redis: results[6],
            redis_config_path: results[7],
            redis_config_content: results[8],
            nginx: results[9],
            nginx_config_path: results[10],
            nginx_config_content: results[11],
            pm2: results[12]
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
        init_password = fs.readFileSync('init_password.arrowjs').toString().trim();
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

/* Ajax POST config postgres */
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
        res.send("success");
    }).catch(function (err) {
        res.send("ERROR: " + err);
    });
});

module.exports = router;

