function wordFrequency(txt, n) {
    // deal with empty string
    if (txt == '') return []

    // object with key=word, val=count
    let wordCounts = txt.toLowerCase()
                    .split(" ")
                    .reduce((tot, word) => {
                        if (tot[word]) {
                            tot[word] = tot[word] + 1
                        } else {
                            tot[word] = 1
                        }
                        return tot
                    }, {})
                    
    // turn into array of [word, count] pairs
    let counts = Object.keys(wordCounts)
                       .map(k => [k, wordCounts[k]])
                       .sort((a,b) => b[1] - a[1])

    // find the nth entry and use it's count value as a cutoff if necessary
    if (counts.length > n) {
        const cutoff = counts[n-1][1]
        counts = counts.filter(w => (w[1] >= cutoff))
    }
    
    // output result
    return counts
}
