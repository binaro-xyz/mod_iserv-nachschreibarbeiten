<?php
require_once 'share.inc';
require_once 'sec/secure.inc';
require_once 'ctrl.inc';
require_once 'form.inc';
require_once 'format.inc';
require_once 'db.inc';
require_once 'mod_iserv-nachschreibarbeiten/functions.php';

jquery_ui_head('combobox, timepicker');
css_include('style.css');
PageBlue('Nachschreibtermine verwalten', 'manage');

db_user('nachschreibarbeiten');

if(!userIsAdmin()) {
  printf("<p class='err'>Fehler: Zugriff verweigert.</p>\n");
  _PageBlue();
  exit();
}

mountspc('form_manage');

jquery_combobox();
jquery_datetimepicker(false);
_PageBlue();
