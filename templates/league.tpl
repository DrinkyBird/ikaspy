{extends file="main.tpl"}
{block name=title}League Battle Leaderboards{/block}
{block name=content}
    <h1 class="title">League Battle Leaderboards</h1>
    <p>All times shown are in {$smarty.now|date_format:"%Z"} (UTC{$smarty.now|date_format:"%z"}).</p>
    
    <div class="box">
        <div class="columns">
            <div class="column">
                {if $lastRotation !== false}
                    <a href="?rotation={$lastRotation->id}&region={$filterRegion}"><< {$lastRotation->start_time|date_format:"%e %b %Y %H:%M"}</a>
                {/if}
            </div>
            <div class="column is-two-thirds" style="text-align: center">
                <p><b>{$rotationInfo->start_time|date_format:"%e %b %Y %H:%M"}</b></p>
                <p>{IkaSpy\getModeName($rotationInfo->mode)}</p>
                <p>{$stageA->name}</p>
                <p>{$stageB->name}</p>
            </div>
            <div class="column">
                {if $nextRotation !== false}
                    <a href="?rotation={$nextRotation->id}&region={$filterRegion}">{$nextRotation->start_time|date_format:"%e %b %Y %H:%M"} >></a>
                {/if}
            </div>
        </div>
    </div>
    
    <form action="" method="GET">
        <input type="hidden" name="rotation" value="{$rotationInfo->id}" />
        <div class="field">
            <label class="label" for="region">Region</label>
            <div class="control">
                <div class="select">
                    <select name="region" id="region">
                        <option value="ALL" {if $filterRegion == 'ALL'}selected="selected"{/if}>All</option>
                        <option value="EU" {if $filterRegion == 'EU'}selected="selected"{/if}>Europe</option>
                        <option value="US" {if $filterRegion == 'US'}selected="selected"{/if}>Americas and Oceania</option>
                        <option value="JP" {if $filterRegion == 'JP'}selected="selected"{/if}>Japan</option>
                    </select>
                </div>
            </div>
        </div>
        <div class="field">
            <div class="control">
                <input class="button is-link" type="submit" value="Filter" />
            </div>
        </div>
    </form>
    
    <div class="columns">
        {foreach ['Team' => $teamData, 'Pair' => $pairData] as $title => $data}
            <div class="column">
                <div class="panel">
                    <div class="panel-heading">
                        {$title}
                    </div>
                    {if count($data) == 0}
                        <div class="panel-block" style="display:block">
                            No {$title} League Battle data is known for this rotation yet; check back in a few hours...
                        </div>
                    {else}
                        {foreach $data as $team}
                            <div class="panel-block" style="display:block" id="{$team['team_id']}">
                                <div>
                                    <span class="panel-icon">{$team['rank']}</span>
                                    <b>Power:</b> {$team['power']}
                                    <b>Region:</b> {$team['region']}
                                    <b>Team ID:</b> <code>{$team['team_id']}</code>
                                </div>
                                
                                <div class="columns">
                                    {foreach $team['members'] as $member}
                                        <div class="column">
                                            {if $member['player_icon'] !== null}
                                                <a href="{$smarty.const.HTTP_ROOT}players/{$member['player_id']}">
                                                    <img src="{$member['player_icon']|escape}" loading="lazy" style="width: 16px; height: 16px;" referrerpolicy="no-referrer" />
                                                </a>
                                            {/if}
                                            <img src="{$smarty.const.HTTP_ROOT}assets/{$weaponSets[$member['weapon_id']]->image}" alt="{$weaponSets[$member['weapon_id']]->name}" title="{$weaponSets[$member['weapon_id']]->name}" style="width: 16px; height: 16px;" loading="lazy" />
                                            <img src="{$smarty.const.HTTP_ROOT}assets/{$weaponSubs[$weaponSets[$member['weapon_id']]->sub]->image}" alt="{$weaponSubs[$weaponSets[$member['weapon_id']]->sub]->name}" title="{$weaponSubs[$weaponSets[$member['weapon_id']]->sub]->name}" style="width: 16px; height: 16px;" loading="lazy" />
                                            <img src="{$smarty.const.HTTP_ROOT}assets/{$weaponSpecials[$weaponSets[$member['weapon_id']]->special]->image}" alt="{$weaponSpecials[$weaponSets[$member['weapon_id']]->special]->name}" title="{$weaponSpecials[$weaponSets[$member['weapon_id']]->special]->name}" style="width: 16px; height: 16px;" loading="lazy" />
                                            <br />
                                            <a href="{$smarty.const.HTTP_ROOT}players/{$member['player_id']}">{$member['player_nickname']}</a>
                                        </div>
                                    {/foreach}
                                </div>
                            </div>
                        {/foreach}
                    {/if}
                </div>
            </div>
        {/foreach}
    </div>
{/block}