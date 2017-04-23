package main

import (
	"bufio"
	"fmt"
	"log"
	"net"
	"os"
	"strings"
)

func main() {
	// connect to this socket
	conn, err := net.Dial("tcp", "127.0.0.1:9090")
	if err != nil {
		log.Fatal("net.Dial(\"tcp\", \"127.0.0.1:9090\") executed. ERROR: ", err)
	}
	reader := bufio.NewReader(os.Stdin)
	line, _ := reader.ReadString('\n')

	fmt.Fprintf(os.Stdout, strings.ToUpper(line+"\n"))
	scanner := bufio.NewScanner(os.Stdin)
	for scanner.Scan() {
		// send to socket
		fmt.Fprintf(conn, line+"\n")
		// listen for reply
		message, _ := bufio.NewReader(conn).ReadString('\n')
		fmt.Print("Message from server: " + message)
		line = scanner.Text()

		// fmt.Fprintf(os.Stdout, strings.ToUpper(line)+"\n")
	}

	// for {
	// 	// mode := os.Getenv("WFF_EXECUTION_MODE")
	// 	hostname, _ := os.Hostname()
	// 	fmt.Printf("The activity wil be executed by '%s' with HOME dir = '%s' on node '%s'.\n",
	// 		os.Getenv("USER"), os.Getenv("HOME"), hostname)
	// 	env := os.Environ()
	// 	fmt.Printf("env[0] '%s'\n", env[0])
	// 	// read in input from stdin
	// 	reader := bufio.NewReader(os.Stdin)
	// 	fmt.Print("Text to send: ")
	// 	text, _ := reader.ReadString('\n')
	// 	// send to socket
	// 	fmt.Fprintf(conn, text+"\n")
	// 	// listen for reply
	// 	message, _ := bufio.NewReader(conn).ReadString('\n')
	// 	fmt.Print("Message from server: " + message)
	// }
}

// Algumas variáveis de Ambiente de interesse
// FIRST_PARAM=change-this
// MY_IP=192.168.0.5
// SPARK_HOME=/usr/local/spark
// DOCKER_IP_PREFIX=172.17.0
// SHELL=/bin/bash
// TMPDIR=/var/folders/75/6rvvrrpx2m3bky596nd7h_1w0000gn/T/
// JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_11.jdk/Contents/Home
// USER=admin
// ORACLE_BASE=/Applications/oracle
// TNS_ADMIN=/Applications/oracle/admin/network
// PATH=/Users/admin/anaconda/bin:/Users/admin/bin/activator/bin:/usr/local/scala/bin:/usr/local/sbin:/usr/local/spark/bin:/Library/Java/JavaVirtualMachines/jdk1.8.0_11.jdk/Contents/Home/bin:/Users/admin/.rvm/gems/ruby-2.2.0/bin:/Users/admin/.rvm/gems/ruby-2.2.0@global/bin:/Users/admin/.rvm/rubies/ruby-2.2.0/bin:/Applications/oracle/product/instantclient_64/11.2.0.3.0/bin:/usr/local/mysql/bin:/Users/admin/bin:/usr/local/Cellar/gdb/7.9.1/bin:/usr/local/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:/usr/local/go/bin:/Library/TeX/texbin:/Users/admin/.rvm/bin
// PWD=/Users/admin/Desktop/Development/EIC/data-engineer/docker/maven
// LANG=pt_BR.UTF-8
// JDK_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_11.jdk/Contents/Home
// HOME=/Users/admin
// GOROOT=/usr/local/go
// LOGNAME=admin
// GOPATH=/Users/admin/docker/maven
// SCALA_HOME=/usr/local/scala
// DISPLAY=/private/tmp/com.apple.launchd.tUdc3mRA4b/org.macosforge.xquartz:0
// ORACLE_HOME=/Applications/oracle/product/instantclient_64/11.2.0.3.0
