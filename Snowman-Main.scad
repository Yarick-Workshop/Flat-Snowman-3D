use <Snowman-Library.scad>
use <Geometry-Helpers.scad>

/* [Body] */
body_color = "White"; // [Black, Blue, Brown, Chartreuse, Green, Magenta, Orange, Purple, Red, Teal, Violet, White, Yellow]
body_height = 5;
base_round_diameter = 12;
bottom_diameter = 40;
medium_diameter = 30;
hands_diameter = 10;
head_diameter = 23;

/* [Rounding] */
chamfer = false;
rounding = 1.2;

/* [Lug] */
show_lug = true;
lug_diameter = 5;
lug_hole_diameter = 2;

/* [Drawing] */
show_drawing = true;
drawing_color = "Black"; // [Black, Blue, Brown, Chartreuse, Green, Magenta, Orange, Purple, Red, Teal, Violet, White, Yellow]
drawing_height = 1;
buttons_diameter = 5;
eyes_diameter = 3;
lips_thickness = 1;
mood = 1; // [-1:0.1:1]
animate_mood = false;

/* [Preview] */
preview_mode = "normal"; // [normal:Normal Snowman, xor:Compare - XOR (Flat vs Chamfered), flat_minus_chamfer:Compare - Flat minus Chamfered, chamfer_minus_flat:Compare - Chamfered minus Flat]
mesh_resolution = 360; // [3:1:720]

/* [Hidden] */
assert(mesh_resolution >= 3, "mesh_resolution must be >= 3");
$fn = mesh_resolution;
mood_calculated = animate_mood
    ? cos(360 * $t)
    : mood;

module render_snowman(use_chamfer)
{
    Snowman(
        // Body
        body_color = body_color,
        body_height = body_height,
        base_round_diameter = base_round_diameter,
        bottom_diameter = bottom_diameter,
        medium_diameter = medium_diameter,
        hands_diameter = hands_diameter,
        head_diameter = head_diameter,

        // Rounding
        chamfer = use_chamfer,
        rounding = rounding,

        // Lug
        show_lug = show_lug,
        lug_diameter = lug_diameter,
        lug_hole_diameter = lug_hole_diameter,

        // Drawing
        show_drawing = show_drawing,
        drawing_color = drawing_color,
        drawing_height = drawing_height,
        buttons_diameter = buttons_diameter,
        eyes_diameter = eyes_diameter,
        lips_thickness = lips_thickness,
        mood = mood_calculated
    );
}

if (preview_mode == "normal")
{
    render_snowman(chamfer);
}
else if (preview_mode == "xor")
{
    xor()
    {
        render_snowman(false);
        render_snowman(true);
    }
}
else if (preview_mode == "flat_minus_chamfer")
{
    difference()
    {
        render_snowman(false);
        render_snowman(true);
    }
}
else if (preview_mode == "chamfer_minus_flat")
{
    difference()
    {
        render_snowman(true);
        render_snowman(false);
    }
}
else
{
    assert(false, str("Unknown preview_mode: ", preview_mode));
}
