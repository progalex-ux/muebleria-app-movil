<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Content-Type: application/json; charset=UTF-8");

include("dbconnection.php");
$connection = dbconnection();

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    echo json_encode(["success" => "false", "error" => "Método no permitido"]);
    exit();
}

$id = $_POST['id'];
$price = $_POST['price'];
$description = $_POST['description'];

if (isset($_FILES['image']) && $_FILES['image']['error'] == UPLOAD_ERR_OK) {
    $tmp_name = $_FILES['image']['tmp_name'];
    $path = "upload/" . $_FILES['image']['name'];

    if (move_uploaded_file($tmp_name, $path)) {
        $query = "UPDATE `products` SET `image_path`='$path', `price`='$price', `description`='$description' WHERE id = '$id'";
    } else {
        echo json_encode(["success" => "false", "error" => "Failed to move uploaded file"]);
        exit();
    }
} else {
    $query = "UPDATE `products` SET `price`='$price', `description`='$description' WHERE id = '$id'";
}

if (mysqli_query($connection, $query)) {
    echo json_encode(["success" => "true"]);
} else {
    echo json_encode(["success" => "false", "error" => mysqli_error($connection)]);
}

mysqli_close($connection);
?>
