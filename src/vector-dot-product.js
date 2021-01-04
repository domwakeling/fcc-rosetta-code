function dotProduct(...vectors) {
    try {
        const l = vectors[0].length;
        let a = vectors[0];
        for (let i = 1; i < vectors.length; i++) {
            if (vectors[i].length != l) return null;
            a = a.map((n,idx) => n * vectors[i][idx]);
        }
        return a.reduce((tot, n) => tot + n, 0);
    } catch {
        return null;
    }
}
