<?php
header("Access-Control-Allow-Origin: *");
include("dbconnection.php");
$connection = dbconnection();

if(isset($_POST["user"]) && isset($_POST["mail"]) && isset($_POST["password"])) {
    $user = $_POST["user"];
    $mail = $_POST["mail"];
    $password = $_POST["password"];

    if (
        filter_var($mail, FILTER_VALIDATE_EMAIL) &&  
        strpos($mail, "@") !== false &&            
        substr($mail, -4) === ".com"              
    ) {
    
        if (
            strlen($password) >= 8 &&                          
            preg_match('/[A-Z]/', $password) &&                
            preg_match('/[0-9]/', $password) &&                
            preg_match('/[^a-zA-Z0-9]/', $password) &&         
            !preg_match('/123|234|345|456|567|678|789/', $password)
        ) {
            $check_query = "SELECT * FROM user_table WHERE user = '$user' OR mail = '$mail'";
            $check_result = mysqli_query($connection, $check_query);

            if(mysqli_num_rows($check_result) > 0) {
                $row = mysqli_fetch_assoc($check_result);
                if ($row["user"] === $user) {
                    $response["message"] = "El usuario ya está en uso.";
                } elseif ($row["mail"] === $mail) {
                    $response["message"] = "El correo electrónico ya está en uso.";
                }
                $response["success"] = false;
            } else {
                $insert_query = "INSERT INTO `user_table`(`user`, `mail`, `password`) VALUES ('$user','$mail','$password')";
                $insert_result = mysqli_query($connection, $insert_query);
                
                if($insert_result) {
                    $response["success"] = true;
                    $response["message"] = "Usuario registrado exitosamente.";
                } else {
                    $response["success"] = false;
                    $response["message"] = "Error al registrar el usuario.";
                }
            }
        } else {
            $response["success"] = false;
            $response["message"] = "La contraseña no cumple con los requisitos mínimos.";
        }
    } else {
        $response["success"] = false;
        $response["message"] = "Correo electrónico inválido.";
    }
} else {
    $response["success"] = false;
    $response["message"] = "No se recibieron todos los datos necesarios.";
}

header('Content-Type: application/json');
echo json_encode($response);
?>
