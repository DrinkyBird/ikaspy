<?php
    require_once '../common/common.php';
    
    $smarty = IkaSpy\createSmarty();
    $smarty->display('index.tpl');