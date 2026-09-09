//==============================================================
// Module: guardian_fsm
// Block:  GUARDIAN (M2N-BB-05) — FSM & Protection Core
//
// Port functions:
//
//   fault_in     - Active-high signal indicating a critical fault
//                  condition detected upstream (via SENTINEL
//                  and/or COMPASS). When asserted, forces an
//                  immediate transition to PROTECTION_LATCH,
//                  overriding whatever the current state or
//                  other transition logic would otherwise do.
//                  This is the direct code-level implementation
//                  of the "a fault always wins" design
//                  philosophy from the project blueprint.
//                  TODO: confirm actual signal name/width with
//                  team — may end up as a single aggregated
//                  line from COMPASS, or multiple independent
//                  fault lines GUARDIAN must arbitrate itself.
//
//   activate_in  - One-shot trigger placeholder for the "incoming
//                  digital control line" referenced in the
//                  blueprint's Core Functional Objectives
//                  (Section 1). Asserting it while in IDLE moves
//                  GUARDIAN into ACTIVE. Once in ACTIVE, GUARDIAN
//                  stays there until either fault_in forces it to
//                  PROTECTION_LATCH, or stop_in returns it to
//                  IDLE (see stop_in below).
//                  TODO: confirm actual signal name, source
//                  block, and exact semantics with team — this
//                  is currently a design placeholder, not a
//                  confirmed interface signal.
//
//   stop_in      - One-shot trigger placeholder for a deliberate,
//                  non-fault stop request. Asserting it while in
//                  ACTIVE returns GUARDIAN to IDLE. Only has an
//                  effect in ACTIVE — ignored in every other
//                  state. Distinct from fault_in: represents an
//                  intentional, planned stop (e.g. maintenance),
//                  not a detected fault, so it does NOT route
//                  through PROTECTION_LATCH. If fault_in and
//                  stop_in are both asserted in the same cycle,
//                  fault_in wins — it's checked first in the RTL,
//                  before stop_in is ever evaluated.
//                  TODO: confirm actual signal name, source
//                  block, and exact semantics with team — this
//                  is currently a design placeholder, not a
//                  confirmed interface signal.
//==============================================================

module guardian_fsm (    // Remember to confirm every name used with the team and every other team
    input wire clk,
    input wire rst,
    input wire fault_in, // confirm actual fault signal name and width with the team
    input wire activate_in,
    input wire stop_in,   // A delibrate stop signal when in active state
    output reg [1:0] state
);
    // state encoding
    localparam RESET = 2'b00;
    localparam IDLE = 2'b01;
    localparam ACTIVE = 2'b10;
    localparam PROTECTION_LATCH = 2'b11;

    reg [1:0] next_state;

    // state transition logic
    always @(posedge clk) begin
        if (rst) 
            state <= RESET;
        else
            state <= next_state;
                 
    end

    always @(*) begin
        next_state = state; // default to current state
        if (fault_in)
            next_state = PROTECTION_LATCH;
        else begin
            case (state)
                RESET: next_state = IDLE;
                IDLE: next_state = (activate_in) ? ACTIVE : IDLE; // transition to ACTIVE if activate signal is high
                ACTIVE: next_state =  (stop_in) ? IDLE : ACTIVE; // system is active, only a fault can move it out of this state and also a stop signal
                PROTECTION_LATCH: next_state = PROTECTION_LATCH; // stay in protection latch
                default: next_state = RESET; // default case to handle unexpected states
            endcase
        end
    end
     
endmodule