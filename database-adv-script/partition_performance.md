# Partitioning Performance Report — Airbnb Clone

## Objective

Improve performance of queries on the large `Booking` table by implementing table partitioning based on the `start_date` column.

---

## Approach

- Implemented **range partitioning** on `start_date`.
- Created separate partitions for each year (2023, 2024, and future years).

---

## SQL Implementation

- Defined `bookings` as a partitioned table.
- Created child tables: `bookings_2023`, `bookings_2024`, `bookings_future`.
- Stored the full script in `partitioning.sql`.

---

## Query Performance Comparison

### Before partitioning

- Queries scanning bookings by date range (e.g., a single month) required full table scan.
- High execution time and higher cost (especially on large dataset).

---

### After partitioning

- PostgreSQL query planner pruned partitions.
- Query executed only on relevant year partition.
- Significantly faster response time and reduced I/O.

---

## Example Results

| Query                      | Before Partitioning | After Partitioning |
|----------------------------|--------------------|-------------------|
| June 2023 bookings scan | ~500 ms              | ~30 ms           |

> *Values above are approximate example numbers and may vary based on actual data.*

---

## Conclusion

- Partitioning greatly improves query efficiency for time-based queries.
- Recommended for production workloads with large, time-dependent tables.

---
