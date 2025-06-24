# 📘 Airbnb Clone – Normalization Explanation

In this document, I tried to explain the steps taken to modify and normalize my Airbnb database schema located [here](./ERD/airbnb_erd.jpg). The goal of the modification and normalization is to reduce redundancy, ensure data integrity, and improve scalability. The schema follows the first, second, and third normal forms (1NF, 2NF, and 3NF).

---

## ✅ First Normal Form (1NF)

> I ensured all attributes are atomic (indivisible) and there are no repeating groups.

- All columns store atomic values (e.g., `first_name`, `email`, `city`).
- Multi-valued fields (e.g., a user speaking multiple languages or a property having many categories) were removed and replaced with **junction tables**:
  - `user_language` for users and languages.
  - `property_category` for properties and categories.
  - `property_attribute` for properties and amenity attributes.
  - `booking_guests` for capturing types and numbers of guests.

✅ **Result:** All tables store one value per cell, and multi-value data is represented using separate linking tables.

---

## ✅ Second Normal Form (2NF)

> I eliminated partial dependencies; all non-key attributes must depend on the whole primary key.

- Composite relationships (e.g., a property having multiple attributes) were moved into junction tables with their own surrogate primary keys (e.g., UUIDs).
- Each non-key attribute in all tables fully depends on the primary key.
- For example:
  - `place_type_name` was extracted to a `place_type` table.
  - `category_name` was extracted to a `category` table.
  - `language` was extracted to a `language` table.

✅ **Result:** All partial dependencies are removed, allowing efficient updates and consistent data.

---

## ✅ Third Normal Form (3NF)

> I removed transitive dependencies; non-key attributes should not depend on other non-key attributes.

- Transitive dependencies were resolved by introducing reference tables:
  - `location → country → region` is now structured using foreign keys instead of repeating strings.
  - `payment → payment_method` ensures method details are abstracted away from transactional rows.
  - `user → user_role → role` enforces separation of concerns regarding user privileges.
- This helps enforce referential integrity and makes filtering and reporting more flexible.

✅ **Result:** No column is dependent on a non-primary key field. All data is logically grouped.

---

## Why This Matters

| Benefit                | Description |
|------------------------|-------------|
| **Data Consistency**   | Each fact is stored in only one place, reducing chances of conflict. |
| **Efficiency**         | Avoids data duplication, resulting in smaller, faster queries. |
| **Flexibility**        | Easier to evolve schema by adding new languages, locations, or roles. |
| **Better Relationships** | Many-to-many relationships are captured using bridge tables. |

---

## Summary of Key Improvements

| Change Applied                        | Explanation |
|--------------------------------------|-------------|
| Extracted `role`, `language`, `place_type`, etc. | To ensure data reuse and eliminate transitive dependencies. |
| Introduced M:N bridge tables         | e.g., `property_attribute`, `user_language`, `favorites`. |
| Structured location hierarchy        | With `location → country → region`. |
| Broke down review components         | Added `component_rating` and `review_components` for granular scoring. |
| Normalized payment and status fields | Created `payment_method` and used enums for statuses. |

---

## ERD Reference

The complete normalized schema is represented in the ERD located in the `/ERD/` directory or [view here](./ERD/airbnb_normalized_erd.png) and it was built using [eraser](app.eraser.io).
The code, in text based schema notation is located [here](./ERD/airbnb_normalized_erd.txt).

---

## Schema in tabular format

I used `CHATGPT` to create my schema in a tabular format easy to go through.

---

### 🧑 Users

| Field               | Type      | Constraints                |
| ------------------- | --------- | -------------------------- |
| user\_id            | UUID      | PK, indexed                |
| first\_name         | VARCHAR   | NOT NULL                   |
| last\_name          | VARCHAR   | NOT NULL                   |
| email               | VARCHAR   | UNIQUE, NOT NULL, indexed  |
| phone\_number       | VARCHAR   | UNIQUE, NULL               |
| password\_hash      | VARCHAR   | NOT NULL                   |
| joined\_at          | TIMESTAMP | DEFAULT current\_timestamp |
| date\_host\_started | DATE      | NULL                       |

---

### 🗣️ Language

| Field        | Type    | Constraints      |
| ------------ | ------- | ---------------- |
| language\_id | UUID    | PK               |
| language     | VARCHAR | UNIQUE, NOT NULL |

---

### 👥 User\_Language

