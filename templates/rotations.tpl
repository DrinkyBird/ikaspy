{extends file="main.tpl"}
{block name=title}Rotations{/block}
{block name=content}
    <h1 class="title">Rotations</h1>
    
    <p>Times are in {$smarty.now|date_format:"%Z"} (UTC{$smarty.now|date_format:"%z"}).</p>
    
    {assign var="last_time" value=0}
    
    {foreach $rotations as $rotation}
        {if $rotation->start_time != $last_time}
            <h2 class="subtitle">
                {$rotation->start_time|date_format:"%e %b %H:%M"} - {$rotation->end_time|date_format:"%e %b %H:%M"}
            </h2>
        {/if}
        <div class="panel">
            <p class="panel-heading">
                {if $rotation->type == 0}Regular Battle
                {elseif $rotation->type == 1}Ranked Battle
                {else}League Battle{/if}
            </p>
            
            <h2 class="subtitle">{IkaSpy\getModeName($rotation->mode)}</h2>
            <div class="columns">
                <div class="column is-one-half">
                    <div class="card">
                        <div class="card-image">
                            <figure class="image is-2by1">
                                <img src="/assets/{$stages[$rotation->stage_a]->image}" />
                            </figure>
                        </div>
                        
                        <div class="card-content">
                            <div class="content">
                                <h2 class="title is-4">{$stages[$rotation->stage_a]->name}</h2>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="column is-one-half">
                    <div class="card">
                        <div class="card-image">
                            <figure class="image is-2by1">
                                <img src="/assets/{$stages[$rotation->stage_b]->image}" />
                            </figure>
                        </div>
                        
                        <div class="card-content">
                            <div class="content">
                                <h2 class="title is-4">{$stages[$rotation->stage_b]->name}</h2>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        {assign var="last_time" value=$rotation->start_time}
    {/foreach}
{/block}