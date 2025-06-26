# Socat `kubectl` Shell Interaction Manual

This guide explains how to use `socat` to create a stable, non-binding shell session into a Kubernetes container using `kubectl exec`. This is useful for maintaining a persistent shell even if the client-side connection is interrupted.

## Overview

The setup involves two `socat` processes:

1.  **Server-Side:** A `socat` process on your machine that listens on a TCP port. When a connection is made, it executes a `kubectl exec` command to open a shell in the target container.
2.  **Client-Side:** A second `socat` process that connects to the server-side listener and creates a local pseudo-terminal (PTY) device. You interact with this PTY to control the shell in the container.

---

## Step 1: Start the Server-Side Listener

Open a terminal and run the following command. This will start a `socat` process listening on port 9000.

```bash
socat -d -d TCP-LISTEN:9000,reuseaddr,fork EXEC:'kubectl exec -it -n <your-namespace> <your-pod-name> -- /bin/bash',pty,stderr
```

**Command Breakdown:**

*   `socat -d -d`: Enables verbose logging to see what's happening.
*   `TCP-LISTEN:9000`: Listens for incoming TCP connections on port 9000.
*   `reuseaddr`: Allows `socat` to reuse the port immediately after it's closed.
*   `fork`: Creates a new process for each incoming connection, allowing multiple simultaneous sessions.
*   `EXEC:'...'`: The command to execute upon connection.
    *   `kubectl exec -it -n <namespace> <pod> -- /bin/bash`: The standard command to get an interactive shell in a pod. **Remember to replace `<your-namespace>` and `<your-pod-name>`**.
*   `pty`: Allocates a pseudo-terminal for the `kubectl` session.
*   `stderr`: Forwards the standard error from the `exec` command.

---

## Step 2: Start the Client-Side Connector

In a **second terminal**, run this command to connect to the listener you just started:

```bash
socat -d -d PTY,raw,echo=0 TCP:localhost:9000
```

**Command Breakdown:**

*   `PTY,raw,echo=0`: Creates a local pseudo-terminal (PTY) device, puts it in "raw" mode (to pass all characters through), and disables local echo. This gives you a clean shell experience.
*   `TCP:localhost:9000`: Connects to the `socat` listener on `localhost` port 9000.

When you run this command, `socat` will print log messages to this terminal. Among them will be the path to the new PTY device it has created. It will look something like this:

```
2025/06/26 19:53:12 socat[229441] N PTY is /dev/pts/7
```

---

## Step 3: Interact with the Shell

The path from the log (`/dev/pts/7` in the example above) is the "file" you will use to interact with the container's shell.

You can now read from and write to this device file from any other terminal. For a simple, direct interaction, you can use another `socat` instance or simply `cat` and `echo`:

**To see output from the shell:**

```bash
cat /dev/pts/7
```

**To send commands to the shell (run in a different terminal):**

```bash
# Run a single command
echo "ls -l /" > /dev/pts/7

# Start an interactive session (anything you type will be sent)
cat > /dev/pts/7
```

### Finding the PTY Device Later

If you lose the initial log message, you can find the correct PTY device by inspecting the running `socat` client process.

1.  Find the Process ID (PID) of the client `socat` process.
    ```bash
    ps aux | grep "socat -d -d PTY" | grep -v grep
    ```

2.  Use `lsof` (list open files) with that PID to see which PTY it has open.
    ```bash
    # Replace <PID> with the PID from the previous command
    lsof -p <PID> | grep /dev/pts
    ```
    The output will show both the controlling terminal and the created PTY. The one you want is the one with the higher number, which is the one created by the `PTY` option.
