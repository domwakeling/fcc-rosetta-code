function dotProduct(ary1, ary2) {
    // catch unequal arrays
    if (ary1.length != ary2.length) return 0;
    // use reduce to multiply out
    return ary1.reduce((tot, num, idx) => tot + num * ary2[idx], 0)
}
