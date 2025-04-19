package main

import (
	"fmt"
	"net/http"
	"os"
)

func main() {
	// Get the text from the environment variable, or use a default.
	landingText := os.Getenv("LANDING_TEXT")
	if landingText == "" {
		landingText = "Hello from the Go Server!"
	}

	// Define the HTTP handler
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		// Set the content type to HTML
		w.Header().Set("Content-Type", "text/html; charset=utf-8")
		// Write the HTML response
		fmt.Fprintf(w, "<h1>%s</h1>", landingText)
	})

	// Define a simple health check endpoint
	http.HandleFunc("/health", func(w http.ResponseWriter, r *http.Request) {
		// Set the content type to JSON
		w.Header().Set("Content-Type", "application/json")
		// Write the JSON response
		w.WriteHeader(http.StatusOK)
		version := os.Getenv("VERSION")
		fmt.Fprint(w, `{
	"status":"healthy",
	"version":"`+version+`"
}`)
	})

	// Start the server on port 8000
	port := "8000"
	fmt.Printf("Server starting on port %s\n", port)
	if err := http.ListenAndServe(":"+port, nil); err != nil {
		fmt.Printf("Error starting server: %s\n", err)
		os.Exit(1)
	}
}
