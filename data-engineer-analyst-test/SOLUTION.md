# Solution: <Sudan Wu>

Copy this file to `SOLUTION.md` and fill it in. Bullets are welcome. Short is better than long.

**Time spent:** e.g. 1h45

**How to run my code:**

```
<Get-Content solution.sql | sqlite3 -header -csv kpi_local.db > output/weekly_kpi_2026-W46.csv>
```

---

## Part 1A: Week 46

### What I found in the data, and what I did

| Issue | What I did | Impact on week 46 |
|---|---|---|
| The week number is wrong | FILTER BY DATE| |

### What Laura should know before this goes to the client

- Data reliability

### Laura's question about week 45

- IN TABLE FIELD_VISITS, 2026-W45 RUNS FROM 2026-10-31 TO 2026-11-6, BUT WHAT IS NEEDED IS FROM 2026-11-01 TO 2026-11-7

## Part 1B: Running it every Monday (a few bullets)

- Use two control flags: a send flag and a delay flag 

## Part 2A: Reply to the client (150 words maximum)

> Draft here.<img width="405" height="232" alt="image" src="https://github.com/user-attachments/assets/f2c4c22b-b3c4-4577-b7ab-949cfff6dbec" />

Hi [Client Name],
Regarding the ~50% drop in XR sell-out at MegaElectro shown on our dashboard, I reviewed the underlying data and found the following weekly totals:
Week 44 (Oct 25–31): 74 units
Week 45 (Nov 1–7): 97 units
Week 46 (Nov 8–14): 45 units
As shown above, Week 45 saw a significant spike driven by the promotion we ran, which naturally led to a post-promotional dip in Week 46. Additionally, this downward trend is consistent across all stores and is likely influenced by the approaching Black Friday, as it is normal for consumers to hold off on electronics purchases while waiting for upcoming deals.
We will continue monitoring store-level performance and stock availability ahead of the Black Friday peak. Let me know if you would like any further details.
Attached is the chart showing that this drop is consistent across nearly all stores.
Best regards,
[Sudan Wu]



**Evidence:**

## Part 2B: Field notes

| # | What the client should hear | Stores | Evidence (note IDs) |
|---|---|---|---|
| 1 | The table isn't well structured—many entries in the store_code column are missing data | GP Murcia | N20507,N20640, N20654,N20717 |
| 2 | The text format isn't standardized—it should follow a consistent pattern across all entries, for example: "store: [explanation]". | Goya | N20542...|
| 3 |  It would be good to add a column for the person in charge's ID (or "owner/assignee ID") |ALL | ALL|

**With 300 notes a week:**

-If we received 300 notes per week, ensuring data reliability and scalability would require a combination of process controls, automation, and monitoring. I would focus on three key areas:
1. Enforce structured data capture at the source
2. Automate data quality checks during ingestion
3. Automate note classification and prioritization

## Part 2C: Optional insight

-

## Part 3: First 90 days (three bullets)

-

## How I used AI (two or three lines)

- 
