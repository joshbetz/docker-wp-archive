<?php

// Strip port from cookie domain
add_filter( 'get_network', function( $network ) {
	list( $cookie_domain ) = explode( ':', $network->cookie_domain );
	$network->cookie_domain = $cookie_domain;
	return $network;
});
