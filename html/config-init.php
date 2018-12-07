<?php

// Configuration options handled (read and write) by PHP.
define('THIS_CONFIG_PHP', '/etc/airpi/www-config.php');
// Extra options, handled by external means (read only by PHP).
define('THIS_CONFIG_OVERRIDE', '/etc/airpi/www-config-override.php');

// Read $config settings from local files.
function local_config_read() {
    global $config;
    if (file_exists(THIS_CONFIG_PHP)) include(THIS_CONFIG_PHP);
    if (file_exists(THIS_CONFIG_OVERRIDE)) include(THIS_CONFIG_OVERRIDE);
}

// Write $config settings to local file.
function local_config_write() {
    global $config;
    $config_export  = "<?php\n// Do not edit this file! It will be overwritten by PHP local_config_write().\n";
    $config_export .= "// Set your overrides in \"" . THIS_CONFIG_OVERRIDE . "\" instead.\n";
    $config_export .= '$config = ' . var_export($config, true) . ";\n";
    return file_put_contents(THIS_CONFIG_PHP, $config_export);
}

// Default, hard-coded, fallback $config array().
// Do not edit this file, change THIS_CONFIG_PHP instead.
$config = array();
$config['users'] = array(
    'admin' => array(
        'passwd' => '$2y$10$LdZb2R1p6D1uHBdwl9F6jemf0GoFFA0DHjxkwlX7c254YK6VFuqeO',  // "secret"
        'isadmin' => true));
$config['lang'] = 'en_US';
$config['app_title'] = 'AirPi Station';
$config['station_name'] = 'Local AirPi Station';
$config['pg_connect'] = '';
$config['stale_rrd'] = 900;
$config['config_options_dir'] = '/etc/host-config';

local_config_read();

?>
