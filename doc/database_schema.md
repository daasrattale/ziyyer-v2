# Ziyyer — Database Schema

**Engine:** SQLite via Drift ORM  
**DB file:** `ziyyer.sqlite` in app documents directory  
**Schema version:** 1

## Tables

### budget_table
| Column | Type | Constraints |
|---|---|---|
| id | INTEGER | PK AUTOINCREMENT |
| defined_amount | REAL | NOT NULL |
| currency | TEXT | NOT NULL |
| created_at | DATETIME | NOT NULL |
| updated_at | DATETIME | NOT NULL |

### category_table
| Column | Type | Constraints |
|---|---|---|
| id | INTEGER | PK AUTOINCREMENT |
| budget_id | INTEGER | NOT NULL → budget_table(id) |
| name | TEXT | NOT NULL |
| defined_amount | REAL | NOT NULL |
| real_amount | REAL | DEFAULT 0 |
| created_at | DATETIME | NOT NULL |
| updated_at | DATETIME | NOT NULL |

### transaction_table
| Column | Type | Constraints |
|---|---|---|
| id | INTEGER | PK AUTOINCREMENT |
| category_id | INTEGER | NOT NULL → category_table(id) ON DELETE CASCADE |
| amount | REAL | NOT NULL |
| date | DATETIME | NOT NULL |
| description | TEXT | NULLABLE |
| created_at | DATETIME | NOT NULL |

### payment_table
| Column | Type | Constraints |
|---|---|---|
| id | INTEGER | PK AUTOINCREMENT |
| budget_id | INTEGER | NOT NULL → budget_table(id) |
| name | TEXT | NOT NULL |
| amount | REAL | NOT NULL |

## Relationships
```
budget_table (1) ──< (N) category_table (1) ──< (N) transaction_table
     │
     └── (1) ──< (N) payment_table
```

## Architecture
- **Persistence layer:** `lib/shared/database/persistence/` — thin wrappers per table
- **Services layer:** `lib/shared/services/` — combines multiple persistence sources with rxdart
- **Service/Persistence locators:** Singletons initialized in `main.dart`
