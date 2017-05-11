var express = require('express');
var router = express.Router();

var db = require('../queries');

// middleware to use for all requests
router.use(function (req, res, next) {

    // Website you wish to allow to connect
    res.setHeader('Access-Control-Allow-Origin', 'chrome-extension://apagkcgippjgcmepobhiifkpccpfljkf');

    // Request methods you wish to allow
    res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS, PUT, PATCH, DELETE');

    // Request headers you wish to allow
    res.setHeader('Access-Control-Allow-Headers', 'X-Requested-With,content-type');

    // Set to true if you need the website to include cookies in the requests sent
    // to the API (e.g. in case you use sessions)
    res.setHeader('Access-Control-Allow-Credentials', true);

    // Pass to next layer of middleware
    next();
});


router.post('/api/1.0/extension', db.checkIfUserExists);
router.get('/api/1.0/application', db.getApps);
router.post('/api/1.0/application', db.addApp);
router.post('/api/1.0/session', db.saveSession);

module.exports = router;
