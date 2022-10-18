import requests
import json
import common
import config
from datetime import datetime, timedelta
import time
import secrets

updated_users = []

def query_user_info(cursor, ids):
    url = "https://app.splatoon2.nintendo.net/api/nickname_and_icon"
    for i in range(len(ids)):
        if i == 0:
            url += "?"
        else:
            url += "&"
        url += f"id={ids[i]}"
        
    cookies = dict(iksm_session=common.get_cookie())
    headers = {
        "User-Agent": config.USER_AGENT,
        "Accept": "application/json"
    }
    print(url)
    r = requests.get(url, cookies=cookies, headers=headers)
    data = r.json()
    
    for user in data['nickname_and_icons']:
        principal_id = user['nsa_id']
        nickname = user['nickname']
        icon = user['thumbnail_url']
        common.update_player(cursor, principal_id, nickname, icon)
        updated_users.append(principal_id)

def scrape_league_rotation(rotation, is_team, region):
    db = common.create_database()
    cursor = db.cursor()
    
    tssuffix = "T" if is_team else "P"
    
    api_url = f"https://app.splatoon2.nintendo.net/api/league_match_ranking/{rotation}{tssuffix}/{region}"
    cookies = dict(iksm_session=common.get_cookie())
    headers = {
        "User-Agent": config.USER_AGENT,
        "Accept": "application/json"
    }
    print(api_url)
    r = requests.get(api_url, cookies=cookies, headers=headers)
    data = r.json()
    
    if 'code' in data:
        if data['code'] == 'NOT_FOUND_ERROR':
            return
    
    rotation_start_time = data['start_time']
    rotation_id = common.create_rotation_id(rotation_start_time, common.ROTATION_LEAGUE)
    
    print(rotation_start_time)
    print(rotation_id)
    
    users_wanted = []
    
    for team in data['rankings']:
        for member in team['tag_members']:
            principal_id = member['principal_id']
            if principal_id not in updated_users:
                users_wanted.append(principal_id)
                
    query_user_info(cursor, users_wanted)
                
    for team in data['rankings']:
        team_id = team['tag_id']
        power = team['point']
        rank = team['rank']
        cheater = team['cheater']
        team_type = 1 if is_team else 0
        
        sql = "INSERT IGNORE INTO league_teams (rotation_id, team_id, type, power, rank, cheater, region) VALUES (%s, %s, %s, %s, %s, %s, %s)"
        values = (rotation_id, team_id, team_type, power, rank, cheater, region.upper())
        cursor.execute(sql, values)
        
        for member in team['tag_members']:
            principal_id = member['principal_id']
                
            common.update_weapon(cursor, member['weapon'])
            
            print(principal_id)
            
            sql = "INSERT IGNORE INTO league_members (rotation_id, team_id, player_id, weapon_id, splatnet_id) VALUES (%s, %s, %s, %s, %s)"
            values = (rotation_id, team_id, principal_id, member['weapon']['id'], member['unique_id'])
            cursor.execute(sql, values)
        
    db.commit()
    
if __name__ == "__main__":
    dt = datetime.utcnow().replace(microsecond=0, second=0, minute=0)
    if dt.hour % 2 != 0:
        dt = dt - timedelta(hours=1)
    dt = dt - timedelta(hours=4)
    rotstr = dt.strftime("%y%m%d%H")
    print (rotstr)
    #scrape_league_rotation("21092716", True, "EU")
    
    for region in ['EU', 'US', 'JP']:
        for is_team in [True, False]:
            scrape_league_rotation(rotstr, is_team, region)
            
            print("Sleeping 5 seconds")
            time.sleep(5)