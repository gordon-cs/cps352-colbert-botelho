connect to project;

-- Insert test data for reports

INSERT INTO Book_info VALUES('001', 'Old Testament', 'HC');
INSERT INTO Book_info VALUES('002', 'New Testament', 'HC');

INSERT INTO Book VALUES('001', 1, DEFAULT);
INSERT INTO Book VALUES('001', 2, DEFAULT);
INSERT INTO Book VALUES('002', 1, DEFAULT);
INSERT INTO Book VALUES('002', 2, DEFAULT);

INSERT INTO Book_author VALUES('001', 'God');
INSERT INTO Book_author VALUES('002', 'God');

INSERT INTO Book_keyword VALUES('001', 'Christian');
INSERT INTO Book_keyword VALUES('001', 'Old');
INSERT INTO Book_keyword VALUES('002', 'Christian');
INSERT INTO Book_keyword VALUES('002', 'New');

INSERT INTO Category VALUES('HC', 1, 1);

INSERT INTO Borrower VALUES('01', 'Colbert', 'Jacob', 'HC');
INSERT INTO Borrower VALUES('02', 'B', 'Eddy', 'HC');

INSERT INTO Borrower_phone VALUES('01', '911');
INSERT INTO Borrower_phone VALUES('01', '123');
INSERT INTO Borrower_phone VALUES('02', '456');

INSERT INTO Checked_out VALUES('001', 1, '01', '2023-04-18'); 
INSERT INTO Checked_out VALUES('001', 2, '02', '2023-04-17'); 
INSERT INTO Checked_out VALUES('002', 1, '01', '2023-01-01'); 
INSERT INTO Checked_out VALUES('002', 2, '02', '2025-01-01'); 

INSERT INTO Fine VALUES('01', 'Bible', '2023-01-01', '2023-02-02', 0.50);
INSERT INTO Fine VALUES('01', 'Bible1', '2023-01-01', '2023-02-02', 0.50);
INSERT INTO Fine VALUES('01', 'Bible2', '2023-01-01', '2023-02-02', 0.50);
INSERT INTO Fine VALUES('02', 'Bible3', '2023-01-01', '2023-02-02', 1.00);
INSERT INTO Fine VALUES('02', 'Bible4', '2023-01-01', '2023-02-02', 0.50);
INSERT INTO Fine VALUES('02', 'Bible5', '2023-01-01', '2023-02-02', 0.50);
