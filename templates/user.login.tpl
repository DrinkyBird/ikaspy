{extends file="main.tpl"}
{block name=title}Register{/block}
{block name=content}
    <h1 class="title">Log in</h1>
    
    {if $error !== null}
        <article class="message is-danger">
            <div class="message-body">
                {if $error === 'noUsername'}
                    Username not specified
                {elseif $error === 'noEmail'}
                    Email not specified
                {elseif $error === 'noPassword'}
                    Password not specified
                {elseif $error === 'noConfirmPassword'}
                    Password (confirm) not specified
                {elseif $error === 'invalidEmail'}
                    Email address is invalid
                {elseif $error === 'confirmPasswordMismatch'}
                    Passwords do not match
                {elseif $error === 'usernameTaken'}
                    That username is already taken
                {elseif $error === 'emailTaken'}
                    That email is already in use
                {/if}
            </div>
        </article>
    {/if}
    
    <form action="" method="POST">
        <div class="field">
            <label class="label" for="username">Username</label>
            <div class="control">
                <input class="input" type="text" name="username" id="username" value="{$smarty.post.username}" required="required" />
            </div>
        </div>
        <div class="field">
            <label class="label" for="password">Password</label>
            <div class="control">
                <input class="input" type="password" name="password" id="password" value="{$smarty.post.password}" required="required" />
            </div>
        </div>
        <div class="field">
            <div class="control">
                <input class="button is-link" type="submit" value="Log in" />
            </div>
        </div>
    </form>
{/block}