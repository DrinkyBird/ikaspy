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
        
        Header("Location: " . HTTP_ROOT);
    } else {
        $smarty = IkaSpy\createSmarty();
        $smarty->display('user.login.tpl');
    }