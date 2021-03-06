-- CREATE DATABASE blockage ENCODING 'UTF8';

-- Postgres 9.1 and newer:
CREATE EXTENSION "uuid-ossp";

CREATE TABLE extension (
    id TEXT PRIMARY KEY
);

CREATE TABLE application (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v1mc(),
    name TEXT,
    url TEXT,
    extension_id TEXT REFERENCES extension (id),
    in_session BOOLEAN DEFAULT FALSE,
    paused BOOLEAN DEFAULT FALSE,
    session_start TIMESTAMP with time zone,
    duration BIGINT,
    check_count INT
);

CREATE TABLE session (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v1mc(),
    start TIMESTAMP WITH TIME ZONE,
    stop TIMESTAMP WITH TIME ZONE,
    duration BIGINT,
    check_count INT,
    application_id UUID REFERENCES application (id),
    extension_id TEXT REFERENCES extension (id)
);

CREATE OR REPLACE VIEW session_daily AS
 SELECT s.application_id,
    a.name AS application_name,
    s.extension_id,
    s.start::date AS date,
    count(s.id) AS num_sessions
   FROM session s
     JOIN application a ON a.id = s.application_id
  WHERE s.start::date > (( SELECT date_trunc('day'::text, now() - '1 mon'::interval) AS date_trunc))
  GROUP BY s.application_id, a.name, s.extension_id, s.start::date
  ORDER BY s.application_id, s.start::date;

CREATE TABLE preset (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v1mc(),
    display_name TEXT,
    base_url TEXT
);

INSERT INTO preset VALUES 
(DEFAULT, 'Facebook', 'facebook.com'),
(DEFAULT, 'Gmail', 'mail.google.com'),
(DEFAULT, 'Twitter', 'twitter.com');

-- INSERT INTO extension VALUES
-- ('31bc99ffd36ddfcb5d350982c31b4f1f96e45c51293ff622b8e0947b9fee');
