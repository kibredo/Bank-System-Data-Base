CREATE OR REPLACE PROCEDURE banking_system.make_transaction(
  acc_id INTEGER, type VARCHAR(20),
  val DECIMAL(10, 2)) AS $$
DECLARE tmp INT;
BEGIN
  IF val < 0 THEN RAISE EXCEPTION 'Negative!';
  END IF;
  IF type = 'withdrawal' THEN
    IF (SELECT balance FROM banking_system.Accounts WHERE account_id = acc_id) < val THEN
        RAISE EXCEPTION 'Not enough money!';
    END IF;
    UPDATE banking_system.Accounts
    SET balance = balance - val
    WHERE account_id = acc_id;
  ELSEIF type = 'deposit' THEN
    UPDATE banking_system.Accounts
    SET balance = balance + val
    WHERE account_id = acc_id;
  ELSE RAISE EXCEPTION 'Incorrect type!';
  END IF;

  INSERT INTO banking_system.Transactions (account_id, transaction_type, amount, transaction_date)
  VALUES (acc_id, type, val, CURRENT_TIMESTAMP)
  RETURNING transaction_id INTO tmp;
  INSERT INTO banking_system.TransactionHistory (transaction_id, amount,
    transaction_date, start_date, end_date, is_active)
  VALUES (tmp, val, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, '9999-12-31', TRUE);
  COMMIT;
EXCEPTION
  WHEN OTHERS THEN ROLLBACK;
  RAISE;
END;
$$ LANGUAGE plpgsql;
