package main

import (
	"crypto/tls"
	"encoding/json"
	"log"
	"net/http"
	"time"
)

type HealthResponse struct {
	Healthy bool   `json:"healthy"`
	Status  int    `json:"status"`
	Error   string `json:"error,omitempty"`
}

func main() {
	log.Println("Starting Health Check Proxy on port 3000")

	customTransport := &http.Transport{
		TLSClientConfig: &tls.Config{InsecureSkipVerify: true},
	}

	client := &http.Client{
		Timeout:   5 * time.Second,
		Transport: customTransport,
	}

	http.HandleFunc("/api/health", func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		w.Header().Set("Access-Control-Allow-Origin", "*")

		url := r.URL.Query().Get("url")
		if url == "" {
			w.WriteHeader(http.StatusBadRequest)
			json.NewEncoder(w).Encode(HealthResponse{Healthy: false, Error: "url parameter is required"})
			return
		}

		req, err := http.NewRequest("GET", url, nil)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			json.NewEncoder(w).Encode(HealthResponse{Healthy: false, Error: "failed to create request"})
			return
		}

		req.Header.Set("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36")
		req.Header.Set("Accept", "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8")

		resp, err := client.Do(req)
		
		var result HealthResponse
		if err != nil {
			result = HealthResponse{
				Healthy: false,
				Status:  0,
				Error:   err.Error(),
			}
		} else {
			defer resp.Body.Close()
			result = HealthResponse{
				Healthy: resp.StatusCode == http.StatusOK,
				Status:  resp.StatusCode,
			}
		}

		log.Printf("HEALTH CHECK %s | HEALTHY: %v | Status: %d", url, result.Healthy, result.Status)
		json.NewEncoder(w).Encode(result)
	})

	http.ListenAndServe(":3000", nil)
}