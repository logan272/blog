---
title: "Mermaid Cheat Sheet"
date: 2026-01-09
taxonomies:
  tags: ["tools"]
extra:
  toc: true
---

# Mermaid Cheat Sheet

I use [Mermaid](https://mermaid.js.org/) for nearly every diagram in this blog. Before Mermaid, I'd reach for Excalidraw, draw.io or others, export a PNG, and embed it. That works — until you need to tweak a label, update a color, or diff a diagram in a pull request.

Mermaid solves all of that because diagrams are just text:

- **Wide coverage** — flowcharts, sequence diagrams, state machines, ERDs, Gantt charts, and more. One syntax for almost every diagram you'd need.
- **Native rendering** — GitHub renders Mermaid in markdown files, READMEs, issues, and comments. So do most markdown editors (Typora, VsCode, Obsidian, Notion).
- **Version control friendly** — diagrams live in your markdown files. You get real diffs, real blame, real history.
- **AI friendly** — LLMs can read, generate, and edit Mermaid diagrams trivially. Try asking an LLM to "draw me a sequence diagram" and you'll get valid Mermaid on the first try.

This post is a cheat sheet — one section per diagram type, each with a quick "when to use it" and a working example.

---

## Flowchart

**When to use it:** Decision logic, process flows, any "if this then that" reasoning. The most versatile diagram type — when in doubt, start here.

```mermaid
flowchart LR
    Start[New Request] --> Auth{Authenticated?}
    Auth -->|Yes| Authz{Authorized?}
    Auth -->|No| Reject[401 Unauthorized]
    Authz -->|Yes| Process[Process Request]
    Authz -->|No| Forbidden[403 Forbidden]
    Process --> Response[200 OK]

    style Start fill:#4a9eff,color:#fff
    style Reject fill:#ff6b6b,color:#fff
    style Forbidden fill:#ff6b6b,color:#fff
    style Response fill:#51cf66,color:#fff
```

Key syntax:
- `LR` = left to right, `TB` = top to bottom
- `[text]` = rectangle, `{text}` = diamond (decision), `([text])` = stadium, `((text))` = circle
- `-->` = arrow, `-->|label|` = labeled arrow, `---` = line without arrow

### Subgraphs

Group related nodes into labeled boxes with `subgraph`. Useful for showing system boundaries, environments, or logical groupings.

```mermaid
flowchart LR
    subgraph Internet
        Client[Browser]
    end
    subgraph AWS
        ALB[Load Balancer]
        subgraph ECS Cluster
            S1[Service A]
            S2[Service B]
        end
        DB[(Database)]
    end

    Client --> ALB
    ALB --> S1
    ALB --> S2
    S1 --> DB
    S2 --> DB

    style Client fill:#4a9eff,color:#fff
    style DB fill:#ff922b,color:#fff
```

### Node Shapes

Mermaid supports a variety of node shapes beyond the basics:

```mermaid
flowchart LR
    A[Rectangle] --> B(Rounded)
    B --> C([Stadium])
    C --> D[[Subroutine]]
    D --> E[(Database)]
    E --> F((Circle))
    F --> G{Diamond}
    G --> H{{Hexagon}}
    H --> I[/Parallelogram/]
    I --> J[\Reverse Parallelogram\]
    J --> K[/Trapezoid\]
```

### Top-to-Bottom Layout

Swap `LR` for `TB` when vertical flow reads more naturally — like pipelines, waterfalls, or anything with a clear top-down progression.

```mermaid
flowchart TB
    Input[Raw Data] --> Validate{Valid?}
    Validate -->|Yes| Transform[Transform]
    Validate -->|No| DLQ[Dead Letter Queue]
    Transform --> Enrich[Enrich]
    Enrich --> Load[Load to Warehouse]

    style Input fill:#4a9eff,color:#fff
    style Load fill:#51cf66,color:#fff
    style DLQ fill:#ff6b6b,color:#fff
```

---

## Sequence Diagram

**When to use it:** API calls, service-to-service interactions, anything where the order of messages between participants matters.

```mermaid
sequenceDiagram
    participant C as Client
    participant G as API Gateway
    participant A as Auth Service
    participant O as Order Service

    C->>G: POST /orders
    G->>A: Validate token
    A-->>G: Token valid
    G->>O: Create order
    O-->>G: Order created
    G-->>C: 201 Created
```

Key syntax:
- `->>` = solid arrow (request), `-->>` = dashed arrow (response)
- `participant X as Label` = alias a participant
- `Note over A,B: text` = add a note spanning participants
- `alt` / `else` / `end` = conditional blocks
- `loop` / `end` = loops

---

## Class Diagram

**When to use it:** Data models, OOP relationships, struct/trait hierarchies. Good for documenting the shape of your domain objects.

```mermaid
classDiagram
    class Order {
        +String id
        +OrderSide side
        +Decimal price
        +Decimal quantity
        +place()
        +cancel()
    }
    class Trade {
        +String id
        +Decimal price
        +Decimal quantity
    }
    class Account {
        +String id
        +Decimal balance
        +deposit(amount)
        +withdraw(amount)
    }

    Order "1" --> "*" Trade : generates
    Account "1" --> "*" Order : places
```

Key syntax:
- `+` = public, `-` = private, `#` = protected
- `<|--` = inheritance, `*--` = composition, `o--` = aggregation, `-->` = association
- `"1" --> "*"` = multiplicity labels

---

## State Diagram

**When to use it:** State machines, lifecycle management, anything with well-defined states and transitions.

```mermaid
stateDiagram-v2
    [*] --> Pending
    Pending --> Open : accepted
    Pending --> Rejected : validation failed
    Open --> PartiallyFilled : partial match
    PartiallyFilled --> Filled : fully matched
    Open --> Filled : fully matched
    Open --> Cancelled : user cancel
    PartiallyFilled --> Cancelled : user cancel
    Filled --> [*]
    Cancelled --> [*]
    Rejected --> [*]
```

Key syntax:
- `[*]` = start/end state
- `-->` = transition, `State1 --> State2 : event` = labeled transition
- `state "Description" as S1` = named state alias
- Supports nested states with `state Parent { ... }`

---

## Entity Relationship Diagram

**When to use it:** Database schemas, table relationships, data modeling.

```mermaid
erDiagram
    USER ||--o{ ORDER : places
    ORDER ||--|{ ORDER_LINE : contains
    ORDER_LINE }|--|| PRODUCT : references
    USER {
        uuid id PK
        string email
        string name
    }
    ORDER {
        uuid id PK
        uuid user_id FK
        timestamp created_at
        enum status
    }
    PRODUCT {
        uuid id PK
        string name
        decimal price
    }
```

Key syntax:
- `||--o{` = one to zero-or-many, `||--|{` = one to one-or-many
- `}|--||` = many to one
- `PK` = primary key, `FK` = foreign key

---

## Gantt Chart

**When to use it:** Project timelines, sprint planning, any schedule-based visualization.

```mermaid
gantt
    title Project Roadmap
    dateFormat YYYY-MM-DD
    section Backend
        API Design           :done, api, 2026-01-01, 2026-01-14
        Core Implementation  :done, core, after api, 30d
        Performance Testing  :active, perf, after core, 14d
    section Frontend
        Wireframes           :done, wire, 2026-01-01, 2026-01-21
        UI Implementation    :active, ui, after wire, 45d
        Integration Testing  :int, after ui, 14d
    section Launch
        Beta Release         :milestone, beta, after perf, 0d
        GA Release           :milestone, ga, after int, 0d
```

Key syntax:
- `done`, `active`, `crit` = task status/style modifiers
- `after taskid` = dependency
- `milestone` = zero-duration milestone marker
- `30d` = duration, or use an end date

---

## Pie Chart

**When to use it:** Proportional data, distribution breakdowns, quick "share of total" visualizations.

```mermaid
pie title Request Latency Distribution
    "< 10ms" : 45
    "10-50ms" : 30
    "50-100ms" : 15
    "100-500ms" : 8
    "> 500ms" : 2
```

Key syntax:
- `pie title Title` = chart with title
- `"Label" : value` = each slice

---

## Quadrant Chart

**When to use it:** Priority matrices, effort-vs-impact analysis, any 2D comparison where you want to bucket items into four categories.

```mermaid
quadrantChart
    title Task Prioritization
    x-axis Low Effort --> High Effort
    y-axis Low Impact --> High Impact
    quadrant-1 Do First
    quadrant-2 Plan Carefully
    quadrant-3 Reconsider
    quadrant-4 Quick Wins
    Add caching: [0.3, 0.8]
    Rewrite auth: [0.9, 0.9]
    Fix typo: [0.1, 0.1]
    Add dark mode: [0.4, 0.5]
    Upgrade DB: [0.8, 0.7]
    Add logging: [0.2, 0.6]
```

Key syntax:
- `x-axis Low --> High` = axis labels
- `quadrant-1` through `quadrant-4` = quadrant labels (1 = top-right, 2 = top-left, 3 = bottom-left, 4 = bottom-right)
- `Item: [x, y]` = data points (0 to 1)

---

## XY Chart

**When to use it:** Bar charts, line charts, any data where you want to plot values against categories or a numeric axis.

```mermaid
xychart-beta
    title "Monthly Deployments"
    x-axis [Jan, Feb, Mar, Apr, May, Jun, Jul, Aug, Sep, Oct, Nov, Dec]
    y-axis "Deploys" 0 --> 50
    bar [12, 15, 18, 22, 28, 25, 30, 35, 32, 38, 42, 45]
    line [12, 15, 18, 22, 28, 25, 30, 35, 32, 38, 42, 45]
```

Key syntax:
- `x-axis [A, B, C]` = categorical axis
- `y-axis "Label" min --> max` = numeric axis with range
- `bar [...]` and `line [...]` = data series

---

## Timeline

**When to use it:** Chronological events, historical progressions, release histories.

```mermaid
timeline
    title Product Evolution
    2024 : Prototype
         : First 10 users
    2025 : Public beta
         : 1,000 users
         : Series A funding
    2026 : General availability
         : 50,000 users
         : Enterprise tier
```

Key syntax:
- `title` = chart title
- `period : event` = first event in a period
- `: event` (indented) = additional events in the same period

---

## Mind Map

**When to use it:** Brainstorming, topic hierarchies, organizing related concepts.

```mermaid
mindmap
    root((System Design))
        Compute
            Containers
            Serverless
            VMs
        Storage
            SQL
            NoSQL
            Object Storage
        Networking
            Load Balancer
            CDN
            DNS
        Observability
            Logging
            Metrics
            Tracing
```

Key syntax:
- `root((text))` = root node (circle)
- Indentation defines hierarchy
- Node shapes: `(text)` = rounded, `[text]` = square, `((text))` = circle, `)text(` = bang

---

## Git Graph

**When to use it:** Branch/merge strategies, git workflow documentation, visualizing release processes.

```mermaid
gitGraph
    commit id: "init"
    branch feature/auth
    checkout feature/auth
    commit id: "add login"
    commit id: "add logout"
    checkout main
    branch feature/api
    commit id: "add endpoints"
    checkout main
    merge feature/auth id: "merge auth"
    merge feature/api id: "merge api"
    commit id: "release v1.0" tag: "v1.0"
```

Key syntax:
- `commit id: "msg"` = commit with label
- `branch name` = create branch, `checkout name` = switch to branch
- `merge branch` = merge branch into current
- `tag: "v1.0"` = add a tag to a commit

---

## References

- [Mermaid Documentation](https://mermaid.js.org/intro/) — official docs, the definitive syntax reference
- [Mermaid Live Editor](https://mermaid.live/) — browser-based editor with instant preview, great for prototyping
- [Mermaid Syntax Cheat Sheet](https://mermaid.js.org/ecosystem/tutorials.html) — official tutorials and examples
