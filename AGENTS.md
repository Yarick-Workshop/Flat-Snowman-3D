# Project AI Rules

## OpenSCAD Library & Customizer Parity
- Every parameter of `module Snowman(...)` in [Snowman-Library.scad](Snowman-Library.scad) must define a default value that matches the corresponding Customizer parameter default in [Snowman-Main.scad](Snowman-Main.scad).
- Whenever a default value or parameter is added or updated in either [Snowman-Main.scad](Snowman-Main.scad) or [Snowman-Library.scad](Snowman-Library.scad), update the other file in the same change so defaults remain synchronized.

## Single Responsibility & Module Separation
- [Snowman-Library.scad](Snowman-Library.scad) is responsible strictly for drawing the snowman (`module Snowman(...)` and its private sub-modules).
- Generic CSG helper modules (such as `xor()` and `chain_hull_children()`) must live in [Geometry-Helpers.scad](Geometry-Helpers.scad), not inside [Snowman-Library.scad](Snowman-Library.scad).
- Preview modes, animation logic (`animate_mood`), Customizer controls, and geometry comparison modes (`normal`, `xor`, `flat_minus_chamfer`, `chamfer_minus_flat`) belong in [Snowman-Main.scad](Snowman-Main.scad).

## Mesh Resolution & Curves
- Never hardcode `$fn`, `$fa`, or `$fs` inside library modules. Mesh resolution must come from outside callers ([Snowman-Main.scad](Snowman-Main.scad) or CLI `-D` overrides).
- Any variable-span curved geometry (such as `lips_arc`) must compute its angular resolution dynamically from the caller's `$fn`/`$fa` and geometry parameters.

## OpenSCAD Hygiene
- Import module libraries in [Snowman-Main.scad](Snowman-Main.scad) with `use <...>` rather than `include <...>`.
- Place any internal or computed variables declared after Customizer tabs under `/* [Hidden] */`.
- Use `delta` overlap when joining or subtracting shapes to avoid coplanar Z-fighting or manifold issues.
- Validate all public module parameters with `assert(...)`.
