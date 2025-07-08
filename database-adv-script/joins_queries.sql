SELECT *
FROM bookings as b
INNER JOIN users as u
ON b.user_id = u.id
ORDER BY b.boking_id

SELECT *
FROM properties as p
LEFT JOIN reviews as r
ON p.property_id = r.property_id
ORDER BY p.property_id

SELECT *
FROM users AS u
FULL OUTER JOIN bookings AS b
ON u.id = b.user_id