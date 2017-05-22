# wraps all commands in .sql file in BEGIN <> COMMIT
psql -U 'tom' -d 'blockage' -f ./db.sql --single-transaction