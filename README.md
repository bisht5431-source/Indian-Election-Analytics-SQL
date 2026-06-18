# 🗳️ India General Election 2024 — SQL Analysis

<p align="center">
<img width="255" height="148" alt="download" src="https://github.com/user-attachments/assets/821f6b81-195c-467d-8210-69a70c9ae2b0" />


<p align="center">
  <img src="https://img.shields.io/badge/Database-PostgreSQL-336791?style=for-the-badge&logo=postgresql&logoColor=white" />
  <img src="https://img.shields.io/badge/Tool-pgAdmin%204-2F6792?style=for-the-badge&logo=postgresql&logoColor=white" />
  <img src="https://img.shields.io/badge/Language-SQL-F29111?style=for-the-badge&logo=databricks&logoColor=white" />
  <img src="https://img.shields.io/badge/Domain-Election%20Analytics-138808?style=for-the-badge" />
  <img src="https://img.shields.io/badge/Status-Completed-success?style=for-the-badge" />
</p>

---

## 📌 Project Overview

This project is a comprehensive **SQL-based analysis of the India General Election 2024** results. Using PostgreSQL, I designed a relational database schema from scratch, loaded real election data across **543 constituencies** and **36 states/UTs**, and wrote structured queries to uncover key political insights — from alliance seat tallies to constituency-level candidate battles.

The project demonstrates applied skills in **database design, multi-table joins, window functions, CTEs, conditional aggregation, and analytical reporting** — all using real-world government election data.

---

## 🖼️ Election Context
<p align="center">
<img width="148" height="148" alt="download (1)" src="https://github.com/user-attachments/assets/ea84fbe5-f905-4e29-9591-4dc1d18c5be7" />


> The **18th Lok Sabha General Election 2024** was one of the largest democratic exercises in human history — with over **640 million votes cast** across 543 parliamentary constituencies. This analysis explores the final seat distribution between the **NDA**, **I.N.D.I.A**, and **OTHER** alliances.

---

## 🗄️ Database Schema

The project uses **5 relational tables** in PostgreSQL:

```
┌─────────────────┐       ┌──────────────────┐       ┌──────────────────┐
│   state_results │       │   const_results  │       │   const_details  │
│─────────────────│       │──────────────────│       │──────────────────│
│ Parliament_Const│◄─────►│ Parliament_Const │       │ Const_ID         │
│ Constituency    │       │ Const_Name       │◄─────►│ Candidate        │
│ Leading_Candidate│      │ Winning_Candidate│       │ Party            │
│ Trailing_Candidate│     │ Total_Votes      │       │ EVM_Votes        │
│ Margin          │       │ Margin           │       │ Postal_Votes     │
│ Status          │       │ Const_ID         │       │ Total_Votes      │
│ State_ID        │       │ Party_ID         │       │ Votes_percent    │
└────────┬────────┘       └────────┬─────────┘       └──────────────────┘
         │                         │
         ▼                         ▼
┌────────────────┐        ┌────────────────────┐
│    states      │        │   party_results    │
│────────────────│        │────────────────────│
│ State_ID (PK)  │        │ Party_ID (PK)      │
│ States         │        │ Party              │
└────────────────┘        │ Won                │
                          │ party_allianz      │
                          └────────────────────┘
```

**Relationships:**
- `state_results` ↔ `const_results` — joined on `Parliament_Const`
- `const_results` ↔ `party_results` — joined on `Party_ID`
- `const_results` ↔ `const_details` — joined on `Const_ID`
- `state_results` ↔ `states` — joined on `State_ID`

---

## 🔍 Key SQL Analyses

| # | Analysis | Techniques Used |
|---|----------|-----------------|
| 1 | Total Lok Sabha seats | `COUNT DISTINCT` |
| 2 | Seats available per state | `INNER JOIN`, `GROUP BY`, `ORDER BY` |
| 3 | Total seats won by NDA alliance | `SUM + CASE WHEN` conditional aggregation |
| 4 | Total seats won by I.N.D.I.A alliance | `SUM + WHERE IN` |
| 5 | Alliance-wise seat comparison (NDA vs I.N.D.I.A vs OTHER) | `ALTER TABLE`, `UPDATE`, `GROUP BY` |
| 6 | Winning candidate details for a specific constituency | 4-table `INNER JOIN` |
| 7 | EVM vs Postal vote distribution per constituency | `JOIN` on `Const_ID` |
| 8 | Parties with most seats in a given state | Multi-table `JOIN`, `GROUP BY` |
| 9 | Alliance-wise seat breakdown per state | `SUM + CASE`, pivoted output |
| 10 | Top 10 candidates by EVM votes | Correlated subquery, `LIMIT` |
| 11 | Winner & runner-up in each constituency | `CTE`, `ROW_NUMBER()`, `PARTITION BY`, `PIVOT` logic |

---

## 💡 Sample Query — Alliance Seats by State

```sql
SELECT 
    s.States AS State_Name,
    SUM(CASE WHEN p.party_allianz = 'NDA'     THEN 1 ELSE 0 END) AS NDA_Seats,
    SUM(CASE WHEN p.party_allianz = 'I.N.D.I.A' THEN 1 ELSE 0 END) AS INDIA_Seats,
    SUM(CASE WHEN p.party_allianz = 'OTHER'   THEN 1 ELSE 0 END) AS Other_Seats
FROM const_results cr
JOIN party_results  p  ON cr.Party_ID        = p.Party_ID
JOIN state_results  sr ON cr.Parliament_Const = sr.Parliament_Const
JOIN states         s  ON sr.State_ID         = s.State_ID
GROUP BY s.States
ORDER BY s.States;
```

