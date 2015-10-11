<?
require_once('mod_iserv-nachschreibarbeiten/functions.php');

if(userIsAdmin()) {
  TreeNode('Termine verwalten', 'mod_iserv-nachschreibarbeiten/manage.php', 'manage');
}