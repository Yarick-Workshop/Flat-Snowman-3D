module Snowman(
    // Body
    body_color = "White",
    body_height = 5,
    body_base_round_diameter = 12,
    body_bottom_diameter = 40,
    body_medium_diameter = 30,
    body_hands_diameter = 10,
    body_head_diameter = 23,

    // Rounding
    rounding_chamfer = false,
    rounding_size = 1.2,

    // Lug
    lug_show = true,
    lug_diameter = 5,
    lug_hole_diameter = 2,

    // Drawing
    drawing_show = true,
    drawing_color = "Black",
    drawing_height = 1,
    drawing_buttons_diameter = 5,
    drawing_eyes_diameter = 3,
    drawing_lips_thickness = 1,
    drawing_mood = 1
)
{
    delta = 0.01;
    max_rounding = min(
        body_height,
        min(
            body_base_round_diameter,
            body_bottom_diameter,
            body_medium_diameter,
            body_hands_diameter,
            body_head_diameter
        )
    ) / 2;

    lips_width = 14.1;
    lips_medium_offset_max = 2.9;
    lips_flat_threshold = 0.001;
    lips_radius_min = lips_width * lips_width / (8 * lips_medium_offset_max) + lips_medium_offset_max / 2;
    lips_angle_max = atan(lips_width / 2 / (lips_radius_min - lips_medium_offset_max)) * 2;

    // Validations
    assert($fn == 0 || $fn >= 3, "$fn must be 0 or >= 3");
    assert(body_height > 0, "body_height must be greater than zero");
    assert(body_base_round_diameter > 0, "body_base_round_diameter must be greater than zero");
    assert(body_bottom_diameter > 0, "body_bottom_diameter must be greater than zero");
    assert(body_medium_diameter > 0, "body_medium_diameter must be greater than zero");
    assert(body_hands_diameter > 0, "body_hands_diameter must be greater than zero");
    assert(body_head_diameter > 0, "body_head_diameter must be greater than zero");
    assert(
        !rounding_chamfer || (rounding_size > 0 && rounding_size < max_rounding),
        str("rounding_size must be > 0 and < ", max_rounding, " when rounding_chamfer is enabled"));
    assert(!lug_show || lug_diameter > 0, "lug_diameter must be greater than zero");
    assert(
        !lug_show || (lug_hole_diameter > 0 && lug_hole_diameter < lug_diameter),
        "lug_hole_diameter must be > 0 and < lug_diameter");
    assert(drawing_height > 0, "drawing_height must be greater than zero");
    assert(drawing_buttons_diameter > 0, "drawing_buttons_diameter must be greater than zero");
    assert(drawing_eyes_diameter > 0, "drawing_eyes_diameter must be greater than zero");
    assert(
        drawing_lips_thickness > 0 && drawing_lips_thickness < lips_radius_min,
        str("drawing_lips_thickness must be > 0 and < ", lips_radius_min));
    assert(drawing_mood >= -1 && drawing_mood <= 1, "drawing_mood must be between -1 and 1");

    lips_medium_offset = drawing_mood * lips_medium_offset_max;
    drawing_extrude_height = drawing_height + delta;

    if (drawing_show)
    {
        color(drawing_color)
        translate([0, 0, body_height - delta])
        {
            // buttons
            translate([10, 0, 0])
                cylinder(h = drawing_extrude_height, d = drawing_buttons_diameter);
            translate([30, 0, 0])
                cylinder(h = drawing_extrude_height, d = drawing_buttons_diameter);
            translate([50, 0, 0])
                cylinder(h = drawing_extrude_height, d = drawing_buttons_diameter);

            // eyes
            translate([73, 5, 0])
                cylinder(h = drawing_extrude_height, d = drawing_eyes_diameter);
            translate([73, -5, 0])
                cylinder(h = drawing_extrude_height, d = drawing_eyes_diameter);

            // lips
            lips();
        }
    }

    color(body_color)
    {
        // lug
        if (lug_show)
        translate([82.5, 0, 0])
        {
            difference()
            {
                cylinder(h = body_height, d = lug_diameter);
                translate([0, 0, -delta])
                    cylinder(h = body_height + 2 * delta, d = lug_hole_diameter);
            }
        }

        hull()
        {
            translate([6, 14, 0])
                my_cylinder(h = body_height, d = body_base_round_diameter);
            translate([6, -14, 0])
                my_cylinder(h = body_height, d = body_base_round_diameter);
        }

        translate([20, 0, 0])
        {
            // bottom
            my_cylinder(h = body_height, d = body_bottom_diameter);

            translate([27, 0, 0])
            {
                // medium
                my_cylinder(h = body_height, d = body_medium_diameter);

                // "hands"
                translate([3, 16, 0])
                    my_cylinder(h = body_height, d = body_hands_diameter);
                translate([3, -16, 0])
                    my_cylinder(h = body_height, d = body_hands_diameter);

                // "head"
                translate([23, 0, 0])
                    my_cylinder(h = body_height, d = body_head_diameter);
            }
        }
    }

    module lips()
    {
        module lips_arc(offset)
        {
            lips_radius = lips_width * lips_width / (8 * offset) + offset / 2;
            lips_angle = atan(lips_width / 2 / (lips_radius - offset)) * 2;
            lips_offset = lips_radius - offset / 2 - (drawing_lips_thickness / 2) * cos(lips_angle / 2);

            arc_fn = ($fn > 0)
                ? ceil(max($fn * lips_angle_max / lips_angle, 3 * 360 / lips_angle))
                : 0;
            arc_fa = ($fn == 0)
                ? max(0.01, $fa * lips_angle / lips_angle_max)
                : $fa;

            translate([lips_offset, 0])
                rotate([0, 0, 180 - lips_angle / 2])
                    rotate_extrude(angle = lips_angle, $fn = arc_fn, $fa = arc_fa)
                        translate([lips_radius - drawing_lips_thickness, 0])
                            square([drawing_lips_thickness, drawing_extrude_height]);
        }

        translate([65.475, 0, 0])
        {
            if (abs(lips_medium_offset) < lips_flat_threshold)
            {
                translate([0, 0, drawing_extrude_height / 2])
                    cube([drawing_lips_thickness, lips_width, drawing_extrude_height], center = true);
            }
            else if (lips_medium_offset > 0)
            {
                lips_arc(lips_medium_offset);
            }
            else
            {
                mirror([1, 0, 0])
                    lips_arc(-lips_medium_offset);
            }
        }
    }

    module my_cylinder(h, d)
    {
        if (rounding_chamfer)
        {
            cylinder(h = rounding_size, d1 = d - 2 * rounding_size, d2 = d);
            translate([0, 0, rounding_size])
                cylinder(h = h - 2 * rounding_size, d = d);
            translate([0, 0, h - rounding_size])
                cylinder(h = rounding_size, d1 = d, d2 = d - 2 * rounding_size);
        }
        else
        {
            cylinder(h = h, d = d);
        }
    }
}
