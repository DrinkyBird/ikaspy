{extends file="main.tpl"}
{block name=title}{$playerInfo->nickname|escape}{/block}
{block name=content}
    <h1 class="title">
        {if $playerInfo->icon !== null}
            <img src="{$playerInfo->icon|escape}" style="width: 30px; height: 30px;" referrerpolicy="no-referrer" />
        {/if}
        {$playerInfo->nickname|escape}
    </h1>
    <p>All times shown are in {$smarty.now|date_format:"%Z"} (UTC{$smarty.now|date_format:"%z"}).</p>
    <h2 class="subtitle">X Rank Placements</h2>
    {if count($xranks) == 0}
        <p>This player has never placed on the Rank X leaderboards.</p>
    {else}
        <table class="table is-striped">
            <thead>
                <tr>
                    <th>Period</th>
                    <th>Mode</th>
                    <th colspan="2">Rank</th>
                    <th>Power</th>
                    <th>Weapon</th>
                </tr>
            </thead>
            <tbody>
                {foreach $xranks as $placement}
                    <tr>
                        <td><a href="{$smarty.const.HTTP_ROOT}xrank?mode={IkaSpy\getModeId($placement->mode)}&amp;period={$placement->period}#rank-{$placement->rank}">{IkaSpy\periodToString($placement->period)}</a></td>
                        <td><a href="{$smarty.const.HTTP_ROOT}xrank?mode={IkaSpy\getModeId($placement->mode)}&amp;period={$placement->period}#rank-{$placement->rank}">{IkaSpy\getModeName($placement->mode)}</a></td>
                        <td>{IkaSpy\changeToArrow($placement->rank_change)}</td>
                        <td>{$placement->rank}</td>
                        <td>{$placement->power}</td>
                        <td>
                            <img src="{$smarty.const.HTTP_ROOT}assets/{$placement->weapon_image}" alt="{$placement->weapon_name}" title="{$placement->weapon_name}" style="width: 24px; height: 24px;" />
                            <img src="{$smarty.const.HTTP_ROOT}assets/{$placement->sub_image}" alt="{$placement->sub_name}" title="{$placement->sub_name}" style="width: 24px; height: 24px;" />
                            <img src="{$smarty.const.HTTP_ROOT}assets/{$placement->special_image}" alt="{$placement->special_name}" title="{$placement->special_name}" style="width: 24px; height: 24px;" />
                        </td>
                    </tr>
                {/foreach}
            </tbody>
        </table>
    {/if}
    
    <h2 class="subtitle">League Battle Placements</h2>
    {if count($leagues) == 0}
        <p>This player has never placed on the League Battle leaderboards.</p>
    {else}
        <table class="table is-striped">
            <thead>
                <tr>
                    <th colspan="2">Rotation</th>
                    <th>Region</th>
                    <th title="Regional">Rank</th>
                    <th>Power</th>
                    <th>Weapon</th>
                </tr>
            </thead>
            <tbody>
                {foreach $leagues as $placement}
                    <tr>
                        <td>
                            <a href="{$smarty.const.HTTP_ROOT}league?rotation={$placement->rotation_id}#{$placement->team_id}">
                                {$placement->rotation_start_time|date_format:"%F %H:%M"}
                            </a>
                        </td>
                        <td>
                            {if $placement->league_type == 0}Pair
                            {elseif $placement->league_type == 1}Team{/if}
                        </td>
                        <td>{$placement->league_region}</td>
                        <td>{$placement->league_rank}</td>
                        <td>{$placement->league_power}</td>
                        <td>
                            <img src="{$smarty.const.HTTP_ROOT}assets/{$placement->weapon_image}" alt="{$placement->weapon_name}" title="{$placement->weapon_name}" style="width: 24px; height: 24px;" />
                            <img src="{$smarty.const.HTTP_ROOT}assets/{$placement->sub_image}" alt="{$placement->sub_name}" title="{$placement->sub_name}" style="width: 24px; height: 24px;" />
                            <img src="{$smarty.const.HTTP_ROOT}assets/{$placement->special_image}" alt="{$placement->special_name}" title="{$placement->special_name}" style="width: 24px; height: 24px;" />
                        </td>
                    </tr>
                {/foreach}
            </tbody>
        </table>
    {/if}
{/block}