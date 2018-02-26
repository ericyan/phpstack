<?php

switch ($_REQUEST['q']) {
    case '/':
        $name = isset($_GET['name']) ? $_GET['name'] : 'world';
        echo 'hello, ' . $name;
        break;
    case '/phpinfo':
        phpinfo();
        break;
    default:
        http_response_code(404);
        echo 'Unknown path: ' . $_REQUEST['q'];
        die();
}
