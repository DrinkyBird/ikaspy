{extends file="main.tpl"}
{block name=title}Rank X Leaderboards{/block}
{block name=content}
    <h1 class="title">Rank X Leaderboards</h1>
    <div class="columns">
        <div class="column is-one-quarter">
            <form action="" method="GET">
                <div class="field">
                    <label class="label" for="mode">Mode</label>
                    <div class="control">
                        <div class="select">
                            <select name="mode" id="mode">
                                {foreach $modeDropdown as $id => $name}
                                    {if $selectedMode != -1 && IkaSpy\getModeId($selectedMode) == $id}
                                        <option value="{$id}" selected="selected">{$name}</option>
                                    {else}
                                        <option value="{$id}">{$name}</option>
                                    {/if}
                                {/foreach}
                            </select>
                        </div>
                    </div>
                </div>
                <div class="field">
                    <label class="label" for="period">Period</label>
                    <div class="control">
                        <div class="select">
                            <select name="period" id="period">
                                {foreach $periods as $period => $label}
                                    {if $period == $selectedPeriod}
                                        <option value="{$period}" selected="selected">{$label}</option>
                                    {else}
                                        <option value="{$period}">{$label}</option>
                                    {/if}
                                {/foreach}
                            </select>
                        </div>
                    </div>
                </div>
                <div class="field">
                    <div class="control">
                        <input class="button is-link" type="submit" value="Go" />
                    </div>
                </div>
            </form>
        </div>
        <div class="column">
            <h2 class="subtitle">{IkaSpy\periodToString($selectedPeriod)} - {IkaSpy\getModeName($selectedMode)}</h2>
            <table class="table is-striped">
                <thead>
                    <tr>
                        <th colspan="2">Rank</th>
                        <th colspan="2">Player</th>
                        <th>Power</th>
                        <th>Weapon</th>
                    </tr>
                </thead>
                <tbody>
                    {foreach $rows as $row}
                        <tr id="rank-{$row->rank}">
                            <td>{IkaSpy\changeToArrow($row->rank_change)}</td>
                            <td>{$row->rank}</td>
                            <td>
                                {if $row->player_icon !== null}
                                    <a href="{$smarty.const.HTTP_ROOT}players/{$row->player_id}">
                                        <img src="{$row->player_icon|escape}" loading="lazy" style="width: 24px; height: 24px;" referrerpolicy="no-referrer" />
                                    </a>
                                {/if}
                            </td>
                            <td><a href="{$smarty.const.HTTP_ROOT}players/{$row->player_id}">{$row->player_name|escape}</a></td>
                            <td>{$row->power}</td>
                            <td>
                                <img src="{$smarty.const.HTTP_ROOT}assets/{$row->weapon_image}" alt="{$row->weapon_name}" title="{$row->weapon_name}" style="width: 24px; height: 24px;" loading="lazy" />
                                <img src="{$smarty.const.HTTP_ROOT}assets/{$row->sub_image}" alt="{$row->sub_name}" title="{$row->sub_name}" style="width: 24px; height: 24px;" loading="lazy" />
                                <img src="{$smarty.const.HTTP_ROOT}assets/{$row->special_image}" alt="{$row->special_name}" title="{$row->special_name}" style="width: 24px; height: 24px;" loading="lazy" />
                            </td>
                        </tr>
                    {/foreach}
                </tbody>
            </table>
        </div>
    </div>
{/block}