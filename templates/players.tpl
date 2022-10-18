{extends file="main.tpl"}
{block name=title}Players{/block}
{block name=content}
    <h1 class="title">Players</h1>
    <p>{$playerCount|number_format} players are currently known:</p>
    <table class="table is-striped">
        <thead>
            <tr>
                <th>Principal ID</th>
                <th>Icon</th>
                <th>Nickname</th>
                <th>Last Seen</th>
            </tr>
        </thead>
        <tbody>
            {foreach $playerInfo as $player}
                <tr>
                    <td><code>{$player->principal_id|escape}</code></td>
                    <td>
                        {if $player->icon !== null}
                            <a href="{$player->icon|escape}" rel="noreferrer">
                                <img src="{$player->icon|escape}" loading="lazy" style="width: 24px; height: 24px;" referrerpolicy="no-referrer" />
                            </a>
                        {/if}
                    </td>
                    <td><a href="{$smarty.const.HTTP_ROOT}players/{$player->principal_id|escape}">{$player->nickname|escape}</a></td>
                    <td>{$player->last_updated|date_format:"%F %T %Z"}</td>
                </tr>
            {/foreach}
        </tbody>
    </table>
{/block}