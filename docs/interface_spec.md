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
