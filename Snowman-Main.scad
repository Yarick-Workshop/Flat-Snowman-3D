use <Snowman-Library.scad>
use <Geometry-Helpers.scad>

/* [Body] */
body_color = "White"; // [Black, Blue, Brown, Chartreuse, Green, Magenta, Orange, Purple, Red, Teal, Violet, White, Yellow]
body_height = 5; // .1
body_base_round_diameter = 12; // .1
body_bottom_diameter = 40; // .1
body_medium_diameter = 30; // .1
body_hands_diameter = 10; // .1
body_head_diameter = 23; // .1

/* [Rounding] */
rounding_chamfer = false;
rounding_size = 1.2;

/* [Lug] */
lug_show = true;
lug_diameter = 5; // .1
lug_hole_diameter = 2; // .1

/* [Drawing] */
drawing_show = true;
drawing_color = "Black"; // [Black, Blue, Brown, Chartreuse, Green, Magenta, Orange, Purple, Red, Teal, Violet, White, Yellow]
drawing_height = 1; // .1
drawing_buttons_diameter = 5; // .1
drawing_eyes_diameter = 3; // .1
drawing_lips_thickness = 1; // .1
drawing_mood = 1; // [-1:0.1:1]
drawing_animate_mood = false;

/* [Preview] */
preview_mode = "normal"; // [normal:Normal Snowman, xor:Compare - XOR (Flat vs Chamfered), flat_minus_chamfer:Compare - Flat minus Chamfered, chamfer_minus_flat:Compare - Chamfered minus Flat]
preview_mesh_resolution = 360; // [3:1:720]

/* [Hidden] */
assert(preview_mesh_resolution >= 3, "preview_mesh_resolution must be >= 3");
$fn = preview_mesh_resolution;
drawing_mood_calculated = drawing_animate_mood
    ? cos(360 * $t)
    : drawing_mood;

module render_snowman(use_chamfer)
{
    Snowman(
        // Body
        body_color = body_color,
        body_height = body_height,
        body_base_round_diameter = body_base_round_diameter,
        body_bottom_diameter = body_bottom_diameter,
        body_medium_diameter = body_medium_diameter,
        body_hands_diameter = body_hands_diameter,
        body_head_diameter = body_head_diameter,

        // Rounding
        rounding_chamfer = use_chamfer,
        rounding_size = rounding_size,

        // Lug
        lug_show = lug_show,
        lug_diameter = lug_diameter,
        lug_hole_diameter = lug_hole_diameter,

        // Drawing
        drawing_show = drawing_show,
        drawing_color = drawing_color,
        drawing_height = drawing_height,
        drawing_buttons_diameter = drawing_buttons_diameter,
        drawing_eyes_diameter = drawing_eyes_diameter,
        drawing_lips_thickness = drawing_lips_thickness,
        drawing_mood = drawing_mood_calculated
    );
}

if (preview_mode == "normal")
{
    render_snowman(rounding_chamfer);
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
