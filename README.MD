# Kubernetes small playground

This playgroud it will implement the following scenario

## Nodes Configuration and Roles

- 1 Master Node
- 6 Worker Nodes

Those nodes it will be splitted between:

- Development
- Quality
- Production

For each type it will exists a taint to block not only by the life cycle but for the target too(frontend/backend)

For instance:

| Node         | Development State | Target   |
| ------------ | ----------------- | -------- |
| kind-worker  | Development       | Frontend |
| kind-worker2 | Development       | Backend  |
| kind-worker3 | Quality           | Frontend |
| kind-worker4 | Quality           | Backend  |
| kind-worker5 | Production        | Frontend |
| kind-worker6 | Production        | Backend  |

## Services Implementation

- Prometheus Stack
- Dummy WebServer
- Dummy Busybox
