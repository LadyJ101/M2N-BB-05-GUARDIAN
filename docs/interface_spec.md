# GUARDIAN Interface Specification

**Block Code:** M2N-BB-05
**Module Name:** guardian
**Block Type:** Digital Finite State Machine (FSM) & Protection Core

## Purpose

GUARDIAN is a reusable digital safety controller that manages operating states (RESET, IDLE, ACTIVE and PROTECTION) and latches critical faults until a verified reset signal is received.

## External Signal Table

| Signal | Direction | Width | Purpose |
|---|---|---|---|
| clk | Input | 1 | System clock from PULSE block |
| reset | Input | 1 | Manual reset that clears the protection latch |
| start | Input | 1 | Requests transition from IDLE to ACTIVE |
| stop | Input | 1 | Requests transition from ACTIVE to IDLE |
| fault | Input | 1 | Emergency fault signal from SENTINEL |
| motor | Output | 1 | Motor enable control signal |
| alarm | Output | 1 | Activates the system alarm during PROTECTION |
| state_out | Output | 2 | Encoded current FSM state for VOICE block |

## State Encoding

| State | Binary | Meaning |
|---|---|---|
| RESET | 00 | Initial system state |
| IDLE | 01 | Waiting for start command |
| ACTIVE | 10 | Normal operating mode |
| PROTECTION | 11 | Latched emergency state |


## Pin Numbering Table

| Pin No. | Signal | Direction | Width |
|---|---|---|---|
| 1 | clk | Input | 1 |
| 2 | reset | Input | 1 |
| 3 | start | Input | 1 |
| 4 | stop | Input | 1 |
| 5 | fault | Input | 1 |
| 9 | motor | Output | 1 |
| 10 | alarm | Output | 1 |
| 11 | state_out[1] | Output | 1 |
| 12 | state_out[0] | Output | 1 |

**Note:** Pins 6–8 and 13–16 are reserved for future expansion or power pins (VCC/GND) depending on the final chip integration.

## state_out Bus Explanation

`state_out` is a 2-bit signal, so it occupies two physical pins (pin 11 and pin 12).

| State | Bit 1 (pin 11) | Bit 0 (pin 12) |
|---|---|---|
| RESET | 0 | 0 |
| IDLE | 0 | 1 |
| ACTIVE | 1 | 0 |
| PROTECTION | 1 | 1 |

This allows the VOICE block to read the FSM state directly.

## Signal Direction Rules

- All input signals are driven by external blocks.
- All output signals are driven only by GUARDIAN.
- `clk` is supplied by the PULSE timing block.
- `fault` is supplied by the SENTINEL comparator block.
- `state_out` is intended for monitoring by the VOICE digital I/O block.
