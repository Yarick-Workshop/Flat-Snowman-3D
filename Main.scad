$fn=360;

// buttons
color("black")
translate([0, 0, 2.5])
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
translate([0, 0, 2.5])
{
    translate([73, 5, 0])
        cylinder(h=1, d = 3);
    translate([73, -5, 0])
        cylinder(h=1, d = 3);
};

// lips
color("black")
translate([0, 0, 2.5])
{
    translate([74, 0, 0])
    {
        intersection()
        {
            difference()
            {
                cylinder(h = 1, d = 20);
                translate([0, 0, -0.005])
                {
                    cylinder(h = 1.1, d = 18);
                }
            }
            rotate(135)
                cube([25, 25, 25]);
        }
    }
};

/*// nose
color("black")
translate([70, 0, 2.5])
{
    cylinder(h = 10, d1 = 5, d2 = 0);
}*/

color("white")
{
    // lug
    translate([83, 0, 0])
    {
        difference()
        {
            cylinder(h = 5, d = 5, center = true);
            cylinder(h = 6, d = 2, center = true);
        }
    }

    hull()
    {
        translate([6, 14, 0])
            cylinder(h = 5, d = 12, center = true);
    translate([6, -14, 0])
        cylinder(h = 5, d = 12, center = true);
    }
            
    translate([20, 0, 0])
    {
        // bottom
        cylinder(h = 5, d = 40, center = true);

        translate([27, 0, 0])
        {
            // medium
            cylinder(h = 5, d = 30, center = true);
            
            // "hands"
            translate([3, 16, 0])
                cylinder(h = 5, d = 10, center = true);
            translate([3, -16, 0])
                cylinder(h = 5, d = 10, center = true);
            
            // "head"
            translate([23, 0, 0])
                cylinder(h = 5, d = 23, center = true);
        }
    }
}