-- Track 4257
-- Track 4258
-- Track 4259
--
-- test case to make sure that conglomerate metadata is stored/retrieved
-- correctly across database boots.  track 4257-9 all were caused by not
-- storing the metadata correctly after an addColumn call.
-- baseline case for add column test
create table foo (a int);
insert into foo values (1);
insert into foo values (1, 2);
select * from foo;

-- baseline case of simple create/index test
create table foo2 (a int, b int, c int);
create index foo2_idx on foo2 (c);
insert into foo2 values (3, 30, 300);
insert into foo2 values (2, 20, 200);
insert into foo2 values (1, 10, 100);

disconnect;
connect 'wombat;shutdown=true';

connect 'wombat' as conn1;
alter table foo add column b int;
select * from foo;
insert into foo values (2, 1);
select * from foo;

-- just make sure normal case works too.
select * from foo2;
select c from foo2;
select c from foo2;


disconnect;
connect 'wombat;shutdown=true';

connect 'wombat' as conn2;

-- does insert correctly pick up previous alter?
insert into foo values (2, 2);

-- does alter correctly pick up previous alter?
alter table foo add column c int;

-- does select correctly pick up previous alter?
select * from foo;

insert into foo values (3, 1, 1);
select * from foo;

disconnect;
connect 'wombat;shutdown=true';
