# fpga-env
Personal dev container and neovim configuration for RTL development. Comes packaged open-source tools for RTL verification such as cocotb, verilator, and symbiyosys 

# Mounting the University Cadence Installation with SSHFS

This guide mounts the university's `/proj/cad` directory locally using SSHFS, allowing Cadence tools and setup scripts to be accessed as if they were installed on the local machine.

## Prerequisites

* Linux host
* SSH access to the university server
* `sudo` privileges

---

## A. Install SSHFS

### Ubuntu/Debian

```bash
sudo apt update
sudo apt install sshfs
```

Verify the installation:

```bash
sshfs --version
```

---

## B. Create the Mount Point

Create the directory expected by the Cadence environment scripts:

```bash
sudo mkdir -p /proj/cad
```

---

## C. Mount `/proj/cad`

Run:

```bash
sudo sshfs \
  ebw220000@giant.utdallas.edu:/proj/cad \
  /proj/cad \
  -o ro \
  -o allow_other \
  -o default_permissions \
  -o reconnect \
  -o ServerAliveInterval=15 \
  -o ServerAliveCountMax=3 \
  -o cache=yes \
  -o kernel_cache \
  -o attr_timeout=3600 \
  -o entry_timeout=3600 \
  -o negative_timeout=60 \
  -o compression=no
```

Replace `<netid>` with your university NetID.

---

## D. Verify the Mount

Check that the mount is active:

```bash
mount | grep /proj/cad
```

List the directory contents:

```bash
ls /proj/cad
```

If successful, the Cadence installation should be visible.

---

## E. Source the Cadence Environment

Run the appropriate environment setup script provided by the university, for example:

```bash
source /proj/cad/<path-to-setup-script>
```

Because the filesystem is mounted at `/proj/cad`, any hard-coded paths inside the setup scripts should work without modification.

---

## F. Unmount

When finished:

```bash
sudo umount /proj/cad
```

or, if necessary:

```bash
sudo fusermount -u /proj/cad
```

---

## Notes

* The mount is **read-only**, preventing accidental modification of the university's shared installation.
* Metadata caching (`attr_timeout` and `entry_timeout`) significantly improves responsiveness for interactive use.
* This setup works well for accessing the Cadence installation while keeping your RTL repository local or mounting your project separately.
* If using Docker, bind-mount the directory into the container:

```bash
docker run \
  -v /proj/cad:/proj/cad:ro \
  ...
```

This preserves the expected `/proj/cad` path inside the container.

 
