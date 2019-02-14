node default {
# Test message
  notify { "Debug output on ${hostname} node.": }
  include ntp, git
}


node 'node01.example.com' {

	# Test message
	notify { "Debug output on ${hostname} node.": }
	include ntp, git, nginx

	class { '::mysql::server':
		root_password           => 'root'
	}

	class { '::php':
		ensure       => latest,
		manage_repos => true,
		fpm          => true,
		dev          => true,
		composer     => true,
		pear         => true,
		phpunit      => true,

		settings   => {
			'PHP/max_execution_time'  => '90',
			'PHP/max_input_time'      => '300',
			'PHP/memory_limit'        => '512M',
			'PHP/post_max_size'       => '32M',
			'PHP/upload_max_filesize' => '32M',
			'Date/date.timezone'      => 'Pacific/Auckland'
		},

		extensions => {
			'bcmath'    => { },
			'imagick'   => {
				provider => pecl,
				header_packages => [ 'libmagickwand-dev', 'libmagickcore-dev'],
			},

			'xmlrpc'    => { },
			'memcached' => {
				provider        => 'pecl',
				header_packages => [ 'libmemcached-dev'],
			},

			'mysql'  => {
				'multifile_settings' => true,
				'settings' => {
					'mysqli' => { },
					'mysqlnd' => { },
					'pdo_mysql' => { }
				}
			},

			'mbstring' => {},
			'gd' => {},
			'mongodb' => {
				provider => pecl
			}

		},
	}
}