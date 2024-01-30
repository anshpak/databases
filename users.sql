create user 'nikita'@'localhost' IDENTIFIED BY '12345';
grant select, update on * . * to 'nikita'@'localhost';

create user 'andrey'@'localhost' IDENTIFIED BY '1111';
grant delete on * . * to 'andrey'@'localhost';

create user 'kirill'@'localhost' IDENTIFIED BY '4444';
grant create user on * . * to 'kirill'@'localhost';

create user 'gene'@'localhost' IDENTIFIED BY '7777';
grant insert on * . * to 'gene'@'localhost';