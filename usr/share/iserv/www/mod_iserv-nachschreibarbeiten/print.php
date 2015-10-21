<?php
require_once 'share.inc';
require_once 'sec/secure.inc';
require_once 'ctrl.inc';
require_once 'form.inc';
require_once 'format.inc';
require_once 'db.inc';
require_once 'mod_iserv-nachschreibarbeiten/functions.php';

db_user('nachschreibarbeiten');
css_include('style.css');
css_include('style_print.css');

if(!userHasAccess()) {
    Error('Fehler: Zugriff verweigert.');
    die;
}

page_open();

include __DIR__ . '/form_nachschreiber/30list.mod';
echo '<hr><p>Ausdruck vom ' . getLocalizedFormattedDate(date(''), '%d. %B %Y um %H:%M:%S') . '</p>';

js('window.print();');
page_close();
