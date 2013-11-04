<?php
include 'db.php';
header('Content-Type: application/json');

function proc_login($DBH, $data) {
    try {
        // get user's hash
        $STH = $DBH->prepare("SELECT id, hash FROM users WHERE username=:username LIMIT 1");
        $qdata = array('username' => $data->username);
        $STH->execute($qdata);
        // no such username!
        if ($STH->rowCount() == 0) {
          // handle no such user error
          response(false, 'no_user');
        }
        $user = $STH->fetch(PDO::FETCH_OBJ);

        // check password with hash; if it doesn't match, return
        if (crypt($data->password, $user->hash) !== $user->hash) {
          // handle wrong password error
          response(false, 'incorrect_password');
        }

        // Start login session
        $_SESSION['user_id'] = $user->id;

        response(true, 'login_success');
    } catch (PDOException $e) {
        response(false, $e->getMessage());
    }
}

function proc_register($DBH, $data) {
  /* Generate strong hash.
   * See http://alias.io/2010/01/store-passwords-safely-with-php-and-mysql/
   */
  $cost = 10;
  // generate salt
  $salt = strtr(base64_encode(mcrypt_create_iv(16, MCRYPT_DEV_URANDOM)), '+', '.');
  $salt = sprintf("$2a$%02d$", $cost) . $salt;
  // make hash
  $hash = crypt($data->password, $salt);
  try {
    $DBH->beginTransaction();

    // Add entry into `users` table
    $STH = $DBH->prepare("INSERT INTO users (username, hash) VALUES (:username, :hash)");
    $qdata = array('username' => $data->username, 'hash' => $hash);

    $STH->execute($qdata);

    $DBH->commit();

    $user_id = $DBH->lastInsertId();
    // Start login session
    $_SESSION['user_id'] = $user_id;

    response(true, 'register_success');
  } catch(PDOException $e) {
    $DBH->rollback();

    response(false, $e->getMessage());
  }
}

function proc_exists($DBH, $data) {
  $STH = $DBH->prepare("SELECT id FROM users WHERE username=:username");
  $data = array('username' => $data->username);
  $STH->execute($data);
  if($STH->fetch() !== false) {
    die('true');
  } else {
    die('false');
  }
}

function response($succeeded, $message = "") {
  if($succeeded) {
    http_response_code(200);
  } else {
    http_response_code(400);
  }
  die($message);
}

if(!array_key_exists('mode', $_GET)) die();
$data = json_decode(file_get_contents("php://input"));
$mode = $_GET['mode'];
switch($mode) {
  case 'login':
    proc_login($DBH, $data);
    break;
  case 'register':
    proc_register($DBH, $data);
    break;
  case 'exists':
    proc_exists($DBH, $data);
    break;
  default:
    break;
}
?>