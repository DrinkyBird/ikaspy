<?php
    namespace IkaSpy;
    
    define ('MONTH_NAMES', [
        'January', 'February', 'March', 'April',
        'May', 'June', 'July', 'August',
        'September', 'October', 'November', 'December'
    ]);
    
    define('MODE_NAMES', [
        'Splat Zones', 'Tower Control', 'Rainmaker', 'Clam Blitz', 'Turf War'
    ]);
    
    define('MODE_IDS', [
        'splatzones', 'towercontrol', 'rainmaker', 'clamblitz', 'turfwar'
    ]);
    
    function getModeName($mode) {
        return MODE_NAMES[$mode];
    }
    
    function getModeId($mode) {
        return MODE_IDS[$mode];
    }
    
    function getModeOrdinalById($id) {
        for ($i = 0; $i < count(MODE_IDS); $i++) {
            if (MODE_IDS[$i] === $id) {
                return $i;
            }
        }
        
        return -1;
    }