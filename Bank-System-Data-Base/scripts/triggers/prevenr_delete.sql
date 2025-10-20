-- third one
CREATE OR REPLACE FUNCTION banking_system.prevent_customer_deletion()
RETURNS TRIGGER AS $$
DECLARE account_count INT;
BEGIN
  SELECT COUNT(*)
  INTO account_count
  FROM banking_system.Accounts
  WHERE customer_id = OLD.customer_id;
  IF account_count > 0 THEN
    INSERT INTO banking_system.TransactionHistory 
    (transaction_id, amount, transaction_date, start_date, end_date, is_active)
    VALUES (NULL, 0.00, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, '9999-12-31', TRUE);
    RAISE EXCEPTION '% has an active account!!', OLD.customer_id;
  END IF;
  RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_prevent_customer_deletion
BEFORE DELETE ON banking_system.Customers
FOR EACH ROW
EXECUTE FUNCTION banking_system.prevent_customer_deletion();
