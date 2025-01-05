<?php

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

$con = mysqli_connect("fdb1027.runhosting.com", "4571066_todo", "Rawass123456", "4571066_todo");

if (mysqli_connect_errno()) {
    echo json_encode(['status' => 'error', 'message' => 'Failed to connect to MySQL: ' . mysqli_connect_error()]);
    exit();
}

$name = isset($_GET['name']) ;
$color = isset($_GET['color']);

if ($name === null || $color === null) {
    echo json_encode(['status' => 'error', 'message' => 'Missing name or color parameter.']);
    exit();
}

$sql = "INSERT INTO categories (db_name, db_color) VALUES ('$name', '$color')";
if (mysqli_query($con, $sql)) {
    echo json_encode(['status' => 'success', 'message' => 'Category added successfully!']);
} else {
    echo json_encode(['status' => 'error', 'message' => 'Failed to add category: ' . mysqli_error($con)]);
}

mysqli_close($con);

?>
