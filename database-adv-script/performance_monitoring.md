# Database Performance Monitoring Report — Airbnb Clone

## Objective

Continuously monitor and improve query performance by analyzing execution plans and refining database schema.

---

## 🟢 Monitoring Strategy

- Used `EXPLAIN ANALYZE` on frequently used queries to analyze execution paths and timing.

---

## Queries Analyzed

### 1️⃣ Fetch user bookings

```sql
SELECT *
FROM users AS u
INNER JOIN booking AS b
ON b.guest_id = u.user_id
```

- Before: Sequential scan on bookings table.
- After: Index scan using new booking.guest_id.

```sql
SELECT *
FROM properties
WHERE location = 'New York'
  AND price_per_night < 200;
```

- Before: Sequential scan.
- After: Index scan on location and price_per_night using properties.price_per_night and propeties.location.


```sql
SELECT u.username, b.start_date, b.end_date
FROM users AS u
JOIN booking AS b ON u.id = b.user_id
WHERE b.start_date >= '2023-01-01';
```

- Before: Nested loop with sequential scan
- After: Join now levarages index on booking.user_id


### Schema Adjustments

- Created new indexes:

    - idx_bookings_user_id
    - idx_properties_location_price

- Reviewed partitioning for bookings table to further optimize time-based filters.

| Query                          | Before Execution Time | After Execution Time |
| ------------------------------ | --------------------- | -------------------- |
| User bookings                  | \~450 ms              | \~20 ms              |
| Properties by location & price | \~300 ms              | \~15 ms              |
| User-booking join              | \~500 ms              | \~30 ms              |

## Conclusion

- New indexes drastically reduced scan times.
- Partitioning further supports efficient date-based filtering.
- Monitoring with EXPLAIN ANALYZE will continue as the dataset grows.
