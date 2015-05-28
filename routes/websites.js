var express = require('express');

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

