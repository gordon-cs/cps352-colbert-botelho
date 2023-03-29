# cps352-colbert-botelho
Repository for cps352 programming project :)


Notes:

Command to quickly run create file after opening container
db2 -t +p < ./database/cps352-colbert-botelho/createdb.sql

Command to quickly run drop file after opening container
db2 -t +p < ./database/cps352-colbert-botelho/dropdb.sql

	when (o.date_due < today)
		(INSERT INTO Fine(borrower_id, title, date_due, date_returned, amount)
		values (o.borrower_id,
			(SELECT title               --this whole query literally just gets
			FROM Checked_out JOIN Book  --                            the title
			ON Checked_out.call_number = Book.call_number
			AND Checked_out.copy_number = Book.copy_number JOIN Book_info
			ON Book.call_number = Book_info.call_number
			WHERE Book_info.call_number = o.call_number),
		o.date_due, today, (5*(today-o.date_due))));



INSERT INTO Fine(borrower_id, title, date_due, date_returned, amount) values (
		o.borrower_id,
		( SELECT title
		FROM Checked_out JOIN Book
		ON Checked_out.call_number = Book.call_number
		AND Checked_out.copy_number = Book.copy_number JOIN Book_info
		ON Book.call_number = Book_info.call_number
		WHERE Book_info.call_number = o.call_number),
		o.date_due, today, (fine_daily_rate_in_cents*(today-o.date_due)))