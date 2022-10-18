# [IkaSpy](https://ikaspy.drinkybird.net)

A website for analysing Splatoon 2 Rank X and League Battle data.

## Config

* You need a `scripts/config.py` with your database info, etc: 
  ```python
  DB_HOST = "localhost"
  DB_USER = "ikaspy"
  DB_PASSWORD = "hunter2"
  DB_NAME = "ikaspy"

  # Copied from splatnet2statink's code.
  USER_AGENT = "Mozilla/5.0 (Linux; Android 11; Pixel 5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.61 Mobile Safari/537.36"

  SPLATNET2STATINK_CONFIG = "/home/sean/splatnet2statink/config.txt"
  ```
  The `SPLATNET2STATINK_CONFIG` variable should point to a `config.txt` from [splatnet2statink](https://github.com/frozenpandaman/splatnet2statink).
* You also need a `config.php` in the root directory:
  ```php
  <?php
      define('DB_HOST', 'localhost');
      define('DB_USER', 'ikaspy');
      define('DB_PASS', 'hunter2');
      define('DB_NAME', 'ikaspy');

      define('HTTP_ROOT', '/');
  ```
