-- Insert Roles
INSERT INTO role (role_id, role_name) VALUES
(uuid_generate_v4(), 'host'),
(uuid_generate_v4(), 'guest');

-- Insert Users
INSERT INTO users (user_id, first_name, last_name, email, phone_number, password_hash, date_host_started)
VALUES
(uuid_generate_v4(), 'Ifeoma', 'Ojo', 'ifeoma@example.com', '+2348011122233', 'hashed_pwd1', '2024-01-01'),
(uuid_generate_v4(), 'Tolu', 'Ade', 'tolu@example.com', '+2348023344556', 'hashed_pwd2', NULL);

-- Assign User Roles
INSERT INTO user_role (user_id, role_id)
SELECT u.user_id, r.role_id FROM users u, role r
WHERE (u.email = 'ifeoma@example.com' AND r.role_name = 'host')
   OR (u.email = 'tolu@example.com' AND r.role_name = 'guest');

-- Regions and Countries
INSERT INTO region (region_id, region_name) VALUES (uuid_generate_v4(), 'West Africa');

INSERT INTO country (country_id, region_id, country_name)
VALUES (uuid_generate_v4(), (SELECT region_id FROM region WHERE region_name = 'West Africa'), 'Nigeria');

-- Locations
INSERT INTO location (location_id, city, state, country_id)
VALUES
(uuid_generate_v4(), 'Lagos', 'Lagos State', (SELECT country_id FROM country WHERE country_name = 'Nigeria')),
(uuid_generate_v4(), 'Abuja', 'FCT', (SELECT country_id FROM country WHERE country_name = 'Nigeria'));

-- Place and Property Types
INSERT INTO place_type (place_type_id, place_type_name) VALUES (uuid_generate_v4(), 'Entire home');

INSERT INTO property_type (property_type_id, property_type_name) VALUES (uuid_generate_v4(), 'Bungalow');

-- Properties
INSERT INTO properties (
    property_id, host_id, location_id, place_type_id, property_type_id,
    name, description, price_per_night, max_guests, num_bedroom, num_bathroom, address_1
)
VALUES (
    uuid_generate_v4(),
    (SELECT user_id FROM users WHERE email = 'ifeoma@example.com'),
    (SELECT location_id FROM location WHERE city = 'Lagos'),
    (SELECT place_type_id FROM place_type WHERE place_type_name = 'Entire home'),
    (SELECT property_type_id FROM property_type WHERE property_type_name = 'Bungalow'),
    'Lekki Beach House',
    'A cozy beach house near the Atlantic shore',
    35000.00, 4, 2, 2, '15 Coconut Grove, Lekki Phase 1'
);

-- Guest Types
INSERT INTO guest_type (guest_type_id, guest_type_name) VALUES
(uuid_generate_v4(), 'Adult'),
(uuid_generate_v4(), 'Child');

-- Booking
INSERT INTO booking (
    booking_id, property_id, guest_id, start_date, end_date, booking_status,
    service_fee, cleaning_fee, total_price
)
VALUES (
    uuid_generate_v4(),
    (SELECT property_id FROM properties WHERE name = 'Lekki Beach House'),
    (SELECT user_id FROM users WHERE email = 'tolu@example.com'),
    '2025-07-01', '2025-07-05',
    'confirmed', 3000.00, 2500.00, 175000.00
);

-- Payment Methods
INSERT INTO payment_method (payment_method_id, payment_name)
VALUES (uuid_generate_v4(), 'Card');

-- Payment
INSERT INTO payment (
    payment_id, booking_id, amount, payment_method_id, payment_status, transaction_id
)
VALUES (
    uuid_generate_v4(),
    (SELECT booking_id FROM booking LIMIT 1),
    175000.00,
    (SELECT payment_method_id FROM payment_method WHERE payment_name = 'Card'),
    'completed',
    'TXN-2342-LAG'
);

