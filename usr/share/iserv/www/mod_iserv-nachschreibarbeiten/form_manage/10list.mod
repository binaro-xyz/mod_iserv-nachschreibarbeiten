<?php
require_once 'format.inc';
require_once 'js.inc';

// this is the code to insert a new date (sent from 20insert_form.mod)
// we have to execute it here though, in order for the new date to be shown without refreshing the page
if(!empty($_POST['date'])) {
    if(validateTeacherAct($_POST['teacher'])) {
        // TODO: Date has to be unique!
        $data = array(
          'date' => escape($_POST['date']),
          'time' => escape($_POST['time']),
          'room' => escape($_POST['room']),
          'teacher_act' => escape($_POST['teacher']),
          'created_by_act' => escape($_SESSION['act'])
        );

        require_once 'sec/login.inc';
        if (db_store('mod_nachschreibarbeiten_dates', $data)) {
            log_insert('Nachschreibtermin ' . escape($_POST['date']) . ' um ' . escape($_POST['time']) . ' mit Betreuer_in ' . ActToName(($_POST['teacher'])) . ' in Raum "' . escape($_POST['room']) . '" hinzugefügt', NULL, 'Nachschreibarbeiten');
            Info('Nachschreibtermin erfolgreich eingetragen.');
        }
        else {
            Error('Fehler beim Eintragen des Nachschreibtermins.');
        }
    } else {
        echo '<div class="warn" style="text-align: center; margin: 10px;">' . icon('dlg-warn') . '<strong>Falsche Eingabe!</strong> Die eingegebene Lehrer_in existiert nicht.</div>';
    }
}

$dates = db_getAll('SELECT * FROM mod_nachschreibarbeiten_dates WHERE date >= current_date ORDER BY date ASC');
?>

<h1>Bereits eingetragene Nachschreibtermine</h1>

<table class="display-table">
    <thead>
    <td>Wochentag</td><td>Datum</td><td>Uhrzeit</td><td>Raum</td><td>Betreuer_in</td><td></td>
    </thead>
    <tbody>
        <?php
        foreach($dates as $date) {
            echo '<tr><td>' . getLocalizedFormattedDate($date['date'], '%A') . '</td><td>' . getLocalizedFormattedDate($date['date'], '%d. %B %Y') . '</td><td>' . getLocalizedFormattedDate($date['time'], '%H:%M') . '</td><td>' . $date['room'] . '</td><td>' . ActToName($date['teacher_act']) . '</td><td>' . popup('edit.php?type=date&id=' . $date['id'], 320, 240, icon('manage'))  . '</a></td></tr>';
        }
        ?>
    </tbody>
</table>
