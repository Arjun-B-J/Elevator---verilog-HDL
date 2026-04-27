# Elevator --- Verilog HDL

A group project implementing a dual-elevator controller in Verilog HDL. Two
elevators serve a 7-floor building using two different scheduling strategies,
along with a power-saving motor model, a temperature-controlled fan, and a
seven-segment floor display. An Arduino + Python pipeline supplies real
temperature readings from an LM35 sensor as stimulus input.

## What's modeled

The top-level module `main_` wires together the following submodules:

- **`Elevator_algorithm`** -- elevator 1. Sweep-style scheduler: serves all
  pending requests in the current direction (up or down) before reversing.
- **`Short_distance_algorithm`** -- elevator 2. Picks the nearest pending
  request to the current floor regardless of direction.
- **`powersavingmotor`** -- selects motor power level 1-5 based on the
  current cabin weight (0-200, 200-400, 400-600, 600-800, 800+).
- **`temperature_controlled_fan`** + **`fanrpm_control`** -- sets fan speed
  (1/2/3) and RPM (100/200/300) from an 8-bit temperature input.
- **`seven_segment_display`** -- decodes the 3-bit floor number to a 7-bit
  seven-segment pattern.

Both elevator modules support 7 floors (3-bit floor IDs), an 11-bit weight
input, and an over-weight cutoff at >900 (lift halts and signals
`over_weight` until the load drops). Each elevator reports current floor,
direction (0 idle / 1 up / 2 down), completion flag, and a turnover counter
for comparing scheduler efficiency between the two algorithms.

## Files

- `final.v` -- all synthesizable modules (top-level + the six submodules
  above).
- `stim_final.v` -- testbench (`aastim_final`) that drives a clock, applies
  several request scenarios (normal, overweight, scheduler-comparison), and
  reads `temp_readings.log` for temperature stimulus.
- `FINAL/final_v3.v`, `FINAL/stim_final.v` -- a later revision of the
  design and testbench.
- `tempsensor_arduino.ino/tempsensor_arduino.ino.ino` -- Arduino sketch:
  reads an LM35 on analog pin 7 and prints the scaled temperature over
  serial at 9600 baud.
- `temp_sensor.py` -- Python script that opens `/dev/ttyACM1`, reads the
  Arduino's serial output, and writes values to `temp_readings.log`.
- `temp_readings.log` -- sample temperature log consumed by the testbench
  via `$fopen` / `$fscanf`.
- `DOCUMENTATION.docx` -- group project documentation.

## Simulating

Any Verilog simulator that supports Verilog-2001 file I/O (`$fopen`,
`$fscanf`) will work. With Icarus Verilog:

```bash
iverilog -o elevator final.v stim_final.v
vvp elevator
```

To use the temperature pipeline live, flash
`tempsensor_arduino.ino/tempsensor_arduino.ino.ino` to an Arduino with an
LM35 wired to A7, then run `python temp_sensor.py` to populate
`temp_readings.log` before/while simulating. Otherwise the existing log
file is used as stimulus.

The testbench includes several commented request sequences (normal,
overweight, and scenarios that highlight the turnover difference between
the two scheduling algorithms) -- uncomment whichever you want to run.