INSERT INTO message (message_id, sender_id, recipient_id, message_body)
VALUES (
    uuid_generate_v4(),
    (SELECT user_id FROM users WHERE email = 'tolu@example.com'),
    (SELECT user_id FROM users WHERE email = 'ifeoma@example.com'),
    'Hi Ifeoma, I just booked your beach house and I have a question about check-in time.'
);

-- Review Components
INSERT INTO review_components (component_id, component_name)
VALUES 
(uuid_generate_v4(), 'Cleanliness'),
(uuid_generate_v4(), 'Accuracy'),
(uuid_generate_v4(), 'Value');

-- Review
INSERT INTO review (review_id, user_id, property_id, rating, comment)
VALUES (
    uuid_generate_v4(),
    (SELECT user_id FROM users WHERE email = 'tolu@example.com'),
    (SELECT property_id FROM properties WHERE name = 'Lekki Beach House'),
    9,
    'Amazing place! Super clean and even better than the pictures.'
);

-- Component Ratings
INSERT INTO component_rating (component_id, review_id, rating)
SELECT 
    (SELECT component_id FROM review_components WHERE component_name = 'Cleanliness'),
    r.review_id,
    10
FROM review r
WHERE r.comment LIKE '%Amazing place%';

INSERT INTO component_rating (component_id, review_id, rating)
SELECT 
    (SELECT component_id FROM review_components WHERE component_name = 'Accuracy'),
    r.review_id,
    9
FROM review r
WHERE r.comment LIKE '%Amazing place%';

INSERT INTO component_rating (component_id, review_id, rating)
SELECT 
    (SELECT component_id FROM review_components WHERE component_name = 'Value'),
    r.review_id,
    8
FROM review r
WHERE r.comment LIKE '%Amazing place%';

-- Attribute Category
INSERT INTO attribute_category (attribute_category_id, attribute_category_name)
VALUES (uuid_generate_v4(), 'Essentials');

-- Attributes
INSERT INTO attribute (attribute_id, attribute_category_id, attribute_name, description)
SELECT uuid_generate_v4(), ac.attribute_category_id, 'Air Conditioning', 'Cooling system available'
FROM attribute_category ac WHERE ac.attribute_category_name = 'Essentials';

-- Property-Attribute Linking
INSERT INTO property_attribute (id, property_id, attribute_id)
SELECT uuid_generate_v4(), 
       (SELECT property_id FROM properties WHERE name = 'Lekki Beach House'),
       (SELECT attribute_id FROM attribute WHERE attribute_name = 'Air Conditioning');
	   
	   
INSERT INTO users (user_id, first_name, last_name, email, phone_number, password_hash, date_host_started)
VALUES
(uuid_generate_v4(), 'Zainab', 'Bello', 'zainab@example.com', '+2348133344455', 'hashed_pwd3', '2023-05-10'),
(uuid_generate_v4(), 'Kunle', 'Adebayo', 'kunle@example.com', '+2348066677788', 'hashed_pwd4', NULL);

-- Assign Roles
INSERT INTO user_role (user_id, role_id)
SELECT u.user_id, r.role_id FROM users u, role r
WHERE (u.email = 'zainab@example.com' AND r.role_name = 'host')
   OR (u.email = 'kunle@example.com' AND r.role_name = 'guest');
   

-- Message from Kunle to Ifeoma
INSERT INTO message (message_id, sender_id, recipient_id, message_body)
VALUES (
    uuid_generate_v4(),
    (SELECT user_id FROM users WHERE email = 'kunle@example.com'),
    (SELECT user_id FROM users WHERE email = 'ifeoma@example.com'),
    'Hi Ifeoma, does the beach house have a generator in case of power outages?'
);

-- Message from Zainab to Tolu
INSERT INTO message (message_id, sender_id, recipient_id, message_body)
VALUES (
    uuid_generate_v4(),
    (SELECT user_id FROM users WHERE email = 'zainab@example.com'),
    (SELECT user_id FROM users WHERE email = 'tolu@example.com'),
    'Hope you enjoyed your stay! Kindly leave a review—it helps future guests.'
);


