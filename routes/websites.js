var express = require('express');
var child_process = require('child_process');
var fs = require('fs');

var router = express.Router();

function getListWebsites() {
    var list_websites = [];

    try {
        var data = fs.readFileSync('websites/list_websites.arrowjs', 'utf8');
        list_websites = JSON.parse(data);
    } catch (error) {
        return "error";
    }

    return list_websites;
}

/* GET manage websites page */
router.get('/', function (req, res) {
    // Check login
    if (!req.session.auth) {
        return res.redirect('/login');
    }

    var list_websites = getListWebsites();
    if (list_websites != 'error') {
        res.locals.list_websites = list_websites;
    }

    res.locals.installedNginx = _installedNginx;

    res.render('websites');
});

/* Ajax POST validate */
router.post('/validate', function (req, res) {
    // Check login
    if (!req.session.auth) {
        return res.redirect('/login');
    }

    var data = req.body;

    var use_nginx = data.use_nginx ? 1 : 0;

    child_process.exec('./shell_scripts/website/validate.sh ' + data.location + ' ' + use_nginx + ' ' + data.file_name, function (err, stdout, stderr) {
        if (err) {
            res.send(err);
        } else {
            res.send('success');
        }
    });
});

/* Ajax POST update website */
router.post('/update', function (req, res) {
    // Check login
    if (!req.session.auth) {
        return res.redirect('/login');
    }

    var data = req.body;
    var list_websites = getListWebsites();
    if (list_websites != 'error') {
        delete data.database_user;
        delete data.password;
        list_websites.push(data);
        var str_content = JSON.stringify(list_websites, null, 4);

        try {
            fs.writeFileSync('websites/list_websites.arrowjs', str_content, 'utf8');
            res.send('success');
        } catch (error) {
            res.send('ERROR: Cannot save website information');
        }

    } else {
        res.send('ERROR: Cannot read website information');
    }
});

/* Ajax POST config nginx */
router.post('/nginx', function (req, res) {
    // Check login
    if (!req.session.auth) {
        return res.redirect('/login');
    }

    var data = req.body;

    child_process.exec('./shell_scripts/nginx/config_nginx.sh ' + _osId + ' ' + _osVersion + ' ' + data.file_name + ' ' + data.server_name + ' ' + data.website_listen_port + ' ' + data.root_path + ' ' + data.upstream, function (err, stdout, stderr) {
        if (err) {
            res.send("ERROR: " + err);
        } else {
            if (stdout.trim() == 'exists') {
                res.send('exists');
            } else {
                res.send('success');
            }
        }
    });
});

module.exports = router;

