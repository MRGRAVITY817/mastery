# What I learned

## Build functional core

• Build single-purpose functions
• Where possible, bring functions to data rather than bringing your data to functions.
• Name concepts with functions
• Shape functions for composition
• Build functions at a single level of abstraction
• Make decisions in function heads where possible

## Run Test Coverage

```bash
$ MIX_ENV=test mix converalls
```

## Use cases for considering using Elixir processes

- Sharing state across processes
- Presenting a uniform API for external services such as databases or communications.
- Managing side effects such as logging of file I/O
- Monitoring system-wide resources or performance metrics
- Isolating critical services from failure

## GenServer main APIs

- `init(initial_state)`: Establish a new state of GenServer. We (indirectly) invoke this every time we start server.
- `handle_call(message, from, state) -> {:reply, message_to_client, new_state}`: Handle synchronous Two-way message (like a phone _call_).
- `handle_cast(message, state) -> {:noreply, new_state}`: One-way asynchronous message handler (like pod*cast*).
