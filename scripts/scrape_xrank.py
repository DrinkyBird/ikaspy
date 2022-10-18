import requests
import json
import common
import config
from datetime import datetime
import time
import secrets

# SELECT `rank_x`.*, `players`.`nickname` AS `player_name` FROM `rank_x`, `players` WHERE `player_id` = `players`.`principal_id`;

# period is an int of the format YYYYMM
def scrape_xrank_leaderboard(period, mode):
    db = common.create_database()
    cursor = db.cursor()
    
    api_start = str(period)[2:6] + "01T00"
    api_end = str(period + 1)[2:6] + "01T00"
    
    if api_end[2:4] == "13":
        year = int(api_end[0:2]) + 1
        api_end = f"{year}0101T00"
    
    mode_id = common.MODE_ORDINAL_TO_ID[mode]
    
    for page in range(1, 6):
        api_url = f"https://app.splatoon2.nintendo.net/api/x_power_ranking/{api_start}_{api_end}/{mode_id}?page={page}"
        print(api_url)
        
        cookies = dict(iksm_session=common.get_cookie())
        headers = {
            "User-Agent": config.USER_AGENT,
            "Accept": "application/json"
        }
        r = requests.get(api_url, cookies=cookies, headers=headers)
        data = r.json()
        
        try:
            top_rankings = data['top_rankings']
            for ranking in top_rankings:
                common.update_player(cursor, ranking['principal_id'], ranking['name'], None)
                common.update_weapon(cursor, ranking['weapon'])
                
                rank_change = common.RANK_CHANGE_SAME
                if ranking['rank_change'] == 'up':
                    rank_change = common.RANK_CHANGE_UP
                elif ranking['rank_change'] == 'down':
                    rank_change = common.RANK_CHANGE_DOWN
                
                sql = "INSERT IGNORE INTO rank_x (splatnet_id, mode, rank_change, rank, period, player_id, power, cheater, weapon_id) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)"
                values = (ranking['unique_id'], mode, rank_change, ranking['rank'], period, ranking['principal_id'], ranking['x_power'], ranking['cheater'], int(ranking['weapon']['id']))
                cursor.execute(sql, values)
        except KeyError as ex:
            print("KeyError")
            print(ex)
            
    db.commit()
    time.sleep(2)
    
def scrape_all_periods(mode):
    year = 2018
    month = 5
    currentMonth = datetime.now().month
    currentYear = datetime.now().year
    print(currentYear)
    print(currentMonth)
    
    while year <= currentYear:
        if year == currentYear and month == currentMonth:
            break
            
        period = (year * 100) + month
        scrape_xrank_leaderboard(period, mode)
        
        month += 1
        if month == 13:
            year += 1
            month = 1
            
def scrape_whole_leaderboard():
    for mode in range(0, 4):
        scrape_all_periods(mode)
            
def scrape_current_leaderboard():
    currentMonth = datetime.now().month
    currentYear = datetime.now().year
    
    currentMonth -= 1
    if currentMonth == 0:
        currentYear -= 1
        currentMonth = 12
    
    period = (currentYear * 100) + currentMonth
    
    for mode in range(0, 4):
        scrape_xrank_leaderboard(period, mode)
    
if __name__ == "__main__":
    print("AA")
    scrape_current_leaderboard()