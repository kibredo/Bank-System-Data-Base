--first_one
CREATE OR REPLACE FUNCTION banking_system.get_the_balance(p_customer_id INTEGER)
RETURNS DECIMAL(15, 2)
AS $$
DECLARE ans DECIMAL(15, 2);
BEGIN
  SELECT COALESCE(SUM(balance), 0.00) INTO ans
  FROM banking_system.Accounts
  WHERE customer_id = p_customer_id;
  RETURN ans;
END;
$$ LANGUAGE plpgsql;
