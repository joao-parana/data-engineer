package main

import (
	"bufio"
	"fmt"
	"log"
	"net/http"
	"os"
	"strings"

	"github.com/gin-gonic/gin"
)

// go get gopkg.in/gin-gonic/gin.v1
// Estou usando gopkg.in que funciona como proxy para o código original no
// github. Assim :
// gopkg.in/gin-gonic/gin.v1 -> github.com/gin-gonic/gin/releases/tag/v1.1.4
// Veja o projeto https://github.com/gin-gonic/gin para detalhes

func main() {
	// doIt1()
	// doIt2()
	// Creates a gin router with default middleware:
	// logger and recovery (crash-free) middleware
	router := gin.Default()

	router.GET("/user/:name", getting)
	router.POST("/somePost", posting)
	router.PUT("/somePut", putting)
	router.DELETE("/someDelete", deleting)
	router.PATCH("/somePatch", patching)
	router.HEAD("/someHead", head)
	router.OPTIONS("/someOptions", options)

	// By default it serves on :8080 unless a
	// PORT environment variable was defined.
	router.Run()
	// router.Run(":3000") for a hard coded port
}

func getting(c *gin.Context) {
	name := c.Param("name")
	c.String(http.StatusOK, "Hello %s", name)
}

func posting(c *gin.Context) {
	c.String(http.StatusOK, "posting %s", "Não implementando ainda")
}

func putting(c *gin.Context) {
	c.String(http.StatusOK, "putting %s", "Não implementando ainda")
}

func deleting(c *gin.Context) {
	c.String(http.StatusOK, "deleting %s", "Não implementando ainda")
}

func patching(c *gin.Context) {
	c.String(http.StatusOK, "patching %s", "Não implementando ainda")
}

func head(c *gin.Context) {
	c.String(http.StatusOK, "head %s", "Não implementando ainda")
}

func options(c *gin.Context) {
	c.String(http.StatusOK, "options %s", "Não implementando ainda")
}

func doIt1() {
	fmt.Fprintf(os.Stdout, strings.ToUpper("porta escolhida:"))
	scanner := bufio.NewScanner(os.Stdin)
	fmt.Fprintf(os.Stdout, scanner.Text()+"\n")
	fs := http.FileServer(http.Dir("./"))
	http.Handle("/static", http.StripPrefix("/static", fs))
	err := http.ListenAndServe(":8393", nil)
	if err != nil {
		log.Fatal("ListenAndServe: ", err)
	}
}

// Outra abordagem
func doIt2() {
	fmt.Fprintf(os.Stdout, strings.ToUpper("porta escolhida: 8393"))
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		http.ServeFile(w, r, "main")
	})

	err := http.ListenAndServe(":8393", nil)
	if err != nil {
		log.Fatal("ListenAndServe: ", err)
	}
}
