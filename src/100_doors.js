function getFinalOpenedDoors(numDoors) {
    // array of numDoors doors
    let myArr = Array(numDoors).fill(0)
    // cyclce 100 times (accounting for door numbers not 0-indexed)
    for (let i = 1; i <= 100; i++) {
        myArr = myArr.map((num, idx) => (idx + 1) % i == 0 ? 1 - num : num)
    }
    // get the indices (+1, door number) for closed doors
    return myArr.map((num,idx) => num > 0 ? idx + 1 : -1).filter(num => num >= 0)
}
