#!/bin/bash

PRINTER=$(sudo docker exec -t print-server-cups-1 /usr/lib/cups/backend/usb | grep '^direct\s')
PRINTER_URI=$(echo $PRINTER | grep -Po 'direct\s\K[^\s]*(?=\s)')
PRINTER_DESCRIPTION=$(echo $PRINTER | grep -Po 'direct\s[^\s]*\s"\K[^"]*(?=")')
PRINTER_NAME=$(echo $PRINTER_DESCRIPTION | sed -e 's/[^a-zA-Z0-9-]/_/g')
lpinfo -m | grep "<Printer model>"
PRINTER_DRIVER="gutenprint.5.3://brother-hl-5140/expert"
sudo docker exec print-server-cups-1 lpadmin -p "$PRINTER_NAME" -D "$PRINTER_DESCRIPTION" -v "$PRINTER_URI" -m "$PRINTER_DRIVER" -o printer-is-shared=true
sudo docker exec print-server-cups-1 cupsenable "$PRINTER_NAME"
sudo docker exec print-server-cups-1 cupsaccept "$PRINTER_NAME"
