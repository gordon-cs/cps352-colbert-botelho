# cps352-colbert-botelho
Repository for cps352 programming project :)

Notes:

Command to quickly run create file after opening container
db2 -t +p < ./database/cps352-colbert-botelho/createdb.sql

Command to quickly run drop file after opening container
db2 -t +p < ./database/cps352-colbert-botelho/dropdb.sql

Helpful link for triggers:
https://www.ibm.com/docs/en/db2-for-zos/11?topic=statements-create-trigger


Notepad:

Current hard-coded version:
create trigger assess_fine_trigger
    after delete on Checked_out
	referencing old as o
	for each row
	when (o.date_due < today)
        INSERT INTO Fine(borrower_id, title, date_due, date_returned, amount)
		values(o.borrower_id,'hard_wired_title', o.date_due, today,
        ((fine_daily_rate_in_cents * 0.01 * (days(today) - days(o.date_due)))));


Potential solution that still gives error:
create trigger assess_fine_trigger
    after delete on Checked_out
	referencing old as o
	for each row
	when (o.date_due < today)
        INSERT INTO Fine(borrower_id, title, date_due, date_returned, amount)
        values (o.borrower_id,
		(SELECT title
		 FROM Checked_out JOIN Book
		 ON Checked_out.call_number = Book.call_number
		 AND Checked_out.copy_number = Book.copy_number
		 JOIN Book_info
		 ON Book.call_number = Book_info.call_number
		 WHERE Book.call_number = o.call_number
		 AND Book.copy_number = o.copy_number),
        o.date_due, today,
        ((fine_daily_rate_in_cents * 0.01 * (days(today) - days(o.date_due)))));




