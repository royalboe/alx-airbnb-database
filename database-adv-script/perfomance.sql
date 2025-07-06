-- Query to retrieve all user details, bookings, properties and payment details

SELECT 
  b.*,
  u.id AS user_id,
  u.username,
  u.email,
  p.property_id,
  p.property_name,
  p.location,
  pay.payment_id,
  pay.amount,
  pay.status
FROM booking AS b
INNER JOIN users AS u ON b.user_id = u.id
INNER JOIN properties AS p ON b.property_id = p.property_id
INNER JOIN payments AS pay ON b.booking_id = pay.booking_id
WHERE 
  b.start_date >= '2023-01-01' AND 
  b.end_date <= '2023-12-31';


-- Refactored optimized query
SELECT 
  b.booking_id,
  b.start_date,
  b.end_date,
  u.id AS user_id,
  u.username,
  u.email,
  p.property_id,
  p.property_name,
  p.location,
  pay.payment_id,
  pay.amount,
  pay.status
FROM booking AS b
INNER JOIN users AS u ON b.user_id = u.id
INNER JOIN properties AS p ON b.property_id = p.property_id
LEFT JOIN payments AS pay ON b.booking_id = pay.booking_id
WHERE 
  b.start_date >= '2023-01-01' AND 
  b.end_date <= '2023-12-31';


EXPLAIN ANALYZE SELECT * FROM booking;