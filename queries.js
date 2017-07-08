var promise = require('bluebird');

var options = {
  // Initialization Options
  promiseLib: promise,
  error: (error, e) => {
      if (e.cn) {
          // A connection-related error;
          //
          // Connections are reported back with the password hashed,
          // for safe errors logging, without exposing passwords.
          console.log("CN:", e.cn);
          console.log("EVENT:", error.message || error);
      }
  }
};

var pgp = require('pg-promise')(options);
var cn = {
    host: process.env.DB_HOST,
    port: process.env.DB_PORT,
    database: process.env.DB_NAME,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD
};

var db = pgp(cn);

// utility func for getDailySessions
function getDatesOneMonthAgoToToday(format=null,distance='week') {
    var start = new Date();
    switch(distance) {
      case 'month':
        start.setMonth(start.getMonth() - 1);
        break;
      case 'week':
        start.setDate(start.getDate() - 7);
        break;
      // default to one month back
      default:
        start.setMonth(start.getMonth() - 1);
    }
    start.setHours(0,0,0,0);
    var end = new Date();

    between = []
    while (start <= end) {
        between.push(new Date(start));
        start.setDate(start.getDate() + 1);
    }

    // to do: make choosing date format a user-settable feature
    switch(format) {
      case 'MM/dd':
          for (var i = 0; i < between.length; i++) {
            between[i] = (between[i].getMonth()+1)+"/"+between[i].getDate();
          };
          break;
      default:
          return between
    }

    // we shouldn't get here but just in case
    return between
}

function generateEmptyXYData() {
  var datelist = getDatesOneMonthAgoToToday();
  var empty_xy_data = {};
  for (var i = 0; i < datelist.length; i++) {
      empty_xy_data[datelist[i]] = 0;
  };
  return empty_xy_data
}

// add query functions
function checkIfUserExists(req, res, next) {
  db.query('select * from extension where id = ${extension_id}',
    req.body)
  .then(function (data) {
      if (data.length > 0) {
        res.status(200)
          .json({
            status: 'success',
            message: 'checkIfUserExists'
          });
      } else {
        addUser(req, res, next);
      }
    })
    .catch(function (err) {
      return next(err);
    });
  
}

function addUser(req, res, next) {
  db.none('insert into extension(id)' +
    'values(${extension_id})',
  req.body)
  .then(function () {
    res.status(200)
      .json({
        status: 'success',
        message: 'addUser'
      });
  })
  .catch(function (err) {
    return next(err);
  });
}

function getApps(req, res, next) {
  var extension_id = req.query.extension_id;
  db.any("select a.id,a.name,a.url,a.extension_id,a.in_session,a.paused,a.session_start,a.duration,a.check_count," +
    "SUM(CASE WHEN b.start > (SELECT now()::date + interval '0h') THEN 1 ELSE 0 END) as sessions_today from application a " +
    "left join session b on b.extension_id = a.extension_id and b.application_id = a.id " +
    "where a.extension_id = $1 " +
    "group by a.id;",extension_id)
    .then(function (data) {
    res.status(200)
      .json({
        status: 'success',
        data: data,
        message: 'getApps'
      });
  })
  .catch(function (err) {
    return next(err);
  });
}

function addApp(req, res, next) {
  db.none('insert into application(name,url,extension_id)' +
    'values(${name},${url},${extension_id})',
  req.body)
  .then(function () {
    res.status(200)
      .json({
        status: 'success',
        message: 'addApp'
      });
  })
  .catch(function (err) {
    return next(err);
  });
}

function updateApp(req, res, next) {
  db.none('update application ' +
    'set name=${name},url=${url},'+
    'extension_id=${extension_id},'+
    'in_session=${in_session},'+
    'paused=${paused},'+
    'session_start=${session_start},'+
    'duration=${duration},'+
    'check_count=${check_count} '+
    'where id = ${id}',
  req.body)
  .then(function () {
    res.status(200)
      .json({
        status: 'success',
        message: 'updateApp'
      });
  })
  .catch(function (err) {
    return next(err);
  });
}

function saveSession(req, res, next) {
  db.none('insert into session(start,stop,duration,check_count,application_id,extension_id)' +
    'values(${start},${stop},${duration},${check_count},${application_id},${extension_id})',
  req.body)
  .then(function () {
    // res.status(200)
    //   .json({
    //     status: 'success',
    //     message: 'saveSession'
    //   });
    getSessions(req, res, next);
  })
  .catch(function (err) {
    return next(err);
  });
}

// to-do: expand this for multiple query params, e.g. start/end time, certain apps, etc
function getSessions(req, res, next) {
  if (req.query.extension_id) {
    var extension_id = req.query.extension_id;
  } else {
    var extension_id = req.body.extension_id;
  }
  db.any('select * from session where extension_id = $1',extension_id)
    .then(function (data) {
    res.status(200)
      .json({
        status: 'success',
        data: data,
        message: 'getSessions'
      });
  })
  .catch(function (err) {
    return next(err);
  });
}

function getSessionsToday(req,res,next) {
  var extension_id = req.query.extension_id;
  db.any("select a.id,a.name,a.url,a.extension_id,a.in_session," +
    "SUM(CASE WHEN b.start > (SELECT now()::date + interval '0h') THEN 1 ELSE 0 END) as sessions_today from application a " +
    "left join session b on b.extension_id = a.extension_id and b.application_id = a.id " +
    "where a.extension_id = $1 " +
    "group by a.id,a.name,a.url,a.extension_id,a.in_session;",extension_id)
  .then(function (data) {
    res.status(200)
      .json({
        status: 'success',
        data: data,
        message: 'getSessionsToday'
      });
  })
  .catch(function (err) {
    return next(err);
  });
}

function getDailySessions(req,res,next) {
  var extension_id = req.query.extension_id;
  db.any("select *"+
    "from session_daily "+
    "where extension_id = $1",extension_id)
  .then(function (data) {
    // build return obj
    var return_data = {};
    return_data.labels = getDatesOneMonthAgoToToday('MM/dd');

    //build datasets
    var datasets = {};

    for (var i = 0; i < data.length; i++) {
      var row = data[i];
      var row_app_id = row.application_id;
      var row_app_name = row.application_name;
      var row_date = new Date(row.date);
      var row_num_sessions = parseInt(row.num_sessions);

      if (!datasets.hasOwnProperty(row.application_id)) {
        // create empty list of dates for the past month
        datasets[row.application_id] = {data: generateEmptyXYData()}
      }
      //adding app name for readability
      if (!datasets[row.application_id].hasOwnProperty('label')) {
        datasets[row.application_id].label = row_app_name;
      }

      //add data point
      datasets[row_app_id]['data'][row_date] = row_num_sessions;
    };

    return_data.datasets = [];
    for (app_id in datasets) {
      var xy_obj = datasets[app_id]['data'];
      var xy_arr = Object.entries(xy_obj);
      xy_arr = xy_arr.map((item) => ({ x:item[0], y: item[1] }));
      datasets[app_id]['data'] = xy_arr;
      return_data.datasets.push(datasets[app_id]);
    }

    res.status(200)
      .json({
        status: 'success',
        data: return_data,
        message: 'getDailySessions'
      });
  })
  .catch(function (err) {
    return next(err);
  });
}


module.exports = {
  getApps: getApps,
  checkIfUserExists: checkIfUserExists,
  addApp: addApp,
  updateApp:updateApp,
  getSessions: getSessions,
  saveSession: saveSession,
  getSessionsToday: getSessionsToday,
  getDailySessions:getDailySessions
};
