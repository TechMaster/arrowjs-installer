var express = require('express');
var path = require('path');
var favicon = require('serve-favicon');
var logger = require('morgan');
var cookieParser = require('cookie-parser');
var bodyParser = require('body-parser');
var nunjucks = require('nunjucks');
var child_process = require('child_process');

var index = require('./routes/index');
var postgres = require('./routes/postgres');

var app = express();

// Get OS ID
//global._osId = null;
//child_process.exec('./shell_scripts/get_os_id.sh', function (err, stdout, stderr) {
//    if (stdout) {
//        console.log(stdout);
//        global._osId = stdout;
//    }
//});

// Get OS Architecture
global._osArchitecture = '32';
child_process.exec('uname -m | grep 64', function (err, stdout, stderr) {
    if (stdout) {
        global._osArchitecture = '64';
    }
});

// Global variables
global._installingPostgres = false;
global._installingRedis = false;
global._installingNginx = false;
global._installingPm2 = false;
global._redisPath = '~/redis-3.0.1';    // Reference to install_redis.sh

// View engine setup
app.set('view engine', 'html');
nunjucks.configure('views', {
    autoescape: true,
    express: app
});

// uncomment after placing your favicon in /public
//app.use(favicon(__dirname + '/public/favicon.ico'));
app.use(logger('dev'));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({extended: false}));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

app.use('/', index);
app.use('/postgres', postgres);

// Catch 404 and forward to error handler
app.use(function (req, res, next) {
    var err = new Error('Not Found');
    err.status = 404;
    next(err);
});

// Development error handler, will print stacktrace
if (app.get('env') === 'development') {
    app.use(function (err, req, res, next) {
        res.status(err.status || 500);
        res.render('error', {
            message: err.message,
            error: err
        });
    });
}

// Production error handler, no stacktraces leaked to user
app.use(function (err, req, res, next) {
    res.status(err.status || 500);
    res.render('error', {
        message: err.message,
        error: {}
    });
});

module.exports = app;
