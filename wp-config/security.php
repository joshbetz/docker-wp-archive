<?php

define( 'DISALLOW_FILE_MODS', true );

if ( $_ENV['WP_PRODUCTION'] ) {
	define( 'FORCE_SSL_ADMIN', true );
}