---

## 💡 Sample Query — Winner & Runner-Up per Constituency (CTE + Window Function)

```sql
WITH RankedCandidates AS (
    SELECT
        cd.Const_ID,
        cr.Const_Name,
        cd.Candidate,
        cd.Party,
        (cd.EVM_Votes + cd.Postal_Votes) AS total_votes,
        ROW_NUMBER() OVER (
            PARTITION BY cd.Const_ID
            ORDER BY (cd.EVM_Votes + cd.Postal_Votes) DESC
        ) AS vote_rank
    FROM const_details cd
    JOIN const_results  cr ON cd.Const_ID        = cr.Const_ID
    JOIN state_results  sr ON cr.Parliament_Const = sr.Parliament_Const
    JOIN states          s ON sr.State_ID         = s.State_ID
    WHERE s.States = 'Maharashtra'
)
SELECT
    Const_Name,
    MAX(CASE WHEN vote_rank = 1 THEN Candidate END) AS Winning_Candidate,
    MAX(CASE WHEN vote_rank = 2 THEN Candidate END) AS RunnerUp_Candidate
FROM RankedCandidates
GROUP BY Const_Name
ORDER BY Const_Name;
```

---

## 🛠️ Tech Stack

| Tool / Technology | Purpose |
|---|---|
| **PostgreSQL 16** | Relational database engine |
| **pgAdmin 4** | GUI for database management & query execution |
| **SQL** | Data querying, transformation, and analysis |
| **DDL** (`CREATE`, `ALTER`, `DROP`) | Schema design and modification |
| **DML** (`INSERT`, `UPDATE`) | Data loading and alliance tagging |
| **Window Functions** | `ROW_NUMBER()`, `PARTITION BY` for ranking |
| **CTEs** | `WITH` clause for readable multi-step queries |
| **Conditional Aggregation** | `SUM(CASE WHEN ...)` for pivot-style outputs |
| **Subqueries** | Correlated subqueries for per-constituency max |

---

## 📂 Project Structure

```
india-election-2024-sql/
│
├── schema/
│   └── election_postgresql_schema.sql   # All CREATE TABLE + ALTER statements
│
├── queries/
│   ├── alliance_analysis.sql            # NDA, I.N.D.I.A, OTHER seat tallies
│   ├── state_analysis.sql               # State-wise seat distribution
│   ├── constituency_analysis.sql        # Winner, runner-up, margins
│   └── candidate_analysis.sql           # EVM vs Postal, top candidates
│
└── README.md
```

---

## 📊 Key Findings

- ✅ **543 total Lok Sabha seats** analysed across all states and UTs
- 🟠 **NDA** — 14 constituent parties tracked with exact seat counts
- 🔵 **I.N.D.I.A** — 20 constituent parties tracked with exact seat counts
- ⚪ **OTHER** — remaining parties classified and aggregated separately
- 🗺️ State-level alliance dominance mapped for all major states including **Uttar Pradesh, Maharashtra, West Bengal, Tamil Nadu, Andhra Pradesh**
- 🏆 Constituency-level winner + runner-up identified for every parliamentary seat using window functions

---

## ▶️ How to Run

1. Install **PostgreSQL** and open **pgAdmin 4**
2. Create a new database: `india_election_2024`
3. Run `schema/election_postgresql_schema.sql` to create all tables
4. Import your CSV data into each table using the pgAdmin Import tool or `COPY` command
5. Run any query file from the `queries/` folder

```sql
-- Quick check after setup
SELECT COUNT(*) FROM const_results;   -- Should return 543
SELECT COUNT(*) FROM party_results;   -- Should return total parties
SELECT COUNT(*) FROM const_details;   -- Candidate-level rows
```

---

## 👤 About Me

<p align="left">
  <img src="https://avatars.githubusercontent.com/bisht5431-source" width="80" style="border-radius:50%" alt="Manish Bisht" />
</p>

**Manish Bisht** — Data Analyst

I'm a results-driven Data Analyst with **6+ years of experience** across government, private, and technology sectors. I specialize in turning raw, unstructured data into clean, decision-ready insights using SQL, Power BI, Python, and Excel.

| | |
|---|---|
| 📍 Location | Delhi, India |
| 💼 Current Role | Data Analyst Intern — Intellipaat Software Solutions |
| 🛠️ Core Skills | SQL · Power BI (DAX) · Python (pandas) · Excel · MIS Reporting |
| 🎓 Certification | Advanced Data Analytics — IIT Roorkee (iHUB DivyaSampark) |

**Connect with me:**

[![LinkedIn](https://img.shields.io/badge/LinkedIn-dataanalyst--manish-0A66C2?style=flat-square&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/dataanalyst-manish)
[![GitHub](https://img.shields.io/badge/GitHub-bisht5431--source-181717?style=flat-square&logo=github&logoColor=white)](https://github.com/bisht5431-source)
[![Email](https://img.shields.io/badge/Email-alphainsights123@gmail.com-EA4335?style=flat-square&logo=gmail&logoColor=white)](mailto:alphainsights123@gmail.com)

---

<p align="center">
  <sub>Built with ❤️ using PostgreSQL · India General Election 2024 data · by Manish Bisht</sub>
</p>
