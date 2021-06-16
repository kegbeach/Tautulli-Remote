// DO NOT EDIT. This is code generated via package:easy_localization/generate.dart

// ignore_for_file: prefer_single_quotes

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' show AssetLoader;

class CodegenLoader extends AssetLoader{
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>> load(String fullPath, Locale locale ) {
    return Future.value(mapLocales[locale.toString()]);
  }

  static const Map<String,dynamic> en = {
  "activity_empty": "Nothing is currently being played",
  "activity_page_title": "Activity",
  "history_page_title": "History",
  "recently_added_page_title": "Recently Added",
  "libraries_page_title": "Libraries",
  "users_page_title": "Users",
  "statistics_page_title": "Statistics",
  "graphs_page_title": "Graphs",
  "synced_items_page_title": "Synced Items",
  "announcements_page_title": "Announcements",
  "donate_page_title": "Donate",
  "settings_page_title": "Settings",
  "media_details_audio": "AUDIO",
  "media_details_transcode": "Transcode",
  "media_details_direct_stream": "Direct Stream",
  "media_details_direct_play": "Direct Play",
  "media_details_unknown": "Unknown",
  "media_details_bandwidth": "BANDWIDTH",
  "media_details_container": "CONTAINER",
  "media_details_converting": "Converting",
  "media_details_na": "N/A",
  "masked_info_ip_address": "Hidden IP Address",
  "media_details_location": "LOCATION",
  "media_details_relay_message": "This stream is using Plex Relay",
  "masked_info_location": "Hidden Location",
  "media_details_optimized": "OPTIMIZED",
  "media_details_player": "PLAYER",
  "media_details_product": "PRODUCT",
  "media_details_quality": "QUALITY",
  "media_details_throttled": "Throttled",
  "media_details_speed": "Speed",
  "media_details_stream": "STREAM",
  "media_details_subtitle": "SUBTITLE",
  "media_details_burn": "Burn",
  "media_details_none": "None",
  "media_details_synced": "SYNCED",
  "media_details_video": "VIDEO",
  "button_view_user": "View User",
  "button_view_media": "View Media",
  "button_terminate_stream": "Terminate Stream",
  "button_learn_more": "LEARN MORE",
  "masked_info_user": "Hidden User",
  "termination_request_sent_alert": "Termination request sent to Plex",
  "termination_default_message": "The server owner has ended the stream",
  "termination_photo_alert": "Photo streams cannot be terminated",
  "termination_synced_alert": "Synced content cannot be terminated",
  "termination_dialog_title": "Are you sure you want to terminate this stream",
  "termination_terminate_message_label": "Terminate Message",
  "button_cancel": "CANCEL",
  "button_terminate": "TERMINATE",
  "button_go_to_settings": "Go to settings",
  "button_retry": "Retry",
  "media_details_location_error": "ERROR: IP Address not in GeoIP map",
  "media_details_location_loading": "Loading location data",
  "activity_time_left": "left",
  "settings_not_loaded_error": "ERROR: Settings not loaded",
  "general_unknown_error": "Unknown Error",
  "donate_thank_you_alert": "Thank you for your donation",
  "donate_error_alert": "Something went wrong.",
  "donate_message_title": "Tautulli Remote is free and open source.",
  "donate_message_body": "However, any contributions you can make towards the app are appreciated!",
  "donate_one_time_heading": "One-Time Donations",
  "donate_cone": "Buy Me A Cone",
  "donate_slice": "Buy Me A Slice",
  "donate_burger": "Buy Me A Burger",
  "donate_meal": "Buy Me A Meal",
  "donate_recurring_heading": "Recurring Donations",
  "donate_tip_jar": "Tip Jar",
  "donate_big_tip": "Big Tip",
  "donate_supporter": "Supporter",
  "donate_patron": "Patron",
  "donate_load_failed": "Failed to load donation items.",
  "donate_month": "month",
  "graphs_media_type_tab": "Media Type",
  "graphs_stream_type_tab": "Stream Type",
  "graphs_play_totals_tab": "Play Totals",
  "general_filter_plays": "Plays",
  "general_filter_duration": "Duration",
  "general_tooltip_y_axis": "Y Axis",
  "general_tooltip_time_range": "Time Range",
  "general_filter_days": "Days",
  "general_filter_custom": "Custom",
  "general_time_range_dialog_title": "Custom Time Range",
  "general_time_range_dialog_hint_text": "Enter a time range in days",
  "general_time_range_dialog_validator_integer": "Please enter an integer",
  "general_time_range_dialog_notice": "It is recommended you do not exceed 90 days for most screen sizes.",
  "button_save": "SAVE",
  "button_close": "CLOSE",
  "masked_info_hidden": "Hidden",
  "graphs_no_plays": "No plays for the selected time range",
  "graphs_load_fail": "Failed to load graph",
  "graphs_media_type_daily_play": "Daily Play {} by Media Type",
  "graphs_media_type_day_of_week": "Play {} by Day of the Week",
  "graphs_media_type_hour_of_day": "Play {} by Hour of the Day",
  "graphs_media_type_top_platforms": "Play {} by Top 10 Platforms",
  "graphs_media_type_top_users": "Play {} by Top 10 Users",
  "general_filter_count": "Count",
  "graphs_play_totals_last_12_months": "Total Play {} for Last 12 Months",
  "graphs_stream_type_daily_play": "Daily Play {} by Stream Type",
  "graphs_stream_type_source_resolution": "Play {} by Source Resolution",
  "graphs_stream_type_stream_resolution": "Play {} by Stream Resolution",
  "graphs_stream_type_platform": "Play {} by Platform Stream Type",
  "graphs_stream_type_user": "Play {} by User Stream Type",
  "help_help_topics_heading": "Help Topics",
  "help_support_heading": "Support",
  "help_bugs_features_heading": "Bugs/Feature Requests",
  "help_logs_heading": "Logs",
  "help_tautulli_remote_logs": "View Tautulli Remote logs",
  "help_page_title": "Help & Support",
  "history_empty": "No history found.",
  "history_filter_empty": "No history for the selected filters found.",
  "general_filter_users": "Users",
  "general_filter_users_loading": "Loading users",
  "general_filter_users_failed": "Users failed to load",
  "general_filter_history": "Filter history",
  "general_movies": "Movies",
  "general_tv": "TV",
  "general_live_tv": "Live TV",
  "general_tv_shows": "TV Shows",
  "general_music": "Music",
  "general_videos": "Videos",
  "general_all": "All",
  "history_details_user": "USER",
  "history_details_platform": "PLATFORM",
  "history_details_product": "PRODUCT",
  "history_details_player": "PLAYER",
  "history_details_ip_address": "IP ADDRESS",
  "history_details_date": "DATE",
  "history_details_started": "STARTED",
  "history_details_stopped": "STOPPED",
  "history_details_paused": "PAUSED",
  "history_details_watched": "WATCHED",
  "libraries_empty": "No libraries found.",
  "general_tooltip_sort_libraries": "Sort libraries",
  "general_filter_name": "Name",
  "general_never": "never",
  "libraries_details_streamed": "STREAMED",
  "libraries_details_tab_stats": "Stats",
  "libraries_details_tab_new": "New",
  "libraries_details_tab_media": "Media",
  "libraries_details_movies": "MOVIES",
  "libraries_details_shows": "SHOWS",
  "libraries_details_seasons": "SEASONS",
  "libraries_details_episodes": "EPISODES",
  "libraries_details_artists": "ARTISTS",
  "libraries_details_albums": "ALBUMS",
  "libraries_details_tracks": "TRACKS",
  "libraries_details_photos": "PHOTOS",
  "libraries_details_videos": "VIDEOS",
  "libraries_details_plays": "PLAYS",
  "general_details_duration": "DURATION",
  "general_details_days": "days",
  "general_details_hrs": "hrs",
  "general_details_mins": "mins",
  "general_details_secs": "secs",
  "libraries_media_tab_empty": "No items found.",
  "libraries_full_refresh": "Performing a full refresh of library media.",
  "libraries_details_recent_tab_failure": "Failed to fetch items.",
  "libraries_details_all_time": "All Time",
  "general_details_min": "min",
  "libraries_details_hours": "Hours",
  "statistics_empty": "No statistics found.",
  "libraries_details_user_stats_heading": "User Stats",
  "libraries_details_global_stats_heading": "Global Stats",
  "logs_page_title": "Tautulli Remote Logs",
  "logs_export": "Export logs",
  "logs_clear": "Clear logs",
  "logs_exported": "Logs exported",
  "button_access_logs": "HOW TO ACCESS LOGS",
  "logs_failed": "Failed to load logs.",
  "logs_clear_dialog_title": "Are you sure you want to clear the Tautulli Remote logs?",
  "button_confirm": "CONFIRM",
  "logs_timestamp": "Timestamp",
  "logs_level": "Level",
  "logs_message": "Message",
  "logs_empty": "No logs found.",
  "general_tooltip_more": "More options",
  "media_go_to_season": "Go to season",
  "media_go_to_show": "Go to show",
  "media_go_to_artist": "Go to artist",
  "media_view_on_plex": "View on Plex",
  "general_read_more": "READ MORE",
  "general_read_less": "READ LESS",
  "media_details_items": "ITEMS",
  "media_details_year": "YEAR",
  "media_details_studio": "STUDIO",
  "media_details_aired": "AIRED",
  "media_details_runtime": "RUNTIME",
  "media_details_rated": "RATED",
  "media_details_genres": "GENRES",
  "media_details_directed_by": "DIRECTED BY",
  "media_details_written_by": "WRITTEN BY",
  "media_details_starring": "STARRING",
  "media_details_bitrate": "BITRATE",
  "media_details_file_size": "FILE SIZE",
  "media_details_taken": "TAKEN",
  "media_tab_details": "Details",
  "media_tab_seasons": "Seasons",
  "media_tab_episodes": "Episodes",
  "media_tab_albums": "Albums",
  "media_tab_tracks": "Tracks",
  "media_tab_movies": "Movies",
  "media_tab_media": "Media",
  "privacy_page_title": "OneSignal Data Privacy",
  "privacy_consent_switch": "Consent to OneSignal data privacy",
  "privacy_status": "Status",
  "privacy_not_accepted": "Not Accepted",
  "privacy_accepted": "Accepted",
  "privacy_text_block_1": "Tautulli Remote uses %OneSignal% to handle delivery of notifications.",
  "privacy_text_block_2": "With %encryption enabled% in Tautulli there is no Personally Identifiable Information (PII) collected. Some non-PII user information is collected and cannot be encrypted. Read the %OneSignal Privacy Policy% for more details. Without encryption the contents of the notifications are sent to OneSignal in plain text.",
  "privacy_text_block_3": "Notification data sent through OneSignal's API will be %deleted after ~30 days%.",
  "privacy_text_block_4": "Once you accept, this device will register with OneSignal. Consent can be revoked to prevent further communication with OneSignal.",
  "recently_added_empty": "No recently added items.",
  "recently_added_empty_filter": "No recently added items for {}.",
  "general_tooltip_filter_media_type": "Filter media type",
  "general_added": "Added",
  "settings_registration_page_title": "Register a Tautulliu Server",
  "settings_registration_text_1": "Use the button below to scan your QR code and auto-fill your server information or enter it manually instead.",
  "settings_registration_text_2": "Optionally, you can add a Secondary Connection Address. If the Primary Connection Address is unreachable, the app will automatically use the secondary address.",
  "settings_registration_qr_error": "Error scanning QR code",
  "settings_registration_scan_code": "Scan QR Code",
  "settings_primary_connection_address": "Primary Connection Address",
  "settings_secondary_connection_address": "Secondary Connection Address",
  "settings_connection_address_validation_message": "Please enter a valid URL format",
  "settings_device_token": "Device Token",
  "settings_device_token_validation_message": "Must be 32 characters long (current: {})",
  "button_register": "REGISTER",
  "settings_registration_exit_dialog_title": "Are you sure you want to exit?",
  "settings_registration_exit_dialog_content": "Any currently entered information will be discarded.",
  "button_discard": "DISCARD",
  "masked_info_connection_address": "Hidden Connection Address",
  "settings_active": "Active",
  "settings_passive": "Passive",
  "settings_disabled": "Disabled",
  "settings_copied": "Copied to clipboard",
  "settings_not_configured": "Not configured",
  "masked_device_token": "Hidden Device Token",
  "settings_copy_device_token_message": "Device tokens cannot be edited",
  "settings_open_server": "Open {} in browser",
  "settings_server_error": "Server not found in settings [{}]",
  "settings_primary_connection_dialog_title": "Tautulli Primary Connection Address",
  "settings_primary_connection_dialog_hint": "Input your primary connection address",
  "settings_server_delete_dialog_title": "Are you sure you want to remove {}?",
  "settings_required": "Required",
  "settings_secondary_connection_dialog_hint": "Input your secondary connection address",
  "settings_secondary_connection_dialog_title": "Tautulli Secondary Connection Address",
  "settings_registration_success": "Tautulli Registration Successful",
  "settings_servers_heading": "Tautulli Servers",
  "settings_primary_connection_missing": "Primary Connection Address Missing",
  "button_register_server": "Register a Tautulli Server",
  "settings_app_settings_heading": "App Settings",
  "settings_server_timeout": "Server Timeout",
  "settings_activity_refresh_rate": "Activity Refresh Rate",
  "settings_double_tap_exit_title": "Double Tap To Exit",
  "settings_double_tap_exit_message": "Tap back twice to exit",
  "settings_mask_info_title": "Mask Sensitive Info",
  "settings_mask_info_message": "Hides sensitive info in the UI",
  "changelog_page_title": "Changelog",
  "settings_about": "About",
  "settings_about_license": "Licensed under the GNU General Public License v3.0",
  "settings_default": "Default",
  "settings_faster": "Faster",
  "settings_fast": "Fast",
  "settings_normal": "Normal",
  "settings_slow": "Slow",
  "settings_slower": "Slower",
  "general_details_sec": "sec",
  "button_trust": "TRUST",
  "button_no": "NO",
  "settings_certificate_dialog_title": "Certificate Verification Failed",
  "settings_certificate_dialog_content": "This servers certificate could not be authenticated and may be self-signed. Do you want to trust this certificate?",
  "settings_setup_instructions_warning": "This app is not registered to a Tautulli server.",
  "settings_setup_instructions_line_1": "To register with a Tautulli server:",
  "settings_setup_instructions_line_2": "Open the Tautulli web interface on another device.",
  "settings_setup_instructions_line_3": "Navigate to Settings > Tautulli Remote App.",
  "settings_setup_instructions_line_4": "Select \"Register a new device\".",
  "settings_setup_instructions_line_5": "Use the button below to register with the server.",
  "button_dismiss": "DISMISS",
  "button_view_privacy_page": "VIEW PRIVACY PAGE",
  "button_check_again": "CHECK AGAIN",
  "settings_alert_onesignal_connection_title": "Unable to reach OneSignal",
  "settings_alert_onesignal_connection_item_1": "Notifications will not work.",
  "settings_alert_onesignal_connection_item_2": "Registration with OneSignal will fail.",
  "onesignal_consent_error_title": "OneSignal Data Privacy Not Accepted",
  "onesignal_consent_error_message": "To receive notifications from Tautulli consent to OneSignal data privacy.",
  "onesignal_register_error_title": "Device Has Not Registered With OneSignal",
  "onesignal_register_error_message": "This device is attempting to register with OneSignal. This process may take up to 2 min.",
  "onesignal_unexpected_error_title": "Unexpected Error Communicating With OneSignal",
  "onesignal_unexpected_error_message": "Please contact Tautulli support for assistance.",
  "statistics_filter_empty": "No statistics to show for the selected period.",
  "general_tooltip_stats_type": "Stats Type",
  "general_time_range_dialog_validator_larger_1": "Please enter an integer larger than 1",
  "general_time_range_dialog_validator_larger_0": "Please enter an integer larger than 0",
  "statistics_no_title": "NO TITLE",
  "general_play": "play",
  "general_plays": "plays",
  "general_users": "users",
  "general_streams": "streams",
  "general_hours": "hours",
  "general_minutes": "minutes",
  "general_seconds": "seconds",
  "statistics_no_additional_items": "No additional items for this statistic",
  "synced_items_media_details_unsupported": "Media details for this type of synced item is not supported.",
  "synced_items_empty": "No synced items found.",
  "synced_items_delete_request": "Delete synced item request sent to Plex.",
  "synced_items_delete_dialog_title": "Are you sure you want to delete this synced item?",
  "button_delete": "DELETE",
  "synced_items_delete": "Delete"
};
static const Map<String, Map<String,dynamic>> mapLocales = {"en": en};
}
