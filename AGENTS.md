# Project AI Rules

## OpenSCAD Library & Customizer Parity
- Order and group parameters in `module Snowman(...)` in [Snowman-Library.scad](Snowman-Library.scad) (and at its call sites) in the exact same sequence and groupings as the Customizer parameters in [Snowman-Main.scad](Snowman-Main.scad).
- Prefix every parameter in a Customizer `/* [Group] */` section with the lowercase group name (e.g., `body_`, `rounding_`, `lug_`, `drawing_`, `preview_`), and keep parameter names identical between [Snowman-Main.scad](Snowman-Main.scad) and `module Snowman(...)` in [Snowman-Library.scad](Snowman-Library.scad).
- Never hardcode user-configurable dimensions (heights, diameters, thicknesses, clearances) inside [Snowman-Library.scad](Snowman-Library.scad); expose them as module parameters with synchronized Customizer variables and defaults.
- Whenever a default value or parameter is added, renamed, reordered, or updated in either [Snowman-Main.scad](Snowman-Main.scad) or [Snowman-Library.scad](Snowman-Library.scad), update the other file in the same change.

## Single Responsibility & Module Separation
- [Snowman-Library.scad](Snowman-Library.scad) is responsible strictly for drawing the snowman (`module Snowman(...)` and its private sub-modules).
- Generic CSG helper modules (such as `xor()` and `chain_hull_children()`) must live in [Geometry-Helpers.scad](Geometry-Helpers.scad), not inside [Snowman-Library.scad](Snowman-Library.scad).
- Preview modes, animation logic (`drawing_animate_mood`), Customizer controls, and geometry comparison modes (`normal`, `xor`, `flat_minus_chamfer`, `chamfer_minus_flat`) belong in [Snowman-Main.scad](Snowman-Main.scad).

## Mesh Resolution & Curves
- Never hardcode `$fn`, `$fa`, or `$fs` inside library modules. Mesh resolution must come from outside callers ([Snowman-Main.scad](Snowman-Main.scad) or CLI `-D` overrides).
- Any variable-span curved geometry (such as `lips_arc`) must compute its angular resolution dynamically from the caller's `$fn`/`$fa` and geometry parameters.

## OpenSCAD Hygiene
- Import module libraries in [Snowman-Main.scad](Snowman-Main.scad) with `use <...>` rather than `include <...>`.
- Place any internal or computed variables declared after Customizer parameters under `/* [Hidden] */`.
- Validate all public module parameters with `assert(...)`.
