CREATE USER nachschreibarbeiten;

CREATE TABLE "mod_nachschreibarbeiten_dates" (
	"id" serial NOT NULL PRIMARY KEY,
	"date" date NOT NULL,
	"time" time without time zone NOT NULL,
	"room" text,
	"teacher_act" text REFERENCES "users" ("act"),
	"created_by_act" text REFERENCES "users" ("act")
);

CREATE TABLE "mod_nachschreibarbeiten_entries" (
	"id" serial NOT NULL PRIMARY KEY,
	"date_id" int NOT NULL REFERENCES "mod_nachschreibarbeiten_dates"("id"),
	"student_act" text NOT NULL REFERENCES "users"("act"),
	"class" text,
	"subject" text,
	"additional_material" text,
	"duration" int,
	"teacher_act" text REFERENCES "users"("act"),
	"created_by_act" text REFERENCES "users"("act")
);

GRANT ALL ON mod_nachschreibarbeiten_dates TO nachschreibarbeiten;
GRANT ALL ON mod_nachschreibarbeiten_entries TO nachschreibarbeiten;
GRANT USAGE, SELECT ON SEQUENCE mod_nachschreibarbeiten_dates_id_seq TO nachschreibarbeiten;
GRANT USAGE, SELECT ON SEQUENCE mod_nachschreibarbeiten_entries_id_seq TO nachschreibarbeiten;
GRANT SELECT, REFERENCES ON users TO nachschreibarbeiten;
GRANT SELECT, REFERENCES ON groups TO nachschreibarbeiten;
GRANT SELECT ON members TO nachschreibarbeiten;
GRANT SELECT ON groups_priv TO nachschreibarbeiten;
GRANT INSERT ON log TO nachschreibarbeiten;
