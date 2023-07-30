# Flyway Demo

[Flyway](https://documentation.red-gate.com/fd) is an industry leading database versioning framework that aims to unlock DevOps for the database. It strongly favors simplicity and convention over configuration.

For this demo to run, you should run all commands through a **MS DOS Command Window** or **Windows Powershell**

## Prerequisites

### Install Flyway

Download [Flyway](https://flywaydb.org/documentation/usage/commandline/#download-and-installation) for your target operating system and unzip the files to a directory of your choosing.

#### flyway.conf

In the installation directory there is a flyway.conf file that has all the possible configuration options.  This demo uses a custom configuration file located at `./conf/flyway_sqllite.conf` to connect to the SQLite database.

This file stores your connection string, user_id and password to connect to the database.  You may need to make changes here.

## Running Flyway

This demo has a Windows command file `run_flyway.cmd` that does some of the heavy lifting for you.  You will need to review this file and change the `FLYWAY_HOME` to the location of where you unzip Flyway.

```
set FLYWAY_HOME=I:\desktop-setup\test\DevTools\flyway-9.4.0
```

NOTE: For this demo to run, you should run all commands through a **MS DOS Command Window** or **Windows Powershell**

There are a few commands that we'll run in this demo.

| Command | Description |
| ------- | ----------- |
| baseline | Baselines an existing database |
| info | Prints the details and status information about all the migrations. |
| migrate | Migrates the schema to the latest version. Flyway will create the schema history table automatically if it doesn’t exist. Open a DOS Command Window or Windows Powershell and invoke the following command to test your connection.
| clean | Drops all objects (tables, views, procedures, triggers, …) in the configured schemas.<br>The schemas are cleaned in the order specified by the schemas and defaultSchema property. |

First run flyway with `baseline` to create the flyway history table

```
> run_flyway.cmd baseline
A new version of Flyway is available
Upgrade to Flyway 9.21.1: https://rd.gt/2X0gakb
Flyway Community Edition 9.4.0 by Redgate
See what's new here: https://flywaydb.org/documentation/learnmore/releaseNotes#9.4.0

Database: jdbc:sqlite:flyway-demo.db (SQLite 3.34)
Creating Schema History table "main"."flyway_schema_history" with baseline ...
Successfully baselined schema with version: 1
```

Using your favorite SQL Client, You can now see that a flyway_schema_history table has been created and our baseline is in there.  
Our database is now at version 1

![](assets/baseline.png)

Now run an `info` to see what we will migrate.

```
> run_flyway.cmd info
A new version of Flyway is available
Upgrade to Flyway 9.21.1: https://rd.gt/2X0gakb
Flyway Community Edition 9.4.0 by Redgate
See what's new here: https://flywaydb.org/documentation/learnmore/releaseNotes#9.4.0

Database: jdbc:sqlite:flyway-demo.db (SQLite 3.34)
Schema version: 1

+-----------+---------+-----------------------+----------+---------------------+--------------------+
| Category  | Version | Description           | Type     | Installed On        | State              |
+-----------+---------+-----------------------+----------+---------------------+--------------------+
|           | 1       | << Flyway Baseline >> | BASELINE | 2023-07-30 12:35:20 | Baseline           |
| Versioned | 1.0     | create schema         | SQL      |                     | Ignored (Baseline) |
| Versioned | 1.1     | create customer table | SQL      |                     | Pending            |
| Versioned | 1.2.1   | insert customer data  | SQL      |                     | Pending            |
+-----------+---------+-----------------------+----------+---------------------+--------------------+
```

This shows what will be migrated when we run `migrate`.

When Flyway runs `migrate` it will take all the SQL files in the `./sql` directory and apply them to the database.

## The SQL

### V1.2__create_customer_table.sql

```
CREATE TABLE customer (
    id int NOT NULL,
    first_name  varchar(35) NOT NULL,
    last_name   varchar(35) NOT NULL,
    city        varchar(50),
    state       varchar(2),
    zip         INT,
    PRIMARY KEY (id)
);
```

### V1.1.2__insert_customer_data.sql

```
INSERT INTO customer (id, first_name, last_name, city, state, zip) 
    VALUES (1, 'Joe', 'Smith', 'Nowhere', 'MO', 12345);
INSERT INTO customer (id, first_name, last_name, city, state, zip) 
    VALUES (2, 'Jane', 'Doe', 'Tightwad', 'MO', 54321);

```

Now run migrate

```
> run_flyway.cmd migrate
A new version of Flyway is available
Upgrade to Flyway 9.21.1: https://rd.gt/2X0gakb
Flyway Community Edition 9.4.0 by Redgate
See what's new here: https://flywaydb.org/documentation/learnmore/releaseNotes#9.4.0

Database: jdbc:sqlite:flyway-demo.db (SQLite 3.34)
Successfully validated 4 migrations (execution time 00:00.043s)
Current version of schema "main": 1
Migrating schema "main" to version "1.1 - create customer table"
Migrating schema "main" to version "1.2.1 - insert customer data"
Successfully applied 2 migrations to schema "main", now at version v1.2.1 (execution time 00:00.077s)
```

## Conclusion
So just by adding some versioned files, you can easily create tables and the rows for your database.

If you really want to start clean each time, you can stack the commands like the following.

```
> run_flyway.cmd clean baseline info migrate
```

When all the versioned files have been applied then you can run an `info` to see the version of the database that you are on.

```
> run_flyway.cmd info
+-----------+---------+-----------------------+----------+---------------------+--------------------+
| Category  | Version | Description           | Type     | Installed On        | State              |
+-----------+---------+-----------------------+----------+---------------------+--------------------+
|           | 1       | << Flyway Baseline >> | BASELINE | 2023-07-30 12:35:20 | Baseline           |
| Versioned | 1.1     | create customer table | SQL      | 2023-07-30 12:36:17 | Success            |
| Versioned | 1.2.1   | insert customer data  | SQL      | 2023-07-30 12:36:17 | Success            |
| Versioned | 1.0     | create schema         | SQL      |                     | Ignored (Baseline) |
+-----------+---------+-----------------------+----------+---------------------+--------------------+
```


