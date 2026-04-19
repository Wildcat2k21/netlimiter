# Simple net limiter for linux

Support sapparate edit for upload / download speed

**create a script "net-limiter.sh", and insert content from `net-limiter.sh` fallow repository**

```bash
nano /usr/local/bin/net-limiter.sh
```

**make it executable**
```bash
chmod +x /usr/local/bin/net-limiter.sh
```

Done! How to use:

netlimit <iface> <down_mbit> <up_mbit>"
netlimit <iface> off"
netlimit <iface> status"

Notice: `netlimit <iface> <down_mbit> <up_mbit>`, you can check `iface` with `ip addr show`. For example `ens3` or wl0;

