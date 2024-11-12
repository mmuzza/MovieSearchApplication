package main

import (
	"database/sql"
	"encoding/json"
	"log"
	"net/http"

	_ "github.com/jackc/pgconn"
	_ "github.com/jackc/pgx/v4"
	_ "github.com/jackc/pgx/v4/stdlib"
)

func openDB(dsn string) (*sql.DB, error) {
	db, err := sql.Open("pgx", dsn)
	if err != nil {
		return nil, err
	}

	err = db.Ping()
	if err != nil {
		return nil, err
	}

	return db, nil
}

func (app *application) connectToDB() (*sql.DB, error) {
	connection, err := openDB(app.DSN)
	if err != nil {
		return nil, err
	}

	log.Println("Connected to Postgres!")
	return connection, nil
}

// checkDBConnection will try to connect to the database
// and return a success message or error
func (app *application) checkDBConnection(w http.ResponseWriter, r *http.Request) {
	// Try connecting to the database
	db, err := app.connectToDB()
	if err != nil {
		http.Error(w, "Failed to connect to the database: "+err.Error(), http.StatusInternalServerError)
		return
	}
	defer db.Close()

	// Send a success response if the connection is successful
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)

	// Send back a simple JSON response
	json.NewEncoder(w).Encode(map[string]string{
		"message": "Database is connected successfully",
	})
}
