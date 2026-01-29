
body_color = "White"; // [Black, Blue, Brown, Chartreuse, Green, Magenta, Orange, Purple, Red, Teal, Violet, White, Yellow]
drawing_color = "Black"; // [Black, Blue, Brown, Chartreuse, Green, Magenta, Orange, Purple, Red, Teal, Violet, White, Yellow]

show_lug = true;

/* [Drawing] */
show_drawing = true;
drawing_height = 1;
buttons_diameter = 5;
eyes_diameter = 3;
lips_thickness = 1;
lips_medium_offset = 2.9;

/* [Rounding] */
chamfer = false;
rounding = 1.2;

/* [Hidden] */
delta = 0.01;
$fn = 360;
lips_medium_offset_min = -2.9;
lips_medium_offset_max = 2.9;

// Validations
assert(drawing_height > 0, "drawing_height must be greater than zero");
assert(lips_thickness > 0, "lips_thickness must be greater than zero");
assert(lips_medium_offset >= lips_medium_offset_min, str("lips_medium_offset must be >= ", lips_medium_offset_min));
assert(lips_medium_offset <= lips_medium_offset_max, str("lips_medium_offset must be <= ", lips_medium_offset_max));

if (show_drawing)
{
    color(drawing_color)
    translate([0, 0, 5])
    {
        // buttons
        translate([10, 0, 0])
            cylinder(h = drawing_height, d = buttons_diameter);
        translate([30, 0, 0])
            cylinder(h = drawing_height, d = buttons_diameter);    
        translate([50, 0, 0])
            cylinder(h = drawing_height, d = buttons_diameter);

        // eyes
        translate([73, 5, 0])
            cylinder(h = drawing_height, d = eyes_diameter);
        translate([73, -5, 0])
            cylinder(h = drawing_height, d = eyes_diameter);

        // lips
        lips();

        // nose
        /*translate([70, 0, 0])
        {
            cylinder(h = 1, d = 5);
        }*/
    };
}

color(body_color)
{    
    // lug
    if (show_lug)
    translate([82.5, 0, 0])
    {
        difference()
        {
            cylinder(h = 5, d = 5);
            translate([0, 0, -delta])
                cylinder(h = 5 + 2 * delta, d = 2);
        }
    }

    hull()
    {
        translate([6, 14, 0])
            my_cylinder(h = 5, d = 12);
        translate([6, -14, 0])
            my_cylinder(h = 5, d = 12);
    }
            
    translate([20, 0, 0])
    {
        // bottom
        my_cylinder(h = 5, d = 40);

        translate([27, 0, 0])
        {
            // medium
            my_cylinder(h = 5, d = 30);
            
            // "hands"
            translate([3, 16, 0])
                my_cylinder(h = 5, d = 10);
            translate([3, -16, 0])
                my_cylinder(h = 5, d = 10);
            
            // "head"
            translate([23, 0, 0])
                my_cylinder(h = 5, d = 23);
        }
    }
}

module lips()
{
    lips_width = 14.1;

    translate([65.475, 0, 0])
    {
        if (lips_medium_offset == 0)
        {
            rotate([90, 0, 0])
                linear_extrude(height = lips_width, center = true)
                    square([lips_thickness, drawing_height], center = false);
        }
        else
        {
            lips_radius = lips_width * lips_width / (8 * lips_medium_offset) + lips_medium_offset / 2;
            lips_offset = lips_radius - lips_medium_offset / 2;

            lips_angle = atan(lips_width / 2 / (lips_radius - lips_medium_offset)) * 2;

            translate([lips_offset, 0])
                rotate([0, 0, 180 - lips_angle / 2])
                    rotate_extrude(angle = lips_angle)
                        translate([lips_radius - lips_thickness / 2, lips_thickness / 2])
                            square([lips_thickness, drawing_height], center = true);
        }
    }
}

module xor()
{
    assert($children == 2, "xor() requires exactly 2 children");

    difference()
    {
        union()
        {
            children(0);
            children(1);
        }
        intersection()
        {
            children(0);
            children(1);
        }
    }
}

module chain_hull_children()
{
    if ($children > 1)
    {
        for (i = [0 : $children - 2])
        {
            hull()
            {
                children(i);
                children(i + 1);
            }
        }
    }
}

module my_cylinder(h, d)
{
    if (chamfer)
    {
        cylinder(h=rounding, d1 = d - 2 * rounding, d2 = d);
        translate([0, 0, rounding])
            cylinder(h = h - 2 * rounding, d = d);
        translate([0, 0, h - rounding])
            cylinder(h=rounding, d1 = d, d2 = d - 2 * rounding);
    }
    else
    {
        cylinder(h=h, d = d);
    }
}
