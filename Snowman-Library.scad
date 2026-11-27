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

    // Internal layout coordinates (hidden from Customizer/callers)
    base_x = 6;
    base_y = 14;
    bottom_x = 20;
    medium_offset_x = 27;
    medium_x = bottom_x + medium_offset_x;
    hands_offset_x = 3;
    hands_offset_y = 16;
    head_offset_x = 23;
    head_x = medium_x + head_offset_x;

    bottom_button_xs = [10, 30];
    medium_button_x = 50;
    eyes_offset_x = 3;
    eyes_offset_y = 5;
    eyes_x = head_x + eyes_offset_x;
    lips_x = 65.475;

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
    chamfer_inset = rounding_chamfer ? rounding_size : 0;

    lug_head_overlap = min(delta, (lug_diameter - lug_hole_diameter) / 4);
    lug_x = min(
        head_x + body_head_diameter / 2 + lug_hole_diameter / 2,
        head_x + body_head_diameter / 2 - chamfer_inset + lug_diameter / 2 - lug_head_overlap
    );

    // TODO: Derive base, snowball, hand, and drawing coordinates dynamically from parameters
    // (and expose lip dimensions) instead of asserting against hardcoded positions.
    assert(
        (body_base_round_diameter + body_bottom_diameter) / 2 - 2 * chamfer_inset > bottom_x - base_x,
        "base detaches from bottom snowball at current diameters and rounding_size");
    assert(
        (body_bottom_diameter + body_medium_diameter) / 2 - 2 * chamfer_inset > medium_offset_x,
        "bottom snowball detaches from medium snowball at current diameters and rounding_size");
    assert(
        (body_medium_diameter + body_hands_diameter) / 2 - 2 * chamfer_inset > norm([hands_offset_x, hands_offset_y]),
        "hands detach from medium snowball at current diameters and rounding_size");
    assert(
        (body_medium_diameter + body_head_diameter) / 2 - 2 * chamfer_inset > head_offset_x,
        "head detaches from medium snowball at current diameters and rounding_size");

    if (drawing_show)
    {
        lips_abs_offset = abs(lips_medium_offset);
        lips_is_flat = lips_abs_offset < lips_flat_threshold;
        lips_arc_radius = lips_is_flat ? 0 : (lips_width * lips_width / (8 * lips_abs_offset) + lips_abs_offset / 2);
        lips_arc_angle = lips_is_flat ? 0 : (atan(lips_width / 2 / (lips_arc_radius - lips_abs_offset)) * 2);
        lips_arc_offset = lips_is_flat ? 0 : (lips_arc_radius - lips_abs_offset / 2 - (drawing_lips_thickness / 2) * cos(lips_arc_angle / 2));
        lips_sign = (lips_medium_offset > 0) ? 1 : -1;
        lips_arc_center_x = lips_x + lips_sign * lips_arc_offset;
        lips_max_dist_from_head = lips_is_flat
            ? norm([(head_x - lips_x) + drawing_lips_thickness / 2, lips_width / 2])
            : max(
                abs(lips_arc_center_x - lips_sign * lips_arc_radius - head_x),
                abs(lips_arc_center_x - lips_sign * (lips_arc_radius - drawing_lips_thickness) - head_x),
                norm([lips_arc_center_x - lips_sign * lips_arc_radius * cos(lips_arc_angle / 2) - head_x, lips_arc_radius * sin(lips_arc_angle / 2)]),
                norm([lips_arc_center_x - lips_sign * (lips_arc_radius - drawing_lips_thickness) * cos(lips_arc_angle / 2) - head_x, (lips_arc_radius - drawing_lips_thickness) * sin(lips_arc_angle / 2)])
            );

        assert(
            max([for (bx = bottom_button_xs) abs(bx - bottom_x)]) + drawing_buttons_diameter / 2 <= body_bottom_diameter / 2 - chamfer_inset,
            "lower/middle buttons exceed bottom snowball top face");
        assert(
            abs(medium_button_x - medium_x) + drawing_buttons_diameter / 2 <= body_medium_diameter / 2 - chamfer_inset,
            "upper button exceeds medium snowball top face");
        assert(
            norm([eyes_x - head_x, eyes_offset_y]) + drawing_eyes_diameter / 2 <= body_head_diameter / 2 - chamfer_inset,
            "eyes exceed head top face");
        assert(
            lips_max_dist_from_head <= body_head_diameter / 2 - chamfer_inset,
            "lips exceed head top face");
    }

    if (drawing_show)
    {
        color(drawing_color)
        translate([0, 0, body_height - delta])
        {
            // buttons
            for (bx = bottom_button_xs)
                translate([bx, 0, 0])
                    cylinder(h = drawing_extrude_height, d = drawing_buttons_diameter);
            translate([medium_button_x, 0, 0])
                cylinder(h = drawing_extrude_height, d = drawing_buttons_diameter);

            // eyes
            translate([eyes_x, eyes_offset_y, 0])
                cylinder(h = drawing_extrude_height, d = drawing_eyes_diameter);
            translate([eyes_x, -eyes_offset_y, 0])
                cylinder(h = drawing_extrude_height, d = drawing_eyes_diameter);

            // lips
            lips();
        }
    }

    color(body_color)
    {
        difference()
        {
            union()
            {
                // lug
                if (lug_show)
                translate([lug_x, 0, 0])
                    cylinder(h = body_height, d = lug_diameter);

                hull()
                {
                    translate([base_x, base_y, 0])
                        my_cylinder(h = body_height, d = body_base_round_diameter);
                    translate([base_x, -base_y, 0])
                        my_cylinder(h = body_height, d = body_base_round_diameter);
                }

                translate([bottom_x, 0, 0])
                {
                    // bottom
                    my_cylinder(h = body_height, d = body_bottom_diameter);

                    translate([medium_offset_x, 0, 0])
                    {
                        // medium
                        my_cylinder(h = body_height, d = body_medium_diameter);

                        // "hands"
                        translate([hands_offset_x, hands_offset_y, 0])
                            my_cylinder(h = body_height, d = body_hands_diameter);
                        translate([hands_offset_x, -hands_offset_y, 0])
                            my_cylinder(h = body_height, d = body_hands_diameter);

                        // "head"
                        translate([head_offset_x, 0, 0])
                            my_cylinder(h = body_height, d = body_head_diameter);
                    }
                }
            }

            if (lug_show)
            translate([lug_x, 0, -delta])
                cylinder(h = body_height + 2 * delta, d = lug_hole_diameter);
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

        translate([lips_x, 0, 0])
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
