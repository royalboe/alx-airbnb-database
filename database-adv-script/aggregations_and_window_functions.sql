-- Query to find total number of bookings made by each user, using the count functiona nd group by clause

SELECT
  u.user_id AS user_id,
  COUNT(b.booking_id) AS total_bookings
FROM users AS u
LEFT JOIN bookings AS b
ON u.user_id = b.user_id
GROUP BY u.user_id;


-- Query with a window function(ROW_NUMBER, RANK) to rank properties based on the number of reviews they have bookings they have received

-- Use ROW_NUMBER over RANK to rank properties based on the number of bookings because I want to assign a unique rank to each property, even if they have the same number of bookings.
SELECT
  p.property_id,
  p.property_name,
  COUNT(b.booking_id) AS total_bookings,
  RANK() OVER (ORDER BY COUNT(bookings.id) DESC) AS rank_number,
  ROW_NUMBER() OVER (ORDER BY COUNT(b.booking_id) DESC) AS booking_rank
FROM properties AS p
LEFT JOIN bookings AS b
ON p.property_id = b.property_id
GROUP BY p.property_id, p.property_name;