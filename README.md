## SSH (Secure Shell)

The general syntax for the ssh command is `ssh [OPTIONS] [USER@]HOST [COMMAND]`. It establishes an encrypted connection to a remote system, providing secure command-line access or command execution over an insecure network.

### The Core Syntax Structure
SSH uses a simple addressing format: `user@host`. The host can be a domain name, IP address, or defined SSH alias. If no user is specified, the current local username is used.

### Basic Syntax Scenarios

**Connect to Remote Host**
```bash
ssh user@remotehost
```

**Connect with Custom Port**
```bash
ssh -p 2222 user@remotehost
```

**Execute a Single Command Remotely**
```bash
ssh user@remotehost "ls -la /var/log"
```

**Connect Using Private Key**
```bash
ssh -i ~/.ssh/mykey.pem user@remotehost
```

### Common SSH Options Cheat Sheet

| Option | Function | Syntax Example |
|--------|----------|----------------|
| `-p` | Specify custom SSH port (lowercase p) | `ssh -p 2222 user@host` |
| `-i` | Path to SSH Private Key (Identity file) | `ssh -i ~/.ssh/id_rsa user@host` |
| `-v` | Verbose mode (debug connection issues) | `ssh -v user@host` |
| `-L` | Local port forwarding | `ssh -L 8080:localhost:80 user@host` |
| `-R` | Remote port forwarding | `ssh -R 8080:localhost:80 user@host` |
| `-N` | No remote commands (for port forwarding) | `ssh -N -L 8080:host:80 user@host` |
| `-t` | Force pseudo-terminal allocation | `ssh -t user@host "sudo command"` |
| `-C` | Compress data for faster transfers | `ssh -C user@host` |
| `-o` | Pass custom SSH options | `ssh -o "ServerAliveInterval=60" user@host` |

### Crucial Things to Keep in Mind

**Authentication:** SSH supports password authentication, public-key authentication (recommended), and other methods like GSSAPI.

**Known Hosts:** The first connection to a new host will prompt you to verify its fingerprint, which is stored in `~/.ssh/known_hosts`.

**Escape Characters:** The default escape character is `~`. Use `~.` to terminate a hung session, `~?` for help.

**Configuration Files:** Global settings in `/etc/ssh/ssh_config`, user-specific in `~/.ssh/config`. These can define aliases, default users, and connection parameters.

---

## ss -tlnp (Socket Statistics)

The `ss -tlnp` command displays detailed socket statistics, showing all TCP ports that are currently listening with their associated processes.

```bash
ss -tlnp
```

### Flag Breakdown

| Flag | Meaning | Description |
|------|---------|-------------|
| `-t` | TCP | Display only TCP sockets |
| `-l` | Listening | Show only listening sockets (servers) |
| `-n` | Numeric | Show numerical addresses and port numbers (no DNS resolution) |
| `-p` | Processes | Display the process ID and name owning each socket |

### Example Output

```
State   Recv-Q  Send-Q  Local Address:Port   Peer Address:Port  Process
LISTEN  0       128     0.0.0.0:22           0.0.0.0:*          users:(("sshd",pid=1234,fd=3))
LISTEN  0       128     0.0.0.0:443          0.0.0.0:*          users:(("nginx",pid=5678,fd=6))
```

### Crucial Things to Keep In Mind

**Root Privileges:** Some information (especially process details for privileged ports <1024) requires `sudo` to display properly.

**Modern Replacement:** `ss` is the preferred modern tool over the older `netstat` command, with faster performance and more detailed output.

**Combination:** This specific combination is commonly used for security audits and identifying which services are exposed on a server.

---

## top (Process Monitor)

The `top` command provides a real-time, dynamic view of system processes, showing CPU and memory usage, running processes, and overall system load.

```bash
top
```

### Key Interactive Commands (press within top)

| Key | Function |
|-----|----------|
| `h` | Help screen |
| `q` | Quit top |
| `P` | Sort by CPU usage (highest first) |
| `M` | Sort by Memory usage (highest first) |
| `k` | Kill a process (enter PID) |
| `r` | Renice (change priority of) a process |
| `1` | Show individual CPU cores |
| `c` | Show full command line |
| `f` | Configure displayed fields |

### Understanding the Header

- **Load Average:** 1, 5, 15 minute averages — values > number of cores indicate overload
- **Tasks:** Total processes, running, sleeping, stopped, zombie
- **%CPU(s):** User, system, nice, idle, wait, hardware interrupt, software interrupt, steal time
- **MiB Mem/Swap:** Total, used, free, buffers, cached memory

### Crucial Things to Keep In Mind

**Interactive vs Batch Mode:** `top -b` runs in batch mode, useful for logging or script processing.

**User View:** `top -u username` shows only processes for a specific user.

**Refresh Rate:** Default is 3 seconds; can be changed with `-d` or by pressing `s` in interactive mode.

---

## free -h (Memory Usage)

The `free -h` command displays the system's memory usage in a human-readable format, showing total, used, free, shared, buffer/cache, and available RAM and swap space.

```bash
free -h
```

### Example Output

```
              total   used   free   shared  buff/cache   available
Mem:          7.6Gi   2.1Gi  3.2Gi  123Mi   2.3Gi        5.0Gi
Swap:         2.0Gi   0.0Gi  2.0Gi
```

