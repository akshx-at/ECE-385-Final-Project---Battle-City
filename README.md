# Battle City on FPGA

Multiplayer FPGA game project inspired by the classic Battle City / Battle Tank style arcade gameplay, built for ECE 385 at the University of Illinois Urbana-Champaign.

## Overview

This project implements a two-player tank battle game on FPGA hardware using SystemVerilog, VGA output, sprite-based rendering, hardware state machines, and USB keyboard input. The design combines real-time graphics, collision handling, animation logic, and embedded software running alongside the hardware design.

## Project Highlights

- Two-player gameplay with independent movement and firing controls
- VGA-based graphics pipeline for game rendering
- Sprite-driven visual assets and menu/game-state screens
- Collision detection built around bitmap-style obstacle handling
- Hardware state machines for gameplay flow and animation control
- Nios II software support for keyboard input through USB

## Hardware/Software Split

The project uses a mixed design approach:

- `*.sv` files implement the game logic, timing, rendering, collision handling, and control state machines
- Quartus project files capture the FPGA build configuration
- `usb_kb/` contains the embedded C application used to interface with USB keyboard input
- supporting reports and screenshots document the final design and implementation process

## Repository Layout

```text
ECE-385-Final-Project---Battle-City/
├── *.sv                # Core SystemVerilog modules
├── finalproject.qpf    # Quartus project file
├── finalproject.qsf    # Quartus settings
├── Final Project.pdf   # Project report/documentation
├── usb_kb/             # Embedded C code for keyboard handling
├── summary.html        # Generated Quartus summary output
└── README.md
```

## Key Modules

Representative modules in the design include:

- `Color_Mapper.sv` for display pixel/color selection
- `VGA_controller.sv` for VGA timing and output coordination
- `ball.sv` and `ball2.sv` for player/tank behavior
- `collision_handler.sv` for object interaction logic
- `gamestatemachine.sv` for high-level flow between menus and gameplay
- `map_generator.sv` for map-related logic
- `clock_divider.sv` and `posedgedetector.sv` for timing/control support

## Development Notes

This repository preserves the original project structure from the course workflow, so it includes generated project files, backup files, and embedded build artifacts that were part of the original hardware development environment.

To work with the project again, you would typically need:

- Intel Quartus for FPGA project management and synthesis
- the course's supported FPGA board/tool setup
- a Nios II-compatible embedded toolchain for the `usb_kb` program

## Outcomes

This project demonstrates practical experience with:

- FPGA-based game design
- hardware/software co-design
- finite state machines
- VGA graphics pipelines
- collision detection in hardware
- integrating external input devices into a digital system
