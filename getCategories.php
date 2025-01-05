<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");


// Database connection
$con = mysqli_connect("fdb1027.runhosting.com", "4571066_todo", "Rawass123456", "4571066_todo");

// $con = mysqli_connect("sql102.infinityfree.com", "if0_37982413", "Rawass12345678", "if0_37982413_todo");


if (mysqli_connect_errno()) {
    echo json_encode(["error" => "Database connection failed."]);
    exit();
}

// Fetch data
$sql = "SELECT * FROM categories";
if ($result = mysqli_query($con, $sql)) {
    $categories = array();
    while ($row = mysqli_fetch_assoc($result)) {
        $categories[] = $row;
    }
    echo json_encode($categories);
} else {
    echo json_encode(["error" => "Query execution failed."]);
}

// Close connection
mysqli_close($con);

?>