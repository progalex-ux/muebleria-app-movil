<?php
header("Access-Control-Allow-Origin: *"); 

include("dbconnection.php");
$connection = dbconnection();

if ($connection->connect_error) {
    die("Conexión fallida: " . $connection->connect_error);
}

$mail = $_POST['mail'];
$password = $_POST['password'];

$correoEspecifico = 'admin@hotmail.com';

$stmt = $connection->prepare("SELECT password FROM user_table WHERE mail = ?");
$stmt->bind_param("s", $mail);
$stmt->execute();
$stmt->store_result();
$stmt->bind_result($hashed_password);
$stmt->fetch();

if ($stmt->num_rows > 0) {
    if ($password === $hashed_password) {
        if ($mail === $correoEspecifico) {
            echo "Login exitoso - Correo Especifico";
        } else {
            echo "Login exitoso";
        }
    } else {
        echo "Credenciales incorrectas";
    }
} else {
    echo "Credenciales incorrectas";
}

$stmt->close();
$connection->close();
?>
