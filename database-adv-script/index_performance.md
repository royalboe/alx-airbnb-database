# Index Performance Analysis

## Objective

Evaluate the impact of adding indexes on query performance in the User, Booking, and Property tables.

---

## Test Setup

1. Queries were run using `EXPLAIN ANALYZE`.
2. Performance measured before and after adding indexes.

---

## Results

### Query 1: Fetch a single user

```sql
EXPLAIN ANALYZE SELECT * FROM users WHERE email = 'ifeoma@example.com'
```

**Before Indexing**:

- Planning Time: 3.359 ms
- Execution Time: 1.093 ms
- Query Plan: Sequential Scan on `users`

**After Indexing**:

- Planning Time: 0.172 ms
- Execution Time: 0.066 ms
- Query Plan: Index Scan using `users_email_key`

---

### Query 2: Join bookings table to users table

```sql
EXPLAIN ANALYZE SELECT users.first_name, users.last_name, book
ing.property_id, booking.total_price FROM booking LEFT JOIN users ON users.us
er_id = booking.guest_id;
```

**Before Indexing**:

- Execution Time: 0.199 ms
- Plannign Time: 2.885 ms
- Query Plan: Sequential Scan on `booking`

**After Indexing**:

- Planning Time: 1.005 ms
- Execution Time: 0.093 ms
- Query Plan: Index Scan using `booking.guest_id` and `users.user_id`

---

### Query 3: Search properties by price_per_night

```sql
 EXPLAIN ANALYSE SELECT * FROM properties WHERE price_per_night
 < 10000;
 ```

**Before Indexing**:

- Planning Time: 0.191 ms
- Execution Time: 0.065 ms
- Query Plan: Sequential Scan on `properties`

**After Indexing**:

- Planning Time: 0.081 ms
- Execution Time: 0.025 ms
- Query Plan: Index Scan using `properties.price_per_night`

---

## Conclusion

Indexes significantly improved query performance, particularly for filtering and join operations. Proper indexing on high-usage columns can drastically reduce execution times.
