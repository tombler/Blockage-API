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
    in_session BOOLEAN
);

CREATE TABLE session (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v1mc(),
    start TIMESTAMP WITH TIME ZONE,
    stop TIMESTAMP WITH TIME ZONE,
    duration INTERVAL,
    application_id UUID REFERENCES application (id),
    extension_id TEXT REFERENCES extension (id)
);

-- INSERT INTO extension VALUES
-- ('31bc99ffd36ddfcb5d350982c31b4f1f96e45c51293ff622b8e0947b9fee');

-- INSERT into application VALUES
-- ('8ed29b3a-32cb-11e7-9656-77fc695c4cff','facebook.com','Facebook','31bc99ffd36ddfcb5d350982c31b4f1f96e45c51293ff622b8e0947b9fee'),
-- ('950f777a-32cb-11e7-9656-ab6f2e19e18e','mail.google.com','Gmail','31bc99ffd36ddfcb5d350982c31b4f1f96e45c51293ff622b8e0947b9fee'),
-- ('9e008e50-32cb-11e7-9656-f399021b0dab','twitter.com','Twitter','31bc99ffd36ddfcb5d350982c31b4f1f96e45c51293ff622b8e0947b9fee');
