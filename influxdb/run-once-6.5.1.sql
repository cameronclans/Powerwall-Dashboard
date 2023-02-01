# DDL
# Powerwall-Dashboard v6.5.1
# 
# Version 6.5.1 moved from using METER_X_VLxN to ISLAND_VLxN_Main for Grid Voltage. This script
# will transfer the METER_X_VLxN data to ISLAND_VLxN_Main and will resample the raw data.
# This only needs to run once.
#
# docker exec --tty influxdb sh -c "influx -import -path=/var/lib/influxdb/run-once-6.5.1.sql"
#
# USE powerwall
CREATE DATABASE powerwall
# Use METER data from vitals as ISLAND data to fill history
SELECT METER_X_VL1N AS ISLAND_VL1N_Main, METER_X_VL2N AS ISLAND_VL2N_Main, METER_X_VL3N AS ISLAND_VL3N_Main INTO powerwall.vitals.:MEASUREMENT FROM (SELECT METER_X_VL1N, METER_X_VL2N, METER_X_VL3N FROM powerwall.vitals.http)
# User current ISLAND from raw data - same as cq_vitals7
SELECT mean(ISLAND_VL1N_Main) AS ISLAND_VL1N_Main, mean(ISLAND_VL2N_Main) AS ISLAND_VL2N_Main, mean(ISLAND_VL3N_Main) AS ISLAND_VL3N_Main INTO powerwall.vitals.:MEASUREMENT FROM (SELECT ISLAND_VL1N_Main, ISLAND_VL2N_Main, ISLAND_VL3N_Main FROM powerwall.raw.http) GROUP BY time(15s), month, year fill(linear)
