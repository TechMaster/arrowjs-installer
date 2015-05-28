var express = require('express');
var path = require('path');
var favicon = require('serve-favicon');
var logger = require('morgan');
var cookieParser = require('cookie-parser');
var session = require('express-session');
var bodyParser = require('body-parser');
var nunjucks = require('nunjucks');
var child_process = require('child_process');

var index = require('./routes/index');
var websites = require('./routes/websites');
var services = require('./routes/services');
var nginx = require('./routes/nginx');

var app = express();

// Global variables
global._osId = child_process.execSync('./shell_scripts/os/get_os_id.sh').toString().split('-')[0];
global._osVersion = child_process.execSync('./shell_scripts/os/get_os_id.sh').toString().split('-')[1];
global._ipAddress = child_process.execSync('./shell_scripts/os/get_ip_address.sh ' + _osId + ' ' + _osVersion).toString();
global._installingPostgres = false;
global._installingRedis = false;
global._installingNginx = false;
global._installingPm2 = false;
global._installedPostgres = false;
global._installedRedis = false;
global._installedNginx = false;
global._installedPm2 = false;
global._creatingWebsite = false;

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
app.use(session({
    secret: 'freeskyteamdottechmasterdotvn',
    resave: false,
    saveUninitialized: true
}));
app.use(express.static(path.join(__dirname, 'public')));

app.use('/', index);
app.use('/websites', websites);
app.use('/services', services);
app.use('/nginx', nginx);

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
