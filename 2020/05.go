// https://adventofcode.com/2020/day/5

package main

import (
	"fmt"
	"math"
	"os"
	"strconv"
	"strings"
)

// Part 1
func getHighestSeatID(ids []string) (highestSeatID int64) {
	replacer := strings.NewReplacer("F", "0", "B", "1", "L", "0", "R", "1")

	for _, id := range ids {
		replacedID := replacer.Replace(id)
		seatID, _ := strconv.ParseInt(replacedID, 2, 64)
		if seatID > highestSeatID {
			highestSeatID = seatID
		}
	}

	return
}

// Part 2
func getMySeatID(ids []string) int64 {
	var lowestSeatID int64 = math.MaxInt64
	var tempSeatID int64
	replacer := strings.NewReplacer("F", "0", "B", "1", "L", "0", "R", "1")

	for _, id := range ids {
		replacedID := replacer.Replace(id)
		seatID, _ := strconv.ParseInt(replacedID, 2, 64)
		tempSeatID = tempSeatID ^ seatID
		if lowestSeatID > seatID {
			lowestSeatID = seatID
		}
	}

	return tempSeatID - lowestSeatID
}

func main() {
	if getHighestSeatID([]string{"FBFBBFFRLR", "BFFFBBFRRR", "FFFBBBFRRR", "BBFFBBFRLL"}) != 820 {
		panic("Part 1 failed")
	}

	if len(os.Args) > 1 {
		ids := strings.Split(os.Args[1], "\n")
		fmt.Println(getHighestSeatID(ids))
		fmt.Println(getMySeatID(ids))
	}
}
