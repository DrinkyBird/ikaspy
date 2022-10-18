<?php
    require_once '../common/common.php';
    
    function isSetAndNotEmpty($field) {
        return (isset($_POST[$field]) && !empty($_POST[$field]));
    }
    
    function showError($key) {
        $smarty = IkaSpy\createSmarty();
        $smarty->assign('error', $key);
        $smarty->display('user.register.tpl');
        exit;
    }
    
    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        if (!isSetAndNotEmpty('username')) {
            showError('noUsername');
        }
        if (!isSetAndNotEmpty('email')) {
            showError('noEmail');
        }
        if (!isSetAndNotEmpty('password')) {
            showError('noPassword');
        }
        if (!isSetAndNotEmpty('passwordConfirm')) {
            showError('noConfirmPassword');
        }
        
        $username = $_POST['username'];
        $email = $_POST['email'];
        $password = $_POST['password'];
        $passwordConfirm = $_POST['passwordConfirm'];
        
        if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
            showError('invalidEmail');
        }
        
        if ($password !== $passwordConfirm) {
            showError('confirmPasswordMismatch');
        }
        
        $hash = password_hash($password);
        
        $now = time();
        
        $db = IkaSpy\connectDb();
        $stmt = $db->prepare("
            SELECT 
                COUNT(*)
            FROM    `users`
            WHERE   `username` = :username
        ");
        $stmt->bindParam(":username", $username, PDO::PARAM_STR);
        $stmt->execute();
        $count = $stmt->fetchColumn();
        if ($count > 0) {
            showError("usernameTaken");
        }
        
        $stmt = $db->prepare("
            SELECT 
                COUNT(*)
            FROM    `users`
            WHERE   `email` = :email
        ");
        $stmt->bindParam(":email", $email, PDO::PARAM_STR);
        $stmt->execute();
        $count = $stmt->fetchColumn();
        if ($count > 0) {
            showError("emailTaken");
        }
        
        $hash = password_hash($password, PASSWORD_DEFAULT);
        $stmt = $db->prepare("
            INSERT INTO `users`
                (username, email, password, register_time)
            VALUES
                (:username, :email, :password, :now)
        ");
        $stmt->bindParam(":username", $username, PDO::PARAM_STR);
        $stmt->bindParam(":email", $email, PDO::PARAM_STR);
        $stmt->bindParam(":password", $hash, PDO::PARAM_STR);
        $stmt->bindParam(":now", $now, PDO::PARAM_INT);
        $stmt->execute();
        
        Header("Location: " . HTTP_ROOT);
    } else {
        $smarty = IkaSpy\createSmarty();
        $smarty->display('user.register.tpl');
    }