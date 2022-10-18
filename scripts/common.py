import json
import config
import mysql.connector
import time
import math
    
MODE_SPLAT_ZONES = 0
MODE_TOWER_CONTROL = 1
MODE_RAINMAKER = 2
MODE_CLAM_BLITZ = 3
MODE_TURF_WAR = 4

RANK_CHANGE_DOWN = -1
RANK_CHANGE_SAME = 0
RANK_CHANGE_UP = 1

ROTATION_REGULAR = 0
ROTATION_RANKED = 1
ROTATION_LEAGUE = 2 

MODE_ORDINAL_TO_ID = {
    MODE_SPLAT_ZONES: "splat_zones",
    MODE_TOWER_CONTROL: "tower_control",
    MODE_RAINMAKER: "rainmaker",
    MODE_CLAM_BLITZ: "clam_blitz"
}

def create_database():
    db = mysql.connector.connect(
        host=config.DB_HOST,
        user=config.DB_USER,
        password=config.DB_PASSWORD,
        database=config.DB_NAME
    )
    
    return db
        
def get_cookie():
    with open(config.SPLATNET2STATINK_CONFIG, "r") as f:
        text = f.read()
        data = json.loads(text)
        return data['cookie']
        
def update_player(cursor, principal_id, nickname, icon):
    now = math.floor(time.time())
    sql = "INSERT INTO players (principal_id, nickname, icon, last_updated) VALUES (%s, %s, %s, %s) ON DUPLICATE KEY UPDATE nickname = COALESCE(nickname, %s), icon = COALESCE(icon, %s), last_updated = %s"
    cursor.execute(sql, (principal_id, nickname, icon, now, nickname, icon, now))
        
def update_stage(cursor, stage_id, name, image):
    now = math.floor(time.time())
    sql = "INSERT INTO stages (id, name, image) VALUES (%s, %s, %s) ON DUPLICATE KEY UPDATE name = COALESCE(name, %s), image = COALESCE(image, %s)"
    cursor.execute(sql, (stage_id, name, image, name, image))
    
def update_weapon(cursor, data):
    sub_id = None
    special_id = None
    
    if 'special' in data:
        special = data['special']
        special_id = int(special['id'])
        image_a = special['image_a'] if 'image_a' in special else None
        image_b = special['image_b'] if 'image_b' in special else None
        sql = "INSERT INTO weapon_special (id, name, image_a, image_b) VALUES (%s, %s, %s, %s) ON DUPLICATE KEY UPDATE name = %s, image_a = COALESCE(image_a, %s), image_b = COALESCE(image_b, %s)"
        cursor.execute(sql, (special_id, special['name'], image_a, image_b, special['name'], image_a, image_b))
    
    if 'sub' in data:
        sub = data['sub']
        sub_id = int(sub['id'])
        image_a = sub['image_a'] if 'image_a' in sub else None
        image_b = sub['image_b'] if 'image_b' in sub else None
        sql = "INSERT INTO weapon_sub (id, name, image_a, image_b) VALUES (%s, %s, %s, %s) ON DUPLICATE KEY UPDATE name = %s, image_a = COALESCE(image_a, %s), image_b = COALESCE(image_b, %s)"
        cursor.execute(sql, (sub_id, sub['name'], image_a, image_b, sub['name'], image_a, image_b))
    
    weapon_id = int(data['id'])
    sql = "INSERT INTO weapon_sets (id, name, thumbnail, image, sub, special) VALUES (%s, %s, %s, %s, %s, %s) ON DUPLICATE KEY UPDATE name = %s, thumbnail = COALESCE(thumbnail, %s), image = COALESCE(image, %s), sub = COALESCE(sub, %s), special = COALESCE(special, %s)"
    cursor.execute(sql, (weapon_id, data['name'], data['thumbnail'], data['image'], sub_id, special_id, data['name'], data['thumbnail'], data['image'], sub_id, special_id))
    
def create_rotation_id(start_time, rotation_type):
    epoch = 1498867200 # 2017-07-01 00:00:00 UTC
    
    number = str(int((start_time - epoch) / 7200))
    
    if rotation_type == ROTATION_REGULAR:
        return number + "T"
    elif rotation_type == ROTATION_RANKED:
        return number + "R"
    elif rotation_type == ROTATION_LEAGUE:
        return number + "L"