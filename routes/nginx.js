var express = require('express');
var router = express.Router();

var child_process = require('child_process');

function config(data) {
    return new Promise(function (fulfill, reject) {
        //todo: validate data
        if (data.file_name && data.server_name && data.listen_port && data.root_path && data.upstream) {
            child_process.exec('./shell_scripts/nginx/config_nginx.sh '
            + data.file_name + ' '
            + data.server_name + ' '
            + data.listen_port + ' '
            + data.root_path + ' '
            + data.upstream, function (err, stdout, stderr) {
                if (err) {
                    reject("ERROR: " + err);
                } else {
                    if(stdout.trim() == 'exists'){
                        reject("ERROR: File already exists");
                    }else{
                        fulfill('success');
                    }
                }
            });
        } else {
            reject('Invalid or missing information');
        }
    });
}

/* GET nginx config page. */
router.get('/', function (req, res) {
    // Check login
    if (!req.session.auth) {
        return res.redirect('/login');
    }

    res.render('nginx');
});

/* POST nginx config page. */
router.post('/', function (req, res) {
    var data = req.body;

    Promise.all([
        config(data)
    ]).then(function (results) {
        res.locals.msg = '<div class="alert-success">Config saved successfully</div>';
        res.render('nginx');
    }).catch(function (err) {
        res.locals.msg = '<div class="alert-warning"><pre>' + err + '</pre></div>';
        res.render('nginx');
    });
});

module.exports = router;
