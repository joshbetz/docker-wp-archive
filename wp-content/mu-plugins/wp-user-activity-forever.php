<?php

/**
 * Don't allow users to delete or edit their activity.
 *
 * If the site has been hacked, make it hard for attackers
 * to cover their steps.
 */
add_filter( 'wp_user_activity_meta_caps', function( $caps, $cap ) {
	switch ( $cap ) {

		// Editing
		case 'publish_activities':
		case 'edit_others_activities':
		case 'edit_activity':

		// Deleting
		case 'delete_activity':
		case 'delete_activities':
		case 'delete_others_activities':
			return array( 'do_not_allow' );

		case 'edit_activities': // Needed to list activities
		default:
			return $caps;
	}
}, 0, 2 );
