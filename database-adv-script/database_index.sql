-- User Table: Indexes
CREATE UNIQUE INDEX idx_user_email ON users(email); -- Unique constraint on email
CREATE INDEX idx_user_id ON users(user_id); -- Optimized for joins

-- Booking Table: Indexes
CREATE INDEX idx_booking_property_id ON booking(property_id); -- Join optimization
CREATE INDEX idx_booking_user_id ON booking(user_id); -- Join optimization
CREATE INDEX idx_booking_dates ON booking(start_date, end_date); -- Range filtering

-- Property Table: Indexes
CREATE INDEX idx_property_id ON properties(property_id); -- Join optimization
CREATE INDEX idx_property_location ON properties(location); -- Filtering by location
CREATE INDEX idx_property_price ON properties(price_per_night); -- Filtering by price

-- EXPLAIN ANALYZE Example Query
EXPLAIN ANALYZE SELECT * FROM users WHERE email = 'ifeoma@example.com'
EXPLAIN ANALYZE SELECT users.first_name, users.last_name, book
ing.property_id, booking.total_price FROM booking LEFT JOIN users ON users.us
er_id = booking.guest_id;
EXPLAIN ANALYSE SELECT * FROM properties WHERE price_per_night
 < 10000;
