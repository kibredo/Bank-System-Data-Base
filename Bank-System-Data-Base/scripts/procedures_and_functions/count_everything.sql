--second_one
CREATE OR REPLACE FUNCTION banking_system.count_transactions(
  type VARCHAR(20), start_dt TIMESTAMP, end_dt TIMESTAMP)
RETURNS INTEGER
AS $$
DECLARE ans INTEGER;
BEGIN
  IF type NOT IN ('deposit', 'withdrawal', 'transfer') THEN
    RAISE EXCEPTION 'Nope';
  END IF;
  SELECT COUNT(*) INTO ans
  FROM banking_system.Transactions
  WHERE transaction_type = type
  AND transaction_date BETWEEN start_dt AND end_dt;
  RETURN ans;
END;
$$ LANGUAGE plpgsql;
