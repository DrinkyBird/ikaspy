{extends file="main.tpl"}
{block name=title}Home{/block}
{block name=content}
    <h1 class="title">Home</h1>
    <p>Pretend this is a really great landing page ok:</p>
    <ul>
        <li><a href="{$smarty.const.HTTP_ROOT}rotations">Rotations</a></li>
        <li><a href="{$smarty.const.HTTP_ROOT}xrank">Rank X Leaderboards</a></li>
        <li><a href="{$smarty.const.HTTP_ROOT}league">League Battle Leaderboard</a></li>
    </ul>
{/block}