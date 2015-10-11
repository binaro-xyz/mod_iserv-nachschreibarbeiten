<?php
require_once('share.inc');
require_once('sec/secure.inc');
require_once('ctrl.inc');
require_once "form.inc";
require_once "format.inc";
require_once "db.inc";
require_once('mod_iserv-nachschreibarbeiten/functions.php');

db_user('nachschreibarbeiten');

jquery_ui_head('combobox');
css_include('style.css');
PageBlue('Nachschreiber_innen', 'calendar');

if(!userHasAccess()) {
    printf("<p class='err'>Fehler: Zugriff verweigert.</p>\n");
    _PageBlue();
    exit();
}

mountspc('form_nachschreiber');

jquery_combobox();
_PageBlue();