### Flag Breakdown

| Flag | Meaning | Description |
|------|---------|-------------|
| `-h` | Human-readable | Shows sizes in KiB, MiB, GiB as appropriate |
| `-m` | Megabytes | Show all values in megabytes |
| `-g` | Gigabytes | Show all values in gigabytes |
| `-t` | Total | Show total line combining RAM + Swap |
| `-s` | Seconds | Continuous output with refresh interval |

### Understanding the Columns

- **total:** Total installed memory
- **used:** Used memory (calculated as total - free - buff/cache)
- **free:** Completely unused memory
- **shared:** Memory used by tmpfs (temporary filesystems)
- **buff/cache:** Memory used by kernel buffers and page cache
- **available:** Estimate of memory available for new applications (takes into account reclaimable caches)

### Crucial Things to Keep In Mind

**Available vs Free:** "Free" memory is unused, but "available" is more useful — it includes cache that can be reclaimed instantly.

**Swap Usage:** High swap usage indicates memory pressure; consider adding more RAM or investigating memory leaks.

**Buffer/Cache:** Linux uses free RAM for caching; this memory is automatically reclaimed when applications need it.

---

## df -h (Disk Space Usage)

The `df -h` command reports the amount of disk space used and available on mounted filesystems in a human-readable format.

```bash
df -h
```

### Example Output

```
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda1        40G   15G   23G  40% /
tmpfs           1.9G  1.2M  1.9G   1% /run
/dev/sdb1       500G  312G  188G  63% /data
```

### Flag Breakdown

| Flag | Meaning | Description |
|------|---------|-------------|
| `-h` | Human-readable | Shows sizes in K, M, G units |
| `-H` | Human-readable (SI) | Uses powers of 1000 (not 1024) |
| `-T` | Filesystem type | Show filesystem type (ext4, xfs, etc.) |
| `-i` | Inodes | Show inode usage instead of block usage |
| `-x` | Exclude type | Exclude specified filesystem types |
| `--total` | Total | Show grand total line |

### Crucial Things to Keep In Mind

**Tmpfs Filesystems:** Temporary filesystems (tmpfs, devtmpfs) may appear but don't represent physical disk space.

**Mount Points:** The output lists each mounted filesystem with its mount point; root (`/`) is the most critical to monitor.

**Inode Exhaustion:** Even with free space, running out of inodes (file slots) prevents creating new files. Use `df -i` to check.

**Non-Persistent Filesystems:** Some entries (like `devtmpfs`, `tmpfs`) are in-memory only and don't represent physical storage.

---

## SCP (Secure Copy Protocol)

The general syntax for the scp (Secure Copy Protocol) command is `scp [OPTIONS] SOURCE DESTINATION`. It works over an encrypted SSH connection to securely transfer files and folders between local and remote systems.

### The Core Syntax Structure
To distinguish a local path from a remote path, scp relies on a colon (`:`). Any path without a colon is treated as local.

**Remote Path Format:** `user@host:/path/to/target`
**Local Path Format:** `/path/to/target` or just `.` for the current directory

### Basic Syntax Scenarios

**Copy Local File to Remote Host**
```bash
scp /local/path/file.txt user@remotehost:/remote/path/
```

**Copy Remote File to Local Machine**
```bash
scp user@remotehost:/remote/path/file.txt /local/path/
```

**Copy Remote File to Current Local Directory**
```bash
scp user@remotehost:/remote/path/file.txt .
```

**Copy Between Two Remote Servers (via Local Machine)**
```bash
scp user1@host1:/path/file.txt user2@host2:/path/
```

### Common SCP Options Cheat Sheet

| Option | Function | Syntax Example |
|--------|----------|----------------|
| `-r` | Recursively copy whole directories | `scp -r /local/dir user@host:/remote/dir` |
| `-P` | Specify custom SSH port (Uppercase P) | `scp -P 2222 file.txt user@host:/path` |
| `-i` | Path to SSH Private Key (Identity file) | `scp -i ~/.ssh/id_rsa file.txt user@host:/path` |
| `-C` | Compresses data during transfer for speed | `scp -C file.txt user@host:/path` |
| `-p` | Preserves modification/access times and modes | `scp -p file.txt user@host:/path` |
| `-q` | Quiet mode (hides progress bar and non-errors) | `scp -q file.txt user@host:/path` |
| `-l` | Limits bandwidth usage (measured in Kbit/s) | `scp -l 5000 file.txt user@host:/path` |

### Crucial Things to Keep In Mind

**Overwriting:** scp will overwrite existing files of the same name at the destination without warning.

**Permissions:** You must possess read permissions for the source file/folder and write permissions for the destination directory.

**Wildcards:** You can use wildcards (like `*`) to copy multiple files matching a pattern (e.g., `scp *.jpg user@host:/path`).

**Security:** scp uses SSH encryption, but the `-C` flag can help speed up transfers of large or compressible data.

---

## Part of the UnitOfWork series

[@UnitOfWork-y1j](https://youtube.com/@UnitOfWork-y1j)

---

Special Thanks to Claude, Gemini and Deepseek.