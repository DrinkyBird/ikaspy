import requests
import json
import common
import config
from datetime import datetime
import time
import secrets

def handle_rotations(data):
    db = common.create_database()
    cursor = db.cursor()
    
    for rotation in data:
        rotation_type = -1
        if rotation['game_mode']['key'] == 'regular':
            rotation_type = common.ROTATION_REGULAR
        elif rotation['game_mode']['key'] == 'gachi':
            rotation_type = common.ROTATION_RANKED
        elif rotation['game_mode']['key'] == 'league':
            rotation_type = common.ROTATION_LEAGUE
        
        mode = -1
        if rotation['rule']['key'] == 'splat_zones':
            mode = common.MODE_SPLAT_ZONES
        if rotation['rule']['key'] == 'tower_control':
            mode = common.MODE_TOWER_CONTROL
        if rotation['rule']['key'] == 'rainmaker':
            mode = common.MODE_RAINMAKER
        if rotation['rule']['key'] == 'clam_blitz':
            mode = common.MODE_CLAM_BLITZ
        if rotation['rule']['key'] == 'turf_war':
            mode = common.MODE_TURF_WAR
            
        common.update_stage(cursor, int(rotation['stage_a']['id']), rotation['stage_a']['name'], rotation['stage_a']['image'])
        common.update_stage(cursor, int(rotation['stage_b']['id']), rotation['stage_b']['name'], rotation['stage_b']['image'])
        
        start_time = rotation['start_time']
        end_time = rotation['end_time']
        
        rot_id = common.create_rotation_id(start_time, rotation_type)
        
        sql = "INSERT IGNORE INTO rotations (id, start_time, end_time, type, mode, stage_a, stage_b) VALUES (%s, %s, %s, %s, %s, %s, %s)"
        values = (rot_id, start_time, end_time, rotation_type, mode, int(rotation['stage_a']['id']), int(rotation['stage_b']['id']))
        cursor.execute(sql, values)
        
    db.commit()
    
def scrape_rotations():
    api_url = "https://app.splatoon2.nintendo.net/api/schedules"
    cookies = dict(iksm_session=common.get_cookie())
    headers = {
        "User-Agent": config.USER_AGENT,
        "Accept": "application/json"
    }
    r = requests.get(api_url, cookies=cookies, headers=headers)
    data = r.json()
    
    handle_rotations(data['league'])
    handle_rotations(data['regular'])
    handle_rotations(data['gachi'])
        
if __name__ == "__main__":
    scrape_rotations()