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


! ----NOTE THE TESTS BELOW SHOULD BE RE-EXAMINED AFTER FINE TRIGGER WORKS
! Borrower with multiple fines, where we only delete one
AR e1117 MARTIN DEAN { 123-456-7890 098-765-4321 } VOCALIST
AK AAF "Lambastion: The art of blistering retorts" { AARDVARK } CD { ORIGINAL }
AK AAG "Weeping: How to booger cry with style" { AARDVARK } CD { ORIGINAL }
C e1117 AAF 1
C e1117 AAG 1
!
! Now we will change the date so that both books are late
+ 30
! Then e1117 will to return them...
R AAF 1
!R AAG 1
! Now lets look at e1117's fines
G e1117
!
! Now we will pay just one of them
!F e1117 "hard_wired_title" 2023-05-12
!
! Lets verify that only one of the fines was deleted
G e1117




