ECHO OFF
set FLYWAY_HOME=I:\desktop-setup\test\DevTools\flyway-10.7.1

@REM This command will allow paramters to be passed such as info or migrate
@REM %FLYWAY_HOME%\flyway.cmd -configFiles="./conf/flyway_sqlite.conf" %1 %2 %3 %4
%FLYWAY_HOME%\flyway.cmd -configFiles="./conf/flyway_sqllite.toml" %1 %2 %3 %4
