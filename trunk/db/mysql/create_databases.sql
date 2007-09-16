create database dokoiku_development default character set utf8;
create database dokoiku_test default character set utf8;
create database dokoiku_production default character set utf8;
grant all on dokoiku_development.* to 'dokoiku_user'@'localhost';
grant all on dokoiku_test.* to 'dokoiku_user'@'localhost';
grant all on dokoiku_production.* to 'dokoiku_user'@'localhost';
create database dokoiku_development_actual default character set utf8;
grant all on dokoiku_development_actual.* to 'dokoiku_user'@'localhost';
