# Simple net limiter for linux

Support sapparate edit for upload / download speed

**create a script "netlimit", and insert content from `netlimit` fallow repository**

```bash
nano /usr/local/bin/netlimit
```

**make it executable**
```bash
chmod +x /usr/local/bin/netlimit
```

Done! How to use:

netlimit <iface> <down_mbit> <up_mbit>"
netlimit <iface> off"
netlimit <iface> status"

Notice: `netlimit <iface> <down_mbit> <up_mbit>`, you can check `iface` with `ip addr show`. For example `ens3` or `wl0`.
You can use speedtest-cli for work checking;

## For permanent work

create a simple service which will starts with system:

```bash
nano /etc/systemd/system/netlimit.service
```

insert:

```bash
[Unit]
Description=Network bandwidth limit
After=network-online.target
Wants=network-online.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/netlimit ens3 30 10 #download and upload, for example 30 and 10
RemainAfterExit=true

[Install]
WantedBy=multi-user.target
```

turn on:

```bash
systemctl daemon-reload
systemctl enable netlimit
systemctl start netlimit
```

final check:

```bash
systemctl status netlimit
```

done!

