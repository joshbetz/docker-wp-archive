<?php

namespace Mercator\SSO_Redirect;

use Mercator\Mapping;

add_action( 'plugins_loaded', __NAMESPACE__ . '\handle_redirect' );

function is_enabled( $mapping = null ) {
	$mapping = $mapping ?: $GLOBALS['mercator_current_mapping'];

	/**
	 * Determine whether a mapping should be used
	 *
	 * Typically, you'll want to only allow active mappings to be used. However,
	 * if you want to use more advanced logic, or allow non-active domains to
	 * be mapped too, simply filter here.
	 *
	 * @param boolean $is_active Should the mapping be treated as active?
	 * @param Mapping $mapping   Mapping that we're inspecting
	 */
	return apply_filters( 'mercator.redirect.enabled', $mapping->is_active(), $mapping );
}

/**
 * Performs the redirect to the primary domain
 */
function handle_redirect() {

	// Custom domain redirects need SUNRISE.
	if ( ! defined( 'SUNRISE' ) || ! SUNRISE ) {
		return;
	}

	// Don't redirect REST API requests
	// TODO: Temporarily disabled, fix it?
	if ( false && 0 === strpos( $_SERVER['REQUEST_URI'], parse_url( rest_url(), PHP_URL_PATH ) ) ) {
		return;
	}

	// Should we redirect visits to the admin?
	if ( is_admin() || $GLOBALS['pagenow'] === 'wp-login.php' ) {
		// Get mapping if it exists, if we're already on the primary domain we'll exit here
		$mapping = Mapping::get_by_domain( $_SERVER['HTTP_HOST'] );
		if ( is_wp_error( $mapping ) || ! $mapping ) {
			return;
		}

		if ( ! is_enabled( $mapping ) ) {
			return;
		}

		// Use blogs table domain as the primary domain
		wp_redirect( 'http://' . $mapping->get_site()->domain . esc_url_raw( $_SERVER['REQUEST_URI'] ), 301 );
		exit;
	}

	$site = get_site( get_current_blog_id() );

	$mappings = Mapping::get_by_site( get_current_blog_id() );
	if ( is_wp_error( $mappings ) || ! $mappings ) {
		return;
	}

	foreach ( $mappings as $mapping ) {
		if ( ! is_enabled( $mapping ) ) {
			continue;
		}

		// Redirect to the first active alias if we're not there already
		if ( $_SERVER['HTTP_HOST'] !== $mapping->get_domain() ) {
			wp_redirect( 'http://' . $mapping->get_domain() . esc_url_raw( $_SERVER['REQUEST_URI'] ), 301 );
			exit;
		}
		
		break;
	}
}
