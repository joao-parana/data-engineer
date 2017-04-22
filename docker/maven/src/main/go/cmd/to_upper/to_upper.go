package main

import (
	"bufio"
	"fmt"
	"os"
	"strings"
)

func main() {
	// reader := bufio.NewReader(os.Stdin)
	// text, _ := reader.ReadString('\n')
	// fmt.Fprintf(os.Stdout, strings.ToUpper(text+"\n"))
	scanner := bufio.NewScanner(os.Stdin)
	for scanner.Scan() {
		fmt.Fprintf(os.Stdout, strings.ToUpper(scanner.Text()+"\n"))
	}
}