-- Zainab reviews her own hosted property
INSERT INTO review (review_id, user_id, property_id, rating, comment)
VALUES (
    uuid_generate_v4(),
    (SELECT user_id FROM users WHERE email = 'zainab@example.com'),
    (SELECT property_id FROM properties WHERE name = 'Lekki Beach House'),
    10,
    'Hosting has been a delight—our guests have been lovely!'
);

-- Kunle reviews the property
INSERT INTO review (review_id, user_id, property_id, rating, comment)
VALUES (
    uuid_generate_v4(),
    (SELECT user_id FROM users WHERE email = 'kunle@example.com'),
    (SELECT property_id FROM properties WHERE name = 'Lekki Beach House'),
    8,
    'Beautiful location, though we had a little trouble with the water pressure.'
);

-- Component Ratings for Kunle's review
INSERT INTO component_rating (component_id, review_id, rating)
SELECT rc.component_id, r.review_id, 
       CASE rc.component_name
           WHEN 'Cleanliness' THEN 9
           WHEN 'Accuracy' THEN 8
           WHEN 'Value' THEN 7
       END
FROM review_components rc, review r
WHERE r.comment LIKE '%water pressure%'
AND rc.component_name IN ('Cleanliness', 'Accuracy', 'Value');

-- Add a new property by host Zainab
INSERT INTO properties (
    property_id, host_id, location_id, place_type_id, property_type_id,
    name, description, price_per_night, max_guests, num_bedroom, num_bathroom, address_1
)
VALUES (
    uuid_generate_v4(),
    (SELECT user_id FROM users WHERE email = 'zainab@example.com'),
    (SELECT location_id FROM location WHERE city = 'Abuja'),
    (SELECT place_type_id FROM place_type WHERE place_type_name = 'Entire home'),
    (SELECT property_type_id FROM property_type WHERE property_type_name = 'Bungalow'),
    'Asokoro Garden Retreat',
    'Spacious bungalow with garden patio, 24/7 security, and serene views of the city.',
    45000.00, 5, 3, 2, '7 Peace Crescent, Asokoro'
);

INSERT INTO favorites (user_id, property_id)
VALUES (
    (SELECT user_id FROM users WHERE email = 'kunle@example.com'),
    (SELECT property_id FROM properties WHERE name = 'Asokoro Garden Retreat')
);

-- Add more languages
INSERT INTO language (language_id, language) VALUES
(uuid_generate_v4(), 'Hausa'),
(uuid_generate_v4(), 'Igbo');

-- Link users to languages
INSERT INTO user_language (id, user_id, language_id)
SELECT uuid_generate_v4(), u.user_id, l.language_id
FROM users u, language l
WHERE (u.email = 'zainab@example.com' AND l.language = 'English')
   OR (u.email = 'kunle@example.com' AND l.language = 'Hausa');
   

-- New booking by Kunle for Zainab's property
INSERT INTO booking (
    booking_id, property_id, guest_id, start_date, end_date, booking_status,
    service_fee, cleaning_fee, total_price
)
VALUES (
    uuid_generate_v4(),
    (SELECT property_id FROM properties WHERE name = 'Asokoro Garden Retreat'),
    (SELECT user_id FROM users WHERE email = 'kunle@example.com'),
    '2025-08-10', '2025-08-14',
    'confirmed', 4000.00, 3000.00, 188000.00
);

-- Payment method addition if not already included
INSERT INTO payment_method (payment_method_id, payment_name)
VALUES (uuid_generate_v4(), 'Bank Transfer');

-- Payment for Kunle's booking
INSERT INTO payment (
    payment_id, booking_id, amount, payment_method_id, payment_status, transaction_id
)
VALUES (
    uuid_generate_v4(),
    (SELECT booking_id FROM booking 
     WHERE property_id = (SELECT property_id FROM properties WHERE name = 'Asokoro Garden Retreat')
       AND guest_id = (SELECT user_id FROM users WHERE email = 'kunle@example.com')
     LIMIT 1),
    188000.00,
    (SELECT payment_method_id FROM payment_method WHERE payment_name = 'Bank Transfer'),
    'completed',
    'TXN-ASOKORO-4551'
);