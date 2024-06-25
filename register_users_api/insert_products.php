<?php
header("Access-Control-Allow-Origin: *");
include("dbconnection.php");
$connection = dbconnection();

if (isset($_POST["price"]) && isset($_POST["description"]) && isset($_POST["data"]) && isset($_POST["name"])) {
    $price = $_POST["price"];
    $description = $_POST["description"];
    $data = $_POST["data"];
    $name = $_POST["name"];

    $path = "upload/$name";

    $query = "INSERT INTO `products`(`price`, `description`, `image_path`) VALUES ('$price', '$description', '$path')";

    file_put_contents($path, base64_decode($data));

    $arr = [];
    $exe = mysqli_query($connection, $query);

    if ($exe) {
        $arr["success"] = "true";
    } else {
        $arr["success"] = "false";
    }
    print(json_encode($arr));
} else {
    echo json_encode(["success" => "false", "message" => "Missing required parameters"]);
}
?>

