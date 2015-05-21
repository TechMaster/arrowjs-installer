var express = require('express');
var router = express.Router();

var child_process = require('child_process');

function configPgHbaConf(data) {
    return new Promise(function (fulfill, reject) {
        if (data.address1) {
            child_process.exec('./shell_scripts/postgres/config_pg_hba.sh', function (err, stdout, stderr) {
                if (err) {
                    reject("ERROR: " + err);
                } else {
                    fulfill('success');
                }
            });
        } else if (data.address2) {
            child_process.exec('./shell_scripts/postgres/config_pg_hba.sh ' + data.address2, function (err, stdout, stderr) {
                if (err) {
                    reject("ERROR: " + err);
                } else {
                    fulfill('success');
                }
            });
        }else{
            reject('Missing options');
        }
    });
}

function configPostgresqlConf(data) {
    return new Promise(function (fulfill, reject) {
        if (data.listen_addresses) {
            child_process.exec("./shell_scripts/postgres/config_postgresql.sh '" + data.listen_addresses + "'", function (err, stdout, stderr) {
                if (err) {
                    reject("ERROR: " + err);
                } else {
                    fulfill('success');
                }
            });
        }else{
            reject('Missing options');
        }
    });
}

/* GET postgres config page. */
router.get('/', function (req, res) {
    // Check login
    if (!req.session.auth) {
        return res.redirect('/login');
    }

    res.render('postgres');
});

/* POST postgres config page. */
router.post('/', function (req, res) {
    var data = req.body;

    Promise.all([
        configPgHbaConf(data),
        configPostgresqlConf(data)
    ]).then(function (results) {
        res.locals.msg = '<div class="alert-success">Config saved successfully</div>';
        res.render('postgres');
    }).catch(function (err) {
        res.locals.msg = '<div class="alert-warning">Missing options</div>';
        res.render('postgres');
    });
});

module.exports = router;
