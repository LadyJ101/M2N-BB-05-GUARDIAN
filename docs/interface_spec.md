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
| rst | Input | 1 | Manual reset that clears the protection latch |
| activate_in | Input | 1 | Requests transition from IDLE to ACTIVE |
| stop | Input | 1 | Requests transition from ACTIVE to IDLE |
| fault_in | Input | 1 | Emergency fault signal from SENTINEL |
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
| 2 | rst | Input | 1 |
| 3 | activate_in | Input | 1 |
| 4 | stop | Input | 1 |
| 5 | fault_in | Input | 1 |
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
- `fault_in` is supplied by the SENTINEL comparator block.
- `state_out` is intended for monitoring by the VOICE digital I/O block.

## Clocking Rule

GUARDIAN is a synchronous digital block.

- All state transitions occur on the rising edge of `clk`.
- Inputs (`activate_in`, `stop`, `fault_in`, and `rst`) must be stable before the rising edge.
- Outputs update after the state register captures the new state.

## Input Timing Specification

| Signal | Sampled On | Function |
|---|---|---|
| activate_in | Rising edge | Requests ACTIVE state |
| stop | Rising edge | Requests IDLE state |
| fault_in | Rising edge | Forces PROTECTION state |
| rst | Rising edge | Clears protection latch |

**Important:** `fault_in` has the highest priority. If `fault_in = 1` and `activate_in = 1` at the same clock edge, GUARDIAN enters PROTECTION.

## Output Timing Behavior

| Current State | Motor | Alarm |
|---|---|---|
| RESET | 0 | 0 |
| IDLE | 0 | 0 |
| ACTIVE | 1 | 0 |
| PROTECTION | 0 | 1 |

## Timing Notes

- GUARDIAN samples inputs only on the rising edge of `clk`.
- `fault_in` has priority over `activate_in` and `stop`.
- `rst` is the only legal method of leaving the PROTECTION state.
- Outputs reflect the current FSM state immediately after the state register updates.

## Inter-Block Connectivity

| Signal | Connected Block | Relationship |
|---|---|---|
| clk | PULSE (M2N-BB-03) | GUARDIAN receives system clock from PULSE |
| fault_in | SENTINEL | GUARDIAN receives emergency fault signal from SENTINEL |
| state_out | VOICE | VOICE monitors GUARDIAN's current FSM state |
| rst | External / Manual | Manual reset clears the protection latch |
| activate_in, stop | External Control | Requests state transitions between IDLE and ACTIVE |

## Fault Priority

`fault_in` has the highest priority of any input signal.

If `fault_in` returns to 0, GUARDIAN **remains in PROTECTION**. A `rst` is required to leave PROTECTION — this is the only legal recovery path.

## Interface Rules

- Inputs are sampled only on the rising edge of `clk`.
- `fault_in` overrides `activate_in` and `stop` if asserted on the same clock edge.
- `rst` is the sole mechanism for clearing the PROTECTION latch.
- Outputs (`motor`, `alarm`, `state_out`) update immediately after the state register captures the new state.
- Signal names, widths, and directions defined in this document are frozen and must be used identically across RTL, Verification, and Documentation.

## Revision History

| Version | Status | Description |
|---|---|---|
| v0.1 | Draft | Initial interface definition |
| v0.2 | Reviewed | Pinout and timing information added |
| v0.3 | Reviewed | Inter-block connectivity added |
| v1.0 | RELEASED | Final interface specification |
| v1.1 | Reviewed | Renamed `reset`→`rst`, `fault`→`fault_in`, `start`→`activate_in` for naming consistency |
