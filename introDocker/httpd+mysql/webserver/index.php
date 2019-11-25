<?php
$servername = "db-c6-docker:3306";
$username = "c6docker";
$password = "docker";

// Create connection
$conn = new mysqli($servername, $username, $password);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
} 
echo "Connected successfully to the Database";
?>