| Field        | Type | Constraints                |
| ------------ | ---- | -------------------------- |
| id           | UUID | PK                         |
| language\_id | UUID | FK → language.language\_id |
| user\_id     | UUID | FK → users.user\_id        |

---

### 🔐 Role

| Field      | Type    | Constraints |
| ---------- | ------- | ----------- |
| role\_id   | UUID    | PK, indexed |
| role\_name | VARCHAR | NOT NULL    |

---

### 👤 User\_Role

| Field    | Type | Constraints         |
| -------- | ---- | ------------------- |
| role\_id | UUID | FK → role.role\_id  |
| user\_id | UUID | FK → users.user\_id |

---

### 🏠 Properties

| Field              | Type      | Constraints                            |
| ------------------ | --------- | -------------------------------------- |
| property\_id       | UUID      | PK, indexed                            |
| host\_id           | UUID      | FK → users.user\_id, NOT NULL          |
| location\_id       | UUID      | FK → location.location\_id, NOT NULL   |
| place\_type\_id    | UUID      | FK → place\_type.place\_type\_id       |
| property\_type\_id | UUID      | FK → property\_type.property\_type\_id |
| name               | VARCHAR   | NOT NULL                               |
| description        | TEXT      | NOT NULL                               |
| price\_per\_night  | DECIMAL   | NOT NULL                               |
| max\_guests        | INTEGER   | NULL                                   |
| no\_bath           | INTEGER   | NULL                                   |
| no\_bathroom       | INTEGER   | NULL                                   |
| address\_1         | TEXT      | NOT NULL                               |
| created\_at        | TIMESTAMP | DEFAULT current\_timestamp             |
| updated\_at        | TIMESTAMP | DEFAULT current\_timestamp             |
| is\_favorite       | BOOLEAN   | DEFAULT false                          |

---

### 🧭 Location

| Field        | Type    | Constraints              |
| ------------ | ------- | ------------------------ |
| location\_id | UUID    | PK                       |
| city         | VARCHAR | NOT NULL                 |
| state        | VARCHAR | NULL                     |
| country\_id  | UUID    | FK → country. Country\_id |

---

### 🌍 Country

| Field         | Type    | Constraints            |
| ------------- | ------- | ---------------------- |
| country\_id   | UUID    | PK                     |
| region\_id    | UUID    | FK → region.region\_id |
| country\_name | VARCHAR | UNIQUE, NOT NULL       |

---

### 🌐 Region

| Field        | Type    | Constraints      |
| ------------ | ------- | ---------------- |
| region\_id   | UUID    | PK               |
| region\_name | VARCHAR | UNIQUE, NOT NULL |

---

### 🗂️ Place\_Type

| Field             | Type    | Constraints      |
| ----------------- | ------- | ---------------- |
| place\_type\_id   | UUID    | PK               |
| place\_type\_name | VARCHAR | UNIQUE, NOT NULL |

---

### 🏷️ Property\_Type

| Field                | Type    | Constraints      |
| -------------------- | ------- | ---------------- |
| property\_type\_id   | UUID    | PK               |
| property\_type\_name | VARCHAR | UNIQUE, NOT NULL |

---

### 🗃️ Category

| Field          | Type    | Constraints      |
| -------------- | ------- | ---------------- |
| category\_id   | UUID    | PK               |
| category\_name | VARCHAR | UNIQUE, NOT NULL |

---

### 🏷️ Property\_Category

| Field        | Type | Constraints                  |
| ------------ | ---- | ---------------------------- |
| id           | UUID | PK                           |
| property\_id | UUID | FK → properties.property\_id |
| category\_id | UUID | FK → category. Category\_id   |

---

### 🔧 Attribute\_Category

| Field                     | Type    | Constraints      |
| ------------------------- | ------- | ---------------- |
| attribute\_category\_id   | UUID    | PK               |
| attribute\_category\_name | VARCHAR | UNIQUE, NOT NULL |

---

### 🔌 Attribute

| Field                   | Type    | Constraints                                      |
| ----------------------- | ------- | ------------------------------------------------ |
| attribute\_id           | UUID    | PK                                               |
| attribute\_category\_id | UUID    | FK → attribute\_category.attribute\_category\_id |
| attribute\_name         | VARCHAR | UNIQUE, NOT NULL                                 |
| description             | TEXT    | NULL                                             |

---

### 🏡 Property\_Attribute

