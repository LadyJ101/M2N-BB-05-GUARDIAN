# 🛡️ M2N-BB-05: GUARDIAN (FSM & Safety Core)

> **Micro2Nano (M2N) Building Block Specification**  
> **Block Codename:** GUARDIAN (`M2N-BB-05`)  
> **Block Type:** Digital Finite State Machine (FSM) & Protection Latch Core  
> **Target Application Domains:** Energy Systems, Agriculture & Water Management, Infrastructure, Security  

---

## 📌 Executive Summary & Design Philosophy

**GUARDIAN** serves as the reusable, general-purpose decision and safety enforcement engine for the Micro2Nano chip architecture. Rather than building a single end-user application, the team is engineering a configurable, robust Finite State Machine core that downstream teams can synthesize to control their specific hardware modules.

### 🔴 Critical Design Philosophy: Fault Latching
> *Detecting an error condition is only half the battle. If a solar battery overcharges, a pump runs dry, or an intrusion sensor trips, the system must **never** silently recover and repeat a failure loop. **GUARDIAN** intercepts critical faults, immediately forces the chip into a safe state, and latches it locked until an explicit reset signal is verified.*

---

## 🏗️ Project Architecture & Workflow

The entire design, implementation, verification, and documentation pipeline is mapped below. Save the architectural diagram image to `docs/architecture_workflow.png` in this repository to view it inline.

![GUARDIAN Architecture & Workflow Guide](architecture_workflow.png)

### Workflow Stage Breakdown

| Stage | Focus Area | Key Output / Deliverables | Primary Tooling |
| :--- | :--- | :--- | :--- |
| **Stage 1: Design Spec & Architecture** | FSM State Definition, Pinout Spec, Timing Specs | State Diagrams, `docs/interface_spec.md`, Timing Charts | Draw.io, WaveDrom, Google Docs |
| **Stage 2: Implementation (RTL)** | Synthesizable Verilog FSM & Protection Logic | `rtl/guardian_fsm.v` | VS Code + **TerosHDL Extension** |
| **Stage 3: Verification & Simulation** | Testbench Execution, Signal Timing & Waveform Analysis | `tb/tb_guardian_fsm.v`, `.vcd` files | Icarus Verilog (`iverilog`), GTKWave |
| **Stage 4: Documentation & Review** | Specification Finalization & Mentorship Defense Deck | Project Presentation, Updated Specifications | Markdown, Google Slides |
| **Integration Layer** | Version Control & Real-time Collaboration | Branching, Pull Requests, Live Pairing | GitHub, VS Code Live Share |

---

## 🔌 Inter-Block Connectivity Matrix

GUARDIAN operates as the central hub connecting the five other Micro2Nano shared building blocks:

| Connected Block | Block ID | Interface Function in Relation to GUARDIAN |
| :--- | :--- | :--- |
| **Comparator (SENTINEL)** | `M2N-BB-01` | Drives immediate high-priority fault triggers into FSM state transition inputs. |
| **Voltage Reference (ANCHOR)** | `M2N-BB-02` | Provides stable baseline references to SENTINEL to ensure accurate FSM state switching. |
| **Timer / Oscillator (PULSE)** | `M2N-BB-03` | Supplies system clocking, debounce delays, timeout enforcement, and timed state windows. |
| **Aggregator (COMPASS)** | `M2N-BB-04` | Bundles multi-channel sensor lines into a prioritized status word for FSM decisions. |
| **Digital I/O (VOICE)** | `M2N-BB-06` | Reads output state signals from GUARDIAN to display status to external MCUs or displays. |

---

## 📁 Repository Directory Structure

```text
M2N-BB-05-GUARDIAN/
├── docs/
│   ├── architecture_workflow.png   # Architectural & workflow guide diagram
│   └── interface_spec.md           # Pinout definitions & signal timing rules
├── rtl/
│   └── guardian_fsm.v              # Synthesizable Verilog HDL module
├── tb/
│   └── tb_guardian_fsm.v           # Verification testbench file
├── sim/
│   └── (ignored)                   # Generated GTKWave waveform dumps (.vcd)
├── scripts/
│   └── run_sim.bat / run_sim.sh    # Quick compilation & execution scripts
├── .gitignore                      # Prevents tracking compiled binary/waveform artifacts
└── README.md                       # Master project overview & onboarding guide
```

---

## 👥 Team Roles & Tooling Matrix

| Role | Primary Responsibilities | Core Tools Used |
| :--- | :--- | :--- |
| **Lead Architect (Team Lead)** | System integration oversight, timeline tracking, mentor alignment, pull request approvals | GitHub, VS Code, Live Share |
| **RTL Design Lead** | Writing synthesizable Verilog for FSM state registers, next-state logic, & protection latches | VS Code + **TerosHDL**, Git |
| **Interface Spec Lead** | Pinout specification, signal timing definitions, and configuration register design | Draw.io, WaveDrom, Markdown |
| **Verification Lead** | Writing comprehensive testbenches, edge-case fault injection, waveform verification | Icarus Verilog, GTKWave |
| **Documentation & Diagram Lead** | FSM state diagrams, timing charts, project documentation, final presentation deck | Draw.io, WaveDrom, Google Docs |

---

## 🛠️ Toolchain Setup & Environment

Our team relies on a 100% free and open-source EDA toolchain. Ensure all software is installed before starting development:

1. **Integrated Development Environment (IDE):**
   * Download and install **[VS Code](https://code.visualstudio.com/)**.
2. **HDL Extension (VS Code):**
   * Open VS Code Extensions (`Ctrl+Shift+X` or `Cmd+Shift+X`).
   * Search for **TerosHDL** and click **Install**.
   * *Features used:* Verilog linting, code completion, syntax highlighting, and visual FSM viewer.
3. **Simulation Engine:**
   * Install **Icarus Verilog (`iverilog`)** for compiling Verilog RTL and testbenches.
4. **Waveform Viewer:**
   * Install **GTKWave** for inspecting timing diagrams and output signals (`.vcd` files).
5. **Real-time Collaboration:**
   * Install **VS Code Live Share** extension for active co-coding and debugging sessions.

---

## 🚀 Getting Started (Quickstart for Teammates)

### 1. Clone the Repository
Open your terminal or PowerShell and run:
```bash
git clone [https://github.com/LadyJ101/M2N-BB-05-GUARDIAN.git](https://github.com/LadyJ101/M2N-BB-05-GUARDIAN.git)
cd M2N-BB-05-GUARDIAN
```

### 2. Run Simulation (Local Verification)
To compile and execute the testbench using Icarus Verilog:

**On Windows (PowerShell) / Linux / macOS:**
```bash
# Compile RTL and Testbench
iverilog -o sim/guardian_sim.vvp rtl/guardian_fsm.v tb/tb_guardian_fsm.v

# Run Simulation to generate VCD waveform
vvp sim/guardian_sim.vvp

# Open Waveform in GTKWave
gtkwave sim/guardian_tb.vcd
```

### 3. Git Workflow Rules
* Never push broken Verilog code directly to `main`.
* Create a feature branch for your task:
  ```bash
  git checkout -b feature/your-feature-name
  ```
* Commit and push your changes:
  ```bash
  git add .
  git commit -m "Add: [Brief description of changes]"
  git push origin feature/your-feature-name
  ```
* Open a **Pull Request** on GitHub for review by the Lead Architect.
