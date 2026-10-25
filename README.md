# Physical Tamper Detection & Hardware Attestation

An end-to-end secure embedded framework protecting volatile cryptographic keys against mechanical case breach or chassis extraction via real-time IRAM interrupt zeroing routines.

## 📊 Visual Assets & Architecture
```text
┌────────────────────────────────────────────────────────────────────────┐
│                        SYSTEM ARCHITECTURE DIAGRAM                      │
├────────────────────────────────────────────────────────────────────────┤
│                                                                        │
│  [ Ambient Light Breach ]                                              │
│             │                                                          │
│             ▼                                                          │
│     [ Photoresistor LDR ]                                              │
│             │                                                          │
│             ▼                                                          │
│     [ GPIO Pin 4 (Sense) ] ───( Falling Edge Signal )───┐               │
│                                                        ▼               │
│                                            [ IRAM Vector ISR Interrupt ]│
│                                                        │               │
│                                                        ▼               │
│                                            [ Immediate Memory Zeroing ]│
│                                                        │               │
│                                                        ▼               │
│                                            [ Cryptographic Assets = 0 ]│
│                                                        │               │
│                                                        ▼               │
│                                            [ Complete Core Lockdown ]  │
└────────────────────────────────────────────────────────────────────────┘
```
*(Note: A 5-10 second demonstration clip showing successful hardware lockdown can be embedded here as `media/demo_clip.gif` upon case assembly.)*

## 🛠️ Core Hardware & Software Stack

| Layer | Component / Tool | Version / Spec | Purpose inside Ecosystem |
| :--- | :--- | :--- | :--- |
| **Hardware** | ESP32 NodeMCU | Espressif Systems | Execution environment, register manipulation, and NVS/IRAM storage plane. |
| **Hardware** | Photoresistor Module | Built-in Comparator | Optical sensor array capturing immediate enclosure integrity state changes. |
| **Software** | Cross-Compiler | Ubuntu 22.04 LTS | Hermetic multi-stage build system containerizing core compilation assets. |
| **Software** | IDE Platform | PlatformIO v6.0+ | Native VS Code hardware integration and dependency build management. |

## 🔒 Security Hardening Controls Implemented
* **IRAM Instruction Isolation:** The Interrupt Service Routine (ISR) is explicitly compiled into Instruction RAM (`IRAM_ATTR`). This bypasses external flash latency bottlenecks entirely, preventing race conditions or fault injection timing manipulation during a breach.
* **Inline Key Destruction:** Memory scrubbing maps straight to the asynchronous edge trigger context. Keys are wiped to pure zeros before any thread scheduling switch occurs, eliminating data retention windows.
* **Execution Path Interruption:** Following cryptographic erasure, the interrupt vector is systematically detached, forcing the CPU execution engine into a dead trap loop (`while(true)`) to achieve absolute system isolation.

## 🚀 Local Setup & Reproduction Commands
To replicate this environment without contaminating your operating system with local dependencies, use the containerized build engine:

```bash
# 1. Build the isolated hermetic cross-compiler container environment
docker build -t hardware-tamper-compiler -f deployment/Dockerfile.cross-compile .

# 2. Compile assets and extract production-grade .bin artifacts
docker run --rm -v "\$(pwd)"/deployment:/output hardware-tamper-compiler cp /dist/tamper_project.bin /output/
```
