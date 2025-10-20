--second_one
CREATE OR REPLACE PROCEDURE banking_system.make_transfer(
  source INTEGER,
  dest INTEGER, val DECIMAL(10, 2))
AS $$
DECLARE tmp_source INTEGER;
DECLARE tmp_dest INTEGER;
BEGIN
  IF val < 0 THEN RAISE EXCEPTION 'Negative!';
  END IF;
  IF (SELECT balance FROM banking_system.Accounts WHERE account_id = source) < val THEN
    RAISE EXCEPTION 'Not enough money!';
END IF;
  UPDATE banking_system.Accounts
  SET balance = balance - val
  WHERE account_id = source;
  
  UPDATE banking_system.Accounts
  SET balance = balance + val
  WHERE account_id = dest;

  INSERT INTO banking_system.Transactions (account_id, transaction_type, amount, transaction_date)
  VALUES (source, 'withdrawal', val, CURRENT_TIMESTAMP)
  RETURNING transaction_id INTO tmp_source;
  INSERT INTO banking_system.TransactionHistory (transaction_id, amount,
    transaction_date, start_date, end_date, is_active)
  VALUES (tmp_source, val, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, '9999-12-31', TRUE);
  
  INSERT INTO banking_system.Transactions (account_id, transaction_type, amount, transaction_date)
  VALUES (source, 'withdrawal', val, CURRENT_TIMESTAMP)
  RETURNING transaction_id INTO tmp_dest;
  INSERT INTO banking_system.TransactionHistory (transaction_id, amount,
    transaction_date, start_date, end_date, is_active)
  VALUES (tmp_dest, val, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, '9999-12-31', TRUE);
  
  COMMIT;
EXCEPTION
  WHEN OTHERS THEN ROLLBACK;
    RAISE;
END;
$$ LANGUAGE plpgsql;
