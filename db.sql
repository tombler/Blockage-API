-- // SCHEMA:
--     // User
--         // id UUID (PK)
--         // email TEXT
--         // name TEXT
--         // password? Auth token?
--     // User_App
--         // user_id (PK)
--         // app_id (PK)
--     // App
--         // id UUID (PK)
--         // name (human-readable, e.g. "Facebook") TEXT
--         // web_url (to check browser, e.g. 'facebook.com') TEXT
--         // android_url (or whatever id/string Android has for indicating app) TEXT
--         // ios_url (or whatever id/string iOS has for indicating app) TEXT
--         // logo (URL to img) TEXT
--     // Session
--         // id UUID (PK)
--         // start TIMESTAMP
--         // end TIMESTAMP
--         // session_time INTERVAL
--         // app_id (FK) UUID
--         // user_id (FK) UUID

-- SAMPLE QUERIES:
--     // Get user
--         // SELECT * FROM user WHERE id = {id};
--     // Get user's apps that are being tracked
--         // SELECT * FROM user U
--         // JOIN user_app UA ON U.id = UA.user_id
--         // JOIN app A ON A.id = UA.app_id
--         // WHERE U.id = {id};
--     // Get sessions for a particular user and app
--         // SELECT * FROM session S
--         // WHERE S.user_id = {user_id} AND S.app_id = {app_id};
--     // Get all sessions for a user
--         // SELECT * FROM session S
--         // WHERE S.user_id = {user_id}
--         // (GROUP BY S.app_id, AGG session_time,start,end in a list)


CREATE DATABASE blockage ENCODING 'UTF8';

-- Postgres 9.1 and newer:
CREATE EXTENSION "uuid-ossp";

CREATE TABLE blockage_user (
    extension_id TEXT PRIMARY KEY
);

CREATE TABLE tracked_app (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v1mc(),
    name TEXT,
    url TEXT,
    extension_id TEXT REFERENCES blockage_user (extension_id)
);

INSERT INTO blockage_user VALUES
('31bc99ffd36ddfcb5d350982c31b4f1f96e45c51293ff622b8e0947b9fee');

INSERT into tracked_app VALUES
('8ed29b3a-32cb-11e7-9656-77fc695c4cff','facebook.com','Facebook','31bc99ffd36ddfcb5d350982c31b4f1f96e45c51293ff622b8e0947b9fee'),
('950f777a-32cb-11e7-9656-ab6f2e19e18e','mail.google.com','Gmail','31bc99ffd36ddfcb5d350982c31b4f1f96e45c51293ff622b8e0947b9fee'),
('9e008e50-32cb-11e7-9656-f399021b0dab','twitter.com','Twitter','31bc99ffd36ddfcb5d350982c31b4f1f96e45c51293ff622b8e0947b9fee');

-- CREATE TABLE blockage_user_app (
--     blockage_user_id UUID,
--     app_id UUID,
--     PRIMARY KEY(blockage_user_id,app_id)
-- );



-- CREATE TABLE session (
--     id UUID PRIMARY KEY DEFAULT uuid_generate_v1mc(),
--     session_start TIMESTAMP,
--     session_end TIMESTAMP,
--     session_time INTERVAL,
--     app_id UUID REFERENCES app (id),
--     blockage_user_id UUID REFERENCES blockage_user (id)
-- );

