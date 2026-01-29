include  <Snowman-Library.scad>

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

Snowman(
    body_color = body_color,
    drawing_color = drawing_color,

    show_lug = show_lug,

    show_drawing = show_drawing,
    drawing_height = drawing_height,
    buttons_diameter = buttons_diameter,
    eyes_diameter = eyes_diameter,
    lips_thickness = lips_thickness,
    lips_medium_offset = lips_medium_offset,

    chamfer = chamfer,
    rounding = rounding
);