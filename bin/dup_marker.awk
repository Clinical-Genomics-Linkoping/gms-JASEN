#!/usr/bin/awk -f

BEGIN {
    OFS="\n";
    ORS=RS=">";
}
{
    name = $1;
    $1 = "";
    suffix = names[name] ? "-" names[name] : "";
    print name suffix $0, "\n";
    names[name]++;
}
