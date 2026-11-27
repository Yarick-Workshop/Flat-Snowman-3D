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
    assert($children >= 2, "chain_hull_children() requires at least 2 children");

    for (i = [0 : $children - 2])
    {
        hull()
        {
            children(i);
            children(i + 1);
        }
    }
}
