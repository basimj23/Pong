# Pong
x86 Assembly Pong: Bare-Metal Retro Gaming
A minimalist implementation of the classic Pong game written entirely in x86 Assembly Language, designed to run natively in DOSBox or on real 8086/8088 hardware. This project demonstrates low-level system programming without any external libraries, interacting directly with BIOS interrupts for graphics and keyboard input.

⚙️ Technical Architecture
Core Components
Pure Assembly Implementation: Written in MASM/TASM syntax with direct hardware access

BIOS Interrupt-Driven Design: Uses INT 10h for video services and INT 16h for keyboard input

Text-Mode Graphics: Implements game graphics using ASCII characters in 80x25 text mode

Real-Time Game Loop: Custom timing logic without external libraries or operating system dependencies
