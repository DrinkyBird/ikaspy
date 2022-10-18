<?php
    namespace IkaSpy;
    
    require_once '../config.php';
    require_once 'defines.php';
    require_once '../lib/smarty/Smarty.class.php';
    
    function createSmarty() {
        $appRoot = dirname(dirname(__FILE__));
       
        $smarty = new \Smarty();
        $smarty->setTemplateDir($appRoot . '/templates');
        $smarty->setCompileDir($appRoot . '/runtime/templates_c');
        $smarty->setCacheDir($appRoot . '/runtime/cache');
        
        return $smarty;
    }
    
    function connectDb() {
        $dsn = "mysql:host=".DB_HOST.";dbname=".DB_NAME.";charset=utf8mb4";
        $db = new \PDO($dsn, DB_USER, DB_PASS, [
            \PDO::ATTR_ERRMODE            => \PDO::ERRMODE_EXCEPTION,
            \PDO::ATTR_DEFAULT_FETCH_MODE => \PDO::FETCH_OBJ,
            \PDO::ATTR_EMULATE_PREPARES   => false,
        ]);
        
        return $db;
    }
    
    function changeToArrow($change) {
        switch ($change) {
            case -1: return "↑";
            case  1: return "↓";
            default: return "=";
        }
    }
    
    function periodToString($period) {
        $year = intval(substr(strval($period), 0, 4), 10);
        $month = intval(substr(strval($period), 4, 2), 10);
        
        return MONTH_NAMES[$month - 1] . " " . $year;
    }