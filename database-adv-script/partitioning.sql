-- 1️⃣ Create parent table
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
) PARTITION BY RANGE (start_date);

-- 2️⃣ Create partitions

-- Example: Partition for 2023
CREATE TABLE bookings_2023 PARTITION OF bookings
    FOR VALUES FROM ('2023-01-01') TO ('2024-01-01');

-- Partition for 2024
CREATE TABLE bookings_2024 PARTITION OF bookings
    FOR VALUES FROM ('2024-01-01') TO ('2025-01-01');

-- Default partition for future years
CREATE TABLE bookings_future PARTITION OF bookings
    FOR VALUES FROM ('2025-01-01') TO ('2100-01-01');
