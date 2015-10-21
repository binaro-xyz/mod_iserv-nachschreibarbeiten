<?php
$dates = db_getAll('SELECT * FROM mod_nachschreibarbeiten_dates WHERE date >= current_date ORDER BY date ASC');
?>

<h1>Nachschreiber_innen</h1>

<?php
foreach($dates as $date) {
    $entries = db_getAll('SELECT * FROM mod_nachschreibarbeiten_entries WHERE date_id = ' . qdb($date['id']));
    if(count($entries) > 0) {
        echo '<h2>' . getLocalizedFormattedDate($date['date'], '%A') . ', den ' . getLocalizedFormattedDate($date['date'], '%d. %B %Y') . '</h2>' ?>
        <table>
            <thead>
            <td>Name der Schüler_in</td>
            <td>Klasse</td>
            <td>Fach</td>
            <td>Zusatzmaterialien</td>
            <td>Dauer</td>
            <td>Lehrkraft</td>
            </thead>
            <tbody>
            <tr>
                <!-- TODO: Actually fill this -->
                <?php
                foreach ($entries as $entry) {
                    echo '<td>' . ActToName($entry['student_act']) . '</td><td>' . strip_tags($entry['class']) . '</td><td>' . strip_tags($entry['subject']) . '</td><td>' . strip_tags($entry['additional_material']) . '</td><td>' . strip_tags($entry['duration']) . '</td><td>' . ActToName($entry['teacher_act']) . '</td><td>' . popup('edit.php?type=entry&id=' . $date['id'], 320, 240, icon('manage'))  . '</a></td>';
                } ?>
            </tr>
            </tbody>
        </table>
        <?php
    }
} ?>