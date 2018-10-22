<?php

add_action( 'phpmailer_init', function( $phpmailer ) {
	$phpmailer->isSMTP();
	$phpmailer->Host = 'smtp';
});
