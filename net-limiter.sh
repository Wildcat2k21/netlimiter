#!/bin/bash

set -e

usage() {
  echo "Usage:"
  echo "  netlimit <iface> <down_mbit> <up_mbit>"
  echo "  netlimit <iface> off"
  echo "  netlimit <iface> status"
  exit 1
}

IF=$1
DOWN=$2
UP=$3

[ -z "$IF" ] && usage

# STATUS
if [ "$DOWN" = "status" ]; then
  tc qdisc show dev $IF
  tc qdisc show dev ifb0 2>/dev/null || true
  exit 0
fi

# OFF
if [ "$DOWN" = "off" ]; then
  tc qdisc del dev $IF root 2>/dev/null || true
  tc qdisc del dev $IF ingress 2>/dev/null || true
  tc qdisc del dev ifb0 root 2>/dev/null || true
  ip link delete ifb0 2>/dev/null || true
  echo "Limits cleared on $IF"
  exit 0
fi

[ -z "$DOWN" ] || [ -z "$UP" ] && usage

# очистка
tc qdisc del dev $IF root 2>/dev/null || true
tc qdisc del dev $IF ingress 2>/dev/null || true
tc qdisc del dev ifb0 root 2>/dev/null || true
ip link delete ifb0 2>/dev/null || true

# загрузка IFB
modprobe ifb || true
ip link add ifb0 type ifb 2>/dev/null || true
ip link set ifb0 up

# ingress redirect (download)
tc qdisc add dev $IF handle ffff: ingress
tc filter add dev $IF parent ffff: \
  protocol ip u32 match u32 0 0 \
  action mirred egress redirect dev ifb0

# лимиты
tc qdisc add dev ifb0 root cake bandwidth ${DOWN}mbit
tc qdisc add dev $IF root cake bandwidth ${UP}mbit

echo "Limit set on $IF: DOWN=${DOWN}mbit UP=${UP}mbit"
