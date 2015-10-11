<?php
// this should *really* be some nice OOP classes instead. However, IServ doesn't even provide an autoloader or anything like that. I just don't feel like implementing all that myself for a few simple functions...

// Check if user has the privilege to access the Nachschreibarbeiten module (usually given to teachers)
function userHasAccess() {
	return userIsAdmin() || secure_privilege('mod_nachschreibarbeiten_access');
}

// Check if the user has admin privileges in the Nachschreibarbeiten module (usually given to admins and the teacher responsible for the Nachschreibarbeiten)
function userIsAdmin() {
 	return secure_privilege('mod_nachschreibarbeiten_admin');
}

// returns true if the current user can edit the date/entry
function userCanEdit($data) {
    if(!userHasAccess()) return false;
    if(userIsAdmin()) return true;

    return $data['created_by_act'] == $_SESSION['act'];
}

// Unfortunately, IServ doesn't seem to have a function that escapes values to be inserted into the DB (or I just can't find it...)
// They do have a function qdb() that escapes a value and adds quotes around it (presumably for easier SELECT statements, their db_store() also inserts quotes though...)
// We use this function here but remove the quotes with trim().
function escape($data) {
    require_once 'db.inc';

	switch(gettype($data)) {
		case 'string':
            return trim(qdb($data), '\'');
			break;
		default:
            return qdb($data);
			break;
	}
}

// for $format reference see https://secure.php.net/manual/en/function.strftime.php
function getLocalizedFormattedDate($date_string, $format) {
    $date_obj = new DateTime($date_string);
    $timestamp = $date_obj->format('U');

    return strftime($format, $timestamp);
}
