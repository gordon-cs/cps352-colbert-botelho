connect to project;
/*
 * file: createdb.sql
 *
 * Originally written by Russell C. Bjork
 * Modified for CS352 Project by: Jake Colbert and Eddy Botelho (team 6)
 *
 */

create variable today date;
-- Bjork left comment about the fine rate. Does it evaluate properly? $5 or $0.05
create variable fine_daily_rate_in_cents integer default 5;

create table Category(
	category_name char(10) PRIMARY KEY NOT NULL,
	checkout_period integer NOT NULL,
	max_books_out integer NOT NULL
);

create table Borrower(
	borrower_id char(10) PRIMARY KEY NOT NULL,
	last_name char(20) NOT NULL,
	first_name char(20) NOT NULL,
	category_name char(10) NOT NULL,
    CONSTRAINT FK_Borrower_Category FOREIGN KEY (category_name)
    	REFERENCES Category(category_name) ON DELETE CASCADE
);

create table Book_info(
	call_number char(20) PRIMARY KEY NOT NULL,
	title char(50) NOT NULL,
	format char(2) NOT NULL,
	CONSTRAINT format_type CHECK (format IN ('HC', 'SC', 'CD', 'MF', 'PE'))
);

create table Book(
	call_number char(20) NOT NULL,
	copy_number smallint NOT NULL,
	bar_code integer
		generated always as identity (start with 1),
    CONSTRAINT PK_Book PRIMARY KEY (call_number, copy_number),
    CONSTRAINT FK_Book_Book_info FOREIGN KEY (call_number)
    	REFERENCES Book_info(call_number) ON DELETE CASCADE
);

create table Borrower_phone(
    borrower_id char(10) NOT NULL,
    phone char(20) NOT NULL,
    CONSTRAINT FK_Borrower_phone_Borrower FOREIGN KEY (borrower_id)
    	REFERENCES Borrower(borrower_id) ON DELETE CASCADE
);

create table Book_author(
	call_number char(20) NOT NULL,
	author_name char(20) NOT NULL,
    -- composite key better implemented by assigning call_number as unique?
    CONSTRAINT CK_Book_author PRIMARY KEY (call_number, author_name),
    CONSTRAINT FK_Book_author_Book_info FOREIGN KEY (call_number)
    	REFERENCES Book_info(call_number) ON DELETE CASCADE
);

create table Book_keyword(
    call_number char(20) NOT NULL,
    keyword varchar(20) NOT NULL,
    CONSTRAINT CK_Book_keyword PRIMARY KEY (call_number, keyword),
    CONSTRAINT FK_Book_keyword_Book_info FOREIGN KEY (call_number)
    	REFERENCES Book_info(call_number) ON DELETE CASCADE
);

create table Checked_out(
	call_number char(20) NOT NULL,
	copy_number smallint NOT NULL,
	borrower_id char(10) NOT NULL,
	date_due date NOT NULL,
    CONSTRAINT CK_Checked_out PRIMARY KEY (call_number, copy_number),
    CONSTRAINT FK_Checked_out_Book FOREIGN KEY (call_number, copy_number)
    	REFERENCES Book(call_number, copy_number) ON DELETE CASCADE,
    CONSTRAINT FK_Checked_out_Borrower FOREIGN KEY (borrower_id)
    	REFERENCES Borrower(borrower_id)
);

create table Fine(
	borrower_id char(10) NOT NULL,
	title char(50) NOT NULL,
	date_due date NOT NULL,
	date_returned date NOT NULL,
	amount numeric(10,2) NOT NULL,
    CONSTRAINT CK_Fine PRIMARY KEY (borrower_id, title, date_due),
    CONSTRAINT FK_Fine_Borrower FOREIGN KEY (borrower_id)
    	REFERENCES Borrower(borrower_id) ON DELETE CASCADE
);

-- This trigger will delete all other information on book if last
-- copy is deleted

create trigger last_book_trigger
	after delete on Book
	referencing old as o
	for each row
	when ((select count(*)
			from book
			where call_number = o.call_number)
		= 0)
		delete from Book_info
			where call_number = o.call_number;

-- This trigger will prevent an attempt to renew a book that is overdue

create trigger cant_renew_overdue_trigger
	before update on Checked_out
	referencing old as o
	for each row
	when (o.date_due < today)
		 signal sqlstate '70000'
		 set message_text = 'CANT_RENEW_OVERDUE';

-- Code needed to create other triggers should be added here

-- This trigger will prevent an attempt to checkout a book if the borrower
--    already has the maximum number of books checked out
create trigger book_limit_reached_trigger
	before insert on Checked_out
	referencing new as n
	for each row
	when ((SELECT count(*)
		   FROM Checked_out
		   WHERE borrower_id = n.borrower_id)
		   >=               --books out greater than or equal to max_books_out
		   (SELECT max_books_out
	       FROM Borrower join Category
		   ON Borrower.category_name = Category.category_name
		   WHERE borrower_id = n.borrower_id))
		signal sqlstate '79999'
		set message_text = 'MAX_BOOKS_ALREADY_OUT';


-- This trigger will execute after an entry is removed from the Checked_out
--    table (aka book has been returned). The trigger checks if book is
--	  overdue. If so, a fine is inserted into the fines table.
create trigger assess_fine_trigger
    after delete on Checked_out
	referencing old as o
	for each row
	when (o.date_due < today)
        INSERT INTO Fine(borrower_id, title, date_due, date_returned, amount)
        values (o.borrower_id,
		(SELECT title
		 FROM Book_info b
		 WHERE o.call_number = b.call_number),
        o.date_due, today,
        ((fine_daily_rate_in_cents * 0.01 * (days(today) - days(o.date_due)))));