connect to project;

/*
 * file: dropdb.sql
 *
 * Originally written by Russell C. Bjork
 * Modified for CS352 Project by: Jake Colbert and Eddy Botelho (team 6)
 *
 */

drop trigger last_book_trigger;
drop trigger cant_renew_overdue_trigger;
drop trigger book_limit_reached_trigger;

-- Code to drop other triggers needs to be added here.

-- Note that tables must be dropped in the reverse order of creation
-- due to foreign key constraints

drop table category;
drop table borrower;
drop table borrower_phone;
drop table book_info;
drop table book;
drop table book_author;
drop table book_keyword;
drop table checked_out;
drop table fine;

drop variable today;
drop variable fine_daily_rate_in_cents;
