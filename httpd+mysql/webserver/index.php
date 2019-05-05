<?php
$servername = "db-tsbr-docker:3306";
$username = "tsbrdocker";
$password = "docker";

// Create connection
$conn = new mysqli($servername, $username, $password);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
} 
echo "Connected successfully to the Database";

echo "Check the content of the table People:";

$sql = "SELECT * FROM People";
$result = $conn->query($sql);

if($result->num_rows > 0){
    while($row = $result->fetch_assoc()){
        echo "Nome: " .$row["FirstName"]. " - Sobrenome: " . $row["LastName"]. " - Cargo: ". $row["Cargo"]. " - Time: ". $row["Team"]. " ID: ". $row["id"]. "<br>";
    }
}
?>