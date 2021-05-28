#!/usr/bin/awk -f

BEGIN {
	FS=",";
    OFS=",";
}
{
    name = $1;
    $1 = "";
    suffix = names[name] ? "-" names[name] : "";
    print name suffix $0;
    names[name]++;
}
