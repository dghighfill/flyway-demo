ECHO OFF
set FLYWAY_HOME=<INSERT_YOUR_FLYWAY_PATH_HERE>\flyway-10.7.1

@REM This command will allow paramters to be passed such as info or migrate
%FLYWAY_HOME%\flyway.cmd -configFiles="./conf/flyway_sqllite.toml" %1 %2 %3 %4