-- first_one
CREATE OR REPLACE FUNCTION banking_system.do_the_thing()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.transaction_type = 'deposit' THEN
    UPDATE banking_system.Accounts
    SET balance = balance + NEW.amount
    WHERE account_id = NEW.account_id;
  ELSEIF NEW.transaction_type = 'withdrawal' THEN
    IF (SELECT balance FROM banking_system.Accounts WHERE account_id = NEW.account_id) < NEW.amount THEN
      RAISE EXCEPTION 'Not enough money!';
    END IF;
    UPDATE banking_system.Accounts
    SET balance = balance - NEW.amount
    WHERE account_id = NEW.account_id;
  ELSE RAISE EXCEPTION 'Unkonown type!';
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_balance
AFTER INSERT ON banking_system.Transactions
FOR EACH ROW
EXECUTE FUNCTION banking_system.do_the_thing();
