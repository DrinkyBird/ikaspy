<!DOCTYPE html>
<html>
    <head>
        <meta charset='utf-8' />
        <title>{block name="title"}missing title block{/block} &mdash; IkaSpy</title>

        <link rel='stylesheet' type='text/css' href='{$smarty.const.HTTP_ROOT}assets/bulma.min.css' />

        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
		<script defer src="/assets/fsjs.js"></script>
    </head>
    <body>
        <nav class="navbar" role="navigation" aria-label="main navigation">
            <div class="navbar-brand">
                <div class="navbar-item">
                    <strong>IkaSpy</strong>
                </div>
                
                <a role="button" class="navbar-burger" aria-label="menu" aria-expanded="false" data-target="navbarMain" onclick="navbarClick()">
                    <span aria-hidden="true"></span>
                    <span aria-hidden="true"></span>
                    <span aria-hidden="true"></span>
                </a>
            </div>
            <div id="navbarMain" class="navbar-menu">
				<div class="navbar-start">
					<a class="navbar-item" href='/'>Home</a>
					<a class="navbar-item" href='/rotations'>Rotations</a>
					<a class="navbar-item" href='/xrank'>Rank X</a>
					<a class="navbar-item" href='/league'>League</a>
				</div>
			</div>
        </nav>
        
        <section class="section">
            <div class="container is-max-desktop">
                <div class="content">
                    {block name="content"}{/block}
                </div>
            </div>
        </section>
        
        <footer class="footer">
            <div class="content has-text-centered">
                <p>
                    This website is not affiliated with Nintendo. Data scraped from the SplatNet 2 API. Shoutouts to <a href="https://github.com/frozenpandaman/splatnet2statink">splatnet2statink</a>.
                </p>
            </div>
        </footer>
    </body>
</html>