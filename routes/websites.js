var express = require('express');
var crypto = require('crypto');
var child_process = require('child_process');
var fs = require('fs');

var router = express.Router();

/* GET manage websites page */
router.get('/', function (req, res) {
    // Check login
    if (!req.session.auth) {
        return res.redirect('/login');
    }

    res.render('websites');
});

module.exports = router;

