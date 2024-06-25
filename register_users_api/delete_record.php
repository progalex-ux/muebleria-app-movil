<?php
header("Access-Control-Allow-Origin: *");
include("dbconnection.php");
$connection = dbconnection();

$response = array();

if(isset($_POST["id"])) {
    $id = $_POST["id"];
    $query = "DELETE FROM `products` WHERE id='$id'";
    $exe = mysqli_query($connection, $query);
    
    if($exe) {
        $response["success"] = true;
        $response["message"] = "Producto eliminado correctamente";
    } else {
        $response["success"] = false;
        $response["message"] = "Error al eliminar el producto";
    }
} else {
    $response["success"] = false;
    $response["message"] = "ID de producto no recibido";
}

echo json_encode($response);
?>
