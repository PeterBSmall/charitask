# ChariTask Platform Core

The Platform Core contains the fundamental concepts and services
shared across the entire ChariTask ecosystem.

## Areas

### Authorization
Roles, permissions, permission tiers, and authorization relationships.

### Identity
Identity and account concepts associated with a person.

### Organization
The organization as the top-level operating entity.

### People
The canonical person model and person-related capabilities.

### Workspace
Workspace structure and workspace-level context.

### Groups
Groups within a workspace and their default operating context.

### Memberships
Historical and active relationships connecting people to
workspaces and groups.

## Rule

Platform Core concepts are shared infrastructure.

Suites may use the Platform Core, but Platform Core must not depend
on individual suites.