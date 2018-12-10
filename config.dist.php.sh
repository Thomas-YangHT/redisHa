source ./CONFIG
for NodeIP in `echo $NODES|sed 's/,/ /g'`
do

cat >config.dist.php.${NodeIP} <<EOF
<?php
\$config = array(
    'default_controller' => 'Welcome',
    'default_action'     => 'Index',
    'production'         => true,
    'default_layout'     => 'layout',
    'timezone'           => 'Asia/Shanghai',
    'auth' => array(
        'username' => 'admin',
        'password' => password_hash('admin', PASSWORD_DEFAULT)
	), 
    'log' => array(
        'driver'    => 'file',
        'threshold' => 1, /* 0: Disable Logging 1: Error 2: Notice 3: Info 4: Warning 5: Debug */
        'file'      => array(
            'directory' => 'logs'
        )
    ),
    'database'  => array(
        'driver' => 'redis',
        'mysql'  => array(
            'host'     => 'localhost',
            'username' => 'root',
            'password' => 'root'
        ),
        'redis' => array(
            array(
                'host'     => '${NodeIP}',
                'port'     => '${MasterPort}',
                'password' => '${requirepass}',
                'database' => 0,
                'max_databases' => 16, /* Manual configuration of max databases for Redis < 2.6 */
                'stats'    => array(
                    'enable'   => 1,
                    'database' => 0,
                ),
                'dbNames' => array( /* Name databases. key should be database id and value is the name */
                ),
            ),
        ),
    ),
    'session' => array(
        'lifetime'       => 7200,
        'gc_probability' => 2,
        'name'           => 'phpredminsession'
    ),
    'gearman' => array(
        'host' => '127.0.0.1',
        'port' => 4730
    ),
    'terminal' => array(
        'enable'  => true,
        'history' => 200
    )
);

return \$config;
EOF

done
