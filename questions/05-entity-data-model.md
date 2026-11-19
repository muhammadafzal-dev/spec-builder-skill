# Category 5 — Entity / Data Model

Purpose: list every "thing" the product tracks, what fields each has, and how they relate. **Stack-agnostic — no SQL types, no framework names.**

## Questions to ask

1. **What entities exist?** (user, project, site, shift, event, invoice, etc.)
2. **For each entity, what fields does it have?** (list all — even obvious ones like id, created_at)
3. **Which fields are required vs optional?**
4. **Which fields are immutable after creation?**
5. **How do entities relate?** (one-to-one, one-to-many, many-to-many)
6. **Does any entity have a parent?** (hierarchy)
7. **Is any entity "owned" by a user?** (user_id FK)
8. **Are there enum-style fields?** (status, type, category — list all values)
9. **Any audit fields needed?** (created_at, updated_at, deleted_at, created_by, etc.)
10. **Any "snapshot" fields?** (worker_name_snapshot — capture value at event time in case original changes)
11. **Any fields that must NEVER be edited by the user?** (timestamps, computed values)
12. **Soft delete or hard delete?** (keep history? allow true deletion?)
13. **Any uniqueness constraints?** (email unique globally, name unique per project, etc.)
14. **Any derived / computed fields?** (duration = out - in, total = sum of items)
15. **ID strategy?** (UUID, auto-increment, external ID, composite)

## What to extract

- Entity list → Section 5 (one subsection per entity)
- Field list per entity → Section 5 under each entity
- Relationship diagram → Section 5 (ASCII or prose)
- Enum values → Section 5 OR Section 7 (business rules)
- Immutability rules → Section 5 notes + Section 3 (principles) if critical

## Stack-agnostic rules

- ❌ Don't write "VARCHAR(200)" — write "name"
- ❌ Don't write "JSONB" — write "settings (key-value map)"
- ❌ Don't write "foreign key" — write "references X"
- ❌ Don't write "UUID DEFAULT gen_random_uuid()" — write "id (unique)"
- ✅ DO write "timestamps in UTC" as a convention
- ✅ DO note "enum values: PENDING, ACCEPTED, EXPIRED, REVOKED"
- ✅ DO describe cardinality ("one worker has many shifts")

## Red flags

- Missing audit fields on anything mutable
- No clear owner for sensitive data
- No snapshot fields when the entity references something that can be renamed/edited
- Uniqueness unclear (globally unique vs scoped unique?)
- Vague fields ("extra data") — unpack them

## Example output snippet

```markdown
## 5. Entity model

### Worker
- **Fields:** id (unique), email (unique), full_name, role (enum: ADMIN|WORKER),
  status (enum: ACTIVE|INACTIVE|DEACTIVATED), preferred_language (default: en),
  created_at, updated_at
- **Immutable to self:** full_name, role, status
- **Mutable by admin:** full_name (audited), status (audited)

### Project
- **Fields:** id, name, code (optional, unique when present), description (optional),
  start_date (optional), end_date (optional), status (enum: ACTIVE|INACTIVE|COMPLETED)
- **Cannot be hard-deleted if attendance history exists**

### Site
- **Fields:** id, project_id (references Project), name, address, status
- **Cardinality:** many Sites per Project

### Assignment (Worker↔Site)
- **Fields:** id, worker_id, site_id, status, effective_from, effective_until,
  assigned_by (admin)
- **Uniqueness:** one active assignment per (worker, site)

### Shift
- **Fields:** id, worker_id, project_id, site_id, status (enum: OPEN|COMPLETED|REQUIRES_REVIEW),
  check_in_event_id, check_out_event_id, effective_check_in_at, effective_check_out_at,
  calculated_minutes (derived)
- **Constraint:** at most one OPEN shift per worker across all sites

### AttendanceEvent
- **Fields:** id (client-generated UUID — idempotency key), shift_id, worker_id,
  worker_name_snapshot, project_id, site_id, event_type (CHECK_IN|CHECK_OUT),
  device_captured_at, photo_captured_at, timezone_offset_minutes,
  server_received_at, photo_id, location_status + optional GPS fields,
  validation_status
- **Immutable after creation** (corrections update derived Shift fields, not raw events)
```

## Diagram (optional)

```
Project 1---* Site
                |
                * (Assignment) * ---1 Worker
                                       |
                                       1---* Shift
                                              |
                                              *---* AttendanceEvent
                                                     |
                                                     1---1 Photo
```
