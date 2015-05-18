var express = require('express');
var router = express.Router();

var child_process = require('child_process');

/* GET postgres install page. */
router.get('/install', function (req, res) {
    // Check postgres before install
    child_process.exec('which psql', function (err, stdout, stderr) {
        if (err) {
            var result = '';
            var install_process = child_process.spawn('./scripts/' + _osId + '/install_postgresql.sh', [_osArchitecture]);
            install_process.stdout.on('data', function (data) {
                console.log('stdout: ' + data);
                result += data;
            });

            install_process.stderr.on('data', function (data) {
                //console.log('stderr: ' + data);
            });

            install_process.on('close', function (code) {
                console.log('EXIT ' + code);
                res.send(result);
            });
        }

        if (stdout) {
            res.redirect('/');
        }
    });
});

/* GET postgres config page. */
router.get('/config', function (req, res) {
    res.render('postgres');
});

/* POST postgres config page. */
router.post('/config', function (req, res) {
    res.send(req.body);
});

module.exports = router;
