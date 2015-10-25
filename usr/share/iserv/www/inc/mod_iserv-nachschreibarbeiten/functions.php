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

// returns true if the Nachschreibtermin at $date collides with another test or Nachschreibtermin for $student_act
function isCollision($date, $student_act) {
    $query = 'SELECT
(SELECT COUNT(*) FROM exam_plan WHERE exam_plan.actgrp = ANY((SELECT array_agg(distinct members.actgrp) FROM members WHERE members.actuser=' . qdb($student_act) . ')::text[]) AND EXTRACT(WEEK FROM exam_plan.date) = EXTRACT(WEEK FROM TIMESTAMP ' . qdb($date) . ') AND EXTRACT(YEAR FROM exam_plan.date) = EXTRACT(YEAR FROM TIMESTAMP ' . qdb($date) . ')) AS week_count,
(SELECT COUNT(*) AS day_count FROM exam_plan WHERE exam_plan.actgrp = ANY((SELECT array_agg(distinct members.actgrp) FROM members WHERE members.actuser=' . qdb($student_act) . ')::text[]) AND exam_plan.date = ' . qdb($date) . ') AS day_count,
(SELECT COUNT(*) FROM mod_nachschreibarbeiten_entries WHERE student_act = ' . qdb($student_act) . ' AND mod_nachschreibarbeiten_entries.date_id = (SELECT mod_nachschreibarbeiten_dates.id FROM mod_nachschreibarbeiten_dates WHERE date=' . qdb($date) . ')) AS entry_count;';
    $conflicts = db_getRow($query);
    return $conflicts['day_count'] < 1 && $conflicts['week_count'] < 3 && $conflicts['entry_count'] < 1;
}

// Unfortunately, IServ doesn't seem to have a function that escapes values to be inserted into the DB (or I just can't find it...)
// They do have a function qdb() that escapes a value and adds quotes around it (presumably for easier SELECT statements, their db_store() also inserts quotes though...)
// We use this function here but remove the quotes with trim(). We also strip all HTML from strings in the process using strip_tags()
function escape($data) {
    require_once 'db.inc';

	switch(gettype($data)) {
		case 'string':
            return strip_tags(trim(qdb($data), '\''));
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
