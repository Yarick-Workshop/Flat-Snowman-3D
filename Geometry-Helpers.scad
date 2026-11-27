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
