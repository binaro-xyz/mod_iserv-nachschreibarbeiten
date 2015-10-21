<?php
require_once 'share.inc';
require_once 'ctrl.inc';
require_once 'db.inc';
require_once 'sec/secure.inc';
require_once 'mod_iserv-nachschreibarbeiten/functions.php';
db_user('nachschreibarbeiten');

jquery_ui_head('combobox');
css_include('style.css');
PageBlue('Bearbeiten', 'manage');

if(!empty($_POST['action'])) {
    switch($_POST['action']) {
        case 'update':
            require_once 'format.inc';
            switch ($_POST['type']) {
                case 'date':
                    $query = 'UPDATE mod_nachschreibarbeiten_dates SET date=' . qdb($_POST['date']) . ', time=' . qdb($_POST['time']) . ', room=' . qdb($_POST['room']) . ', teacher_act=' . qdb($_POST['teacher']) . ' WHERE id=' . qdb($_POST['id']);
                    $old_date = db_getRow('SELECT * FROM mod_nachschreibarbeiten_dates WHERE id = ' . qdb($_POST['id']));
                    if (db_query($query)) {
                        log_insert('Nachschreibtermin geändert. Neue Daten: ' . strip_tags($_POST['date']) . ' um ' . strip_tags($_POST['time']) . ' mit Betreuer_in ' . ActToName(($_POST['teacher'])) . ' in Raum "' . strip_tags($_POST['room']) . '". Alte Daten: ' . getLocalizedFormattedDate($old_date['date'], '%Y-%m-%d') . ' um ' . strip_tags($old_date['time']) . ' mit Betreuer_in ' . ActToName(($old_date['teacher_act'])) . ' in Raum "' . strip_tags($old_date['room']) . '".', null, 'Nachschreibarbeiten');
                        Info('Nachschreibtermin erfolgreich eingetragen.');
                        js('window.close();');
                    } else {
                        Error('Fehler beim Bearbeiten des Nachschreibtermins.<br><a href="javascript:window.close();">Schließen</a>');
                    }
                    break;
                case 'entry':
                    break;
                default:
                    Error('Ungültige Anfrage.');
                    break;
            }
            break;
        case 'delete':
            $query = 'DELETE FROM mod_nachschreibarbeiten_dates WHERE id=' . qdb($_POST['id']);
            if (db_query($query)) {
                log_insert('Nachschreibtermin ' . strip_tags($_POST['id']) . ' gelöscht.', null, 'Nachschreibarbeiten');
                Info('Nachschreibtermin erfolgreich gelöscht.');
                js('window.close();');
            } else {
                Error('Fehler beim Löschen des Nachschreibtermins.<br><a href="javascript:window.close();">Schließen</a>');
            }
            break;
        default:
            Error('Ungültige Anfrage.');
            break;
    }
}

if(empty($_GET['type']) || empty($_GET['id'])) {
    Error('Ungültige Anfrage.');
    die();
}

$type = $_GET['type'];
$id = $_GET['id'];

$sel_teachers = db_getHash(
    'SELECT u.act, user_join_name(u.firstname, u.lastname)
               FROM users u
                 JOIN members m ON m.actuser = u.act
                 JOIN groups_priv p ON p.act = m.actgrp
               WHERE u.deleted IS NULL
                 AND p.privilege IN (\'mod_nachschreibarbeiten_access\', \'mod_nachschreibarbeiten_admin\')
               ORDER BY u.act'
);

switch($type) {
    case 'date':
        $date = db_getRow('SELECT * FROM mod_nachschreibarbeiten_dates WHERE id = ' . qdb($id));
        if(userCanEdit($date)) {
            $teacher_select = combo('teacher', $date['teacher_act'], $sel_teachers, array('width' => '144px'), true);
            ?>
            <form method="post" action="#">
                <<?php echo $GLOBALS["padtbl"]; ?>>
                <tr><td>Datum:</td><td><input type="date" name="date" value="<?php echo getLocalizedFormattedDate($date['date'], '%Y-%m-%d'); ?>" style="width: 144px;"></td></tr> <!-- TODO: Automatically pick the next Friday -->
                <tr><td>Uhrzeit:</td><td><input type="time" name="time" value="<?php echo $date['time']; ?>" style="width: 144px;"></td></tr>
                <tr><td>Raum:</td><td><input type="text" name="room" value="<?php echo $date['room']; ?>"></td></tr>
                <tr><td>Betreuer:</td><td><?php echo $teacher_select; ?></td></tr>
                </table>
                <input type="hidden" name="id" value="<?php echo $date['id']; ?>">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="type" value="date">
                <input type="submit">
            </form>
            <form method="post" action="#">
                <input type="hidden" name="id" value="<?php echo $date['id']; ?>">
                <input type="hidden" name="action" value="delete">
                <input type="hidden" name="type" value="date">
                <input type="submit" value="Löschen">
            </form>
            <?php
        }
        else {
            Error('Sie haben keine Berechtigung, diesen Nachschreibtermin zu bearbeiten.');
        }
        break;
    case 'entry':
        break;
    default:
        Error('Ungültige Anfrage.');
        break;
}

jquery_combobox();
_PageBlue();
