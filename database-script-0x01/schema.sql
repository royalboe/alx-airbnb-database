-- Create the database
CREATE DATABASE airbnb_clone;
\c airbnb_clone;

-- Enable uuid extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Users Table
CREATE TABLE users (
    user_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone_number VARCHAR(20) UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_host_started DATE
);

-- Roles Table
CREATE TABLE role (
    role_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    role_name VARCHAR(50) NOT NULL UNIQUE
);

-- UserRole (many-to-many)
CREATE TABLE user_role (
    user_id UUID REFERENCES users(user_id) ON DELETE CASCADE,
    role_id UUID REFERENCES role(role_id) ON DELETE CASCADE,
    PRIMARY KEY (user_id, role_id)
);

-- Language Table
CREATE TABLE language (
    language_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    language VARCHAR(100) NOT NULL UNIQUE
);

-- UserLanguage (many-to-many)
CREATE TABLE user_language (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(user_id) ON DELETE CASCADE,
    language_id UUID REFERENCES language(language_id) ON DELETE CASCADE
);

-- Region Table
CREATE TABLE region (
    region_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    region_name VARCHAR(100) NOT NULL UNIQUE
);

-- Country Table
CREATE TABLE country (
    country_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    region_id UUID REFERENCES region(region_id),
    country_name VARCHAR(100) NOT NULL UNIQUE
);

-- Location Table
CREATE TABLE location (
    location_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100),
    country_id UUID REFERENCES country(country_id)
);

-- Place Type Table
CREATE TABLE place_type (
    place_type_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    place_type_name VARCHAR(100) NOT NULL UNIQUE
);

-- Property Type Table
CREATE TABLE property_type (
    property_type_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    property_type_name VARCHAR(100) NOT NULL UNIQUE
);

-- Properties Table
CREATE TABLE properties (
    property_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    host_id UUID REFERENCES users(user_id),
    location_id UUID REFERENCES location(location_id),
    place_type_id UUID REFERENCES place_type(place_type_id),
    property_type_id UUID REFERENCES property_type(property_type_id),
    name VARCHAR(200) NOT NULL,
    description TEXT NOT NULL,
    price_per_night DECIMAL NOT NULL,
    max_guests INTEGER,
    num_bedroom INTEGER,
    num_bathroom INTEGER,
    address_1 TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_favorite BOOLEAN DEFAULT FALSE
);

-- Category Table
CREATE TABLE category (
    category_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    category_name VARCHAR(100) NOT NULL UNIQUE
);

-- PropertyCategory (many-to-many)
CREATE TABLE property_category (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    property_id UUID REFERENCES properties(property_id) ON DELETE CASCADE,
    category_id UUID REFERENCES category(category_id) ON DELETE CASCADE
);

-- Attribute Category Table
CREATE TABLE attribute_category (
    attribute_category_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    attribute_category_name VARCHAR(100) NOT NULL UNIQUE
);

-- Attribute Table
CREATE TABLE attribute (
    attribute_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    attribute_category_id UUID REFERENCES attribute_category(attribute_category_id),
    attribute_name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT
);

-- PropertyAttribute (many-to-many)
CREATE TABLE property_attribute (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    property_id UUID REFERENCES properties(property_id) ON DELETE CASCADE,
    attribute_id UUID REFERENCES attribute(attribute_id) ON DELETE CASCADE
);

-- Images Table
CREATE TABLE images (
    image_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    property_id UUID REFERENCES properties(property_id) ON DELETE CASCADE,
    image_url VARCHAR(300) NOT NULL,
    image_order INTEGER
);

-- Favorites Table
CREATE TABLE favorites (
    user_id UUID REFERENCES users(user_id) ON DELETE CASCADE,
    property_id UUID REFERENCES properties(property_id) ON DELETE CASCADE,
    PRIMARY KEY (user_id, property_id)
);

-- Booking Table
CREATE TABLE booking (
    booking_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    property_id UUID REFERENCES properties(property_id),
    guest_id UUID REFERENCES users(user_id),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    booking_status VARCHAR(20) CHECK (booking_status IN ('confirmed', 'pending', 'cancelled')),
    service_fee DECIMAL,
    cleaning_fee DECIMAL,
    total_price DECIMAL NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Guest Type Table
CREATE TABLE guest_type (
    guest_type_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    guest_type_name VARCHAR(100) NOT NULL UNIQUE
);

-- Booking Guests Table
CREATE TABLE booking_guests (
    booking_id UUID REFERENCES booking(booking_id) ON DELETE CASCADE,
    guest_type_id UUID REFERENCES guest_type(guest_type_id),
    no_guest INTEGER,
    PRIMARY KEY (booking_id, guest_type_id)
);

-- Messages Table
CREATE TABLE message (
	message_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    sender_id UUID REFERENCES users(user_id),
    recipient_id UUID REFERENCES users(user_id),
    message_body TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Review Table
CREATE TABLE review (
    review_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(user_id),
    property_id UUID REFERENCES properties(property_id),
    rating INTEGER CHECK (rating BETWEEN 1 AND 10),
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Review Component Table
CREATE TABLE review_components (
    component_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    component_name VARCHAR(100) NOT NULL UNIQUE
);

-- Component Rating Table
CREATE TABLE component_rating (
    component_id UUID REFERENCES review_components(component_id),
    review_id UUID REFERENCES review(review_id),
    rating INTEGER,
    PRIMARY KEY (component_id, review_id)
);

-- Payment Method Table
CREATE TABLE payment_method (
    payment_method_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    payment_name VARCHAR(100) NOT NULL UNIQUE
);

-- Payment Table
CREATE TABLE payment (
    payment_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    booking_id UUID REFERENCES booking(booking_id),
    amount DECIMAL NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_method_id UUID REFERENCES payment_method(payment_method_id),
    payment_status VARCHAR(20) CHECK (payment_status IN ('pending', 'completed', 'failed')) NOT NULL,
    transaction_id VARCHAR(100) NOT NULL UNIQUE
);

-- Index Suggestions
-- CREATE INDEX idx_properties_location_id ON properties(location_id);
-- CREATE INDEX idx_properties_price ON properties(price_per_night);
-- CREATE INDEX idx_booking_property_id ON booking(property_id);
-- CREATE INDEX idx_favorites_user_id ON favorites(user_id);
-- CREATE INDEX idx_images_property_id ON images(property_id);
