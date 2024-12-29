$fn=360;

chamfer = false;
rounding = 1.2;

/* [Hidden] */
delta = 0.01;

// buttons
color("black")
translate([0, 0, 5])
{
    translate([10, 0, 0])
        cylinder(h=1, d = 5);
    translate([30, 0, 0])
        cylinder(h=1, d = 5);    
    translate([50, 0, 0])
        cylinder(h=1, d = 5);
};

//eyes
color("black")
translate([0, 0, 5])
{
    translate([73, 5, 0])
        cylinder(h=1, d = 3);
    translate([73, -5, 0])
        cylinder(h=1, d = 3);
};

// lips
color("black")
translate([0, 0, 5])
{
    translate([74, 0, 0])
    {
        intersection()
        {
            difference()
            {
                cylinder(h = 1, d = 20);
                translate([0, 0, -delta])
                {
                    cylinder(h = 1 + 2 * delta, d = 18);
                }
            }
            rotate(135)
                cube([25, 25, 25]);
        }
    }
};

/*// nose
color("black")
translate([70, 0, 5])
{
    cylinder(h = 10, d1 = 5, d2 = 0);
}*/

color("white")
{
    // lug
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