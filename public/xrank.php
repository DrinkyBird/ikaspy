<?php
    require_once '../common/common.php';
    
    $currentYear = intval(date('Y'));
    $currentMonth = intval(date('m'));
    $currentPeriod = ($currentYear * 100) + $currentMonth;

    $defaultPeriod = ($currentYear * 100) + ($currentMonth - 1);
    if ($currentMonth == 1) {
        $defaultPeriod = (($currentYear - 1) * 100) + 12;
    }
    
    $filter_period = filter_input(INPUT_GET, 'period', FILTER_VALIDATE_INT, [
        'options' => [
            'default' => $defaultPeriod,
        ]
    ]);
    
    $filter_mode = filter_input(INPUT_GET, 'mode', FILTER_DEFAULT, [
        'options' => [
            'default' => 'splatzones',
        ]
    ]);
    
    $mode = IkaSpy\getModeOrdinalById($filter_mode);
    
    $modeDropdown = [];
    for ($i = 0; $i < count(MODE_IDS); $i++) {
        $modeDropdown[MODE_IDS[$i]] = MODE_NAMES[$i];
    }
    
    $periods = [];
    {
        $year = 2018;
        $month = 5;
        
        while ($year <= $currentYear) {
            if ($year == $currentYear && $month >= $currentMonth) {
                break;
            }
            
            $period = $year * 100 + $month;
            $periods[$period] = MONTH_NAMES[$month - 1] . ' ' . $year;
            
            $month++;
            if ($month == 13) {
                $year++;
                $month = 1;
            }
        }
        
        $periods = array_reverse($periods, true);
    }
    
    $db = IkaSpy\connectDb();
    $sql = "
        SELECT 
            `rank_x`.`rank_change`, `rank_x`.`rank`, `rank_x`.`power`,
            `players`.`principal_id` AS `player_id`, `players`.`nickname` AS `player_name`, `players`.`icon` AS `player_icon`,
            `weapon_sets`.`name` AS `weapon_name`, `weapon_sets`.`thumbnail` AS `weapon_image`,
            `weapon_sub`.`name` AS `sub_name`, `weapon_sub`.`image_a` AS `sub_image`,
            `weapon_special`.`name` AS `special_name`, `weapon_special`.`image_a` AS `special_image`
        FROM `rank_x`, `players`, `weapon_sets`, `weapon_sub`, `weapon_special`
        WHERE 
            `player_id` = `players`.`principal_id`
        AND `weapon_id` = `weapon_sets`.`id`
        AND `weapon_sets`.`sub` = `weapon_sub`.`id`
        AND `weapon_sets`.`special` = `weapon_special`.`id`
        AND `mode` = :mode 
        AND `period` = :period 
        ORDER BY `rank` ASC
    ";
    $stmt = $db->prepare($sql);
    $stmt->bindParam(":mode", $mode, PDO::PARAM_INT);
    $stmt->bindParam(":period", $filter_period, PDO::PARAM_INT);
    $stmt->execute();
    $rows = $stmt->fetchAll();
    
    $smarty = IkaSpy\createSmarty();
    $smarty->assign('modeDropdown', $modeDropdown);
    $smarty->assign('selectedMode', $mode);
    $smarty->assign('selectedPeriod', $filter_period);
    $smarty->assign('periods', $periods);
    $smarty->assign('rows', $rows);
    $smarty->display('xrank.tpl');
?>