| Field         | Type | Constraints                  |
| ------------- | ---- | ---------------------------- |
| id            | UUID | PK                           |
| property\_id  | UUID | FK → properties.property\_id |
| attribute\_id | UUID | FK → attribute.attribute\_id |

---

### 🖼️ Images

| Field        | Type    | Constraints                  |
| ------------ | ------- | ---------------------------- |
| image\_id    | UUID    | PK                           |
| property\_id | UUID    | FK → properties.property\_id |
| image\_url   | VARCHAR | NOT NULL                     |
| image\_order | INTEGER | NULL                         |

---

### ❤️ Favorites

| Field        | Type | Constraints                  |
| ------------ | ---- | ---------------------------- |
| user\_id     | UUID | FK → users.user\_id          |
| property\_id | UUID | FK → properties.property\_id |

---

### 📅 Booking

| Field           | Type      | Constraints                     |
| --------------- | --------- | ------------------------------- |
| booking\_id     | UUID      | PK                              |
| property\_id    | UUID      | FK → properties.property\_id    |
| guest\_id       | UUID      | FK → users.user\_id             |
| start\_date     | DATE      | NOT NULL                        |
| end\_date       | DATE      | NOT NULL                        |
| booking\_status | ENUM      | (confirmed, pending, cancelled) |
| service\_fee    | DECIMAL   | NULL                            |
| cleaning\_fee   | DECIMAL   | NULL                            |
| total\_price    | DECIMAL   | NOT NULL                        |
| created\_at     | TIMESTAMP | DEFAULT current\_timestamp      |

---

### 👨‍👩‍👧 Booking\_Guests

| Field           | Type    | Constraints                      |
| --------------- | ------- | -------------------------------- |
| booking\_id     | UUID    | FK → booking.booking\_id         |
| guest\_type\_id | UUID    | FK → guest\_type.guest\_type\_id |
| no\_guest       | INTEGER | NOT NULL                         |

---

### 👥 Guest\_Type

| Field             | Type    | Constraints      |
| ----------------- | ------- | ---------------- |
| guest\_type\_id   | UUID    | PK               |
| guest\_type\_name | VARCHAR | UNIQUE, NOT NULL |

---

### 💬 Message

| Field         | Type      | Constraints                |
| ------------- | --------- | -------------------------- |
| sender\_id    | UUID      | FK → users.user\_id        |
| recipient\_id | UUID      | FK → users.user\_id        |
| message\_body | TEXT      | NOT NULL                   |
| created\_at   | TIMESTAMP | DEFAULT current\_timestamp |

---

### ⭐ Review

| Field        | Type      | Constraints                  |
| ------------ | --------- | ---------------------------- |
| review\_id   | UUID      | PK                           |
| user\_id     | UUID      | FK → users.user\_id          |
| property\_id | UUID      | FK → properties.property\_id |
| rating       | INTEGER   | CHECK (1 to 10)              |
| comment      | TEXT      | NULL                         |
| created\_at  | TIMESTAMP | DEFAULT current\_timestamp   |

---

### ⚙️ Review\_Components

| Field           | Type    | Constraints |
| --------------- | ------- | ----------- |
| component\_id   | UUID    | PK          |
| component\_name | VARCHAR | UNIQUE      |

---

### ⭐ Component\_Rating

| Field         | Type    | Constraints                           |
| ------------- | ------- | ------------------------------------- |
| component\_id | UUID    | FK → review\_components.component\_id |
| review\_id    | UUID    | FK → review\.review\_id               |
| rating        | INTEGER | NOT NULL                              |

---

### 💰 Payment

| Field               | Type      | Constraints                              |
| ------------------- | --------- | ---------------------------------------- |
| payment\_id         | UUID      | PK                                       |
| booking\_id         | UUID      | FK → booking.booking\_id                 |
| amount              | DECIMAL   | NOT NULL                                 |
| payment\_date       | TIMESTAMP | DEFAULT current\_timestamp               |
| payment\_method\_id | UUID      | FK → payment\_method.payment\_method\_id |
| payment\_status     | ENUM      | (pending, completed, failed), NOT NULL   |
| transaction\_id     | INTEGER   | NOT NULL                                 |

---

### 💳 Payment\_Method

| Field               | Type    | Constraints      |
| ------------------- | ------- | ---------------- |
| payment\_method\_id | UUID    | PK               |
| payment\_name       | VARCHAR | UNIQUE, NOT NULL |

---

