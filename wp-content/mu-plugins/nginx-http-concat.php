<?php

if ( is_admin() ) {
	return;
}

if ( ! defined( 'NGINX_HTTP_CONCAT_ENABLED' ) || ! NGINX_HTTP_CONCAT_ENABLED ) {
	return;
}

require __DIR__ . '/nginx-http-concat/jsconcat.php';
require __DIR__ . '/nginx-http-concat/cssconcat.php';
