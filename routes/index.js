var express = require('express');
var router = express.Router();

var db = require('../queries');

//USERS
// get single user
router.get('/api/1.0/user/:id', db.getUser);
//add user
router.post('/api/1.0/user', db.createUser);

//APPS
// Get all apps
router.get('/api/1.0/app', db.getAllApps);
// Get single app
router.get('/api/1.0/app/:id', db.getSingleApp);
// Create a new app
router.post('/api/1.0/app', db.createApp);
// Remove an app
router.post('/api/1.0/app/:id/delete', db.removeApp);

// // USERs and APPs
//get all tracked apps for a user
router.get('/api/1.0/user/:id/app', db.getUserApps);
// //get single tracked app for a user
// router.get('/api/1.0/user/:id/app/:id', FUNCTION);
// Add an existing tracked app for a user
router.post('/api/1.0/user/:blockage_user_id/app/:app_id', db.userAddApp);
// // Delete an existing tracked app for a user
// router.post('/api/1.0/user/:id/app/:id/delete', FUNCTION);

// // SESSIONs
// // Get single session - will this ever be necessary?
// router.get('/api/1.0/session/:id', FUNCTION);
// Create a new session - is this RESTful?
router.post('/api/1.0/session', db.storeSession);
// // Get all sessions for an app
// router.get('/api/1.0/session/app/:id', FUNCTION);
// // Get all sessions for a user
// router.get('/api/1.0/session/user/:id', FUNCTION);
// // Get all sessions for user + app
// router.get('/api/1.0/session/user/:blockage_user_id/app/:app_id', FUNCTION);



module.exports = router;
