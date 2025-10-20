-- second_one
CREATE OR REPLACE FUNCTION banking_system.update_transaction_history()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'UPDATE' THEN
    UPDATE banking_system.TransactionHistory
    SET is_active = FALSE, end_date = CURRENT_TIMESTAMP
    WHERE transaction_id = OLD.transaction_id
    INSERT INTO banking_system.TransactionHistory (
      transaction_id, amount, transaction_date, start_date, end_date, is_active
    )
    VALUES (
      NEW.transaction_id, NEW.amount, NEW.transaction_date, CURRENT_TIMESTAMP, '9999-12-31', TRUE
    );
  ELSE
  UPDATE banking_system.TransactionHistory
  SET is_active = FALSE,
    end_date = CURRENT_TIMESTAMP
  WHERE transaction_id = OLD.transaction_id
  AND is_active = TRUE;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_transaction_history
AFTER UPDATE OR DELETE ON banking_system.Transactions
FOR EACH ROW
EXECUTE FUNCTION banking_system.update_transaction_history();
