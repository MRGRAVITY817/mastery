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

Normally we won't use `handle_cast`, since it doesn't handle back pressure.  
Each Elixir process has a message queue. We’ll call it the **mailbox**. Unlike a physical mailbox, Elixir processes only receive messages from it; they don’t send from the mailbox. Like a true mailbox, if the receiving process for a given message is struggling, the mailbox can overflow, often leading to severe problems that are hard to debug.

So for the most of the time, use `handle_call`!

## How do we check if the server is stopped?

Try `Process.alive? session`.

## Three main pieces of lifecycle

- GenServer
- Supervisor
- Configuration

### Steps to implement good lifecycle in Elixir project

- Define which types of processes we need.
- Define how many of each process we need.
- Tell supervisor to start/stop our working processes in an organized/repeated way.
- Name & register processes, so that supervisors can find/use/revive them.
- Establish a hierarchy of parent-child supervisors.

### How to explicitly use supervisor?

```
# Start QuizManager supervisor
iex(1)> {:ok, sup_pid} = Supervisor.start_link(
  [%{id: Mastery.Boundary.QuizManager,
     start: { Mastery.Boundary.QuizManager, :start_link, [[ ]]}}],
              [strategy: :one_for_one, name: TestSupervisor])

{:ok, #PID<0.144.0>}

# Stop supervisor
iex(2)> Supervisor.stop(TestSupervisor)

:ok

# Examine the supervisor's policies
iex(3)> Mastery.Boundary.QuizManager.child_spec([name: Mastery.Boundary.QuizManager])

%{
  id: Mastery.Boundary.QuizManager,
  start: {Mastery.Boundary.QuizManager, :start_link,
   [[name: Mastery.Boundary.QuizManager]]}
}
```

### Dynamic supervisor.

To create process for incoming users, use **dynamic supervisor**.  
We don't know how much users will visit, so we have to create processes _dynamically_.

These are the requirements for using dynamic supervisor.

- You must provide a child spec, the description for how to start and restart processes.
- The GenServer you're starting must have a `start_link`.
- You need a strategy for naming and accessing the process.
- You must register your dynamic supervisor, perhaps in `application.ex`.
