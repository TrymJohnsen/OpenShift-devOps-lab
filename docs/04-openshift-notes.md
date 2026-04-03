# OpenShift notes (interview-focused)

## Kubernetes vs OpenShift (what I would expect in a team)
- OpenShift is Kubernetes + opinionated defaults + integrated platform capabilities (auth, routing, build, operators, security constraints).
- I expect most day-2 to be: debugging, rollouts, RBAC, image management, routes/ingress, and GitOps.

## Projects / Namespaces
- OpenShift "Project" is essentially a Kubernetes namespace plus OpenShift-specific metadata and workflows.
- Team separation: one project per env/team/app, with RBAC per project.

## Routes vs Ingress
- In OpenShift I would typically expose HTTP(S) via Route (and use Ingress/IngressController concepts depending on setup).
- I would document: hostnames, TLS termination type, and ownership.

## SCC (Security Context Constraints)
- OpenShift commonly runs with stricter security defaults (non-root, restricted permissions).
- If a container fails due to permissions, I would first check:
  - Pod security context, container user, volume permissions
  - SCC/PSA restrictions (depending on cluster version/policy)
  - Image build best practices (avoid root assumptions)

## RBAC
- Principle of least privilege:
  - devs can deploy into their project
  - only platform/admin can change cluster-wide resources
- Typical debugging: "Forbidden" errors -> check RoleBindings/ClusterRoleBindings.

## GitOps (concept)
- Desired state in Git; cluster syncs continuously (e.g., Argo CD).
- Benefits: audit trail, repeatability, rollbacks, environment consistency.
