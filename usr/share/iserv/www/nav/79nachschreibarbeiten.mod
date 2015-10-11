<?
require_once('mod_iserv-nachschreibarbeiten/functions.php');

if(userIsAdmin()) {
	TreeNode('Nachschreibarbeiten', 'mod_iserv-nachschreibarbeiten/index.php', 'calendar', 'nav/mod_iserv-nachschreibarbeiten');
}
elseif(userHasAccess()) {
  TreeNode('Nachschreibarbeiten', 'mod_iserv-nachschreibarbeiten/index.php', 'calendar');
}