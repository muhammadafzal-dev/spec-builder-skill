# Category 2 — Roles & Permissions

Purpose: identify every distinct user type and what each can/can't do.

## Questions to ask

1. **List every type of user.** Be exhaustive. E.g. Admin, Worker, Guest, Reviewer, Approver, Auditor.
2. **For each role, what's their primary job in the product?**
3. **Who creates each role?** (self-register, admin-invited, auto-provisioned)
4. **Can someone have multiple roles?** (e.g. a manager who is also an employee)
5. **Is there role hierarchy?** (admin > manager > user, or flat?)
6. **What's the authority model?**
   - Role-based (RBAC) — permissions flow from role
   - Attribute-based (ABAC) — permissions flow from attributes
   - Resource-level — permissions per specific resource (project, document)
   - Hybrid?
7. **For every action in the product, which roles can do it?** Build a role × capability matrix.
8. **Can permissions change mid-session?** (e.g. revoked while using the app — what happens?)
9. **Are there any "super" permissions?** (break-glass admin, auditor read-all)
10. **Do any roles see data that others don't?** (e.g. workers see own data; admins see all)
11. **Shared devices?** If yes — must auth prevent data leaks between accounts?
12. **Session timeout rules per role?** (admins strict, workers lenient, etc.)
13. **Any role that requires elevated verification?** (2FA for admin, biometric for finance)

## What to extract

- Role list → Section 2 definitions
- Capability × role matrix → Section 2 table
- Authority model statement → Section 2.1
- Session rules → Section 10 (security)
- Elevated-access requirements → Section 10 (security)

## Red flags to probe

- "Just admin and user" — probe harder. Reviewers? Approvers? Auditors? Guests?
- "Admin can do everything" — bad default. Probe what they shouldn't do.
- "Permissions are complicated" — unpack it. Draw the matrix.
- No answer for "what happens if revoked mid-session" — must define.

## Example output snippet

```markdown
## 2. Roles and permissions

| Capability | Admin | Worker |
|---|---|---|
| Invite/revoke employees | Yes | No |
| Manage projects/sites | Yes | No |
| Assign workers to sites | Yes | No |
| View all attendance/photos | Yes | No |
| View own attendance | Yes | Yes |
| Check in/out at assigned sites | No | Yes |
| Correct attendance (audited) | Yes | No |
| View reports and exports | Yes | No |

### 2.1 Authority model

Role-based (RBAC) with resource-level checks for workers. A worker may only
act on sites explicitly assigned to them by an admin. Backend enforces on every
endpoint; frontend filtering is not a security boundary.

### 2.2 Roles

- **Admin:** Client staff managing the workforce. Invites workers, maintains
  projects/sites/assignments, reviews attendance, corrects errors, exports.
- **Worker:** Construction site worker or subcontractor. Checks in/out at
  assigned sites with a photograph.
```
